import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/patient_card_widget.dart';
import './widgets/search_header_widget.dart';

class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allPatients = [];
  List<Map<String, dynamic>> _filteredPatients = [];
  List<String> _recentSearches = [];
  String _selectedFilter = 'all';
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMockData();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  void _loadMockData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _allPatients = [
          {
            "id": 1,
            "name": "Sarah Johnson",
            "age": 45,
            "condition": "Diabetes Type 2",
            "status": "stable",
            "lastContact": "2 hours ago",
            "hasAlert": false,
            "profileImage":
                "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
            "medicalId": "MID001",
            "riskLevel": "low",
            "lastVisit": DateTime.now().subtract(const Duration(days: 7)),
          },
          {
            "id": 2,
            "name": "Michael Rodriguez",
            "age": 62,
            "condition": "Hypertension",
            "status": "monitoring",
            "lastContact": "1 day ago",
            "hasAlert": true,
            "profileImage":
                "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
            "medicalId": "MID002",
            "riskLevel": "medium",
            "lastVisit": DateTime.now().subtract(const Duration(days: 3)),
          },
          {
            "id": 3,
            "name": "Emily Chen",
            "age": 34,
            "condition": "Asthma",
            "status": "stable",
            "lastContact": "3 hours ago",
            "hasAlert": false,
            "profileImage":
                "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
            "medicalId": "MID003",
            "riskLevel": "low",
            "lastVisit": DateTime.now().subtract(const Duration(days: 14)),
          },
          {
            "id": 4,
            "name": "Robert Thompson",
            "age": 58,
            "condition": "Heart Disease",
            "status": "critical",
            "lastContact": "30 minutes ago",
            "hasAlert": true,
            "profileImage":
                "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
            "medicalId": "MID004",
            "riskLevel": "high",
            "lastVisit": DateTime.now().subtract(const Duration(days: 1)),
          },
          {
            "id": 5,
            "name": "Lisa Anderson",
            "age": 41,
            "condition": "Chronic Pain",
            "status": "monitoring",
            "lastContact": "5 hours ago",
            "hasAlert": false,
            "profileImage":
                "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
            "medicalId": "MID005",
            "riskLevel": "medium",
            "lastVisit": DateTime.now().subtract(const Duration(days: 10)),
          },
          {
            "id": 6,
            "name": "David Kim",
            "age": 29,
            "condition": "Anxiety Disorder",
            "status": "stable",
            "lastContact": "1 day ago",
            "hasAlert": false,
            "profileImage":
                "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
            "medicalId": "MID006",
            "riskLevel": "low",
            "lastVisit": DateTime.now().subtract(const Duration(days: 21)),
          },
        ];
        _filteredPatients = List.from(_allPatients);
        _recentSearches = ['Sarah', 'Diabetes', 'MID001', 'Hypertension'];
        _isLoading = false;
      });
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPatients = _applyCurrentFilter(_allPatients);
      } else {
        _filteredPatients = _allPatients.where((patient) {
          final name = (patient['name'] as String).toLowerCase();
          final condition = (patient['condition'] as String).toLowerCase();
          final medicalId = (patient['medicalId'] as String).toLowerCase();
          return name.contains(query) ||
              condition.contains(query) ||
              medicalId.contains(query);
        }).toList();
        _filteredPatients = _applyCurrentFilter(_filteredPatients);
      }
    });
  }

  List<Map<String, dynamic>> _applyCurrentFilter(
      List<Map<String, dynamic>> patients) {
    switch (_selectedFilter) {
      case 'high_risk':
        return patients
            .where((p) => p['riskLevel'] == 'high' || p['status'] == 'critical')
            .toList();
      case 'recent_alerts':
        return patients.where((p) => p['hasAlert'] == true).toList();
      case 'chronic_conditions':
        return patients
            .where((p) =>
                (p['condition'] as String).toLowerCase().contains('diabetes') ||
                (p['condition'] as String)
                    .toLowerCase()
                    .contains('hypertension') ||
                (p['condition'] as String).toLowerCase().contains('heart') ||
                (p['condition'] as String).toLowerCase().contains('chronic'))
            .toList();
      case 'custom_date':
        if (_selectedDateRange != null) {
          return patients.where((p) {
            final lastVisit = p['lastVisit'] as DateTime;
            return lastVisit.isAfter(_selectedDateRange!.start) &&
                lastVisit.isBefore(
                    _selectedDateRange!.end.add(const Duration(days: 1)));
          }).toList();
        }
        return patients;
      default:
        return patients;
    }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filteredPatients = _applyCurrentFilter(_allPatients);
    });
  }

  void _onDateRangeSelected(DateTimeRange? dateRange) {
    setState(() {
      _selectedDateRange = dateRange;
      if (_selectedFilter == 'custom_date') {
        _filteredPatients = _applyCurrentFilter(_allPatients);
      }
    });
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _onSearchChanged();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate updated data
    _loadMockData();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedFilter: _selectedFilter,
        onFilterSelected: _onFilterSelected,
        selectedDateRange: _selectedDateRange,
        onDateRangeSelected: _onDateRangeSelected,
      ),
    );
  }

  void _onPatientTap(Map<String, dynamic> patient) {
    Navigator.pushNamed(context, '/patient-health-tracking');
  }

  void _onAddPatient() {
    // Simulate adding a new patient
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add Patient feature coming soon!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onPatientAction(String action, Map<String, dynamic> patient) {
    String message = '';
    switch (action) {
      case 'call':
        message = 'Calling ${patient['name']}...';
        break;
      case 'message':
        message = 'Opening message for ${patient['name']}...';
        break;
      case 'vitals':
        message = 'Viewing vitals for ${patient['name']}...';
        break;
      case 'schedule':
        message = 'Scheduling appointment for ${patient['name']}...';
        break;
      case 'note':
        message = 'Adding note for ${patient['name']}...';
        break;
      case 'emergency':
        message = 'Contacting emergency contact for ${patient['name']}...';
        break;
      case 'transfer':
        message = 'Transferring care for ${patient['name']}...';
        break;
      case 'archive':
        message = 'Archiving ${patient['name']}...';
        break;
      case 'export':
        message = 'Exporting records for ${patient['name']}...';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SearchHeaderWidget(
              searchController: _searchController,
              onSearchChanged: (value) => _onSearchChanged(),
              onFilterPressed: _showFilterBottomSheet,
              recentSearches: _recentSearches,
              onRecentSearchTap: _onRecentSearchTap,
            ),
            if (_isOffline) _buildOfflineIndicator(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredPatients.isEmpty
                      ? _buildEmptyState()
                      : _buildPatientList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient List',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${_filteredPatients.length} patients',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      color: Colors.orange.withValues(alpha: 0.1),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: Colors.orange,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Offline mode - Showing cached data',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading patients...',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return _allPatients.isEmpty
        ? EmptyStateWidget(onAddPatient: _onAddPatient)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'search_off',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 15.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'No patients found',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Try adjusting your search or filter criteria',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildPatientList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredPatients.length,
        itemBuilder: (context, index) {
          final patient = _filteredPatients[index];
          return PatientCardWidget(
            patient: patient,
            onTap: () => _onPatientTap(patient),
            onCall: () => _onPatientAction('call', patient),
            onMessage: () => _onPatientAction('message', patient),
            onViewVitals: () => _onPatientAction('vitals', patient),
            onScheduleAppointment: () => _onPatientAction('schedule', patient),
            onAddNote: () => _onPatientAction('note', patient),
            onEmergencyContact: () => _onPatientAction('emergency', patient),
            onTransferCare: () => _onPatientAction('transfer', patient),
            onArchive: () => _onPatientAction('archive', patient),
            onExportRecords: () => _onPatientAction('export', patient),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabScaleAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () {
              _fabAnimationController.forward().then((_) {
                _fabAnimationController.reverse();
                _onAddPatient();
              });
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            icon: CustomIconWidget(
              iconName: 'person_add',
              color: Colors.white,
              size: 6.w,
            ),
            label: Text(
              'Add Patient',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
