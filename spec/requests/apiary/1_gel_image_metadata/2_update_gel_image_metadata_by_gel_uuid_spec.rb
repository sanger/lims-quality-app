require "requests/apiary/1_gel_image_metadata/spec_helper"
describe "update_gel_image_metadata_by_gel_uuid", :gel_image_metadata => true do
  include_context "use core context service"
  it "update_gel_image_metadata_by_gel_uuid" do
    gel_image_metadata = Lims::QualityApp::GelImageMetadata.new(
      :score => "good", 
      :gel_uuid => "11111111-2222-3333-4444-666666666666"
    )
    save_with_uuid gel_image_metadata => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/update_gel_image_metadata", <<-EOD
    {
    "update_gel_image_metadata": {
        "by_gel_uuid": "11111111-2222-3333-4444-666666666666",
        "score": "very good"
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "update_gel_image_metadata": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
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
        },
        "gel_image_metadata": null,
        "by_gel_uuid": "11111111-2222-3333-4444-666666666666",
        "score": "very good"
    }
}
    EOD

  end
end
