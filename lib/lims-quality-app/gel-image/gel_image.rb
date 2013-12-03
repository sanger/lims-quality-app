require 'lims-core/resource'
require 'lims-quality-app/gel-image-metadata/gel_image_metadata'

module Lims::QualityApp
  class GelImage
    include Lims::Core::Resource
    
    attribute :gel_image_metadata, GelImageMetadata, :required => true, :initializable => true
    attribute :image, String, :required => true, :initializable => true
  end
end
