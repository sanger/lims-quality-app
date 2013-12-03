Sequel.migration do
  up do
    create_table :gel_images do
      primary_key :id
      foreign_key :gel_image_metadata_id, :gel_image_metadata, :key => :id
      Blob :image
    end

    create_table :gel_image_metadata do
      primary_key :id
      String :gel_uuid, :fixed => true, :size => 64
      String :score
      index :gel_uuid, :unique => true
    end
  end

  down do
    drop_table :gel_images
    drop_table :gel_image_metadata
  end
end
