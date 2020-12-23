module Tramway::Admin::TramwayModelHelper
  def tramway_model?(model_class)
    model_class.ancestors.include? Tramway::Core::ApplicationRecord
  end
end
