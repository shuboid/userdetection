class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic



field :first_name , type: String
field :last_name, type: String
field :age, type: Integer
field :gender , type: String
field :profile_image_url, type:  String
field :license_image_url , type: String
end
