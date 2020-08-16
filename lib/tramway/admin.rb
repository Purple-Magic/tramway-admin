# frozen_string_literal: true

require 'tramway/admin/engine'
require 'tramway/admin/singleton_models'
require 'tramway/admin/records_models'
require 'tramway/admin/forms'
require 'tramway/admin/additional_buttons'
require 'tramway/admin/notifications'
require 'tramway/admin/welcome_page_actions'
require 'tramway/admin/navbar'
require 'tramway/error'

module Tramway
  Auth.layout_path = 'tramway/admin/application'

  module Admin
    class << self
      include ::Tramway::Admin::RecordsModels
      include ::Tramway::Admin::SingletonModels
      include ::Tramway::Admin::AdditionalButtons
      include ::Tramway::Admin::Forms
      include ::Tramway::Admin::Notifications
      include ::Tramway::Admin::WelcomePageActions
      include ::Tramway::Admin::Navbar

      attr_reader :customized_admin_navbar

      def engine_class(project)
        class_name = "::Tramway::#{project.to_s.camelize}"
        class_name.classify.safe_constantize
      end

      def project_is_engine?(project)
        engine_class(project)
      end

      def get_models_by_key(checked_models, project, role)
        unless project.present?
          error = Tramway::Error.new(
            plugin: :admin,
            method: :get_models_by_key,
            message: "Looks like you have not create at least one instance of #{Tramway::Core.application.model_class} model OR Tramway Application Model is nil"
          )
          raise error.message
        end
        checked_models && checked_models[project]&.dig(role)&.keys || []
      end

      def models_array(models_type:, role:)
        instance_variable_get("@#{models_type}_models")&.map do |projects|
          projects.last[role]&.keys
        end&.flatten || []
      end

      def action_is_available?(record, project:, role:, model_name:, action:)
        project = project.underscore.to_sym unless project.is_a? Symbol
        actions = select_actions(project: project, role: role, model_name: model_name)
        availability = actions&.select do |a|
          if a.is_a? Symbol
            a == action.to_sym
          elsif a.is_a? Hash
            a.keys.first.to_sym == action.to_sym
          end
        end&.first

        return false unless availability.present?
        return true if availability.is_a? Symbol

        availability.values.first.call record
      end

      def select_actions(project:, role:, model_name:)
        stringify_keys(@singleton_models&.dig(project, role))&.dig(model_name) || stringify_keys(@available_models&.dig(project, role))&.dig(model_name)
      end

      def stringify_keys(hash)
        hash&.reduce({}) do |new_hash, pair|
          new_hash.merge! pair[0].to_s => pair[1]
        end
      end
    end
  end
end
