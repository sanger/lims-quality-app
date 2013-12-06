require 'lims-core/resource'
require 'lims-quality-app/gel-image/gel_image'

module Lims::QualityApp
  class GelImage
    class Score
      include Lims::Core::Resource

      SCORES = ["pass", "fail", "degraded", "partially degraded"]
      attribute :score, String, :required => true, :initializable => true
    end
  end
end
