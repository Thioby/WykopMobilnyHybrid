import 'package:wykop_api/data/model/dtoModels.dart';
import 'package:wykop_api/injection/Injector.dart';

void setupMappersDeps() {
  var authorMapper = AuthorResponseToAuthorDtoMapper();
  var mediaMapper = EntryMediaResponseToEntryMediaDtoMapper();
  var entryCommentMapper = EntryCommentResponseToEntryCommentDtoMapper(authorMapper, mediaMapper);
  var entryMapper = EntryResponseToDtoMapper(authorMapper, mediaMapper, entryCommentMapper);
  var linkMapper = LinkResponseToLinkDtoMapper(authorMapper);

  appInjector.addDependency<AuthorResponseToAuthorDtoMapper>(() => authorMapper);
  appInjector.addDependency<AuthorSuggestionResponseToAuthorSuggestionDtoMapper>(
      () => AuthorSuggestionResponseToAuthorSuggestionDtoMapper());
  appInjector.addDependency<ConversationResponseToConversationDtoMapper>(
      () => ConversationResponseToConversationDtoMapper(authorMapper));
  appInjector.addDependency<EntryCommentResponseToEntryCommentDtoMapper>(() => entryCommentMapper);
  appInjector.addDependency<EntryResponseToDtoMapper>(() => entryMapper);
  appInjector.addDependency<EntryLinkResponseToEntryLinkDtoMapper>(
      () => EntryLinkResponseToEntryLinkDtoMapper(linkMapper, entryMapper));
  appInjector.addDependency<EntryMediaResponseToEntryMediaDtoMapper>(() => mediaMapper);
  appInjector.addDependency<LinkCommentResponseToLinkCommentDtoMapper>(
      () => LinkCommentResponseToLinkCommentDtoMapper(authorMapper, mediaMapper));
  appInjector.addDependency<LinkResponseToLinkDtoMapper>(() => LinkResponseToLinkDtoMapper(authorMapper));
  appInjector.addDependency<NotificationResponseToNotificationDtoMapper>(
      () => NotificationResponseToNotificationDtoMapper(authorMapper));
  appInjector
      .addDependency<PmMessageResponseToPmMessageDtoMapper>(() => PmMessageResponseToPmMessageDtoMapper(mediaMapper));
  appInjector.addDependency<ProfileRelatedResponseToRelatedDtoMapper>(() => ProfileRelatedResponseToRelatedDtoMapper());
  appInjector.addDependency<RelatedResponseToRelatedDtoMapper>(() => RelatedResponseToRelatedDtoMapper(authorMapper));
  appInjector.addDependency<TagSuggestionResponseToTagSuggestionDtoMapper>(
      () => TagSuggestionResponseToTagSuggestionDtoMapper());
  appInjector.addDependency<VoterResponseToVoterDtoMapper>(() => VoterResponseToVoterDtoMapper(authorMapper));
}

