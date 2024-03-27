import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Position? userLocation;
  GoogleMapController? mapController;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _getLocation() async {
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userLocation = await Geolocator.getCurrentPosition();
    return userLocation!;
  }
  
  Future<void> showsDialog({required String title,message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Optional: Prevent user from dismissing
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future _SaveLocation(double lat, double lng) async {
    final email = auth.currentUser?.email;
    final query = db.collection('user_info').where('email', isEqualTo: email);
    String docID = '';
    if (email == null) {
      throw Exception(
          'Error: User not logged in'); // Handle unauthenticated case
    }

    final data = {
      'lat': lat,
      'lng': lng,
    };

    try {
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first; // Assuming only one document matches
          docID = doc.id;
          print(docID);
      } else {
          print('No user found with email: $email');
      }
    } on FirebaseException catch (e) {
        print('Error retrieving user data: $e');
    }

    try {
      await db.collection('user_info').doc(docID).update(data);
      // Success notification
      await showsDialog(title: 'Success',message: 'Location saved successfully!');
    } on FirebaseException catch (error) {
      // Handle Firebase errors gracefully
      await showsDialog(title: 'Error',message: 'Error saving location: ${error.message}');
    } catch (error) {
      // Catch other potential errors
      await showsDialog(title: 'Error',
          message: 'An unexpected error occurred: ${error.toString()}');
    }
  }

  Future<void> _openOnGoogleMapApp(double latitude, double longitude) async {
    final Uri _url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    //'https://www.google.com/maps/dir/?api=1&origin=13.7929841,100.636345&destination=13.9880741,100.8068477');

    final bool nativeAppLaunchSucceeded = await launchUrl(
      _url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        _url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        actions: <Widget>[
            IconButton(onPressed: () {_SaveLocation(userLocation!.latitude,userLocation!.longitude);}, icon: Icon(Icons.save))
        ],
      ),
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target:
                      LatLng(userLocation!.latitude, userLocation!.longitude),
                  zoom: 15),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton:  Padding(
          padding: const EdgeInsets.only(right: 200.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(userLocation!.latitude, userLocation!.longitude), 18));
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        'Your location has been send !\nlat: ${userLocation!.latitude} long: ${userLocation!.longitude} '),
                  );
                },
              );
            },
            label: const Text("Send Location"),
            icon: const Icon(Icons.near_me),
          ),
        ));
  }
}
