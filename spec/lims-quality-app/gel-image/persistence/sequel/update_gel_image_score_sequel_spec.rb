require 'lims-quality-app/gel-image/persistence/sequel/spec_helper'
require 'lims-quality-app/gel-image/gel_image_persistor'
require 'lims-quality-app/gel-image/gel_image_shared'
require 'lims-quality-app/gel-image/update_gel_image_score'
require 'lims-quality-app/integration_helper'

module Lims::QualityApp
  describe GelImage::UpdateGelImageScore do
    include_context "use core context service"
    include_context "gel image factory"
    include_context "for application", "update gel image score"

    let!(:gel_image_id) { save(new_scored_gel_image) }

    context "when updating the gel image scores" do
      context "with a gel image" do
        subject do
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.gel_image = s.gel_image[gel_image_id] 
            a.scores = {
              "A1" => "degraded",
              "C3" => "partially degraded",
              "E5" => "pass"
            }
          end
        end

        it_behaves_like "changing the table", :gel_images, 0
        it_behaves_like "changing the table", :gel_image_position_scores, 1
        it_behaves_like "changing the table", :scores, 0
      end

      context "with a gel uuid" do
        subject do
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.gel_uuid = "11111111-2222-3333-4444-555555555555"
            a.scores = {
              "A1" => "degraded",
              "C3" => "partially degraded",
              "E5" => "pass"
            }
          end
        end

        it_behaves_like "changing the table", :gel_images, 0
        it_behaves_like "changing the table", :gel_image_position_scores, 1
        it_behaves_like "changing the table", :scores, 0
      end
    end
  end
end
