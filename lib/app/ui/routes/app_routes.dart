import '../pages/chat_group/chat_group_page.dart';
import '../pages/all_activities/all_activities_page.dart';
import '../pages/all_news/all_news_page.dart';

import '../pages/news_view/news_view_page.dart';
import '../pages/search/search_page.dart';
import '../pages/favorites/favorites_page.dart';
import '../pages/init/init_page.dart';
import '../pages/news/news_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/loggin/loggin_page.dart';
import 'package:flutter/widgets.dart' show BuildContext, Widget;
import 'routes.dart';
import '../pages/home/home_page.dart';
import '../pages/event_view/event_view_page.dart';

/// WARNING: generated code don't modify directly
Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.HOME: (_) => const HomePage(),
    Routes.EVENT_VIEW: (_) => const EventViewPage(),
    Routes.LOGGIN_PAGE: (_) => LogginPage(),
    Routes.PROFILE: (_) => const ProfilePage(),
    Routes.NEWS: (_) => const NewsPage(),
    Routes.INIT: (_) => const InitPage(),
    Routes.FAVORITES: (_) => const FavoritesPage(),
    Routes.SEARCH: (_) => const SearchPage(),
    Routes.NEWS_VIEW: (_) => NewsViewPage(),
    Routes.ALL_NEWS: (_) => AllNewsPage(),
    Routes.ALL_ACTIVITIES: (_) => const AllActivitiesPage(),
    Routes.CHAT_GROUP: (_) => const ChatGroupPage(),
  };
}
