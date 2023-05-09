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
      <div>
        <p>${comment.body}</p>
      </div>
    `;
    return commentHTML;
  }
});
