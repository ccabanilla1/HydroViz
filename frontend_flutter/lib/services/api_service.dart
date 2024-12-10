import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/well.dart';
import 'package:logging/logging.dart';
import 'dart:developer' as developer;

class ApiService {
  // Static instance for singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  // Class fields
  static const String _baseUrl = 'http://127.0.0.1:8000/api';
  final String? _authToken;
  final _logger = Logger('ApiService');

  // Private constructor with initialization
  ApiService._internal() : _authToken = null {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        name: record.loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  // Named constructor for auth token
  ApiService.withToken(this._authToken);

  // Headers getter
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Project-related API calls
  
  Future<List<Project>> getProjects() async {
      try {
        _logger.info('Attempting to fetch projects');
        final response = await http.get(
          Uri.parse('$_baseUrl/projects/'),
          headers: _headers,
        );

        _logger.info('Response status code: ${response.statusCode}');
        _logger.info('Response body: ${response.body}');

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          return data.map((json) => Project.fromJson(json)).toList();
        } else {
          final error = 'Failed to load projects: Status ${response.statusCode}\nResponse: ${response.body}';
          _logger.severe(error);
          throw Exception(error);
        }
      } catch (e, stackTrace) {
        _logger.severe('Error loading projects', e, stackTrace);
        throw Exception('Failed to load projects: $e');
      }
  }

  Future<Project> createProject(Map<String, dynamic> projectData) async {
    try {
      _logger.info('Attempting to create project with data: $projectData');
      final response = await http.post(
        Uri.parse('$_baseUrl/projects/'),
        headers: _headers,
        body: json.encode({
          ...projectData,
          'status': 'ACTIVE',  
          'owner': 1,  // for development, change later
        }),
      );

      if (response.statusCode == 201) {
        _logger.info('Project created successfully');
        return Project.fromJson(json.decode(response.body));
      } else {
        final error = 'Failed to create project: ${response.statusCode}\nResponse: ${response.body}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error creating project', e, stackTrace);
      throw Exception('Failed to create project: $e');
    }
}
  // Well-related API calls

  Future<List<Well>> getProjectWells(int projectId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/wells/?project=$projectId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Well.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wells');
    }
  }

  Future<Well> createWell(Map<String, dynamic> wellData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/wells/'),
      headers: _headers,
      body: json.encode(wellData),
    );

    if (response.statusCode == 201) {
      return Well.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create well');
    }
  }

  Future<void> updateWell(int wellId, Map<String, dynamic> wellData) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/wells/$wellId/'),
      headers: _headers,
      body: json.encode(wellData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update well');
    }
  }

  Future<void> deleteWell(int wellId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/wells/$wellId/'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete well');
    }
  }

  // Component-related API calls
  
  Future<List<Map<String, dynamic>>> getComponents() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/components/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        final error = 'Failed to load components: ${response.statusCode}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error fetching components: $e', e, stackTrace);
      throw Exception('Failed to load components: $e');
    }
  }

Future<Map<String, dynamic>> saveComponent(Map<String, dynamic> componentData, int projectId) async {
    try {
      // Map the coordinates to match backend expectations
      final mappedData = {
        'type': componentData['type'],
        'location_x': componentData['location_x'],
        'location_y': componentData['location_y'],
        'project': projectId,  //  passed as parameter
        'properties': componentData['properties'] ?? {}
      };

      _logger.info('Attempting to save component with data: $mappedData');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/components/'),
        headers: _headers,
        body: json.encode(mappedData),
      );

      _logger.info('Response status code: ${response.statusCode}');
      _logger.info('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = 'Failed to save component: ${response.statusCode}\nResponse body: ${response.body}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error saving component: $e', e, stackTrace);
      throw Exception('Failed to save component: $e');
    }
}

  Future<Map<String, dynamic>> updateComponentPosition(
    String componentId,
    Map<String, dynamic> positionData,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/components/$componentId/'),
        headers: _headers,
        body: json.encode(positionData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = 'Failed to update component position: ${response.statusCode}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error updating component position: $e', e, stackTrace);
      throw Exception('Failed to update component position: $e');
    }
  }

  // Simulation-related API calls

  Future<Map<String, dynamic>> startSimulation(int projectId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/projects/$projectId/start_simulation/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to start simulation');
    }
  }
  Future<void> deleteProject(int projectId) async {
    try {
      _logger.info('Attempting to delete project with ID: $projectId');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/projects/$projectId/'),
        headers: _headers,
      );

      if (response.statusCode != 204) {
        final error = 'Failed to delete project: ${response.statusCode}';
        _logger.severe(error);
        if (response.body.isNotEmpty) {
          _logger.severe('Response body: ${response.body}');
        }
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error deleting project: $e', e, stackTrace);
      throw Exception('Failed to delete project: $e');
    }
  }

  Future<Project> updateProject(int projectId, Map<String, dynamic> projectData) async {
    try {
      _logger.info('Attempting to update project with ID: $projectId');
      
      final response = await http.patch(
        Uri.parse('$_baseUrl/projects/$projectId/'),
        headers: _headers,
        body: json.encode(projectData),
      );

      if (response.statusCode == 200) {
        return Project.fromJson(json.decode(response.body));
      } else {
        final error = 'Failed to update project: ${response.statusCode}';
        _logger.severe(error);
        if (response.body.isNotEmpty) {
          _logger.severe('Response body: ${response.body}');
        }
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error updating project: $e', e, stackTrace);
      throw Exception('Failed to update project: $e');
    }
  }

  Future<Map<String, dynamic>> getSimulationResults(String simulationId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/simulations/$simulationId/results/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch simulation results: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.severe('Error fetching simulation results: $e', e, stackTrace); // proper logging later?
      rethrow;
    }
  }
Future<void> deleteComponent(String componentId) async {
    try {
      _logger.info('Attempting to delete component with ID: $componentId');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/components/$componentId/'),  // note trailing slash
        headers: _headers,
      );

      if (response.statusCode != 204) {
        final error = 'Failed to delete component: ${response.statusCode}';
        _logger.severe(error);
        if (response.body.isNotEmpty) {
          _logger.severe('Response body: ${response.body}');
        }
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error deleting component: $e', e, stackTrace);
      throw Exception('Failed to delete component: $e');
    }
}
}
