require 'lims-core/persistence/persistor'
require 'lims-core/persistence/persistable_trait'
require 'lims-core/persistence/sequel/persistor'

module Lims::QualityApp
  class GelImage
    class Score
      does "lims/core/persistence/persistable"
    end
  end
end
