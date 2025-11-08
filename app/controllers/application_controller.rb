class ApplicationController < ActionController::Base
  # Use this if you want a global auth but only when Devise is actually available:
  # before_action :authenticate_user!, if: -> { respond_to?(:authenticate_user!) }
  #
  # Optional shims so views don’t explode when Devise isn’t loaded:
  helper_method :user_signed_in?, :current_user

  def user_signed_in?
    defined?(super) ? super : false
  end

  def current_user
    defined?(super) ? super : nil
  end
end
