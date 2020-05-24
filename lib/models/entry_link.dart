import 'package:built_value/built_value.dart';
import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

part 'entry_link.g.dart';

abstract class EntryLink implements Built<EntryLink, EntryLinkBuilder> {
  @nullable
  Entry get entry;

  @nullable
  Link get link;

  bool get isExpanded;

  bool get hasEntry => entry != null;

  factory EntryLink.mapFromResponse(EntryLinkResponse response) {
    return _$EntryLink._(
      isExpanded: true,
        entry: response.entry == null
            ? null
            : Entry.mapFromResponse(response.entry),
        link:
            response.link == null ? null : Link.mapFromResponse(response.link));
  }

  EntryLink._();
}
