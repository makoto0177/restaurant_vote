class PostsController < ApplicationController

  skip_before_action :require_login, only: %i[index show]

  def new
    @post = Post.new
    @post.restaurants.build
    @store_informations = HotpepperSearchService.new.call(
      keyword: params[:keyword],
      address: params[:address]
    )
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = '投稿が作成されました。'
      redirect_to posts_path
    else
      @store_informations = HotpepperSearchService.new.call(
        keyword: params[:keyword],
        address: params[:address]
      )
      render :new
    end
  end
  

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: t('.success'), status: :see_other
  end

  def show
    @post = Post.find(params[:id])
    @restaurants = @post.restaurants
    refresh_or_retry!(@restaurants)
    @restaurant_count = @restaurants.map { |restaurant| [restaurant.name, restaurant.votes.count] }.to_h
    max_votes = @restaurants.max_by { |restaurant| restaurant.votes.count }.votes.count
    @max_voted_restaurants = @restaurants.select { |restaurant| restaurant.votes.count == max_votes }
    @max_value = @restaurant_count.values.max
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :asc)
  end

  def vote
    @vote = Vote.new
    @post = Post.find(params[:id])
    @restaurants = Restaurant.where(post_id: @post.id)
    refresh_or_retry!(@restaurants)
  end

  private

  def post_params
    params.require(:post).permit(:title, restaurants_attributes: [:name, :image, :url, :external_shop_id])
  end

  def refresh_or_retry!(restaurants)
  attempts = params[:retry].to_i + 1

  HotpepperRefreshService.new.refresh_if_stale!(restaurants)
rescue => e
  Rails.logger.error("[HotpepperRefresh] #{e.class}: #{e.message}")

  if attempts <= 3
    # 少し待ってから再読み込み（例: 0.5秒）
    sleep 0.5
    redirect_to url_for(params.permit!.to_h.merge(retry: attempts)),
                alert: "店舗情報の取得に失敗しました。再読み込みします。(#{attempts}回目)"
  else
    render "errors/hotpepper_fetch_failed", status: :service_unavailable
  end
end
end