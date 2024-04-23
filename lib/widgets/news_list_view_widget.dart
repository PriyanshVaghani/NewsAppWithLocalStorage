import 'package:flutter/material.dart';
import 'package:news_app/database/db_helper.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/screens/news_details_screen.dart';
import 'package:news_app/utility/color_code.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/theme.dart';
import 'package:news_app/utility/utilities.dart';

class NewsListViewWidget extends StatefulWidget {
  const NewsListViewWidget(
      {super.key, required this.newsDetails, required this.refresh});
  final List<NewsModel> newsDetails;
  final void Function() refresh;
  @override
  State<NewsListViewWidget> createState() => _NewsListViewWidgetState();
}

class _NewsListViewWidgetState extends State<NewsListViewWidget> {
  DBHelper dbHelper = DBHelper();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getFavouriteData();
  }

  List<NewsModel> favouriteNews = [];
  Future<void> getFavouriteData() async {
    favouriteNews =
        await dbHelper.getFavouriteNewsDetails(Utilities.userModel!.id!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    getFavouriteData();
    return isLoading
        ? Center(
            child: buildCircularProgressIndicator(),
          )
        : widget.newsDetails.isEmpty
            ? Center(child: Text(AppStrings.strNoDataFound))
            : ListView.builder(
                itemCount: widget.newsDetails.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  NewsModel news = widget.newsDetails[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailsScreen(
                            news: news,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    news.urlToImage != ""
                                        ? news.urlToImage
                                        : AppStrings.imageNoAvailableImage,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child:
                                              buildCircularProgressIndicator(),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Center(
                                        child: Text(
                                          AppStrings.strFailedToLoadImage,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: favouriteNews.any((element) =>
                                        element.publishedAt == news.publishedAt)
                                    ? IconButton(
                                        onPressed: () async {
                                          await dbHelper
                                              .removeFormFavouriteNewsDetails(
                                                  news.publishedAt)
                                              .then((value) =>
                                                  Utilities.showSnackBarMessage(
                                                      context,
                                                      value != 0
                                                          ? AppStrings
                                                              .strRemoveFromFavourite
                                                          : AppStrings
                                                              .errorSomethingWrong));

                                          widget.refresh();
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: ColorCode.colorRed,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          await dbHelper
                                              .addNewsDetails(news,
                                                  Utilities.userModel!.id!)
                                              .then((value) =>
                                                  Utilities.showSnackBarMessage(
                                                      context,
                                                      value != 0
                                                          ? AppStrings
                                                              .strAddedToFavourite
                                                          : AppStrings
                                                              .errorSomethingWrong));
                                          widget.refresh();
                                        },
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: ColorCode.colorRed,
                                        ),
                                      ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              news.title,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
  }
}
