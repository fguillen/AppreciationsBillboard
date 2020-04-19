class Front::AppreciableSessionsController < Front::BaseController
  layout "front/base_basic"

  def new
    @appreciable_session = AppreciableSession.new
  end
end
