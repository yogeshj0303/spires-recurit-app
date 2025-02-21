import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spires_app/Constants/exports.dart';

class LocationServices {
  static double latitude = 0.0;
  static double longitude = 0.0;
  static String? address;
  static final c = Get.put(MyController());

  static late StreamSubscription<Position> streamSubscription;

  static bool _initialized = false;

  static Future<void> getAddressFromLatLang(Position position) async {
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      latitude = position.latitude;
      longitude = position.longitude;
      Placemark place = placemark[0];
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      c.location.value = address!;
      c.city.value = place.locality!;
      _initialized = true;
      c.isLocationLoading.value = false;
    } catch (e) {
      print('Error getting address: $e');
      c.isLocationLoading.value = false;
    }
  }

  static Future<bool> getLocation() async {
    try {
      c.isLocationLoading.value = true;
      LocationPermission permission;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        c.isLocationLoading.value = false;
        return false;
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          c.isLocationLoading.value = false;
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        c.isLocationLoading.value = false;
        _showPermissionDeniedDialog();
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await getAddressFromLatLang(position);
      return true;
    } catch (e) {
      print('Error getting location: $e');
      c.isLocationLoading.value = false;
      return false;
    }
  }

  static bool isInitialized() {
    return _initialized;
  }
}

_showPermissionDeniedDialog() {
  return Get.defaultDialog(
    title: 'Location Permission Denied',
    middleText: 'Please grant location permission to use this feature.',
    onConfirm: () => Get.back(),
    textConfirm: 'OK',
  );
}
