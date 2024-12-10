// Represents a hydrogeological well with its physical properties and metadata
class Well {
  final int wellId;             // Unique identifier for the well
  final int projectId;          // ID of the project this well belongs to
  final double locationX;       // X coordinate of well location
  final double locationY;       // Y coordinate of well location
  final double groundElevation; // Ground surface elevation at well location
  final double totalDepth;      // Total depth of the well from ground surface
  final DateTime installDate;   // When the well was installed
  final String status;          // Current well status (active, inactive, etc.)
  final String purpose;         // Purpose of the well (monitoring, pumping, etc.)

  Well({
    required this.wellId,
    required this.projectId,
    required this.locationX,
    required this.locationY,
    required this.groundElevation,
    required this.totalDepth,
    required this.installDate,
    required this.status,
    required this.purpose,
  });

  // Creates a Well instance from JSON data received from the API
  factory Well.fromJson(Map<String, dynamic> json) {
    return Well(
      wellId: json['well_id'],
      projectId: json['project'],
      locationX: json['location_x'],
      locationY: json['location_y'],
      groundElevation: json['ground_elevation'],
      totalDepth: json['total_depth'],
      installDate: DateTime.parse(json['install_date']),
      status: json['status'],
      purpose: json['purpose'],
    );
  }
}