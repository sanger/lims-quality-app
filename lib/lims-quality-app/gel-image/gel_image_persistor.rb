require 'lims-core/persistence/persistor'
require 'lims-core/persistence/persistable_trait'
require 'lims-core/persistence/persist_association_trait'
require 'lims-core/persistence/sequel/persistor'
require 'lims-quality-app/gel-image/gel_image'
require 'lims-quality-app/gel-image/score/score'

module Lims::QualityApp
  class GelImage

    does "lims/core/persistence/persistable", :children => [
      {:name => :position_score, :session_name => :gel_image_position_score, :deletable => true}
    ]

    class GelImagePersistor
      def children_position_score(gel_image, children)
        gel_image.scores.each do |position, gel_image_score|
          next unless gel_image_score
          score_db = @session.score[:score => gel_image_score.score]
          position_score = PositionScore.new(gel_image, position, score_db)
          state = @session.state_for(position_score)
          state.resource = position_score
          children << position_score
        end
      end

      def filter_attributes_on_save(attributes, *params)
        super(attributes).tap do |attributes|
          attributes[:gel_uuid].tap do |uuid|
            attributes[:gel_uuid] = @session.pack_uuid(uuid) if uuid
          end
        end
      end

      def filter_attributes_on_load(attributes, *params)
        super(attributes).tap do |attributes|
          attributes[:gel_uuid].tap do |uuid|
            attributes[:gel_uuid] = @session.unpack_uuid(uuid)
          end
        end
      end

      association_class "PositionScore" do
        attribute :gel_image, GelImage, :relation => :parent, :skip_parents_for_attributes => true  
        attribute :position, String
        attribute :score, GelImage::Score, :relation => :parent

        def on_load
          @gel_image.scores[@position] = @score
        end

        def invalid?
          @gel_image.scores[@position] != @score || @score == nil
        end
      end

      class PositionScore
        class PositionScoreSequelPersistor < PositionScorePersistor
          include Lims::Core::Persistence::Sequel::Persistor
          def self.table_name
            :gel_image_position_scores
          end
        end
      end
    end
  end
end
