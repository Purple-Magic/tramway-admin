# frozen_string_literal: true

require 'tramway/admin/record_routes_helper'
require 'tramway/auth'
require 'font-awesome-rails'
require 'ckeditor'

module Tramway
  module Admin
    class Engine < ::Rails::Engine
      isolate_namespace Tramway::Admin
    end
  end
end
