require 'lims-core/persistence/store'
require 'lims-quality-app/gel-image-metadata/spec_helper'

module Lims::QualityApp
  describe GelImageMetadata::UpdateGelImageMetadata do 
    let(:store) { Lims::Core::Persistence::Store.new }
    let(:gel_uuid) { "11111111-2222-3333-4444-666666666666" }
    let(:score) { "good" }
    let(:new_score) { "very good" }
    let(:gel_image_metadata) { GelImageMetadata.new(:gel_uuid => gel_uuid, :score => score) }
    let(:parameters) {{
      :store => store,
      :user => user,
      :application => application,
      :gel_image_metadata => gel_image_metadata,
      :score => new_score
    }}

    include_context "for application", "update gel image"

    context "when the action is invalid" do
      it "requires a gel image metadata" do
        described_class.new(parameters - [:gel_image_metadata]).valid?.should == false
      end

      it "requires a score" do
        described_class.new(parameters - [:score]).valid?.should == false
      end
    end


    context "when the action is valid" do
      include_context "create object"

      subject do
        described_class.new(:store => store, :user => user, :application => application) do |a,s|
          a.gel_image_metadata = gel_image_metadata
          a.score = new_score
        end
      end

      it "is valid" do
        described_class.new(parameters).valid?.should == true
      end

      it_behaves_like "an action"

      it "updates the gel image metadata" do
        Lims::Core::Persistence::Session.any_instance.should_receive(:save_all)
        result = subject.call
        gel_image_metadata = result[:gel_image_metadata]
        gel_image_metadata.should be_a(GelImageMetadata)
        gel_image_metadata.score.should == new_score
        gel_image_metadata.gel_uuid.should == gel_uuid
      end
    end
  end
end
