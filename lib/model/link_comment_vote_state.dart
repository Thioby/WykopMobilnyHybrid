enum LinkCommentVoteState { NOT_VOTED, UP_VOTED, DOWN_VOTED }

extension LinkCommentExtension on LinkCommentVoteState {
  static LinkCommentVoteState fromInt(int state) {
    switch (state) {
      case 0:
        return LinkCommentVoteState.NOT_VOTED;
      case 1:
        return LinkCommentVoteState.UP_VOTED;
      case -1:
        return LinkCommentVoteState.DOWN_VOTED;
    }

    return LinkCommentVoteState.NOT_VOTED;
  }
}
