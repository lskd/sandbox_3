class RegistrationsController < Devise::RegistrationsController

  # params[:user].permit(:name, :email, :password)

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
