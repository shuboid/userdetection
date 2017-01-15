class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

before_save :get_data

field :first_name , type: String
field :last_name, type: String
field :age, type: Integer
field :gender , type: String
field :profile_image_url, type:  String
field :license_image_url , type: String
field :result ,type: Hash, default: {}


  def get_data
    self.result = self.verify_image
    byebug
  end


  def verify_image
    result = {}
    api =  Betaface::Api.new("d45fd466-51e2-4701-8da8-04351c872236"," 171e8465-f548-401d-b63b-caf0dc28df5f")
    data = api.upload_image("classifiers",{url:self.profile_image_url})
    res = api.get_image_info(data["img_uid"])

    if !res["faces"].nil?
      result[:valid_profile_image] = true
      res = res["faces"][0]["tags"]
      res.each do |factor|
        result[factor["name"]] = factor["value"]
      end
    else
      result[:valid_profile_image] = false
    end
    uri = URI('https://api.ocr.space/parse/image')
    res = Net::HTTP.post_form(uri, 'apikey' =>  '56bf15fe8b88957','url' => self.license_image_url)
    res = JSON::parse(res.body)
    res = res["ParsedResults"][0]["ParsedText"].split("\r\n")
    result[:name_on_license] = res.grep(/Name/)
    result[:dob_on_license] = res.grep(/DOB/)
    result[:license_validity] = res.grep(/Valid Till/)


    result
  end

end
