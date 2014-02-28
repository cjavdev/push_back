module ErrorsHelper
  # CUSTOM EXCEPTION HANDLING - render errors to json

  def self.included(base)
    return unless base == ApplicationController
    base.class_eval do
      rescue_from Exception, with: :error
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::RoutingError, with: :not_found
    end
  end

  def routing_error
    error_info = {
      error: "No such route exists"
    }
    render json: error_info, status: 404
  end

  def not_found(exception)
    error_info = {
      error: "Resource Not Found",
      exception: "#{e.class.name}",
      message: "#{e.message}"
    }
    error_info[:trace] = e.backtrace[0, 10] if Rails.env.development?
    render json: error_info, status: 404
  end

  def error(e)
    error_info = {
      error: "Internal Server Error",
      exception: "#{e.class.name}",
      message: "#{e.message}"
    }
    puts "#{e.class.name} : #{e.message}"
    puts e.backtrace
    error_info[:trace] = e.backtrace[0, 10] if Rails.env.development?
    render json: error_info, status: 500
  end
end
