class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      ActionCable.server.broadcast 'comment_channel', { content: render_comment(@comment) }
    else
      flash[:danger] = 'コメントの投稿に失敗しました。'
      redirect_to post_path(@comment.post)
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = 'コメントを削除しました。'
    redirect_to post_path(@comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id, post_id: params[:post_id])
  end

  def render_comment(comment)
    {
      body: comment.body,
      user_name: comment.user.name,
      timestamp: comment.created_at.strftime('%Y/%m/%d %H:%M:%S'),
      owned_by_current_user: comment.own?(current_user)
    }
  end
end
