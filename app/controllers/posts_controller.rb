class PostsController < ApplicationController

  def show
    @reply = Post.new
    @board = Board.find_by_directory(params[:directory])
    @post = Post.find_by_id(params[:id])
    @child_limit = 5
    render 'errors/error_404' unless @board && @post
  end

  def create
    @board = Board.find_by_directory(params[:directory])
    @post  = Post.new(params[:post])
    path_options = {}

    # Simulate different IP addresses
    @post.ip_address = Rails.env.production? ? request.ip : Array.new(4){rand(256)}.join('.')

    if @post.parent_id # Post is a reply.
      # We look for a matching directory in case someone is messing with the parameters.
      @parent = Post.where(id: @post.parent_id, directory: @post.directory)
      if @parent.nil?
        flash[:errors] = "Parent ##{@post.parent_id} not found."
        redirect_to request.referrer
      end      
    end

    # Only a bot would see this field.
    if !params[:email].blank?
      redirect_to request.referrer
    else
      if @post.save
        flash[:notice] = 'Post created!'

        if @post.parent
          redirect_to(request.referrer + "##{@post.id}")
        else
          redirect_to board_post_path(@board, @post, anchor: @post.id)
        end

      else
        flash[:errors] = @post.errors.full_messages.to_sentence
        redirect_to request.referrer
      end
    end
  end

  def destroy
    @post = Post.find_by_id(params[:id])
    response = { success: false }

    if @post
      @board = Board.find_by_directory(@post.directory)
      # No sense in keeping them on a page without a parent.
      response[:redirect] = board_path(@board) unless @post.parent
      
      if can?(:destroy, Post) || @post.verify_tripcode(params[:tripcode])
        if @post.destroy
          response.merge!(
            { success: true, 
              message: "Deleted post ##{@post.id}." })

          response[:report_total] = Report.all.size if params[:getReportTotal]
        end
      else
        response[:message] = "You are not authorized to delete post ##{params[:id]}."
      end
    else
      response[:message] = "Post ##{params[:id]} not found."
    end

    render json: response
  end

  def update
  end
end
