# frozen_string_literal: true

module Tramway::Admin::ActionsHelper
  def destroy_is_available?(association_object, _main_object)
    ::Tramway::Admin.action_is_available?(
      association_object,
      project: (@application_engine || @application.name),
      model_name: association_object.model.class.name,
      role: current_admin.role,
      action: :destroy
    )
  end

  def update_is_available?(association_object, _main_object)
    ::Tramway::Admin.action_is_available?(
      association_object,
      project: (@application_engine || @application.name),
      model_name: association_object.model.class.name,
      role: current_admin.role,
      action: :update
    )
  end

  def create_is_available?(association_class)
    ::Tramway::Admin.action_is_available?(
      nil,
      project: (@application_engine || @application.name),
      model_name: association_class,
      role: current_admin.role,
      action: :create
    )
  end

  # delete_button is in smart-buttons gem

  def edit_button(url:, button_options:)
    link_to(url, **button_options) { yield }
  end

  def habtm_destroy_is_available?(association_object, main_object)
    ::Tramway::Admin.forms&.include?("#{main_object.model.class.to_s.underscore.pluralize}/remove_#{association_object.model.class.to_s.underscore}")
  end
end
