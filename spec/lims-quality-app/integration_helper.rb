require 'spec_helper'
require 'yaml'
require 'logger'
require 'sequel'
Sequel.extension :migration
Loggers = []

def connect_db(env)
  config = YAML.load_file(File.join('config','database.yml'))

  if RUBY_PLATFORM == "java"
    require 'jdbc/sqlite3'
    Sequel.connect('jdbc:sqlite:memory')
  else
    Sequel.connect(config[env.to_s], :loggers => Loggers)
  end
end

def config_bus(env)
  YAML.load_file(File.join('config','amqp.yml'))[env.to_s] 
end

def set_uuid(session, object, uuid)
  session << object
  ur = session.new_uuid_resource_for(object)
  ur.send(:uuid=, uuid)
end

module Helper
  def save(object)
    store.with_session do |session|
      session << object
      lambda { session.id_for(object) }
    end.call
  end
end

RSpec.configure do |c|
  c.include Helper
end

shared_context 'use core context service' do |user="user@example.com", application_id="application_id"|
  let(:db) { connect_db(:test) }
  let(:store) { Lims::Core::Persistence::Sequel::Store.new(db) }
  let(:message_bus) { double(:message_bus).tap { |m|
    m.stub(:connect)
    m.stub(:publish)
    m.stub(:backend_application_id)
  } } 
  let(:context_service) { Lims::Api::ContextService.new(store, message_bus) }

  before(:each) do
    if RUBY_PLATFORM == "java"
      Sequel::Migrator.run(db, 'db/migrations')
    end
    app.set(:context_service, context_service)
    header('user_email', user) if user
    header('application_id', application_id) if application_id
  end

  include_context "clean store"
end

shared_context "clean store" do
  after(:each) do
    %w{gel_image_position_scores gel_images uuid_resources primary_keys}.each do |table|
      db[table.to_sym].delete
    end
    db.disconnect
  end
end

shared_context 'JSON' do
  before(:each) {
    header('Accept', 'application/json')
    header('Content-Type', 'application/json')
  }
end

shared_context "use generated uuid" do 
  let! (:uuid) {
    '11111111-2222-3333-4444-555555555555'.tap do |uuid|
      Lims::Core::Persistence::UuidResource.stub(:generate_uuid).and_return(uuid)
    end
  }
end

shared_context "a valid core action" do |&extra|
  it "creates something" do
    response = post(url, parameters.to_json)
    response.should match_json_response(200, expected_json)
    extra.call(response) if extra
  end
end

shared_context "an invalid core action" do |expected_status, &extra|
  it "doesn't create anything" do
    response = post(url, parameters.to_json)
    if(expected_json)
      response.should match_json_response(expected_status,expected_json)
    else
      response.status.should  == expected_status
    end
    extra.call(response) if extra
  end
end
