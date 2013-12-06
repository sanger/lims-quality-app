Sequel.migration do
  up do
    create_table :gel_images do
      primary_key :id
      String :gel_uuid, :fixed => true, :size => 64
      Blob :image
    end

    create_table :gel_image_position_scores do
      primary_key :id
      foreign_key :gel_image_id, :gel_images, :key => :id
      String :position
      foreign_key :score_id, :scores, :key => :id
    end

    create_table :scores do
      primary_key :id
      String :score
      index :score, :unique => true
    end

    ["pass", "fail", "degraded", "partially degraded"].each do |score|
      self[:scores].insert(:score => score)
    end
  end

  down do
    drop_table :gel_image_position_scores
    drop_table :gel_images
    drop_table :scores
  end
end
