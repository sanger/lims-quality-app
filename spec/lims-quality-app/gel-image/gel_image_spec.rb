require 'lims-quality-app/gel-image/spec_helper'
require 'lims-quality-app/gel-image/score/score'
require 'lims-quality-app/gel-image/gel_image_shared'

module Lims::QualityApp
  describe GelImage do

    def self.it_has_a(attribute, type = nil)
      it "responds to #{attribute}" do
        subject.should respond_to(attribute)
      end

      it "can assign #{attribute}" do
        value = mock(:attribute)
        subject.send("#{attribute}=", value)
        subject.send(attribute).should == value
      end
    end

    let(:image) { "encoded image 1" }
    let(:gel_uuid) { "11111111-2222-3333-4444-555555555555" }

    context "when valid" do
      include_context "gel image factory"
      subject { new_scored_gel_image }

      it "is a valid gel image" do
        subject.valid?.should == true
      end

      it_has_a :filename
      it_has_a :image
      it_has_a :scores
      it_has_a :gel_uuid
    end


    context "when invalid" do
      it "returns false when there is no image" do
        GelImage.new(:gel_uuid => gel_uuid).valid?.should == false
      end

      it "returns false when there is no gel uuid" do
        GelImage.new(:image => image).valid?.should == false
      end
    end
  end
end
