# frozen_string_literal: true

class Tramway::Admin::WelcomeController < Tramway::Admin::ApplicationController
  skip_before_action :check_available!

  def index
    instance_exec(&::Tramway::Admin.welcome_page_actions) if ::Tramway::Admin.welcome_page_actions.present?
  end
end
