class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |type|
      type.all  { render :nothing => true, :status => 404 }
    end
  end
end
