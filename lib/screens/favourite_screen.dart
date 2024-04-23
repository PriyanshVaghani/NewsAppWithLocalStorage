import 'package:flutter/material.dart';
import 'package:news_app/database/db_helper.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/theme.dart';
import 'package:news_app/utility/utilities.dart';
import 'package:news_app/widgets/news_list_view_widget.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.strYourFavouriteNews),
      ),
      body: FutureBuilder(
        future: dbHelper.getFavouriteNewsDetails(Utilities.userModel!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(AppStrings.errorSomethingWrong);
          } else if (snapshot.hasData) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text(AppStrings.strNoDataFound));
            } else {
              return NewsListViewWidget(
                  newsDetails: snapshot.data!,
                  refresh: () {
                    setState(() {});
                  });
            }
          }
          return Center(child: buildCircularProgressIndicator());
        },
      ),
    );
  }
}
