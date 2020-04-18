class Front::AppreciationrsController < Front::BaseController
  before_action :require_appreciation, :except => [:reset_password, :reset_password_submit]
  before_action :load_appreciation, :only => [:show, :edit, :update, :destroy]

  def index
    @appreciations = Appreciationr.by_recent
  end

  def show
  end

  def new
    @appreciation = Appreciationr.new
  end

  def create
    @appreciation = Appreciationr.new(appreciation_params)
    if @appreciation.save
      redirect_to [:admin, @appreciation], :notice => t("controllers.appreciations.create.success")
    else
      flash.now[:alert] = t("controllers.appreciations.create.error")
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @appreciation.update_attributes(appreciation_params)
      redirect_to [:admin, @appreciation], :notice  => t("controllers.appreciations.update.success")
    else
      flash.now[:alert] = t("controllers.appreciations.update.error")
      render :action => :edit
    end
  end

  def destroy
    @appreciation.destroy
    redirect_to :admin_appreciations, :notice => t("controllers.appreciations.destroy.success")
  end

  def reset_password
    @appreciation = Appreciationr.find_using_perishable_token!(params[:reset_password_code], 1.week)

    render :reset_password, :layout => "admin/admin_basic"
  end

  def reset_password_submit
    @appreciation = Appreciationr.find_using_perishable_token!(params[:reset_password_code], 1.week)

    if @appreciation.update_attributes(appreciation_params)
      AppreciationrSession.create(@appreciation)
      flash[:notice] = t("controllers.appreciations.reset_password.success")
      redirect_back_or_default admin_root_path
    else
      flash.now[:alert] = t("controllers.appreciations.reset_password.error")
      render :reset_password, :layout => "admin/admin_basic"
    end
  end

protected

  def appreciation_params
    params.require(:appreciation).permit(:name, :email, :password, :password_confirmation, :uuid)
  end

private

  def load_appreciation
    @appreciation = Appreciationr.find(params[:id])
  end
end
