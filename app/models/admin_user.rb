class AdminUser < ApplicationRecord
  validates_with AdminPasswordValidator

  include HasUuid

  has_many :authorizations, :dependent => :destroy

  acts_as_authentic do |c|
    c.validate_email_field = false
  end

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => RubyRegex::Email }

  scope :by_recent, -> { order("id desc") }

  def send_reset_password_email
    reset_perishable_token!
    Notifier.admin_user_reset_password(self).deliver
  end
end
