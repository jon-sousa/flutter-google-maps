import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Marker> _markers = <Marker>{};
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-9.7584499, -36.6283579),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: _markers.isEmpty
          ? null
          : FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(
                    'Latitude: ${_markers.first.position.latitude} e Longitude: ${_markers.first.position.longitude}');
              },
            ),
      body: GoogleMap(
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (latLng) {
            setState(() {
              _markers.clear();
              _markers.add((Marker(markerId: MarkerId('1'), position: latLng)));
            });
          }),
    );
  }
}
