class Goliath::Env

  class Req
    def initialize(env)
      @env = env
    end
    
    def method
      @env["REQUEST_METHOD"]
    end

    def path
      @env["REQUEST_PATH"]
    end
    
    def host
      @env["HTTP_HOST"]
    end
    
    def origin
      @env["HTTP_ORIGIN"]
    end
  end
  
  def request
    Req.new self
  end

  def get?
    request_method == "GET"
  end
  
  def post?
    request_method == "POST"
  end
  
  def query_string
    self["QUERY_STRING"] || ""
  end
  
  def params
    unless @_params
      @_params = {}
      query_string.split("&").each do |p| 
        k, v = p.split("=") 
        @_params[k.to_sym] = v
      end
    end
    @_params
  end

end