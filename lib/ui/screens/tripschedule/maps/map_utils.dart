import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> lauchMapFromSourceToDestination(sourceLat, sourceLng,destinationLat, destinationLng) async {
    String mapOtions = [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate'
    ].join("&");

    final mapUrl = 'https://www.google.com/maps?$mapOtions';
    if(await canLaunchUrl(mapUrl as Uri)) {
      await launchUrl(mapUrl as Uri);
    }
  }

}