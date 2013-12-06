require 'lims-core/persistence/filter'
require 'lims-core/resource'

module Lims::Core
  module Persistence
    class GelFilter < Lims::Core::Persistence::Filter
      include Lims::Core::Resource
      NOT_IN_ROOT = 1
      attribute :criteria, Hash, :required => true

      def initialize(criteria)
        criteria = {:criteria => criteria} unless criteria.include?(:criteria)
        criteria[:criteria].rekey!{ |k| k.to_sym }
        super(criteria)
      end

      def call(persistor)
        persistor.gel_filter(criteria)
      end
    end

    class Persistor
      def gel_filter(criteria)
        raise NotImplementedError "gel_filter methods needs to be implemented for subclass of Persistor"
      end
    end
  end
end
