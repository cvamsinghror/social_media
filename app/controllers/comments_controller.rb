class CommentsController < ApplicationController
  before_action :set_article
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
    @comment.commenter = "#{current_user.first_name} #{current_user.last_name}"

    if @comment.save
      redirect_to @article, notice: 'Comment was successfully created.'
    else
      redirect_to @article, alert: 'Comment could not be created.'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @article, notice: 'Comment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @article, notice: 'Comment was successfully deleted.'
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def authorize_comment
    unless @comment.user == current_user || @article.user == current_user
      redirect_to @article, alert: "You are not authorized to edit or delete this comment."
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end