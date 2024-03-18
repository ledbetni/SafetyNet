import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we are unable to request permission.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<String> appendLocationToMessage(
    String message, Position position) async {
  try {
    String mapPinUrl =
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    String messageWithMapPin = '$message\nMy Location: $mapPinUrl';
    return messageWithMapPin;
  } catch (e) {
    print('Failed to append map pin: $e');
    return message;
  }
}
