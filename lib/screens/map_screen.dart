import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gauseva_app/controllers/authController.dart';
import 'package:gauseva_app/models/post_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();
  late AuthController _auth;
  bool _markerTapped = false;
  LatLng? currentPosition;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
  }

  Future<void> _getLocationAndSetMarkers() async {
    if ((await Permission.location.isGranted) == false) {
      await Permission.location.request();
    }
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    currentPosition = LatLng(position.latitude, position.longitude);

    _auth.userPosts.map(
      (Post post) {
        Marker marker = Marker(
          point: LatLng((post.location['lat'] as double),
              (post.location['long'] as double)),
          builder: (context) {
            return Icon(Icons.location_on_rounded);
          },
        );
        _markers.add(marker);
      },
    );
    print(_markers);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLocationAndSetMarkers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Widget'),
          );
        }
        print(currentPosition);
        print(_markers);
        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                controller: _mapController,
                center:
                    currentPosition == null ? LatLng(0, 0) : currentPosition,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  maxZoom: 60.0,
                ),
                CircleLayerOptions(
                  circles: [
                    CircleMarker(
                      point: currentPosition!,
                      radius: 50.0,
                      color: Colors.black12,
                    ),
                  ],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      point: currentPosition!,
                      width: 90,
                      height: 150,
                      builder: (context) => _markerTapped
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Location: xyz\napprox cow: abc\nseverity: pqr",
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.red,
                                      size: 40,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _markerTapped = true;
                                });
                              },
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                    ),
                    ..._markers,
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 18.h,
              height: 20.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black12,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Less severe',
                          style: GoogleFonts.raleway(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black26,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'More severe',
                          style: GoogleFonts.raleway(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black54,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'Highly severe',
                          style: GoogleFonts.raleway(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
