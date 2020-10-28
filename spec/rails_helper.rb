# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'
require 'capybara_helpers'
require 'support/errors_helper'
require 'support/navbar_helper'
require 'support/tramway_helpers'
require 'support/date_picker_helper'
require 'json_matchers/rspec'
require 'json_api_test_helpers'
require 'rake'
require 'capybara/rails'
require 'capybara/rspec'
require 'web_driver_helper'
require 'faker'
require 'webmock/rspec'
WebMock.disable_net_connect! allow_localhost: true, allow: 'chromedriver.storage.googleapis.com'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include RSpec::Rails::RequestExampleGroup, type: :feature
  config.include JsonApiTestHelpers
  config.include ErrorsHelper
  config.include Capybara::DSL
  config.include RSpec::JsonExpectations::Matchers
  config.include WebMock::API
  config.include CapybaraHelpers
  config.include NavbarHelper
  config.include TramwayHelpers
  config.include DatePickerHelper
  config.before(:all) do
    ActiveRecord::Base.descendants.each do |model|
      next if model.to_s.in? ['PgSearch::Document']
      next if model.abstract_class

      model.delete_all
    end
    create :admin, email: 'admin@email.com', password: '123456', role: :admin
    create :partner, email: 'partner@email.com', password: '123456', role: :partner
  end
  include ActionDispatch::TestProcess
end
