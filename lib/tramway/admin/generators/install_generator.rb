require 'rails/generators'
require 'tramway/admin/generators/model_generator'

module Tramway
  module Admin
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)
        class_option :user_role, type: :string, default: 'admin'

        def run_decorator_generators
          project = Tramway::Core.application.name
          ::Tramway::Admin.available_models_for(project).map do |model|
            generate 'tramway:admin:model', model.to_s, "--user-role=#{options[:user_role]}"
          end
        end
      end
    end
  end
end
