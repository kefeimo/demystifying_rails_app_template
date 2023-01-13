class ApplicationController < ActionController::Base

  def welcome
    render plain: "welcome-page-placeholder"
  end
end
