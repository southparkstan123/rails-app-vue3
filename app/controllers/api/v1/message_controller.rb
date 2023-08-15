module Api::V1
  class MessageController < ApiController
    before_action :authorized, except: [:greeting]

    def greeting
      render json: { message: 'Hello Vue from Ruby on Rails!' }
    end
  end
end
