# CORS allow all
PushBack::Application.configure do
  config.middleware.use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :post, :options]
    end
  end
end
