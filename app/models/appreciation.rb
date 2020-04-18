class Appreciation < ApplicationRecord
  belongs_to :by, class_name: "AppreciableUser", foreign_key: "by_slug"

  has_and_belongs_to_many :to,
      class_name: "AppreciableUser",
      foreign_key: "appreciation_uuid",
      association_foreign_key: "appreciable_user_slug",
      join_name: "appreciable_users_appreciations"
 # Unknown key: :association_foreign_key. Valid keys are: :class_name, :anonymous_class, :foreign_key, :validate, :autosave, :table_name, :before_add, :after_add, :before_remove, :after_remove, :extend, :primary_key, :dependent, :as, :through, :source, :source_type, :inverse_of, :counter_cache, :join_table, :foreign_type, :index_errors

  include HasUuid

  before_validation :initialize_uuid

  validates :uuid, presence: true, uniqueness: true

  scope :by_recent, -> { order("created_at desc, uuid desc") }
end
