import 'package:flutter/material.dart';
import 'communityhome.dart';
import 'error404.dart';
import '../../services/api_service.dart';
import '../../models/project.dart';
import 'package:logging/logging.dart';
import 'dart:developer' as developer;



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService _apiService = ApiService(); 
  List<Project> _recentProjects = [];        
  List<Project> _filteredProjects = [];        
  bool _isLoading = false;  
  final TextEditingController _searchController = TextEditingController();
  final _logger = Logger('MainScreen');

  @override
  void initState() {
    super.initState();
    _initializeLogging();
    _loadProjects();
    _searchController.addListener(_filterProjects);
  }

  void _initializeLogging() {
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

Future<void> _loadProjects() async {
  setState(() {
    _isLoading = true;
  });

  try {
    _logger.info('Loading projects...');
    final projects = await _apiService.getProjects();
    
    if (!mounted) return;
    
    setState(() {
      _recentProjects = projects;
      _filteredProjects = projects;
    });
    _logger.info('Successfully loaded ${projects.length} projects');
  } catch (e, stackTrace) {
    _logger.severe('Failed to load projects', e, stackTrace);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load projects: $e'),
        duration: const Duration(seconds: 2),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  void _filterProjects() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredProjects = _recentProjects;
      });
      return;
    }

    setState(() {
      _filteredProjects = _recentProjects.where((project) {
        return project.projectName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
               project.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
               project.modelType.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteProject(Project project) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${project.projectName}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirmDelete) return;

    try {
      await _apiService.deleteProject(project.projectId);
      _loadProjects(); // Refresh the list
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project "${project.projectName}" deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete project: $e')),
      );
    }
  }

  Future<void> _editProject(Project project) async {
    final TextEditingController nameController = TextEditingController(text: project.projectName);
    final TextEditingController descController = TextEditingController(text: project.description);
    String selectedStatus = project.status;
    String selectedModelType = project.modelType;

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Project'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Project Name'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: ['active', 'completed', 'archived'].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedStatus = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedModelType,
                      decoration: const InputDecoration(labelText: 'Model Type'),
                      items: ['groundwater', 'surface', 'integrated'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedModelType = value!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'project_name': nameController.text,
                      'description': descController.text,
                      'status': selectedStatus,
                      'model_type': selectedModelType,
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      try {
        await _apiService.updateProject(project.projectId, result);
        _loadProjects(); // Refresh the list
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update project: $e')),
        );
      }
    }
  }

  void _showProjectDetails(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(project.projectName),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Description', project.description),
                const SizedBox(height: 8),
                _detailRow('Status', project.status.toUpperCase()),
                const SizedBox(height: 8),
                _detailRow('Model Type', project.modelType.toUpperCase()),
                const SizedBox(height: 8),
                _detailRow('Created', _formatDate(project.createdDate)),
                const SizedBox(height: 8),
                _detailRow('Last Modified', _formatDate(project.lastModified)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _deleteProject(project),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editProject(project);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label + ':',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleNewProject(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Create new project
      final newProject = await _apiService.createProject({
        'project_name': 'New Project ${DateTime.now().toIso8601String()}',
        'description': 'Created from MainScreen',
        'status': 'active',
        'model_type': 'groundwater',
      });

      if (!mounted) return;
      Navigator.pop(context); // Close loading indicator

      // Navigate to ModelingInterface with project ID
      Navigator.pushNamed(
        context,
        '/modeling',
        arguments: newProject.projectId,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create project: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openExistingProject(Project project) async {
    Navigator.pushNamed(
      context,
      '/modeling',
      arguments: project.projectId,
    );
  }

  Future<void> _showProjectsDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Open Project'),
          content: SizedBox(
            width: 300,
            height: 400,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return ListTile(
                        title: Text(project.projectName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.description),
                            Text('Status: ${project.status}'),
                            Text('Type: ${project.modelType}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _openExistingProject(project);
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _loadProjects();
              },
              child: const Text('Refresh'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF93C6E0),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'lib/assets/hydrovizlogo.png',
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'HydroViz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Search Bar
                Container(
                  width: 400,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: 80,
                  color: const Color(0xFF93C6E0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.dashboard,
                                  size: 30, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Error404()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.people,
                                  size: 30, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Communityhome()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.search,
                                  size: 30, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Error404()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings,
                                  size: 30, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Error404()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('lib/assets/profile.png'),
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _handleNewProject(context),
                              icon: const Icon(Icons.add_circle, color: Colors.white),
                              label: const Text(
                                'New Project...',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: () => _showProjectsDialog(),
                              icon: const Icon(Icons.folder_open, color: Colors.green),
                              label: const Text(
                                'Open...',
                                style: TextStyle(color: Colors.green, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Recent',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _recentProjects.isEmpty
                                    ? [const Text('No recent projects')]
                                    : _recentProjects.map((project) => InkWell(
  onTap: () => _showProjectDetails(project),
  child: Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.projectName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                project.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'open':
                _openExistingProject(project);
                break;
              case 'edit':
                _editProject(project);
                break;
              case 'delete':
                _deleteProject(project);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'open',
              child: Text('Open'),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
              textStyle: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ],
    ),
  ),
)).toList(),
                              ),
                      ],
                    ),
                  ),
                ),
                // Walkthroughs Section
                Container(
                  width: 300,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Walkthroughs',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      walkthroughTile(),
                      walkthroughTile(),
                      walkthroughTile(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walkthroughTile() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Started with HydroViz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Learn the Basics and start your project!',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}