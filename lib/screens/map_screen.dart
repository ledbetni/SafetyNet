import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safetynet/lib.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
      _moveCameraToCurrentUserLocation();
    } catch (e) {
      print(e);
    }
  }

  void _moveCameraToCurrentUserLocation() {
    if (_center != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _center!, zoom: 15),
      ));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (_center != null) {
      _moveCameraToCurrentUserLocation();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
            target: _center ?? LatLng(45.521563, -122.677433), zoom: 11.0),
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
