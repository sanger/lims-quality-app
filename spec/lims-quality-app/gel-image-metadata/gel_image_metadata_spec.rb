require 'lims-quality-app/gel-image-metadata/spec_helper'

module Lims::QualityApp
  describe GelImageMetadata do

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

    let(:score) { "good" }
    let(:gel_uuid) { "11111111-2222-3333-4444-555555555555" }


    context "when valid" do
      subject { described_class.new(:score => score, :gel_uuid => gel_uuid) }

      it "is a valid gel image metadata" do
        subject.valid?.should == true
      end

      it_has_a :score
      it_has_a :gel_uuid
    end


    context "when invalid" do
      it "returns false when there is no score" do
        GelImageMetadata.new(:gel_uuid => gel_uuid).valid?.should == false
      end

      it "returns false when there is no gel uuid" do
        GelImageMetadata.new(:score => score).valid?.should == false
      end
    end
  end
end
