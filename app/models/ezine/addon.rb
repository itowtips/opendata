module Ezine::Addon
  module Page
    module Body
      extend SS::Addon
      extend ActiveSupport::Concern

      set_order 300

      included do
        field :html, type: String, default: ""
        field :text, type: String, default: ""
      end
    end
  end
end
