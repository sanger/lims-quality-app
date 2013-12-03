require "requests/apiary/1_gel_image_metadata/spec_helper"
describe "update_gel_image_metadata", :gel_image_metadata => true do
  include_context "use core context service"
  it "update_gel_image_metadata" do
    gel_image_metadata = Lims::QualityApp::GelImageMetadata.new(
      :score => "good", 
      :gel_uuid => "11111111-2222-3333-4444-666666666666"
    )
    save_with_uuid gel_image_metadata => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "score": "very good"
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "gel_image_metadata": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "score": "very good",
        "gel_uuid": "11111111-2222-3333-4444-666666666666"
    }
}
    EOD

  end
end
