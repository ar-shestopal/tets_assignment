module Api
  class ApiController < ActionController::API
    include CanCan::ControllerAdditions
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include AbstractController::Translation
    include ActionController::StrongParameters

    rescue_from CanCan::AccessDenied do |exception|
      render json: { error: t('access_denied') }, status: 403
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: t('record_not_found') }, status: 404
    end

    rescue_from ActionController::ParameterMissing do |exception|
      render json: { error: exception.message }
    end

  private

    def render options = {}
      self.status = options[:status] || 200
      self.content_type = 'application/json'
      body = Oj.dump(options[:json], mode: :compat)
      self.headers['Content-Length'] = body.bytesize.to_s
      self.response_body = body
    end

    def authenticate
      @current_user ||= authenticate_with_http_basic { |email, password| User.authenticate(email, password) }
      request_http_basic_authentication unless @current_user
    end

    def current_user
      @current_user
    end

    def default_serializer_options
      { root: false }
    end
  end
end
