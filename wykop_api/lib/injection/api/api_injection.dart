import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/api/client.dart';
import 'package:wykop_api/injection/Injector.dart';

void setupApiDeps() {
  appInjector.addDependency<ApiClient>(() => ApiClient());
  appInjector.addDependency<LinksApi>(() => LinksApi(appInjector.getDependency(), appInjector.getDependency(),
      appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<TagsApi>(() => TagsApi(appInjector.getDependency(), appInjector.getDependency(),
      appInjector.getDependency(), appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<PmApi>(() => PmApi(appInjector.getDependency(), appInjector.getDependency(),
      appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<SuggestApi>(
      () => SuggestApi(appInjector.getDependency(), appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<ProfilesApi>(() => ProfilesApi(
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency()));
  appInjector.addDependency<EmbedApi>(() => EmbedApi(appInjector.getDependency()));
  appInjector.addDependency<SearchApi>(() => SearchApi(appInjector.getDependency(), appInjector.getDependency(),
      appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<NotificationsApi>(
      () => NotificationsApi(appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<MyWykopApi>(() => MyWykopApi(appInjector.getDependency(), appInjector.getDependency()));

  appInjector.addDependency<EntriesApi>(() => EntriesApi(appInjector.getDependency(), appInjector.getDependency(),
      appInjector.getDependency(), appInjector.getDependency()));
  appInjector.addDependency<UsersApi>(() => UsersApi(appInjector.getDependency()));


}
