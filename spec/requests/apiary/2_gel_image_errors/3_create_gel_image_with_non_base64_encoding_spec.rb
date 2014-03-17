require "requests/apiary/2_gel_image_errors/spec_helper"
describe "create_gel_image_with_non_base64_encoding", :gel_image_errors => true do
  include_context "use core context service"
  it "create_gel_image_with_non_base64_encoding" do

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/gel_images", <<-EOD
    {
    "gel_image": {
        "gel_uuid": "11111111-2222-3333-4444-666666666666",
        "image": "dummy encoding",
        "scores": {
            "A1": "pass",
            "B2": "fail"
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "ensure_image": [
            "The encoded image doesn't look to be base64 encoded."
        ]
    }
}
    EOD

  end
end
