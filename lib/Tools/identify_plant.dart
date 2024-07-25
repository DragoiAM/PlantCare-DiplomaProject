import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlantIdentifier {
  static Future<String> identifyPlant(String imagePath, String apiKey) async {
    var uri = Uri.parse(
        'https://my-api.plantnet.org/v2/identify/all?include-related-images=false&no-reject=false&lang=en&type=kt&api-key=$apiKey');
    var request = http.MultipartRequest('POST', uri)
      ..headers['accept'] = 'application/json'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..files.add(await http.MultipartFile.fromPath(
        'images',
        imagePath,
        contentType: MediaType('image', 'jpeg'),
      ));

    // Send the request
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var decoded = jsonDecode(responseString);

      // Parse the response data to get the plant names
      String scientificName =
          decoded['results'][0]['species']['scientificNameWithoutAuthor'];

      return scientificName;
    } else {
      // Handle error or non-200 response
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // Log or handle the error response body
      print('Error: ${response.statusCode}');
      print('Error body: $responseString');
      return 'Error: Unable to identify the plant.';
    }
  }
}
