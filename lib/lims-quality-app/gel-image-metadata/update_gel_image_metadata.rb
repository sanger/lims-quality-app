require "lims-core/actions/action"
require "lims-quality-app/gel-image-metadata/gel_image_metadata"

module Lims::QualityApp
  class GelImageMetadata
    class UpdateGelImageMetadata
      include Lims::Core::Actions::Action
      attribute :gel_image_metadata, GelImageMetadata, :required => false
      attribute :gel_uuid, String, :required => false
      attribute :score, String, :required => true
      validates_with_method :ensure_gel_parameter

      def _call_in_session(session)
        metadata = gel_image_metadata || session.gel_image_metadata[:gel_uuid => gel_uuid]
        metadata.score = score
        {:gel_image_metadata => metadata}
      end

      def ensure_gel_parameter
        unless gel_image_metadata || gel_uuid
          return [false, "A gel image metadata uuid or a gel uuid must be passed."]
        end
        true
      end
    end

    Update = UpdateGelImageMetadata
  end
end
