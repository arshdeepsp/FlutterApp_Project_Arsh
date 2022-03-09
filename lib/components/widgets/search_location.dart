import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/widgets/custom_text.dart';
import 'package:tripd_travel_app/models/places_search.dart';
import 'package:tripd_travel_app/models/raw_coordinates.dart';
import 'package:tripd_travel_app/services/location_service.dart';
import 'package:tripd_travel_app/services/places_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({
    Key? key,
  }) : super(key: key);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<PlacesSearch> searchResults = [];

  PlacesService placesService = PlacesService();

  LocationService locationService = LocationService();

  TextEditingController _locationController = TextEditingController();

  RawCoordinates? rawCoordinates;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  searchPlaces(String search) async {
    searchResults = await placesService.getAutoComplete(search);
    setState(() {});
  }

  locate() async {
    rawCoordinates = await locationService.getCoordinates();
    Navigator.pop(context, rawCoordinates);
  }

  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");

    var max = MediaQuery.of(context).size.height;

    return Container(
        height: 500,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Padding(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 15),
                    Expanded(child: SizedBox()),
                    ElevatedButton.icon(
                      onPressed: () {
                        locate();
                      },
                      icon: Icon(
                        Icons.my_location,
                        size: 25,
                      ),
                      label: CustomText(
                          data: 'Use current location',
                          fontFamily: 'CenturyGothic',
                          fontSize: 18,
                          textColor: Colors.white,
                          textAlign: TextAlign.center),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(7)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(color1),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: color1)))),
                    ),
                    SizedBox(
                      width: 65,
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              CustomText(
                  data: 'or',
                  fontFamily: 'CenturyGothic',
                  fontSize: 15,
                  textColor: Colors.black,
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white),
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _locationController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: "Search places",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 15.0),
                            suffixIcon: Container(
                              padding: EdgeInsets.all(5),
                              child: IconButton(
                                splashRadius: double.minPositive,
                                icon: Icon(Icons.close),
                                color: color1,
                                iconSize: 25,
                                onPressed: () {
                                  _locationController.clear();
                                  _focusNode.unfocus();
                                  searchPlaces(_locationController.text);
                                },
                              ),
                            ),
                          ),
                          onChanged: (val) => searchPlaces(val),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: max * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, 'clear');
                      },
                      child: CustomText(
                          data: 'Clear',
                          fontFamily: 'CenturyGothic',
                          fontSize: 15,
                          textColor: Colors.white,
                          textAlign: TextAlign.center),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(7)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple.shade400),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(color: color1, width: 2)))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              if (searchResults.length != 0)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: searchResults.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () async {
                                rawCoordinates =
                                    await placesService.getRawCoordinates(
                                        searchResults[index].placeId!);
                                Navigator.pop(context, rawCoordinates);
                              },
                              tileColor: Colors.black.withOpacity(.6),
                              title: CustomText(
                                  data: searchResults[index].description!,
                                  fontFamily: 'CenturyGothic',
                                  fontSize: 14,
                                  textColor: Colors.black,
                                  textAlign: TextAlign.left),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          padding: EdgeInsets.all(10),
        ));
  }
}
