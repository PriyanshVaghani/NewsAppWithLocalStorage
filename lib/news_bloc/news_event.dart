import 'package:news_app/model/news_model.dart';

abstract class NewsEvent {}

class NewsInitialEvent extends NewsEvent {}

class NewsNavigateToFavouritePageEvent extends NewsEvent {}

class NewsSearchEvent extends NewsEvent {}

class NewsSearchCancelEvent extends NewsEvent {
  final List<NewsModel> newsDetails;
  NewsSearchCancelEvent({
    required this.newsDetails,
  });
}
