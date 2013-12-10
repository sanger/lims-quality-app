require 'lims-quality-app/spec_helper'
require 'base64'

shared_context "mock gel image score" do
  before do
    Lims::Core::Persistence::Session.any_instance.tap do |session_instance|
      session_instance.stub_chain(:gel_image, :[]) { new_scored_gel_image }
      session_instance.stub(:score) do
        mock(:session_score).tap do |sc|
          Lims::QualityApp::GelImage::Score::SCORES.each do |score|
            sc.stub(:[]).with(:score => score) { Lims::QualityApp::GelImage::Score.new(:score => score) }
          end
        end
      end
    end
  end
end
