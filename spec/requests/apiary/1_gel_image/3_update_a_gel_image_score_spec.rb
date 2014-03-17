require "requests/apiary/1_gel_image/spec_helper"
describe "update_a_gel_image_score", :gel_image => true do
  include_context "use core context service"
  it "update_a_gel_image_score" do
    gel_image = Lims::QualityApp::GelImage.new(
      :gel_uuid => "11111111-2222-3333-4444-666666666666",
      :image => "aW1hZ2UgMQ==",
      :filename => "image.jpg",
      :scores => {
        "A1" => Lims::QualityApp::GelImage::Score.new(:score => "fail"),
        "D4" => Lims::QualityApp::GelImage::Score.new(:score => "partially degraded")
      }
    )
    
    save_with_uuid gel_image => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "scores": {
        "A1": "pass",
        "B2": "fail",
        "C3": "degraded"
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "gel_image": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "gel_uuid": "11111111-2222-3333-4444-666666666666",
        "image": "aW1hZ2UgMQ==",
        "filename": "image.jpg",
        "scores": {
            "A1": "pass",
            "D4": "partially degraded",
            "B2": "fail",
            "C3": "degraded"
        }
    }
}
    EOD

  end
end
