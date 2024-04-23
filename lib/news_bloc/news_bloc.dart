import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/crud_sevices/news_dio_services.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/news_bloc/news_event.dart';
import 'package:news_app/news_bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitialState()) {
    on<NewsInitialEvent>(newsInitialEvent);
    on<NewsSearchEvent>(newsSearchEvent);
    on<NewsSearchCancelEvent>(newsSearchCancelEvent);
  }

  /*
  * first it emit to NewsLoadingState
  * after that it fetch data from api
  * if it get data then it emit to NewsLoadedSuccessState
  * else if it throw exception then it emit to error state
  * */
  Future<FutureOr<void>> newsInitialEvent(
      NewsInitialEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    try {
      NewsDioServices newsDioServices = NewsDioServices();
      List<NewsModel> newsDetails = await newsDioServices.getAllNewsDetails();
      emit(NewsLoadedSuccessState(newsDetails: newsDetails));
    } catch (e) {
      emit(NewsErrorState(error: e.toString()));
    }
  }

  // it for user is searching
  FutureOr<void> newsSearchEvent(
      NewsSearchEvent event, Emitter<NewsState> emit) {
    emit(NewsSearchState());
  }

  // it for user cancel the searching
  FutureOr<void> newsSearchCancelEvent(
      NewsSearchCancelEvent event, Emitter<NewsState> emit) {
    emit(NewsLoadedSuccessState(newsDetails: event.newsDetails));
  }
}
