Sequel.migration do
  change do
    create_table? :uuid_resources do
      primary_key :id
      String :uuid, :fixed => true, :size => 64
      String :model_class
      Integer :key
      index :uuid
      index [:key, :model_class]
    end
  end
end
