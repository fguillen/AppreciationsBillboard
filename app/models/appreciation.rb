class Appreciation < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  belongs_to :by, class_name: "AppreciableUser", foreign_key: "by_slug"

  has_and_belongs_to_many :to,
      class_name: "AppreciableUser",
      foreign_key: "appreciation_uuid",
      association_foreign_key: "appreciable_user_slug",
      join_name: "appreciable_users_appreciations"

  has_one_attached :pic

  before_validation :initialize_uuid

  validates :uuid, presence: true, uniqueness: true
  validates :pic, size: { less_than: 2.megabytes }
  validates :pic, dimension: { width: { min: 50 }, height: { min: 50 } }

  scope :by_recent, -> { order("created_at desc, uuid desc") }

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
end
