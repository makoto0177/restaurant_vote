module CommentsHelper
  def comment_text_alignment(comment, user)
    comment.own?(user) ? 'text-right' : 'text-left'
  end

  def comment_background_color(comment, user)
    comment.own?(user) ? 'bg-green-100' : 'bg-blue-100'
  end
end