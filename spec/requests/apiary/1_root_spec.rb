require "requests/apiary/spec_helper"
describe "root" do
  include_context "use core context service"
  it "root" do

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/"
    response.should match_json_response(200, <<-EOD) 
    {
    "actions": {
        "read": "http://example.org/"
    },
    "gel_images": {
        "actions": {
            "create": "http://example.org/gel_images",
            "read": "http://example.org/gel_images",
            "first": "http://example.org/gel_images/page=1",
            "last": "http://example.org/gel_images/page=-1"
        }
    },
    "uuid_resources": {
        "actions": {
            "create": "http://example.org/uuid_resources",
            "read": "http://example.org/uuid_resources",
            "first": "http://example.org/uuid_resources/page=1",
            "last": "http://example.org/uuid_resources/page=-1"
        }
    },
    "searches": {
        "actions": {
            "create": "http://example.org/searches",
            "read": "http://example.org/searches",
            "first": "http://example.org/searches/page=1",
            "last": "http://example.org/searches/page=-1"
        }
    },
    "multi_criteria_filters": {
        "actions": {
            "create": "http://example.org/multi_criteria_filters",
            "read": "http://example.org/multi_criteria_filters",
            "first": "http://example.org/multi_criteria_filters/page=1",
            "last": "http://example.org/multi_criteria_filters/page=-1"
        }
    },
    "create_gel_images": {
        "actions": {
            "create": "http://example.org/actions/create_gel_image"
        }
    },
    "update_gel_image_scores": {
        "actions": {
            "create": "http://example.org/actions/update_gel_image_score"
        }
    },
    "create_searches": {
        "actions": {
            "create": "http://example.org/actions/create_search"
        }
    },
    "revision": 3
}
    EOD

  end
end
