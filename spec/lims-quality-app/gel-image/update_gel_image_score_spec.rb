require 'lims-core/persistence/store'
require 'lims-quality-app/gel-image/spec_helper'
require 'lims-quality-app/gel-image/gel_image_shared'

module Lims::QualityApp
  describe GelImage::UpdateGelImageScore do 
    include_context 'gel image factory'

    let(:store) { Lims::Core::Persistence::Store.new }
    let(:parameters) {
      {
        :store => store,
        :user => user,
        :application => application,
        :gel_image => new_gel_image,
        :scores => {}
      }
    }

    include_context "for application", "create gel image"

    context "when the action is invalid" do
      it "requires a gel image or a gel uuid" do
        described_class.new(parameters - [:gel_image, :gel_uuid]).valid?.should == false
      end

      it "requires valid scores" do
        described_class.new(parameters.tap { |p| p[:scores]["E5"] = "dummy score" }).valid?.should == false
      end

      it "requires valid position" do
        described_class.new(parameters.tap { |p| p[:scores]["dummy"] = "pass" }).valid?.should == false
      end
    end


    context "when the action is valid" do
      include_context "create object"
      include_context "mock gel image score"

      context "updating a gel image scores" do
        subject do
          described_class.new(:store => store, :user => user, :application => application) do |a,s|
            a.gel_image = new_scored_gel_image 
            a.scores = {
              "A1" => "fail",
              "C3" => "pass",
              "E5" => "partially degraded"
            }
          end
        end

        it "is valid" do
          described_class.new(parameters).valid?.should == true
        end

        it_behaves_like "an action"

        it "updates the gel image" do
          Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
          result = subject.call
          gel_image = result[:gel_image]
          gel_image.should be_a(GelImage)
          gel_image.gel_uuid.should == "11111111-2222-3333-4444-555555555555"
          gel_image.image.should == "encoded image"
          gel_image.scores.size.should == 5
          gel_image.scores["A1"].score.should == "fail"
          gel_image.scores["B2"].score.should == "fail"
          gel_image.scores["C3"].score.should == "pass"
          gel_image.scores["D4"].score.should == "partially degraded"
          gel_image.scores["E5"].score.should == "partially degraded"
        end
      end
    end
  end
end
