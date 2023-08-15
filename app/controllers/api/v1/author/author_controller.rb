module Api::V1::Author
  class AuthorController < ApiController
    before_action :authorized, except: [:list, :show]

    def list
      @authors = Author.includes(:creator, :updater, :books)
      render json: @authors, each_serializer: AuthorSerializer
    end

    def show
      @author = Author.find_by(id: params[:id])
      if @author
        render json: @author
      else
        render json: { message: 'Author not found!' }, status: 404
      end
    end

    def create
      @author = Author.new(author_params)
      @author.creator = logged_in_user
      @author.updater = logged_in_user

      if @author.save
        render json: @author, status: :created
      else
        render json: { message: 'Error occurs!', errors: @author.errors.full_messages.uniq }, status: 422
      end
    end

    def update
      @author = Author.find_by(id: params[:id])
      @author.update(author_params)
      @author.updater = logged_in_user

      if @author.update(author_params)
        render json: { message: "Author \"#{@author.name}\" is updated" }
      else
        render json: { message: 'Error occurs!', errors: @author.errors.full_messages.uniq }, status: 422
      end
    end

    def delete
      @author = Author.find_by(id: params[:id])
      if !@author.nil?
        Author.delete(params[:id])
        render json: { message: "Author \"#{@author.name}\" is deleted" }
      else
        render json: { message: 'Author not found!' }, status: 404
      end
    end

    private

    def author_params
      params.permit(:name, :description)
    end
  end
end
