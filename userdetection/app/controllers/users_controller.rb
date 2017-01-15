class UsersController < ApplicationController

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
    cloud_name: "shuboid-cloud",
    api_key: "955113512438869",
    api_secret:"2LNTfxCktq1T78v6UN-na7eqWZc"
    }
    temp = Cloudinary::Uploader.upload(params[:user][:profile_image].tempfile, auth)
    @user[:profile_image_url] = temp["url"]

    temp =  Cloudinary::Uploader.upload(params[:user][:license_image].tempfile, auth)
    @user[:license_image_url] = temp["url"]

    if @user.save!
      render 'index'
    end
  end

  def verify
    @user =  User.last
    @result = @user.verify_image
  end

  def user_params
    params.require(:user).permit(:first_name,:last_name,:age,:gender)
  end

end
