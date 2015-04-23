require 'net/https'
require 'json'

require 'osrm_api/request/route_request'
require 'osrm_api/response/route_object'

require 'osrm_api/request/locate_request'
require 'osrm_api/response/locate_object'

require 'osrm_api/request/distance_request'
require 'osrm_api/response/distance_object'

require 'osrm_api/request/nearest_request'
require 'osrm_api/response/nearest_object'


module OSRM

  class Client

    DEFAULT_OPTIONS = {
      host: 'localhost',
      port: 5000,
    }.freeze

    # @return [OSRM::Client]
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end


    # @return [Response::LocateObject]
    def locate(location)
      request = Request::LocateRequest.new(location)
      if block_given?
        yield
      end
      Response::LocateObject.new execute request
    end


    # @return [Response::RouteObject]
    def route(*locations)
      request = Request::RouteRequest.new(*locations)
      if block_given?
        yield
      end
      Response::RouteObject.new execute request
    end

    # @return [Response::NearestObject]
    def nearest(location)
      request = Request::NearestRequest.new(location)
      if block_given?
        yield
      end
      Response::NearestObject.new execute request
    end

    # Return casting <Response::DistanceObject>
    # @param [Array] locations
    # @return [Response::DistanceObject]
    def distance(*locations)
      request = Request::DistanceRequest.new(*locations)
      if block_given?
        yield
      end
      Response::DistanceObject.new execute request
    end


    private
    # Method performs given request and returns body response
    # @param [OSRM::Request::BaseRequest] request
    def execute(request)
      res = Net::HTTP.get_response(request.build_uri @options[:host], @options[:port])

      JSON.parse(res.body)
    end
  end
end