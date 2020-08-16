# frozen_string_literal: true

module Tramway::Admin::AdditionalButtonsBuilder
  def build_buttons(additional_buttons)
    additional_buttons = additional_buttons.is_a?(Hash) ? [additional_buttons] : additional_buttons
    additional_buttons.each do |button|
      options = button[:options] || {}
      concat(
        link_to(
          button[:url], method: button[:method], class: "btn btn-#{button[:color]} btn-xs", **options
        ) do
          button[:text]
        end
      )
    end
  end
end
