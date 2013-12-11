require 'lims-quality-app/gel-image/persistence/sequel/spec_helper'
require 'lims-quality-app/gel-image/gel_image_persistor'
require 'lims-quality-app/gel-image/gel_image_shared'
require 'lims-quality-app/gel-image/create_gel_image'
require 'lims-quality-app/integration_helper'

module Lims::QualityApp
  describe GelImage::CreateGelImage do
    include_context "use core context service"
    include_context "gel image factory"
    include_context "for application", "create gel image"

    context "when creating a gel image" do
      subject do
        described_class.new(:store => store, :user => user, :application => application) do |a,s|
          a.gel_uuid = "11111111-2222-3333-4444-555555555555"
          a.image = Base64.encode64("image 1")
          a.filename = "image.jpg"
          a.scores = action_scores
        end
      end

      it_behaves_like "changing the table", :gel_images, 1
      it_behaves_like "changing the table", :gel_image_position_scores, 4
      it_behaves_like "changing the table", :scores, 0
    end
  end
end
