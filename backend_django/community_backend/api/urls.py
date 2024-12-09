from django.urls import path
from .views import PostListView, CommentListView

urlpatterns = [
    path('posts/', PostListView.as_view(), name='post-list'),
    path('comments/', CommentListView.as_view(), name='comment-list'),
]
