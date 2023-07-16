class UsersController < ApplicationController
  skip_before_action :authenticate_request

  def signup
    user = User.new(params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :type))
    result = user.save

    response, status = if result
                         [{ message: 'success', auth_token: JsonWebToken.encode(user_id: user.id) }, :ok]
                       else
                         [{ message: 'failure', error: user.errors }, :unprocessable_entity]
                       end
    render json: response, status: status
  rescue StandardError => e
    render json: { message: 'failure', error: e.message }, status: :bad_request
  end

  def login
    command = AuthenticateUser.call(params[:email], params[:password])
    if command.success?
      render json: { message: 'success', auth_token: command.result }
    else
      render json: { message: 'failure', error: command.errors }, status: :unauthorized
    end
  end
end
