class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  def index
  end


  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      # self.current_user = @user # !! now logged in
      redirect_back_or_default('/users')
      flash[:notice] = "Registracion exitosa! Ahora puede loguearse."
    else
      flash[:error]  = "Hubo un problema durante la registracion, intente de nuevo o contacte a un administrador."
      render :action => 'new'
    end
  end

  def show
    destroy
  end

  def destroy
    User.delete(User.find :first, :conditions => {:id => params[:user_id]}) if current_user.tipo == "a"
    redirect_back_or_default('/users')
  end

  def reset_pass
    @user = User.find(:first, :conditions => {:id => params[:user_id]}) || User.find(:first, :conditions => {:id => params[:user][:id]})
    
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        flash[:notice] = "Se actualizo correctamente la contraseña"
        redirect_to root_url
      else
        flash[:notice] = "Fallo la actualizacion"
      end
    else
      render :action => :reset_pass
    end
  end
end
