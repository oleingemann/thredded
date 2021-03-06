# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SetLocale
  include StoreLocationFullpath
  helper_method :the_current_user

  protected

  def the_current_user
    return unless session[:user_id]
    @the_current_user ||= Thredded.user_class.find_by(id: session[:user_id]).tap do |user|
      # If the database has been recreated, user_id may be invalid.
      session.delete(:user_id) if user.nil?
    end
  end

  if Rails::VERSION::MAJOR < 5
    # redirect_back polyfill
    def redirect_back(fallback_location:, **args)
      redirect_to :back, args
    rescue ActionController::RedirectBackError
      redirect_to fallback_location, args
    end
  end
end
