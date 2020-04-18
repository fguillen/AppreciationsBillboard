class AppreciableUser < ApplicationRecord
  self.primary_key = :slug

  has_many :sent_appreciations, class_name: "Appreciation", foreign_key: "by"
  has_and_belongs_to_many :received_appreciations,
      class_name: "Appreciation",
      foreign_key: "appreciable_user_slug",
      association_foreign_key: "appreciation_uuid",
      join_name: "appreciable_users_appreciations"

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => RubyRegex::Email }
  validates :slug, presence: true, uniqueness: true

  before_validation :initialize_slug

  scope :by_recent, -> { order("created_at desc, slug desc") }

  private

  def initialize_slug
    self.slug ||= name.parameterize
  end
end
