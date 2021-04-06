import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const html = `
      <p class="comment-index">
        <strong>${data.content[1].nickname}：</strong>
        ${data.content[0].text}
      </p>`;
    const commentHeaderText = document.getElementById('comment-header-text');
    const commentsIndex = document.getElementById('comments-index');
    const newComment = document.getElementById('comment-text');
    commentsIndex.insertAdjacentHTML('beforeend', html);
    commentHeaderText.innerHTML = `${data.content[2]} comments`;
    newComment.value='';
  }
});


