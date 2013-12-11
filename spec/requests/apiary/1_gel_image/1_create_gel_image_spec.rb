require "requests/apiary/1_gel_image/spec_helper"
describe "create_gel_image", :gel_image => true do
  include_context "use core context service"
  it "create_gel_image" do

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/gel_images", <<-EOD
    {
    "gel_image": {
        "gel_uuid": "11111111-2222-3333-4444-666666666666",
        "image": "aW1hZ2U=",
        "filename": "image.jpg",
        "scores": {
            "A1": "pass",
            "B2": "fail"
        }
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
        "image": "aW1hZ2U=",
        "filename": "image.jpg",
        "scores": {
            "A1": "pass",
            "B2": "fail"
        }
    }
}
    EOD

  end
end
