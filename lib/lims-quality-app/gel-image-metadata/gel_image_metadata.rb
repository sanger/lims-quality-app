require 'lims-core/resource'

module Lims::QualityApp
  class GelImageMetadata
    include Lims::Core::Resource

    attribute :score, String, :required => true, :initializable => true
    attribute :gel_uuid, String, :required => true, :initializable => true, :writer => :private

  end
end
