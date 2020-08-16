# frozen_string_literal: true

require 'tramway/helpers/class_name_helpers'

module Tramway
  module Admin
    class ApplicationController < ::Tramway::Core::ApplicationController
      include Tramway::ClassNameHelpers
      include Tramway::AuthManagement
      include RecordRoutesHelper
      before_action :authenticate_admin!
      before_action :application
      before_action :notifications
      before_action :notifications_count
      before_action :collections_counts, if: :model_given?
      before_action :check_available!
      before_action :check_available_scope!, if: :model_given?, only: :index

      protect_from_forgery with: :exception

      protected

      def check_available!
        raise 'Model or Form is not available' if !model_given? && !form_given?
      end

      def check_available_scope!
        raise 'Scope is not available' if params[:scope].present? && !available_scope_given?
      end

      def collections_counts
        @counts = decorator_class.collections.reduce({}) do |hash, collection|
          records = model_class.active.send(collection)
          records = records.send "#{current_admin.role}_scope", current_admin.id
          records = records.ransack(params[:filter]).result if params[:filter].present?
          params[:list_filters]&.each do |filter, value|
            case decorator_class.list_filters[filter.to_sym][:type]
            when :select
              records = decorator_class.list_filters[filter.to_sym][:query].call(records, value) if value.present?
            when :dates
              begin_date = params[:list_filters][filter.to_sym][:begin_date]
              end_date = params[:list_filters][filter.to_sym][:end_date]
              if begin_date.present? && end_date.present?
                if value.present?
                  records = decorator_class.list_filters[filter.to_sym][:query].call(records, begin_date, end_date)
                end
              end
            end
          end
          hash.merge! collection => records.count
        end
      end

      def application
        if ::Tramway::Core.application
          @application = Tramway::Core.application&.model_class&.first || Tramway::Core.application
        end
      end

      def notifications
        if current_admin
          @notifications ||= Tramway::Admin.notificable_queries&.reduce({}) do |hash, notification|
            hash.merge! notification[0] => notification[1].call(current_admin)
          end
        end
        @notifications
      end

      def notifications_count
        @notifications_count = notifications&.reduce(0) do |count, notification|
          count += notification[1].count
        end
      end

      if Rails.env.production?
        rescue_from StandardError do |exception|
          Rails.logger.warn "ERROR MESSAGE: #{exception.message}"
          Rails.logger.warn "BACKTRACE: #{exception.backtrace.first(30).join("\n")}"
          @exception = exception
          render 'tramway/admin/shared/errors/server_error', status: 500, layout: false
        end
      end

      include Tramway::ClassNameHelpers

      def model_class
        model_class_name(params[:model] || params[:form])
      end

      def decorator_class
        decorator_class_name
      end

      def admin_form_class
        "::#{current_admin.role.camelize}::#{model_class}Form".constantize
      end

      def model_given?
        available_models_given? || singleton_models_given?
      end

      def form_given?
        # FIXME: add tramway error locales to the tramway admin gem
        # Tramway::Error.raise_error(
        #  :tramway, :admin, :application_controller, :form_given, :model_not_included_to_tramway_admin,
        #  model: params[:model]
        # )
        # raise "Looks like model #{params[:model]} is not included to tramway-admin for `#{current_admin.role}` role. Add it in the `config/initializers/tramway.rb`. This way `Tramway::Admin.set_available_models(#{params[:model]})`"
        if params[:form].present?
          Tramway::Admin.forms.include? params[:form].underscore.sub(%r{^admin/}, '').sub(/_form$/, '')
        end
      end

      def available_scope_given?
        params[:scope].present? && params[:scope].in?(decorator_class.collections.map(&:to_s))
      end

      def available_models_given?
        check_models_given? :available
      end

      def singleton_models_given?
        check_models_given? :singleton
      end

      def current_admin
        user = Tramway::User::User.find_by id: session[:admin_id]
        return false unless user

        Tramway::User::UserDecorator.decorate user
      end

      private

      def check_models_given?(model_type)
        models = ::Tramway::Admin.send("#{model_type}_models", role: current_admin.role)
        models.any? && params[:model].in?(models.map(&:to_s))
      end

      def authenticate_admin!
        if !current_admin && !request.path.in?(['/admin/session/new', '/admin/session'])
          redirect_to '/admin/session/new'
        end
      end
    end
  end
end
