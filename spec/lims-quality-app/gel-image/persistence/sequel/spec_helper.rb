require 'lims-quality-app/gel-image/persistence/sequel/spec_helper'

shared_examples_for "changing the table" do |table, quantity|
  it "modifies the #{table} table" do
    expect do
      subject.call
    end.to change { db[table.to_sym].count }.by(quantity)
  end
end
