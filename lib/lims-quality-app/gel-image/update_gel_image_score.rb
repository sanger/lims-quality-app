require "lims-core/actions/action"
require "lims-quality-app/gel-image/gel_image"
require "lims-quality-app/gel-image/score/score"


module Lims::QualityApp
  class GelImage
    class UpdateGelImageScore
      include Lims::Core::Actions::Action

      attribute :scores, Hash, :required => true, :default => {}
      attribute :gel_image, GelImage, :required => false
      attribute :by_gel_uuid, String, :required => false
      validates_with_method :ensure_gel_parameter
      validates_with_method :ensure_scores

      def _call_in_session(session)
        gi = gel_image || session.gel_image[:gel_uuid => by_gel_uuid]
        scores.each do |location, score|
          gi.scores[location.to_sym] = session.gel_image_score[:score => score]
        end

        {:gel_image => gi}
      end

      def ensure_gel_parameter
        unless gel_image || by_gel_uuid
          return [false, "A gel image uuid or a gel uuid must be passed."]
        end
        true
      end

      def ensure_scores
       # scores.each do |location, score|
       #   unless GelImageScore::SCORES.include?(score.to_s.downcase)
       #     return [false, "#{score} is not a valid score for the location #{location}. Valid scores are #{GelImageScore::SCORES.inspect}"]
       #   end
       # end
        true
      end
    end

    Update = UpdateGelImageScore
  end
end
