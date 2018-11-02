module HasUuid
  extend ActiveSupport::Concern

  included do
    before_validation :initialize_uuid, :on => :create

    def initialize_uuid
      Rails.logger.info "XXX: uuid: #{uuid}"
      Rails.logger.info "XXX: uuid.nil?: #{uuid.nil?}"
      self.uuid ||= UUID.new.generate
    end
  end

end
