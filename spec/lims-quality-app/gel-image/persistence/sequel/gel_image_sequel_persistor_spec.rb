require 'lims-quality-app/gel-image/persistence/sequel/spec_helper'
require 'lims-quality-app/gel-image/gel_image_persistor'
require 'lims-quality-app/gel-image/gel_image_shared'
require 'lims-quality-app/integration_helper'

module Lims::QualityApp
  describe GelImage::GelImagePersistor do
    include_context "use core context service"
    include_context "gel image factory"

    shared_examples_for "a stored gel image" do
      let(:gel_image_id) { save(gel_image) }

      it "modifies the gel_image table" do
        expect do
          store.with_session do |session|
            session << gel_image
          end
        end.to change { db[:gel_images].count }.by(1)
      end

      it "is reloadable" do
        store.with_session do |session|
          gi_db = session.gel_image[gel_image_id]
          gi_db.should == gel_image
          gi_db.gel_uuid.should == gel_uuid
          gi_db.image.should == image
        end
      end
    end
    

    context "with a valid gel image" do
      let(:gel_uuid) { "11111111-2222-3333-4444-555555555555" }
      let(:image) { "encoded image" }
      let(:gel_image) { new_gel_image }

      it_behaves_like "a stored gel image"

      context "with scores" do
        let(:gel_image) { new_scored_gel_image }
        it_behaves_like "a stored gel image"

        it "modifies the gel_image_position_scores table" do
          expect do
            store.with_session do |session|
              session << gel_image
            end
          end.to change { db[:gel_image_position_scores].count }.by(4)
        end

        it "doesn't modify the gel_image_scores table" do
          expect do
            store.with_session do |session|
              session << gel_image
            end
          end.to change { db[:scores].count }.by(0)
        end

        it "reloads the scores" do
          store.with_session do |session|
            gi = session.gel_image[save(gel_image)]
            gi.should == gel_image
            gi.scores.size.should == gel_image.scores.size
            gi.scores.each do |location, score|
              gel_image.scores[location].should == score
            end
          end
        end
      end
    end
  end
end
