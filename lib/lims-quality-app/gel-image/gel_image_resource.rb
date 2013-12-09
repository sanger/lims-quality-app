require 'lims-api/core_resource'
require 'lims-api/struct_stream'

module Lims::QualityApp
  class GelImage
    class GelImageResource < Lims::Api::CoreResource

      def content_to_stream(s, mime_type)
        object.attributes.each do |k,v|
          s.add_key k
          s.add_value v
        end

        scores_to_stream(s, mime_type) 
      end

      def scores_to_stream(s, mime_type)
        s.add_key "scores"
        s.with_hash do
          object.scores.each do |position, gel_image_score|
            s.add_key position
            s.add_value gel_image_score.score
          end
        end
      end
    end
  end
end
