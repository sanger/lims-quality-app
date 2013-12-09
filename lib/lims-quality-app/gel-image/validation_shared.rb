require 'lims-quality-app/gel-image/score/score'

module Lims::QualityApp
  class GelImage
    module ValidationShared
      VALID_POSITION = /^[A-Za-z][0-9]+$/ 

      def ensure_scores
        scores.each do |position, score|
          unless position =~ VALID_POSITION
            return [false, "#{position} is not a valid position."]
          end

          unless GelImage::Score::SCORES.include?(score.to_s.downcase)
            return [false, "#{score} is not a valid score for the position #{position}. Valid scores are #{GelImage::Score::SCORES.join(", ")}."]
          end
        end
        true
      end
    end
  end
end
