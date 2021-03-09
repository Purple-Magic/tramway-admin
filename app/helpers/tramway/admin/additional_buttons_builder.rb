# frozen_string_literal: true

module Tramway::Admin::AdditionalButtonsBuilder
  def build_button(button)
    options = button[:options] || {}
    concat(link_to(button[:url], method: button[:method], class: "btn btn-#{button[:color]} btn-xs", **options) do
      button[:inner].call
    end)
  end
end
