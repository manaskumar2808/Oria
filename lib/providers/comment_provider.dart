import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _comments = [];

  Future<List<Comment>> get comments async {
    await this.fetchAndSetComments();
    return [...this._comments];
  }

  Future<List<Comment>> commentByFeedId(String id) async {
    await this.fetchAndSetComments();
    return this._comments.where((comment) => comment.feedId == id).toList();
  }

  List<Comment> commentByCommentorId(String id) {
    return this
        ._comments
        .where((comment) => comment.commentorId == id)
        .toList();
  }

  Comment commentById(String id) {
    return this._comments.firstWhere((comment) => comment.commentId == id);
  }

  Future<void> fetchAndSetComments() async {
    final comments =
        await Firestore.instance.collection('comments').orderBy('timestamp',descending: true).getDocuments();

    List<Comment> loadedComments = [];
    comments.documents.forEach((document) {
      var comment = document.data;
      loadedComments.add(Comment(
        commentId: document.documentID,
        text: comment['text'],
        commentorId: comment['commentorId'],
        feedId: comment['feedId'],
        timestamp: DateTime.parse(comment['timestamp']),
      ));
    });

    this._comments = loadedComments;
  }

  Future<void> addComment({
    String text,
    String feedId,
    String commentorId,
  }) async {
    final commentRef = Firestore.instance.collection('comments').document();
    final commentId = commentRef.documentID;

    await commentRef.setData({
      'text': text,
      'commentorId': commentorId,
      'feedId': feedId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    this._comments.add(Comment(
          commentId: commentId,
          text: text,
          commentorId: commentorId,
          feedId: feedId,
          timestamp: DateTime.now(),
        ));

    notifyListeners();
  }

  Future<void> updateComment(
    String id, {
    String text = '',
  }) async {
    final commentRef = Firestore.instance.collection('comments').document();
    final commentIndex =
        this._comments.indexWhere((comment) => comment.commentId == id);
    final oldComment = this._comments[commentIndex];
    this._comments[commentIndex].text = text.isEmpty ? oldComment.text : text;

    await commentRef.updateData({
      'text': this._comments[commentIndex].text,
    });
    notifyListeners();
  }

  Future<void> removeComment(String id) async {
    await Firestore.instance.collection('comments').document(id).delete();
    this._comments.removeWhere((comment) => comment.commentId == id);
    notifyListeners();
  }
}
