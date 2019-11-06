require 'test_helper'

describe PetsController do
  describe "index" do
    it "responds with JSON, success, and an array of pet hashes" do
      get pets_path
      
      body = check_response(expected_type: Array)
      
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal ["age", "human", "id", "name"]
      end
    end
    
    it "will respond with an empty array when there are no pets" do
      Pet.destroy_all
      
      get pets_path
      
      body = check_response(expected_type: Array)
      
      expect(body).must_equal []
    end    
  end
  
  describe "show" do
    it "responds with success when given a valid pet" do
      pet = Pet.first
      
      get pet_path(pet.id)
      body = check_response(expected_type: Hash)
      
      expect(body["name"]).must_equal pet.name
      expect(body["age"]).must_equal pet.age
      expect(body["human"]).must_equal pet.human
    end
    
    it "responds with hash if pet doesn't exist" do
      invalid_id = -1
      
      get pet_path(invalid_id)
      body = JSON.parse(response.body)
      
      must_respond_with :not_found
      expect(response.header["Content-Type"]).must_include 'json'
      expect(body).must_be_instance_of Hash
      expect(body.keys).must_include 'errors'
    end
  end
  
  describe "create" do
    let(:pet_data) {
    { pet: { age: 13, name: 'Stinker', human: 'Grace' } } }
    it "can create a new pet" do
      expect { post pets_path, params: pet_data }.must_differ 'Pet.count', 1
      
      must_respond_with :created
    end
    
    it "will respond with bad_request for invalid data" do
      pet_data[:pet][:age] = nil
      
      expect { post pets_path, params: pet_data }.wont_change "Pet.count"
      
      must_respond_with :bad_request
      
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "age"
    end
  end
  
  describe "update" do
    
  end
end
