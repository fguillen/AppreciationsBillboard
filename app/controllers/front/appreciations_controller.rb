class Front::AppreciationsController < Front::BaseController
  before_action :require_appreciable_user
  before_action :load_appreciation, :only => [:show, :edit, :update, :destroy]
  before_action :validate_current_appreciable_user, :only => [:edit, :update, :destroy]

  def index
    @appreciations = Appreciation.by_recent
  end

  def show
  end

  def new
    @appreciation = Appreciation.new(by: current_appreciable_user)
  end

  def create
    @appreciation = Appreciation.new(appreciation_params)
    @appreciation.by = current_appreciable_user

    if @appreciation.save
      @appreciation.slack_notification if APP_CONFIG[:slack_notifier]["enabled"]
      redirect_to [:front, @appreciation] #, :notice => t("controllers.appreciations.create.success")
    else
      flash.now[:alert] = t("controllers.appreciations.create.error")
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @appreciation.update_attributes(appreciation_params)
      redirect_to [:front, @appreciation], :notice  => t("controllers.appreciations.update.success")
    else
      flash.now[:alert] = t("controllers.appreciations.update.error")
      render :action => :edit
    end
  end

  def destroy
    @appreciation.destroy
    redirect_to :front_appreciations, :notice => t("controllers.appreciations.destroy.success")
  end

protected

  def appreciation_params
    params.require(:appreciation).permit(:by_slug, :message, :to_names, :pic)
  end

private

  def load_appreciation
    @appreciation = Appreciation.find(params[:id])
  end

  def validate_current_appreciable_user
    if @appreciation.by != current_appreciable_user
      redirect_to [:front, @appreciation], :alert  => t("controllers.front.access_not_authorized")
      return false
    end
  end
end
