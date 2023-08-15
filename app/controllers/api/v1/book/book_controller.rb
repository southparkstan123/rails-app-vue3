module Api::V1::Book
  class BookController < ApiController
    before_action :authorized, except: [:list, :show]

    def list
      @books = Book.includes(:authors, :creator, :updater, :publisher)
      render json: @books, each_serializer: BookSerializer
    end

    def show
      @book = Book.find_by(id: params[:id])
      if @book
        render json: @book
      else
        render json: { message: 'Book not found!' }, status: 404
      end
    end

    def create
      @book = Book.new(book_params)
      @book.creator = logged_in_user
      @book.updater = logged_in_user

      if @book.save
        render json: @book, status: :created
      else
        render json: { message: 'Error occurs!', errors: @book.errors.full_messages.uniq }, status: 422
      end
    end

    def update
      @book = Book.find_by(id: params[:id])
      @book.updater = logged_in_user
      @book.update(book_params)

      if @book.update(book_params)
        render json: { message: "Book \"#{@book.name}\" is updated" }
      else
        render json: { message: 'Error occurs!', errors: @book.errors.full_messages.uniq }, status: 422
      end
    end

    def delete
      @book = Book.find_by(id: params[:id])
      if !@book.nil?
        Book.delete(params[:id])
        render json: { message: "Book \"#{@book.name}\" is deleted" }
      else
        render json: { message: 'Book not found!' }, status: 404
      end
    end

    private

    def book_params
      params.permit(:name, :abstract, :price, :publisher_id, author_ids: [])
    end

  end
end
