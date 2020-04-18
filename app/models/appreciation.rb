class Appreciation < ApplicationRecord
  belongs_to :by, class_name: "AppreciableUser", foreign_key: "by_slug"

  has_and_belongs_to_many :to,
      class_name: "AppreciableUser",
      foreign_key: "appreciation_uuid",
      association_foreign_key: "appreciable_user_slug",
      join_name: "appreciable_users_appreciations"

  include HasUuid

  before_validation :initialize_uuid

  validates :uuid, presence: true, uniqueness: true

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
end
