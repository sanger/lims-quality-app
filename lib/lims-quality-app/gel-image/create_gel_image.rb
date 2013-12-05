require "lims-core/actions/action"
require "lims-quality-app/gel-image/gel_image"

module Lims::QualityApp
  class GelImage
    class CreateGelImage
      include Lims::Core::Actions::Action

      attribute :image, String, :required => true
      attribute :gel_uuid, String, :required => true

      def _call_in_session(session)
        gel_image = GelImage.new(:image => image, :gel_uuid => gel_uuid)
        session << gel_image

        {:gel_image => gel_image, :uuid => session.uuid_for!(gel_image)}
      end
    end

    Create = CreateGelImage
  end
end
