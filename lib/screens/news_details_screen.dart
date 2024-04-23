import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/database/db_helper.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/utility/color_code.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/theme.dart';
import 'package:news_app/utility/utilities.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key, required this.news});
  final NewsModel news;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.zero,
                    bottom: Radius.circular(24),
                  ),
                  child: Image.network(
                    widget.news.urlToImage != ""
                        ? widget.news.urlToImage
                        : AppStrings.imageNoAvailableImage,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: buildCircularProgressIndicator(),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
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
                top: 35,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.share,
                    color: ColorCode.colorWhite,
                  ),
                  onPressed: () async {
                    Share.share("${widget.news.title}: ${widget.news.url}");
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 8,
                right: 8,
                child: Text(
                  widget.news.title,
                  style: TextStyle(color: ColorCode.colorWhite, fontSize: 18),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.strBy,
                      style:
                          TextStyle(color: ColorCode.colorWhite, fontSize: 10),
                    ),
                    Text(
                      widget.news.author.isEmpty
                          ? AppStrings.strUnknown
                          : widget.news.author,
                      style: TextStyle(
                        color: ColorCode.colorWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                    ),
                    Text(dateFormatConverter(widget.news.publishedAt))
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.news.content,
                  style: const TextStyle(fontSize: 15.0),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(widget.news.url);
                        if (!await launchUrl(url,
                            mode: LaunchMode.inAppWebView)) {
                          Utilities.showSnackBarMessage(
                              context, AppStrings.errorSomethingWrong);
                        }
                      },
                      child: Text(
                        AppStrings.strForMore,
                        style: TextStyle(color: ColorCode.colorPrimary),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // this for change the date format
  String dateFormatConverter(String date) {
    DateTime originalDate = DateTime.parse(date);

    DateFormat newFormat = DateFormat(' HH:mm MMM dd, yyyy');

    String formattedDate = newFormat.format(originalDate);
    return formattedDate;
  }
}
