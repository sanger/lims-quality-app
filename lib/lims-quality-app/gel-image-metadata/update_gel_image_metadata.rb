require "lims-core/actions/action"
require "lims-quality-app/gel-image-metadata/gel_image_metadata"

module Lims::QualityApp
  class GelImageMetadata
    class UpdateGelImageMetadata
      include Lims::Core::Actions::Action
      attribute :gel_image_metadata, GelImageMetadata, :required => true
      attribute :score, String, :required => true

      def _call_in_session(session)
        gel_image_metadata.score = score
        {:gel_image_metadata => gel_image_metadata}
      end
    end

    Update = UpdateGelImageMetadata
  end
end
