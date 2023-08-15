module Api::V1::User
  class UserController < ApiController
    before_action :authorized, only: [:auto_login]

    # REGISTER
    def create
      @user = User.create(user_params)
      if @user.valid?
        render json: { message: "Account for \"#{@user.username}\" is created" }
      else
        render json: { message: 'Error occurs!', errors: @user.errors.full_messages.uniq }, status: 400
      end
    end

    # LOGGING IN
    def login
      @user = User.find_by(username: params[:username])

      if @user && @user.authenticate(params[:password])
        token = encode_token({ user_id: @user.id })
        render json: { user: user_information, token: token }
      else
        render json: { message: 'Invalid username or password' }, status: 400
      end
    end

    # AUTO LOGIN
    def auto_login
      render json: user_information
    end

    private

    # USER INFORMATION WITHOUT PASSWORD
    def user_information
      { "username": @user.username, "email": @user.email, "id": @user.id }
    end

    def user_params
      params.permit(:username, :password, :email, :password_confirmation)
    end
  end
end
