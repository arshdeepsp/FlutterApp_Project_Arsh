import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:tripd_travel_app/models/category.dart';
import 'package:tripd_travel_app/models/offering.dart';
import 'package:tripd_travel_app/models/search_results.dart';

class OfferingService {
  OfferingService._();

  /// Returns an instance of [OfferingService].
  factory OfferingService() {
    return OfferingService._();
  }

  Future<List> getOfferingService() async {
    var url = Uri.parse("https://ms.tripd.co/offerings/all");
    List? categories = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var jsonData = await get(url, headers: headers);
    var fetchData = jsonDecode(jsonData.body);

    if (fetchData['status']) {
      fetchData['data'].forEach((categoryData) {
        List<Offering> offerings = [];
        categoryData['offerings'].forEach((offeringData) {
          Offering offering = Offering(
              id: offeringData['id'],
              name: offeringData['name'],
              description: offeringData['description'],
              image: offeringData['image'],
              price: offeringData['price']);
          offerings.add(offering);
        });
        Category category = Category(categoryData['name'],
            categoryData['image'], offerings, categoryData['id']);
        categories.add(category);
      });
    }
    return categories;
  }

  Future<SearchResults> searchOfferingService(String query,
      [String lat = '',
      String long = '',
      String rad = '',
      String filterType = '',
      String fromDate = '',
      String toDate = '']) async {
    bool status = false;
    List<Category> categories = [];

    try {
      if (query.length < 3) {
        status = false;
      } else {
        String params = query + '?regexFlag=' + 'true';
        if (lat.isNotEmpty && long.isNotEmpty) {
          params +=
              '&latitude=' + lat + '&longitude=' + long + '&radius=' + rad;
        }
        if (filterType.isNotEmpty) {
          params += '&filterType=' + filterType;
          if (filterType == 'custom' &&
              fromDate.isNotEmpty &&
              toDate.isNotEmpty) {
            params += '&fromDate=' + fromDate + '&toDate=' + toDate;
          }
        }

        // print(params);
        var response = await get(
            Uri.parse("https://ms.tripd.co/offerings/search/$params"));

        var fetchData = jsonDecode(response.body);
        if (fetchData["status"] && fetchData['data']['totalPages'] > 0) {
          status = true;
          fetchData['data']['content'].forEach((categoryData) {
            List<Offering> offerings = [];
            categoryData['offerings'].forEach((offeringData) {
              Offering offering = Offering(
                  id: offeringData['id'],
                  name: offeringData['name'],
                  description: offeringData['description'],
                  image: offeringData['image'],
                  price: offeringData['price']);
              offerings.add(offering);
            });
            Category category = Category(categoryData['name'],
                categoryData['image'], offerings, categoryData['id']);
            categories.add(category);
          });
        } else {
          print(fetchData['message']);
          status = false;
        }
      }
    } catch (e) {
      print(e);
    }
    SearchResults searchResult = SearchResults(status, categories);
    return searchResult;
  }

  Future<dynamic> getOfferingsById(String id) async {
    var url = Uri.parse("https://ms.tripd.co/offerings/categories/$id");
    List<Offering> offerings = [];
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var jsonData = await get(url, headers: headers);
    var fetchData = jsonDecode(jsonData.body);
    // print(fetchData);
    if (fetchData['status']) {
      fetchData['data']['offerings'].forEach((offeringData) {
        offerings.add(Offering.fromJson(offeringData));
      });
    }
    return offerings;
  }
}
