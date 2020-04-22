class Front::AppreciableSessionsController < Front::BaseController
  layout "front/base_basic"

  def new
    @appreciable_session = AppreciableSession.new
  end

  def destroy
    @appreciable_session = AdminSession.find
    @appreciable_session.destroy if @appreciable_session

    redirect_to :front_login, :notice => t("controllers.appreciable_sessions.logout.success")
  end
end
