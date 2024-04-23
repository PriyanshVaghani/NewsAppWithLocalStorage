import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:news_app/api_key.dart';
import 'package:news_app/model/news_model.dart';

class NewsDioServices {
  late Dio _dio;

  NewsDioServices() {
    DateTime today = DateTime.now();
    DateTime oneMonthAgo;
    if (today.month == 1) {
      // If the current month is January, subtract one month and adjust the year
      oneMonthAgo = DateTime(today.year - 1, 12, today.day);
    } else {
      // Otherwise, subtract one month normally
      oneMonthAgo = DateTime(today.year, today.month - 1, today.day);
    }
    String date = DateFormat("yyyy-MM-dd").format(oneMonthAgo);

    _dio = Dio(
      BaseOptions(
        baseUrl:
            "http://newsapi.org/v2/everything?q=tesla&from=$date&sortBy=publishedAt&apiKey=$API_KEY",
      ),
    );
  }

  /*
  * It fetch data from api and return it  as list of NewsModel
  * else it throw exception
  * */
  Future<dynamic> getAllNewsDetails() async {
    try {
      List<NewsModel> newsDetails = [];
      final response = await _dio.get("");
      if (response.statusCode == 200) {
        var news = response.data["articles"];
        for (var i in news) {
          newsDetails.add(NewsModel.fromJson(i));
        }
        return newsDetails;
      } else {
        throw "Something Wrong"; // Throw an error if status code is not 200
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        // Handle cancellation error
        throw "Request was canceled: $e";
      } else {
        // Handle other DioError types
        throw "Failed to fetch News: $e";
      }
    } catch (error) {
      throw "Failed to fetch News: $error"; // Throw the error
    }
  }
}
