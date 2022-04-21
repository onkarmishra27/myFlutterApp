import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? mapController; //contrller for Google map
  List<Marker> allMarkers = [];
  CameraPosition? cameraPosition;
  String googleApikey = "AIzaSyCHGlhb0MqJoggcE15hl4XF_a74pYggSrA";
  LatLng startLocation = LatLng(12.917361182134956, 77.6150768995285);
  String location = "";
  String choosed = "";
  String lat = "";
  String lng = "";
  Position? currentPosition;
  var geoLocator = Geolocator();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarkers'),
        draggable: true,
        onTap: () {
          log('marker tapped');
        },
        position: LatLng(12.9169, 77.6151)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar(),
      body: Stack(children: [
        GoogleMap(
          //Map widget from google_maps_flutter package
          zoomGesturesEnabled: true, //enable Zoom in, out on map
          initialCameraPosition: CameraPosition(
            //innital position in map
            target: startLocation, //initial position
            zoom: 14.0, //initial zoom level
          ),
          mapType: MapType.normal, //map type
          onMapCreated: (controller) {
            //method called when map is created
            setState(() {
              mapController = controller;
            });
          },
          onCameraMove: (CameraPosition cameraPositiona) {
            cameraPosition = cameraPositiona; //when map is dragging
          },
          onCameraIdle: () async {
            //when map drag stops
            List<Placemark> placemarks = await placemarkFromCoordinates(
                cameraPosition!.target.latitude,
                cameraPosition!.target.longitude);
            setState(() {
              //get place name from lat and lang
              location = placemarks.first.administrativeArea.toString() +
                  ", " +
                  placemarks.first.street.toString();
            });
          },
        ),
        Center(
          //picker image on google map
          child: Image.asset(
            "assets/images/marker.png",
            width: 50,
          ),
        ),
        Positioned(
            //widget to display location name
            top: 0,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Card(
                child: Container(
                    height: 50,
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.search_rounded),
                        onPressed: () {},
                      ),
                      title: Text(
                        location,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      dense: true,
                    )),
              ),
            ))
      ]),
      drawer: Container(
        child: drawer(),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: const Text(
        'ORBIT BOLTON',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromARGB(255, 247, 206, 4),
    );
  }

  // GoogleMap googleMapBody() {
  //   return GoogleMap(
  //     mapType: MapType.normal,
  //     initialCameraPosition:
  //         CameraPosition(target: LatLng(12.9169, 77.6151), zoom: 18.0),
  //     markers: Set.from(allMarkers),
  //     onMapCreated: (GoogleMapController controller) {
  //       _controller.complete(controller);
  //     },
  //   );
  // }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  // void checkPermission() async {
  //   if (await Permission.location.serviceStatus.isEnabled) {
  //     var status = await Permission.location.status;
  //     if (status.isGranted) {
  //       // getCurrentPosition();
  //     } else if (status.isDenied) {
  //       Map<Permission, PermissionStatus> status = await [
  //         Permission.location,
  //       ].request();
  //     }
  //   } else {
  //     if (await Permission.location.isPermanentlyDenied) {
  //       openAppSettings();
  //     }
  //   }
  // }

  // void getCurrentPosition() async {
  //   currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   lat = currentPosition!.latitude.toString();
  //   lng = currentPosition!.longitude.toString();
  //   log("latlng called: $currentPosition,$lat,$lng");
  //   startLocation =
  //       LatLng(currentPosition!.latitude, currentPosition!.longitude);

  //   final coordinates =
  //       new Coordinates(currentPosition!.latitude, currentPosition!.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   log("Fisrttttt : ${first.featureName}");
  //   //print("${first.featureName} : ${first.addressLine}");
  //   location = first.addressLine.toString();
  //   log("Second : $location");
  // }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 247, 206, 4),
            ),
            child: Text('Edit Profile'),
          ),
          ListTile(
            title: const Text('Book a Ride'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('My Rides'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Payments'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Loyalty'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Referral'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Help'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
