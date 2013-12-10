require 'base64'
require 'lims-quality-app/gel-image/spec_helper'

module Lims::QualityApp
  shared_context "gel image factory" do
    def new_gel_image(gel_uuid = "11111111-2222-3333-4444-555555555555", image = Base64.encode64("image 1"))
      GelImage.new(:gel_uuid => gel_uuid, :image => image)
    end

    def new_scored_gel_image(gel_uuid="11111111-2222-3333-4444-555555555555", image = Base64.encode64("image 1"))
      new_gel_image(gel_uuid, image).tap do |gel_image|
        gel_image.scores = scores
      end
    end 

    def scores
      {
        "A1" => GelImage::Score.new(:score => "pass"),
        "B2" => GelImage::Score.new(:score => "fail"),
        "C3" => GelImage::Score.new(:score => "degraded"),
        "D4" => GelImage::Score.new(:score => "partially degraded")
      }
    end

    def gel_image_action_parameters
      {
        :gel_uuid => "11111111-2222-3333-4444-555555555555",
        :image => Base64.encode64("image 1"),
        :scores => action_scores
      }
    end

    def action_scores
      {
        "A1" => "pass",
        "B2" => "fail",
        "C3" => "degraded",
        "D4" => "partially degraded"
      }
    end
  end
end
