class Api::V1::BaseController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    auth = request.headers["Authorization"].to_s
    token = auth.start_with?("Bearer ") ? auth.split(" ", 2)[1] : nil
    @current_user = token.present? ? User.find_by(api_token: token) : nil
    head :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
