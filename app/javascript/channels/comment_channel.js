import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const comments = document.getElementById('comments');
    comments.insertAdjacentHTML('beforeend', this.renderComment(data.content));
  },

  renderComment(comment) {
    let commentHTML = `
      <div class="flex flex-col space-y-2 p-1">
        <div class="flex items-start space-x-2 ${comment.owned_by_current_user ? 'flex-row-reverse' : ''}">
          <div class="flex flex-col space-y-2">
            <p class="text-sm text-gray-500 ${comment.owned_by_current_user ? 'text-right' : 'text-left'}">${comment.user_name}</p>
            <p class="text-xs text-gray-400 ${comment.owned_by_current_user ? 'text-right' : 'text-left'}">${comment.timestamp}</p>
            <div class="${comment.owned_by_current_user ? 'bg-green-100' : 'bg-blue-100'} rounded-xl p-2">
              <p class="text-sm">${comment.body}</p>
            </div>
          </div>
        </div>
      </div>
    `;
    return commentHTML;
  }
});
