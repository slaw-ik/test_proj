class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  Warden::Manager.after_authentication do |user,auth,opts|
    p "================================================"
    #p request.session_options[:id]
    #query = "update sessions set user_id = '#{user.id}' where session_id = '#{request.session_options[:id]}'"
    #ActiveRecord::Base.connection.execute(query);
    p "================================================"
  end

end
