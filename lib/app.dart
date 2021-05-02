import 'package:flutter/material.dart';
import 'src/screens/news_list.dart';
import 'src/blocs/stories_provider.dart';
import 'src/screens/news_details.dart';
import 'src/blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) {
        // good place to initialize
        final storiesBloc = StoriesProvider.of(context);
        storiesBloc.fetchTopIds();

        return NewsList();
      });
    } else {
      return MaterialPageRoute(builder: (context) {
        final commentsBloc = CommentsProvider.of(context);
        final itemId = int.parse(settings.name.replaceFirst('/', ''));
        //great place for any initialization for data
        commentsBloc.fetchItemsWithComments(itemId);

        return NewsDetail(
          itemId: itemId,
        );
      });
    }
  }
}
