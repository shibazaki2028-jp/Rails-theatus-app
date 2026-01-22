module ApplicationHelper
    def render_errors
        resource_name = controller_name.singularize
        resource = instance_variable_get("@#{resource_name}")
    
        if resource&.errors&.any?
          render "shared/errors", obj: resource
        end
    end
end
