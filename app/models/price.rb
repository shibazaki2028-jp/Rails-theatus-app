class Price < ApplicationRecord
    def name_with_value
        "#{ticket_type} (¥#{price})"
    end
end
