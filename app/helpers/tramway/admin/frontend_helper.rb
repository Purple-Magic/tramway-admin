module Tramway::Admin::FrontendHelper
  def react_params(form, action, method)
    url = case action
          when :create
            Tramway::Admin::Engine.routes.url_helpers.records_path(model: form.model.class)
          else
            Tramway::Admin::Engine.routes.url_helpers.record_path(form.model.id, model: form.model.class)
          end
    form.properties.reduce({ action: url, method: method, authenticity_token: form_authenticity_token }) do |hash, property|
      case property[1]
      when :association
        hash.merge!(
          property[0] => {
            collection: build_collection_for_association(form, property[0])
          }
        )
      end
      hash
    end.merge model: form.model.attributes
  end
end
