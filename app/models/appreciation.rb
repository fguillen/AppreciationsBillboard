class Appreciation < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  belongs_to :by, class_name: "AppreciableUser", foreign_key: "by_slug"

  has_and_belongs_to_many :to,
      class_name: "AppreciableUser",
      foreign_key: "appreciation_uuid",
      association_foreign_key: "appreciable_user_slug",
      join_table: "appreciable_users_appreciations"

  has_one_attached :pic

  before_validation :initialize_uuid
  before_validation :initialize_pic

  validates :uuid, presence: true, uniqueness: true
  validates :pic, size: { less_than: 2.megabytes }
  validates :pic, dimension: { width: { min: 50 }, height: { min: 50 } }

  scope :order_by_recent, -> { order("created_at desc, uuid desc") }
  scope :by, -> (appreciable_user) { where(by: appreciable_user)}
  scope :to, -> (appreciable_user) { joins("JOIN appreciable_users_appreciations ON appreciations.uuid = appreciable_users_appreciations.appreciation_uuid").where("appreciable_users_appreciations.appreciable_user_slug = ?", appreciable_user) }

  def to_slugs=(slugs)
    appreciable_users =
      slugs.map do |slug|
        AppreciableUser.find(slug)
      end

    self.to = appreciable_users
  end

  def to_slugs
    to.map(&:slug)
  end

  def to_names
    to.map(&:name).join(", ")
  end

  def to_names=(value)
    Rails.logger.info("XXX value: #{value}")

    appreciable_users =
      value.split(",").map(&:strip).map do |name|
        AppreciableUser.where(name: name).first
      end

    self.to = appreciable_users.compact
  end

  def pic_url
    pic_variant = pic.variant(resize: "400x400>")
    pic_url = Rails.application.routes.url_helpers.rails_representation_url(
      pic_variant,
      host: "https://#{APP_CONFIG[:hosts].first}"
    )
  end

  def slack_notification
    blocks = []

    # Title
    block_title = {
      type: "section",
      text: {
        type: "mrkdwn",
        text: "A new Appreciation by *#{by.name}* to *#{to_formatted}*:"
      }
    }

    # Message
    block_message = {
      type: "section",
      text: {
        type: "plain_text",
        text: message
      }
    }

    # Development URLs are rejected by Slack
    if !Rails.env.development? && pic.attached?
      block_message[:accessory] = {
        type: "image",
        image_url: pic_url,
        alt_text: "Appreciation Header"
      }
    end

    # Link
    block_link = {
      type: "section",
      fields: [
        {
          type: "mrkdwn",
          text: "<https://#{APP_CONFIG[:hosts].first}/front/appreciations/#{uuid}|Check it here>"
        }
      ]
    }

    blocks = []
    blocks << block_title
    blocks << block_message
    blocks << block_link

    AppreciationsBillboard.slack_notifier.post blocks: blocks
  end

  def to_formatted
    to.map(&:name).to_sentence
  end

private

  def initialize_pic
    return if pic.attached?

    files = Dir["#{Rails.root}/db/appreciation_default_pics/*"]
    file = files.sample

    self.pic.attach(io: File.open(file), filename: File.basename(file))
  end


end
