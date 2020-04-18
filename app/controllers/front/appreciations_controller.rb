class Front::AppreciationsController < Front::BaseController
  before_action :load_appreciation, :only => [:show, :edit, :update, :destroy]

  def index
    @appreciations = Appreciation.by_recent
  end

  def show
  end

  def new
    @appreciation = Appreciation.new
  end

  def create
    @appreciation = Appreciation.new(appreciation_params)

    if @appreciation.save
      redirect_to [:front, @appreciation], :notice => t("controllers.appreciations.create.success")
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
    params.require(:appreciation).permit(:by_slug, :message, to_slugs: [])
  end

private

  def load_appreciation
    @appreciation = Appreciation.find(params[:id])
  end
end
