import 'package:news_app/model/news_model.dart';

abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsSearchState extends NewsState {}

class NewsLoadedSuccessState extends NewsState {
  final List<NewsModel> newsDetails;
  NewsLoadedSuccessState({
    required this.newsDetails,
  });
}

class NewsErrorState extends NewsState {
  final String error;

  NewsErrorState({required this.error});
}
