import 'dart:async';
import 'dart:io';

// import 'package:call_number/call_number.dart';
import 'package:dio/dio.dart';
import 'package:donor_tracker/main.dart';
import 'package:donor_tracker/modal/preferenceModal.dart';
import 'package:donor_tracker/style/colorSheet.dart';
import 'package:donor_tracker/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

Map userData;

class _LandingScreenState extends State<LandingScreen> {
  Set<Marker> _markers = {};
  String email;
  // BitmapDescriptor personIcon;
  List blood = ['All', 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  getLocation() async {
    userData = await PreferenceModal().getUserData();
    email = userData['email'];
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 0);
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      await updateUserLocation(
          position.latitude.toString(), position.longitude.toString());
      // print(position == null
      //     ? 'Unknown'
      //     : position.latitude.toString() +
      //         ', ' +
      //         position.longitude.toString());
    });
    return positionStream;
  }

  bool filter = false;
  String filterBlood = 'All';
  setPinLocation() {
    _markers.clear();
    for (var i = 0; i < allUsers.length; i++) {
      if (filter) {
        if (allUsers[i]['blood_group'] == filterBlood) {
          _markers.add(
            Marker(
                markerId: MarkerId(allUsers[i]['user_id'].toString()),
                position:
                    LatLng(allUsers[i]['latitude'], allUsers[i]['longitude']),
                infoWindow: InfoWindow(
                    title: allUsers[i]['name'],
                    onTap: () {
                      showBottom(i);
                    },
                    snippet: allUsers[i]['blood_group'])),
          );
        } else {}
      } else {
        _markers.add(Marker(
            markerId: MarkerId(allUsers[i]['user_id'].toString()),
            position: LatLng(allUsers[i]['latitude'], allUsers[i]['longitude']),
            infoWindow: InfoWindow(
                title: allUsers[i]['name'],
                onTap: () {
                  showBottom(i);
                },
                snippet: allUsers[i]['blood_group'])));
      }
    }
    setState(() {});
  }

  showBottom(i) {
    var control = scaffoldKey.currentState.showBottomSheet(
      (context) => Container(
        child: getBottomSheet(allUsers[i]),
        height: 150,
        color: Colors.transparent,
      ),
    );
    showFloating(false);
    control.closed.then((value) => showFloating(true));
  }

  String tempLat;
  String tempLong;
  Future<Null> updateUserLocation(lat, long) async {
    if (lat != tempLat && long != tempLong) {
      tempLat = lat.toString();
      tempLong = long.toString();
      try {
        Response r = await Dio().put('$domain/updateLocation',
            data: {'email': email, 'latitude': lat, 'longitude': long});
        if (r.statusCode == 200) {
          //print(r.data);
        }
      } catch (e) {
        print(e);
      }
    } else {
      //do nothing
    }
  }

  CameraPosition _myLoc;
  setCamera() async {
    Position position = await Geolocator().getCurrentPosition();
    _myLoc = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLoc));
  }

  Future<Null> getAllUsers() async {
    try {
      Response r = await Dio().get('$domain/getAllUser');
      if (r.statusCode == 200) {
        setState(() {
          allUsers = r.data;
        });
        setPinLocation();
      }
    } catch (e) {
      print(e);
    }
  }

  List allUsers = [];
  @override
  void initState() {
    super.initState();
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(devicePixelRatio: 2.5), 'image/personIcon.png')
    //     .then((onValue) {
    //   personIcon = onValue;
    // });
    Timer.periodic(Duration(seconds: 5), (timer) async {
      await getAllUsers();
    });
    _myLoc = CameraPosition(
      target: LatLng(24, 73),
      zoom: 14.4746,
    );
    getLocation();
    setCamera();
  }

  Completer<GoogleMapController> _controller = Completer();
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UserProfile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget getBottomSheet(Map data) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.person,
                color: Colors.blue,
              ),
              SizedBox(
                width: 20,
              ),
              Text(data['name'])
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.favorite,
                color: Colors.blue,
              ),
              SizedBox(
                width: 20,
              ),
              Text(data['blood_group'])
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              // await new CallNumber().callNumber('+91' + data['contact']);
            },
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.call,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(data['contact'])
              ],
            ),
          )
        ],
      ),
    );
  }

  bool show = true;
  showFloating(value) {
    setState(() {
      show = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: SafeArea(
        child: new Scaffold(
            key: scaffoldKey,
            body: Builder(builder: (context) {
              return Stack(
                children: <Widget>[
                  GoogleMap(
                    markers: _markers,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _myLoc,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              ' Donor Tracker ',
                              style: GoogleFonts.permanentMarker(
                                  color: mainColor,
                                  fontSize: 32,
                                  backgroundColor:
                                      Colors.grey.withOpacity(0.2)),
                            ),
                          )),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(_createRoute());
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage('image/profile.jpg'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              );
            }),
            floatingActionButton: show
                ? FloatingActionButton.extended(
                    onPressed: () {
                      filterBlood = 'All';
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          child: new CupertinoAlertDialog(
                            title: new Column(
                              children: <Widget>[
                                new Text("Select Blood Group"),
                              ],
                            ),
                            content: Container(
                              height: 150,
                              child: ListWheelScrollView(
                                useMagnifier: true,
                                magnification: 1.5,
                                onSelectedItemChanged: (a) {
                                  print(a);
                                  filterBlood = blood[a];
                                },
                                itemExtent: 40.0,
                                children: <Widget>[
                                  Text(
                                    'All',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'O+',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'O-',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'A+',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'A-',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'B+',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'B-',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'AB+',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    'AB-',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("Cancel")),
                              FlatButton(
                                  onPressed: () {
                                    if (filterBlood != 'All')
                                      filter = true;
                                    else
                                      filter = false;
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).push(
                                    //     CupertinoPageRoute(
                                    //         builder: (context) =>
                                    //             ChangeProfileToLender()));
                                  },
                                  child: new Text("Ok"))
                            ],
                          ));
                    },
                    label: Text('Filter Blood Group'),
                    icon: Icon(Icons.filter_list),
                  )
                : Container()),
      ),
    );
  }
}
