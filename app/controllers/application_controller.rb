class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?



     def after_sign_in_path_for(resource)
        if resource.has_role? :admin
            articles_path
        elsif resource.pending? 
            drafts_path
        elsif resource.rejected? 
            cancel_path
        else
          root_path
  
        end
    end
  
    protected
  
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :address, :approved])
      end

      def set_users
        @users = User.all

      end
        
  end

