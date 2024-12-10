// Represents a hydrogeological modeling project with its metadata
class Project {
  final int projectId;          // Unique identifier for the project
  final String projectName;     // Display name of the project
  final String description;     // Brief description of project purpose/scope
  final String status;          // Current project status (e.g., active, completed)
  final String modelType;       // Type of hydrogeological model being used
  final DateTime createdDate;   // When the project was created
  final DateTime lastModified;  // Last time the project was updated

  Project({
    required this.projectId,
    required this.projectName,
    required this.description,
    required this.status,
    required this.modelType,
    required this.createdDate,
    required this.lastModified,
  });

  // Creates a Project instance from JSON data received from the API
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['project_id'],
      projectName: json['project_name'],
      description: json['description'],
      createdDate: DateTime.parse(json['created_date']),
      lastModified: DateTime.parse(json['last_modified']),
      status: json['status'],
      modelType: json['model_type'],
    );
  }
}