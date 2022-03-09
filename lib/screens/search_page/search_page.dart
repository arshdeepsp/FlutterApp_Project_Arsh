import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tripd_travel_app/components/dialogs/offering_options.dart';
import 'package:tripd_travel_app/components/dialogs/options_dialog.dart';
import 'package:tripd_travel_app/components/domain/categories.dart';
import 'package:tripd_travel_app/components/domain/search_view.dart';
import 'package:tripd_travel_app/components/domain/top_bar.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/custom_daterange.dart';
import 'package:tripd_travel_app/components/widgets/date_sort.dart';
import 'package:tripd_travel_app/components/widgets/search_location.dart';
import 'package:tripd_travel_app/models/coordinates.dart';
import 'package:tripd_travel_app/models/date_filter.dart';
import 'package:tripd_travel_app/models/raw_coordinates.dart';
import 'package:tripd_travel_app/models/search_results.dart';
import 'package:tripd_travel_app/services/location_service.dart';
import 'package:tripd_travel_app/services/offering_service.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Color color1 = HexColor("6700E3");
  Color color2 = HexColor('D1D1D1');

  List? categories = [];
  List? results;

  bool _offstage = false;
  bool resultStatus = false;

  OfferingService offerings = OfferingService();

  TextEditingController _searchController = TextEditingController();

  List offeringList = [];

  String description = 'Set a location';
  String? filter;
  String? displayedFilter = 'All';

  final FocusNode _focusNode = FocusNode();

  Coordinates coordinates = Coordinates('', '');
  //RawCoordinates? rawCoordinates;

  LocationService locationService = LocationService();

  DateFilter dateFilter = DateFilter('all', '', '');

  DateTimeRange? dateRange;

  // ignore: close_sinks
  final locationController = StreamController<RawCoordinates>.broadcast();
  // ignore: close_sinks
  final dateController = StreamController<RawCoordinates>.broadcast();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getOfferingService();
    _retrieveLocation();
    KeyboardVisibilityController().onChange.listen((event) {
      if (!event) {
        _focusNode.unfocus();
      }
    });
  }

  Future<void> _getOfferingService() async {
    categories = await offerings.getOfferingService();
    setState(() {});
  }

  Future<void> _showOptions(BuildContext context) async {
    await showDialog(
        context: context, builder: (BuildContext context) => OptionsDialog());
  }

  Future<void> _showOfferingOptions(BuildContext context, offeringId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            OfferingOptions(offeringId: offeringId));
  }

  void _awaitLocationData(BuildContext context) async {
    var data = await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return SearchLocation();
        });
    if (data != null) {
      if (data == 'clear') {
        setState(() {
          coordinates.lat = '';
          coordinates.long = '';
          description = 'Set a location';
        });
      } else {
        //rawCoordinates = data;
        coordinates.lat = data!.lat.toString();
        coordinates.long = data!.long.toString();
        locationController.sink.add(data!);
      }
    }
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start: DateTime.now(), end: DateTime.now().add(Duration(days: 3)));
    /* final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDateRange: dateRange ?? initialDateRange,
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.dark(
                primary: color1,
                onPrimary: Colors.white,
                surface: color1,
              ),
            ),
            child: child!);
      },
    );*/

    final newDateRange = await showCustomDateRange(
        context: context,
        initialDateRange: initialDateRange,
        dateRange: dateRange);

    if (newDateRange == null) {
      setState(() {
        displayedFilter = 'No date selected';
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          displayedFilter = 'All';
        });
      });

      return;
    }

    setState(() {
      dateRange = newDateRange;
    });
    dateFilter.fromDate =
        formatDate(dateRange!.start, [yyyy, '-', mm, '-', dd]);
    dateFilter.toDate = formatDate(dateRange!.end, [yyyy, '-', mm, '-', dd]);
  }

  void _awaitDateSearch() async {
    filter = await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return DateSort();
        });
    if (filter != null) {
      dateFilter.filterType = filter!.toLowerCase();
      setState(() {
        displayedFilter = filter;
      });
      // print(dateFilter.filterType);
      if (dateFilter.filterType == 'custom') {
        pickDateRange(context);
      } else {
        dateFilter.fromDate = '';
        dateFilter.toDate = '';
        dateRange = null;
      }
    }
  }

  Future<void> _retrieveLocation() async {
    locationController.stream.listen((val) async {
      _updateLocation(val);
    });
  }

  void _updateLocation(val) async {
    String recieved = await locationService
        .getDescriptionFromCoordinates(RawCoordinates(val.lat, val.long));
    setState(() {
      description = recieved;
    });
  }

  Future changeSearchUI() async {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _offstage = true;
        });
      } else {
        setState(() {
          _offstage = false;
        });
      }
    });
  }

  String fromDate() {
    return formatDate(dateRange!.start, [dd, ' ', M]);
  }

  String toDate() {
    return formatDate(dateRange!.end, [dd, ' ', M]);
  }

  Future _search() async {
    SearchResults searchResults = await offerings.searchOfferingService(
        _searchController.text,
        coordinates.lat,
        coordinates.long,
        '200',
        dateFilter.filterType,
        dateFilter.fromDate,
        dateFilter.toDate);
    offeringList = searchResults.categories;
    if (searchResults.status) {
      setState(() {
        resultStatus = true;
      });
    } else {
      setState(() {
        resultStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Offstage(
          offstage: _offstage,
          child: TopBar(),
        ),
        Offstage(
          offstage: !_offstage,
          child: SizedBox(
            height: 45,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30)),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onTap: changeSearchUI,
              onChanged: (text) async {
                await _search();
              },
              cursorColor: color1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search for festival, hotels, food and drink.....',
                suffixIcon: IconButton(
                  splashRadius: double.minPositive,
                  icon: Icon(Icons.close),
                  color: color1,
                  iconSize: 25,
                  onPressed: () {
                    offeringList.clear();
                    _focusNode.unfocus();
                    _searchController.clear();
                    changeSearchUI();
                  },
                ),
                fillColor: Colors.grey,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontFamily: 'CenturyGothic',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              children: [
                TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {
                      _awaitLocationData(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.clip,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )),
                Expanded(child: SizedBox()),
                TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {
                      _awaitDateSearch();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          (dateRange == null)
                              ? 'Dates: $displayedFilter'
                              : '${fromDate()} - ${toDate()}',
                          style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.clip,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.date_range,
                          color: Colors.black,
                        ),
                      ],
                    ))
              ],
            )),
        const Divider(
          thickness: 0.5,
          height: 0,
        ),
        Expanded(
          child: (_offstage)
              ? Container(
                  child: (resultStatus)
                      ? SearchView(
                          itemList: offeringList,
                          showOfferingOptions: _showOfferingOptions,
                          controller: _searchController,
                        )
                      : Container(
                          child: Center(
                            child: CenturyGothicText(
                                data: '',
                                fontSize: 20,
                                textColor: color1,
                                textAlign: TextAlign.center),
                          ),
                        ))
              : Categories(
                  itemList: categories,
                  showOptions: () {
                    _showOptions(context);
                  },
                  showOfferingOptions: _showOfferingOptions,
                ),
        ),
      ]),
    );
  }
}
