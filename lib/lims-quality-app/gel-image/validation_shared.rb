require 'lims-quality-app/gel-image/score/score'

module Lims::QualityApp
  class GelImage
    module ValidationShared
      VALID_POSITION = /^[A-Za-z][0-9]+$/ 
      VALID_BASE64_ENCODING = /^([\w+\/]{4})*([\w+\/]{4}|[\w+\/]{3}=|[\w+\/]{2}==)$/

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

      # The size of a base64 encoded string is a multiple of 4.
      # The encoding contains 64 possible caracters: a-z, A-Z, 0-9, = and +
      # plus the padding caracter =
      # Depending on the specification, we could have \n inserted which 
      # doesn't count in the size of the encoded string.
      # @see http://en.wikipedia.org/wiki/Base64
      def ensure_image
        unless image && image.gsub("\n",'').size % 4 == 0 && image =~ VALID_BASE64_ENCODING
          return [false, "The encoded image doesn't look to be base64 encoded."]
        end
        true
      end
    end
  end
end
