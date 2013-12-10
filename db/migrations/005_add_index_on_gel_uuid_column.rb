Sequel.migration do
  up do
    alter_table :gel_images do
      add_index :gel_uuid, :unique => true
    end
  end

  down do
    alter_table :gel_images do
      drop_index :gel_uuid
    end
  end
end
