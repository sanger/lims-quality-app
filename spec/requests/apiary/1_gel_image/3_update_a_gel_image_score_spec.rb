require "requests/apiary/1_gel_image/spec_helper"
describe "update_a_gel_image_score", :gel_image => true do
  include_context "use core context service"
  it "update_a_gel_image_score" do
    gel_image = Lims::QualityApp::GelImage.new(
      :gel_uuid => "11111111-2222-3333-4444-666666666666",
      :image => "encoded image 1"
    )
    debugger
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
}
    EOD

  end
end
