import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/news_bloc/news_bloc.dart';
import 'package:news_app/news_bloc/news_event.dart';
import 'package:news_app/news_bloc/news_state.dart';
import 'package:news_app/screens/favourite_screen.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/utility/color_code.dart';
import 'package:news_app/utility/local_database_function.dart';
import 'package:news_app/utility/preferences.dart';
import 'package:news_app/utility/theme.dart';
import 'package:news_app/widgets/drawer_widget.dart';
import 'package:news_app/widgets/news_list_view_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearch = false;
  List<NewsModel> newsDetails = [];
  List<NewsModel> searchNewsDetails = [];
  @override
  void initState() {
    super.initState();
    // it get the use info from local storage
    LocalStorage.getUserDetailsFromLocalStorage();
    newsBloc.add(NewsInitialEvent());
  }

  final NewsBloc newsBloc = NewsBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: isSearch
            ? TextFormField(
                autofocus: true,
                cursorColor: ColorCode.colorWhite,
                style: TextStyle(color: ColorCode.colorWhite),
                onChanged: (value) {
                  searchNewsDetails = newsDetails
                      .where((element) => element.title
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();

                  newsBloc.add(NewsSearchEvent());
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorCode.colorGrey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorCode.colorGrey, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(8),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = false;
                      });
                      newsBloc
                          .add(NewsSearchCancelEvent(newsDetails: newsDetails));
                    },
                    icon: Icon(Icons.cancel, color: ColorCode.colorWhite),
                  ),
                ),
              )
            : const SizedBox(),
        actions: [
          isSearch
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                    newsBloc.add(NewsSearchEvent());
                  },
                  icon: Icon(Icons.search, color: ColorCode.colorWhite),
                ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavouriteScreen()));
            },
            icon: Icon(Icons.favorite, color: ColorCode.colorWhite),
          ),
          IconButton(
            onPressed: () async {
              await Preferences.setBool('isLogin', false).whenComplete(
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.logout, color: ColorCode.colorWhite),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        color: ColorCode.colorPrimary,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 0), () {
            // if (mounted) {
            //   setState(() {});
            // }
            newsBloc.add(NewsInitialEvent());
          });
        },
        child: BlocBuilder(
          bloc: newsBloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case NewsLoadingState:
                return Center(
                  child: buildCircularProgressIndicator(),
                );
              case NewsLoadedSuccessState:
                final successState = state as NewsLoadedSuccessState;
                newsDetails = successState.newsDetails;
                return NewsListViewWidget(
                  newsDetails: newsDetails,
                  refresh: () {
                    setState(() {});
                  },
                );
              case NewsSearchState:
                return NewsListViewWidget(
                  newsDetails: searchNewsDetails,
                  refresh: () {
                    setState(() {});
                  },
                );
              case NewsErrorState:
                final errorState = state as NewsErrorState;
                return Center(
                  child: Text(errorState.error),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
