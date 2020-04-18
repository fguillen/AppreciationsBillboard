class AppreciableUser < ApplicationRecord
  self.primary_key = :slug

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => RubyRegex::Email }
  validates :slug, presence: true, uniqueness: true

  before_validation :initialize_slug

  private

  def initialize_slug
    self.slug ||= name.parameterize
  end
end
