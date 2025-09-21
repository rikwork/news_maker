class Api::V1::AuthController < ActionController::API
  def register
    user = User.new(user_params)
    if user.save
      render json: { api_token: user.api_token, email: user.email }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      user.rotate_api_token!
      render json: { api_token: user.api_token, email: user.email }
    else
      head :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
