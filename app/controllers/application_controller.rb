class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def test
    render json: {hello: 'world'}, status: :ok
  end
end
