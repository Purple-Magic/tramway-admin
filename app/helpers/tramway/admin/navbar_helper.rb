# frozen_string_literal: true

module Tramway
  module Admin
    module NavbarHelper
      def customized_admin_navbar_given?
        customized_admin_navbar.present?
      end

      def customized_admin_navbar
        ::Tramway::Admin.customized_admin_navbar
      end
    end
  end
end
