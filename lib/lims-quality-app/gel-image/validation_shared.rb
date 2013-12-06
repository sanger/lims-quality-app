require 'lims-quality-app/gel-image/score/score'

module Lims::QualityApp
  class GelImage
    module ValidationShared
      def ensure_scores
        scores.each do |location, score|
          unless GelImage::Score::SCORES.include?(score.to_s.downcase)
            return [false, "#{score} is not a valid score for the location #{location}. Valid scores are #{GelImage::Score::SCORES.join(", ")}."]
          end
        end
        true
      end
    end
  end
end
