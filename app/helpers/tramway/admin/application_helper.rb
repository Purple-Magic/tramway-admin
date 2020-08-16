# frozen_string_literal: true

module Tramway
  module Admin
    module ApplicationHelper
      include ::FontAwesome5::Rails::IconHelper
      include AdditionalButtonsBuilder
      include ::SmartButtons
      include CasesHelper
      include RussianCasesHelper
      include ::Tramway::Admin::RecordsHelper
      include ::Tramway::Admin::SingletonHelper
      include ::Tramway::Admin::NavbarHelper
      include ::Tramway::Core::InputsHelper
      include ::Tramway::Admin::FocusGeneratorHelper
      include ::Tramway::Admin::ActionsHelper
      include ::Tramway::Collections::Helper
      include ::Tramway::Core::CopyToClipboardHelper

      def object_type(object)
        object_class_name = if object.class.ancestors.include? ::Tramway::Core::ApplicationDecorator
                              object.class.model_class.name
                            else
                              object.class.name
                            end
        ::Tramway::Admin.available_models_for(@application_engine || @application.name).map(&:to_s).include?(object_class_name) ? :record : :singleton
      end

      def current_admin
        user = Tramway::User::User.find_by id: session[:admin_id]
        return false unless user

        Tramway::User::UserDecorator.decorate user
      end
    end
  end
end
