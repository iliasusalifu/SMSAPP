class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  @page_title = 'SMS Content Management Platform'
  def authorize
     if session[:user_id]
         return true
     else
         redirect_to :controller => 'users', :action => 'login'
     end
  end

  private
   def allocate_user_session(name,password)
       user = User.authenticate(name,password)
       session[:user_id] = user.id if user
       user
   end

   def deallocate_user_session
       session[:user_id] = nil
   end
   def render_404(exception = nil)
     if exception
        logger.info "Rendering 404: #{exception.message}"
     end
     render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
   end

   #returns currently logged in user
   def get_current_user
       User.find(session[:user_id])
   end

   
end
