class MapService {
  // This function will take in a latitude and longitude and 
  // return the coordinates related to fog grid
  static List<double> locolizeFogCoordinates(double lat, double long) {
    String latRoundedString = lat.toStringAsFixed(3); // Rounds to 3 decimal places
    double latRoundedNumber = double.parse(latRoundedString); // Parses the string back to a double

    String longRoundedString = long.toStringAsFixed(3); // Rounds to 3 decimal places
    double longRoundedNumber = double.parse(longRoundedString); // Parses the string back to a double

    return [latRoundedNumber, longRoundedNumber];
  }
}