require "requests/apiary/2_gel_image_errors/spec_helper"
describe "create_a_gel_image_with_invalid_score", :gel_image_errors => true do
  include_context "use core context service"
  it "create_a_gel_image_with_invalid_score" do

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/gel_images", <<-EOD
    {
    "gel_image": {
        "gel_uuid": "11111111-2222-3333-4444-666666666666",
        "image": "image encoded",
        "scores": {
            "A1": "dummy score",
            "B2": "fail"
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "ensure_scores": [
            "dummy score is not a valid score for the location A1. Valid scores are pass, fail, degraded, partially degraded."
        ]
    }
}
    EOD

  end
end
