class UsersController < ApplicationController


  before_action :load_data , only: [:index]

  def new
    @user = User.new
  end



  def index
    @user =  User.last
    @result = @user.verify_image
  end

  def create
    @user = User.new(user_params)
    auth = {
    cloud_name: "#",
    api_key: "#",
    api_secret:"#"
    }
    temp = Cloudinary::Uploader.upload(params[:user][:profile_image].tempfile, auth)
    @user[:profile_image_url] = temp["url"]

    temp =  Cloudinary::Uploader.upload(params[:user][:license_image].tempfile, auth)
    @user[:license_image_url] = temp["url"]

    if @user.save!
      redirect_to '/users'
    end
  end

  def verify
    #@user =  User.last
    #@result = @user.verify_image
  end

  def user_params
    params.require(:user).permit(:first_name,:last_name,:age,:gender)
  end

  def load_data
    @user = User.last
  end
end
