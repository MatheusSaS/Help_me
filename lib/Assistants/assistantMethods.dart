import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_me/Assistants/requestAssistant.dart';
import 'package:help_me/DataHandler/appData.dart';
import 'package:help_me/Models/address.dart';
import 'package:help_me/Models/allUser.dart';
import 'package:help_me/Models/directDetails.dart';
import 'package:help_me/configMaps.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddres = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "erro") {
      //placeAddres = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st3 = response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];

      placeAddres = st1 + ", " + st2;

      Address userPickUpAddress = new Address(
          '', placeAddres, '', position.latitude, position.longitude);

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddres;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    print(directionUrl);
    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "erro") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    // in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 2;
    double distancTraveledFare = (directionDetails.durationValue / 1000) * 10;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    //local currency
    //1$ = 160 rs
    double totalLocalAmpount = totalFareAmount * 160;

    return totalFareAmount.truncate();
  }

  static void getCurrentOnLineUserInfo() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });
  }
}
