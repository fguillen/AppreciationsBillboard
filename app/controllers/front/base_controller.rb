class Front::BaseController < ApplicationController
  include Front::BaseHelper

  layout "/front/base"

  # helper_method :current_appreciable_user, :namespace

  private

  # def require_apprreciable_user
  #   unless current_appreciable_user
  #     store_location
  #     flash[:alert] = t("controllers.admin.authentication_required")
  #     redirect_to admin_login_path
  #     return false
  #   end
  # end

  # def current_appreciable_user_session
  #   return @current_appreciable_user_session if defined?(@current_appreciable_user_session)
  #   @current_appreciable_user_session = AdminUserSession.find
  # end

  # def current_appreciable_user
  #   return @current_appreciable_user if defined?(@current_appreciable_user)
  #   @current_appreciable_user = current_appreciable_user_session && current_appreciable_user_session.record
  # end

  # def store_location
  #   session[:return_to] = request.url
  # end

  # def redirect_back_or_default( default )
  #   redirect_to(session[:return_to] || default)
  #   session[:return_to] = nil
  # end
end
