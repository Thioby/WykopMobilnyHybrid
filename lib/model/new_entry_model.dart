import 'package:flutter/foundation.dart';
import 'package:owmflutter/model/input_model.dart';
import 'package:owmflutter/screens/input.dart';

import 'package:owmflutter/main.dart';
import 'package:wykop_api/infrastucture/data/model/EntryCommentDto.dart';
import 'package:wykop_api/infrastucture/data/model/EntryDto.dart';
import 'package:wykop_api/infrastucture/data/model/InputData.dart';
import 'package:wykop_api/infrastucture/data/model/LinkCommentDto.dart';


typedef void EntryCreatedCallback(EntryDto entry);

class EditModel extends InputModel {
  final EntryCreatedCallback entryCreated;

  final ValueChanged<EntryCommentDto> commentEdited;
  final ValueChanged<LinkCommentDto> linkCommentEdited;
  final ValueChanged<EntryDto> entryEdited;

  final bool edit;
  final InputType inputType;
  final int itemId;

  EditModel(
      {this.entryCreated,
      this.edit = false,
      this.itemId = -1,
      this.entryEdited,
      this.commentEdited,
      this.linkCommentEdited,
      this.inputType});

  @override
  Future<void> onInputSubmitted(InputData data) async {
    if (edit) {
      switch (inputType) {
        case InputType.ENTRY:
          entryEdited(await api.entries.editEntry(this.itemId, data));
          break;
        case InputType.ENTRY_COMMENT:
          commentEdited(await api.entries.editEntryComment(this.itemId, data));
          break;
        case InputType.LINK_COMMENT:
          linkCommentEdited(await api.links.editComment(this.itemId, data));
          break;
        default:
          return;
      }
    } else {
      var entry = await api.entries.addEntry(data);
      entryCreated(entry);
    }
  }
}
