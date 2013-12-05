require "requests/apiary/1_gel_image/spec_helper"
describe "update_a_gel_image_score", :gel_image => true do
  include_context "use core context service"
  it "update_a_gel_image_score" do
    gel_image = Lims::QualityApp::GelImage.new(
      :gel_uuid => "11111111-2222-3333-4444-666666666666",
      :image => "encoded image 1"
    )
    
    save_with_uuid gel_image => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/update_gel_image_score", <<-EOD
    {
    "update_gel_image_score": {
        "by_gel_uuid": "11111111-2222-3333-4444-666666666666",
        "scores": {
            "A1": "pass",
            "B2": "fail",
            "C3": "degraded"
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "update_gel_image_score": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
            "gel_image": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "gel_uuid": "11111111-2222-3333-4444-666666666666",
                "image": "encoded image 1"
            }
        },
        "scores": {
            "A1": "pass",
            "B2": "fail",
            "C3": "degraded"
        },
        "gel_image": null,
        "by_gel_uuid": "11111111-2222-3333-4444-666666666666"
    }
}
    EOD

  end
end
