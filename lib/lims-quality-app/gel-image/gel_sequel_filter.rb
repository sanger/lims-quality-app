require 'lims-core/persistence/sequel/filters'

module Lims::Core
  module Persistence
    module Sequel::Filters
      def gel_filter(criteria)
        criteria = criteria[:gel] if criteria.keys.first.to_s == "gel"
        criteria = criteria.mash do |k,v|
          case k
          when "uuid" then [:gel_uuid, v]
          else [k,v]
          end
        end
        criteria = @session.gel_image.filter_attributes_on_save(criteria)
        @session.gel_image.__multi_criteria_filter(criteria)
      end
    end
  end
end
