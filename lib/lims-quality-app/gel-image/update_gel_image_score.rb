require "lims-core/actions/action"
require "lims-quality-app/gel-image/gel_image"
require "lims-quality-app/gel-image/score/score"
require 'lims-quality-app/gel-image/validation_shared'

module Lims::QualityApp
  class GelImage
    class UpdateGelImageScore
      include Lims::Core::Actions::Action
      include ValidationShared

      attribute :gel_image, GelImage, :required => false
      attribute :gel_uuid, String, :required => false
      attribute :scores, Hash, :required => false, :default => {}
      validates_with_method :ensure_gel_parameter
      validates_with_method :ensure_scores

      def _call_in_session(session)
        gi = gel_image || session.gel_image[:gel_uuid => gel_uuid]
        scores.each do |location, score|
          gi.scores[location] = session.score[:score => score]
        end

        {:gel_image => gi}
      end

      def ensure_gel_parameter
        unless gel_image || gel_uuid
          return [false, "A gel image uuid or a gel uuid must be passed."]
        end
        true
      end
    end

    Update = UpdateGelImageScore
  end
end
