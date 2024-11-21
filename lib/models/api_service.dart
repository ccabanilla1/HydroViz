import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/well.dart';

// Handles all API calls to the backend server for projects, wells, and simulations
class ApiService {
  // Base URL for the backend API - change this based on your environment
  static const String baseUrl = 'http://localhost:8000/api';
  final String? authToken;

  ApiService({this.authToken});

  // Sets up common headers for all API requests including auth token if present
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  // Project-related API calls
  
  // Gets list of all projects from the backend
  Future<List<Project>> getProjects() async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  // Creates a new project with the provided data
  Future<Project> createProject(Map<String, dynamic> projectData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects/'),
      headers: headers,
      body: json.encode(projectData),
    );

    if (response.statusCode == 201) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  // Well-related API calls

  // Gets all wells associated with a specific project
  Future<List<Well>> getProjectWells(int projectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wells/?project=$projectId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Well.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wells');
    }
  }

  // Creates a new well with the provided data
  Future<Well> createWell(Map<String, dynamic> wellData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wells/'),
      headers: headers,
      body: json.encode(wellData),
    );

    if (response.statusCode == 201) {
      return Well.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create well');
    }
  }

  // Updates an existing well's data
  Future<void> updateWell(int wellId, Map<String, dynamic> wellData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/wells/$wellId/'),
      headers: headers,
      body: json.encode(wellData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update well');
    }
  }

  // Deletes a well by its ID
  Future<void> deleteWell(int wellId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/wells/$wellId/'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete well');
    }
  }

  // Simulation-related API calls

  // Starts a simulation for a specific project
  Future<Map<String, dynamic>> startSimulation(int projectId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/start_simulation/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to start simulation');
    }
  }
}