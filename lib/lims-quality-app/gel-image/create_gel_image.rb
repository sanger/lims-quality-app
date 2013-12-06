require "lims-core/actions/action"
require "lims-quality-app/gel-image/gel_image"
require 'lims-quality-app/gel-image/validation_shared'

module Lims::QualityApp
  class GelImage
    class CreateGelImage
      include Lims::Core::Actions::Action
      include ValidationShared

      attribute :image, String, :required => true
      attribute :gel_uuid, String, :required => true
      attribute :scores, Hash, :required => false
      validates_with_method :ensure_scores

      def _call_in_session(session)
        gel_image = GelImage.new(:image => image, :gel_uuid => gel_uuid)
        scores.each do |location, score|
          gel_image.scores[location] = score
        end

        session << gel_image

        {:gel_image => gel_image, :uuid => session.uuid_for!(gel_image)}
      end
    end

    Create = CreateGelImage
  end
end
