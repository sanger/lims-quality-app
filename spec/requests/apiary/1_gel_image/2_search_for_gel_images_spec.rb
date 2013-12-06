require "requests/apiary/1_gel_image/spec_helper"
describe "search_for_gel_images", :gel_image => true do
  include_context "use core context service"
  it "search_for_gel_images" do


    gel_image1 = Lims::QualityApp::GelImage.new(:gel_uuid => "11111111-0000-0000-0000-111111111111", :image => "encoded image 1")
    gel_image2 = Lims::QualityApp::GelImage.new(:gel_uuid => "11111111-0000-0000-0000-222222222222", :image => "encoded image 2")
    
    save_with_uuid gel_image1 => [1,2,3,4,6], gel_image2 => [1,2,3,4,7]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/searches", <<-EOD
    {
    "search": {
        "description": "search for gel images by gel uuids",
        "model": "gel_image",
        "criteria": {
            "gel": {
                "uuid": "11111111-0000-0000-0000-111111111111"
            }
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "search": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "first": "http://example.org/11111111-2222-3333-4444-555555555555/page=1",
            "last": "http://example.org/11111111-2222-3333-4444-555555555555/page=-1"
        },
        "uuid": "11111111-2222-3333-4444-555555555555"
    }
}
    EOD

  # Get the search result

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/11111111-2222-3333-4444-555555555555/page=1"
    response.should match_json_response(200, <<-EOD) 
    {
    "actions": {
        "read": "http://example.org/11111111-2222-3333-4444-555555555555/page=1",
        "first": "http://example.org/11111111-2222-3333-4444-555555555555/page=1",
        "last": "http://example.org/11111111-2222-3333-4444-555555555555/page=-1"
    },
    "size": 1,
    "gel_images": [
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
            },
            "uuid": "11111111-2222-3333-4444-666666666666",
            "gel_uuid": "11111111-0000-0000-0000-111111111111",
            "image": "encoded image 1",
            "scores": {
            }
        }
    ]
}
    EOD

  end
end
