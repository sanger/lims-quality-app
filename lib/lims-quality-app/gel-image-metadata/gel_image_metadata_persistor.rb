require 'lims-core/persistence/persistor'
require 'lims-core/persistence/persistable_trait'
require 'lims-core/persistence/sequel/persistor'

module Lims::QualityApp
  class GelImageMetadata
    does "lims/core/persistence/persistable"

    class GelImageMetadataSequelPersistor < GelImageMetadataPersistor
      include Lims::Core::Persistence::Sequel::Persistor
      def self.table_name
        :gel_image_metadata
      end
    end
  end
end
