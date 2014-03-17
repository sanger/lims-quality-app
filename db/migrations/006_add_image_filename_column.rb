Sequel.migration do
  up do
    alter_table :gel_images do
      add_column :filename, String
    end
  end

  down do
    drop_column :filename
  end
end
