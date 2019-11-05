require 'test_helper'

describe PetsController do
  describe "index" do
    it "responds with JSON and success" do
      get pets_path
      
      body = JSON.parse(response.body)
      
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Array
      must_respond_with :ok
    end
    
    it "responds with an array of pet hashes" do
      # Act
      get pets_path
      
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal ["age", "human", "id", "name"]
      end
    end
    
    it "will respond with an empty array when there are no pets" do
      # Arrange
      Pet.destroy_all
      
      # Act
      get pets_path
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end    
  end
  
  describe "show" do
    it "responds with success when given a valid pet" do
      pet = Pet.first
      
      get pet_path(pet.id)
      body = JSON.parse(response.body)
      
      expect(body).must_be_instance_of Hash
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
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
end
