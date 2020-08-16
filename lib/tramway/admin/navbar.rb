# frozen_string_literal: true

module Tramway::Admin::Navbar
  def navbar_structure(*links, project:)
    @navbar_structure ||= {}
    @navbar_structure.merge! project => links
  end

  def navbar_items_for(project, role:)
    project = project.underscore.to_sym unless project.is_a? Symbol
    @navbar_structure[project]&.map do |item|
      if item.is_a? Class
        should_be_in_navbar_as item, project, role
      elsif item.is_a? Hash
        sub_items = item.values.first.map do |sub_item|
          should_be_in_navbar_as sub_item, project, role
        end.compact
        { item.keys.first => sub_items } if sub_items.any?
      end
    end&.compact || []
  end

  private

  def should_be_in_navbar_as(item, project, role)
    if singleton_models_for(project, role: role).include?(item)
      { item => :singleton }
    elsif available_models_for(project, role: role).include?(item)
      { item => :record }
    elsif item.is_a? Symbol
      :divider
    end
  end
end
