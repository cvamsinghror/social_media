class ArticlesController < ApplicationController

  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authorize_article, only: [:edit, :update, :destroy]



  def toggle_like
    @article = Article.find(params[:id])
    if current_user.voted_up_on? @article
      @article.unvote_by current_user
    else
      @article.upvote_by current_user
    end
    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end
 


  def drafts 
  end



  def index
    user_articles = current_user.articles
    
    accepted_friend_ids = current_user.friendships.where(status: 'accepted').pluck(:friend_id) +
                          current_user.inverse_friendships.where(status: 'accepted').pluck(:user_id)
                          
    friends_articles = Article.where(user_id: accepted_friend_ids)
    

    @articles = user_articles.or(friends_articles)

     @admins = User.pending
    @admin_count = @admins.count
  end





  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params) 

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end



  def edit
  end



  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end



  def destroy
    @article.destroy
    redirect_to root_path, status: :see_other
  end


  
  private

  def set_article
    @article = Article.find(params[:id])
    unless current_user.friends_with?(@article.user) || @article.user == current_user
      redirect_to articles_path, alert: "You are not authorized to view this article."
    end
  end
end

  def authorize_article
    unless @article.user == current_user
      redirect_to articles_path, alert: "You are not authorized to edit or delete this article."
    end
  end



  def article_params
    params.require(:article).permit(:title, :summary, :content, :avatar)
  end
