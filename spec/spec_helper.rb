require "lims-quality-app"
require "rack/test"
require "hashdiff"
require "json"

#set :environment, :test
#set :run, false
#set :raise_errors, true
#set :logging, false

def app
  Lims::Api::Server
end

module Helper
  def self.parse_json(arg)
    case arg
    when String then JSON.parse(arg)
    when Array, Hash then arg
    end.recurse{|h| h.rekey { |k| k.to_s } }
  end
end

class Hash
  def deep_diff(b)
    a = self
    (a.keys | b.keys).inject({}) do |diff, k|
      if a[k] != b[k]
        if a[k].respond_to?(:deep_diff) && b[k].respond_to?(:deep_diff)
          diff[k] = a[k].deep_diff(b[k])
        else
          diff[k] = [a[k], b[k]]
        end
      end
      diff
    end
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

RSpec::Matchers.define :match_json_response do |status, body|
  match { |to_match| to_match.status == status && Helper::parse_json(to_match.body) == Helper::parse_json(body) }

  failure_message_for_should do |actual|
    hactual = {:status => status, :body =>  Helper::parse_json(actual.body)}
    hcontent = {:status => actual.status, :body => Helper::parse_json(body) }
    diff = hactual ? hactual.deep_diff(hcontent) : hcontent
    "expected: \n#{JSON::pretty_generate(hcontent)}\nto match: \n#{JSON::pretty_generate(hactual)},\ndiff:\n#{JSON::pretty_generate(diff)} "
  end
end

RSpec::Matchers.define :match_json do |content|

  match { |to_match| Helper::parse_json(to_match) == Helper::parse_json(content) }

  failure_message_for_should do |actual|
    hactual = Helper::parse_json(actual)
    hcontent = Helper::parse_json(content)
    diff = hactual ? hactual.deep_diff(hcontent) : hcontent
    "expected: \n#{JSON::pretty_generate(hcontent)}\nto match: \n#{JSON::pretty_generate(hactual)},\ndiff:\n#{JSON::pretty_generate(diff)} "
  end
end

