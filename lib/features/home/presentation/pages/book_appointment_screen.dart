import 'dart:async';

import 'package:ecare360/core/constants/app_colors.dart';
import 'package:ecare360/core/constants/app_text_styles.dart';
import 'package:ecare360/core/providers/admission_provider.dart';
import 'package:ecare360/core/utils/comman_widgets.dart';
import 'package:ecare360/data/models/admission_model.dart';
import 'package:ecare360/data/models/bed_status_model.dart'; // Import BedStatusModel
import 'package:ecare360/data/services/bed_service.dart';
import 'package:ecare360/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecare360/features/home/presentation/providers/bed_status_provider.dart'; // Import BedStatusProvider
import 'package:ecare360/features/home/presentation/providers/doctor_provider.dart'; // Import DoctorProvider
import 'package:ecare360/features/home/presentation/providers/patient_provider.dart'; // Import PatientProvider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart'; // Import for date formatting

// A provider to fetch bed data and group it by floor
final bedManagementProvider =
    FutureProvider.family<Map<String, List<Map<String, dynamic>>>, String>(
        (ref, accessToken) async {
  if (accessToken.isEmpty) {
    throw Exception('Access token is missing.');
  }
  final response = await BedService().fetchBeds(accessToken);
  final List<dynamic> bedsData = response['beds'];

  // Group beds by floorName
  final Map<String, List<Map<String, dynamic>>> groupedBeds = {};
  for (var bed in bedsData) {
    final floorName = bed['floorName'] as String;
    if (!groupedBeds.containsKey(floorName)) {
      groupedBeds[floorName] = [];
    }
    groupedBeds[floorName]?.add(bed);
  }
  return groupedBeds;
});

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  String? _selectedFloor;
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _trackingIdController = TextEditingController();
  final TextEditingController _admittedForController = TextEditingController();
  final TextEditingController _attenderNameController = TextEditingController();
  final TextEditingController _attenderPhoneController =
      TextEditingController();
  final TextEditingController _attenderRelationshipController =
      TextEditingController();
  final TextEditingController _admissionDateController =
      TextEditingController();
  String? _selectedPatientId; // New: To store selected patient ID
  String? _selectedConsultingDoctorId; // New: To store selected doctor ID
  List<Map<String, String>> _attenders = [];

  // Function to refresh bed list
  void _refreshBedList() {
    ref.invalidate(bedManagementProvider); // Invalidate the provider to refetch
  }

  // Removed dummy _consultingDoctors list

  @override
  void dispose() {
    _patientNameController.dispose();
    _trackingIdController.dispose();
    _admittedForController.dispose();
    _attenderNameController.dispose();
    _attenderPhoneController.dispose();
    _attenderRelationshipController.dispose();
    _admissionDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final accessToken = authState.authModel?.accessToken;
    final bedStatuses = ref.watch(bedStatusProvider); // Watch bed statuses

    if (accessToken == null || accessToken.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(
            'Authentication token not found. Please log in again.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final bedDataAsyncValue = ref.watch(bedManagementProvider(accessToken));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: bedDataAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: ${error.toString().replaceFirst('Exception: ', '')}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (groupedBeds) {
          if (groupedBeds.isEmpty) {
            return const Center(
              child: Text('No beds available.'),
            );
          }

          final floors = groupedBeds.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: floors.length,
            itemBuilder: (context, index) {
              final floorName = floors[index];
              final beds = groupedBeds[floorName]!;
              final bool isExpanded = _selectedFloor == floorName;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Icon(
                        Icons.apartment_rounded,
                        color:
                            isExpanded ? Colors.indigo : Colors.grey.shade500,
                      ),
                      title: Text(
                        floorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isExpanded ? Colors.indigo : Colors.grey.shade800,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedFloor = isExpanded ? null : floorName;
                        });
                      },
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: _buildBedGrid(beds, bedStatuses),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget _buildBedGrid(
      List<Map<String, dynamic>> beds, List<BedStatusModel> bedStatuses) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: beds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 160,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final bed = beds[index];
        final statusNumber = bed['status'] as int;
        final bedColor = _getBedStatusColor(statusNumber, bedStatuses);
        final statusLabel = _getBedStatusLabel(statusNumber, bedStatuses);
        final icon = _getStatusIcon(statusNumber);

        return GestureDetector(
          onTap: () {
            // Use the dynamically fetched status number for conditional logic
            final availableStatus = bedStatuses.firstWhere(
                (s) => s.statusName == 'Available',
                orElse: () =>
                    BedStatusModel(id: '', statusNumber: 0, statusName: ''));
            if (statusNumber == availableStatus.statusNumber) {
              _showAddAdmissionBottomSheet(bed);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${bed['bedName']} is currently $statusLabel'),
                  backgroundColor: AppColors.warning,
                ),
              );
            }
          },
          child: Card(
            color: bedColor.withOpacity(0.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      icon,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      bed['bedName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      bed['roomName'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: bedColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: bedColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Utility method to get status color dynamically
  Color _getBedStatusColor(int statusNumber, List<BedStatusModel> bedStatuses) {
    final status = bedStatuses.firstWhere(
      (s) => s.statusNumber == statusNumber,
      orElse: () => BedStatusModel(id: '', statusNumber: 0, statusName: ''),
    );

    // Implement your color mapping logic here based on status.statusName or status.statusNumber
    // For now, using a simple example mapping as requested.
    switch (status.statusName) {
      case 'Available':
        return Colors.green;
      case 'Cleaning Required':
        return Colors.orange;
      case 'Admitted':
        return Colors.red;
      case 'Blocked':
        return Colors.purple;
      case 'Reserved':
        return Colors.blue;
      default:
        return Colors.grey; // Default color for unknown statuses
    }
  }

  // Utility method to get status label dynamically
  String _getBedStatusLabel(
      int statusNumber, List<BedStatusModel> bedStatuses) {
    final status = bedStatuses.firstWhere(
      (s) => s.statusNumber == statusNumber,
      orElse: () =>
          BedStatusModel(id: '', statusNumber: 0, statusName: 'Unknown'),
    );
    return status.statusName;
  }

  String _getStatusIcon(int statusNumber) {
    // This can also be made dynamic if icon names are part of BedStatusModel
    switch (statusNumber) {
      case 210: // Available
        return 'assets/bed_empty.svg';
      case 209: // Cleaning Required / Occupied from previous, now Admitted/Cleaning
        return 'assets/bed_patient.svg';
      case 204: // Admitted
        return 'assets/bed_patient.svg';
      case 202: // Blocked
        return 'assets/bed_lock.svg';
      default:
        return 'assets/cleaning.svg'; // Default icon
    }
  }

  Future<void> _showAddAdmissionBottomSheet(Map<String, dynamic> bed) async {
    // Reset form fields before showing the bottom sheet
    _patientNameController.clear();
    _trackingIdController.clear();
    _admittedForController.clear();
    _attenderNameController.clear();
    _attenderPhoneController.clear();
    _attenderRelationshipController.clear();
    _admissionDateController.clear();
    _selectedPatientId = null; // Reset patient ID
    _selectedConsultingDoctorId = null; // Reset doctor ID
    setState(() {
      // Update state to clear previous attenders
      _attenders = [];
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(builder: (context, ref, child) {
          // Watch patient and doctor providers
          final patients = ref.watch(patientProvider);
          final doctors = ref.watch(doctorProvider);

          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                          20, 20, 20, 100), // Add padding for buttons
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 60,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Add Admission',
                            style: AppTextStyles.headlineMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryLight),
                          ),
                          const SizedBox(height: 24),
                          // Auto-filled fields
                          _buildReadonlyField('Floor', bed['floorName'] ?? ''),
                          _buildReadonlyField('Room No', bed['roomName'] ?? ''),
                          _buildReadonlyField('Bed No', bed['bedName'] ?? ''),

                          const SizedBox(height: 24),

                          // User Input Fields
                          _buildDropdownField(
                            'Patient Name',
                            _selectedPatientId != null
                                ? patients
                                    .firstWhere(
                                        (p) => p.id == _selectedPatientId)
                                    .username
                                : null,
                            patients.map((p) => 'Mr. ${p.username}').toList(),
                            // items
                            (String? newValue) {
                              setState(() {
                                _selectedPatientId = patients
                                    .firstWhere(
                                        (p) => 'Mr. ${p.username}' == newValue)
                                    .id;
                              });
                            },
                            true,
                            displayValueMap: patients
                                .map((p) => {
                                      'display': 'Mr. ${p.username}',
                                      'value': p.id
                                    })
                                .toList(),
                          ),

                          _buildTextField(
                            _trackingIdController,
                            'Tracking ID',
                            true,
                            TextInputType.text,
                          ),
                          _buildTextField(
                            _admittedForController,
                            'Admitted For',
                            true,
                            TextInputType.text,
                          ),
                          // Admitted By (Consulting Doctor) (Dropdown)
                          _buildDropdownField(
                            'Admitted By (Consulting Doctor)',
                            _selectedConsultingDoctorId != null
                                ? doctors
                                    .firstWhere((d) =>
                                        d.id == _selectedConsultingDoctorId)
                                    .username
                                : null,
                            doctors.map((d) => 'Dr. ${d.username}').toList(),
                            (String? newValue) {
                              setState(() {
                                _selectedConsultingDoctorId = doctors
                                    .firstWhere(
                                        (d) => 'Dr. ${d.username}' == newValue)
                                    .id;
                              });
                            },
                            true,
                            displayValueMap: doctors
                                .map((d) => {
                                      'display': 'Dr. ${d.username}',
                                      'value': d.id
                                    })
                                .toList(),
                          ),

                          _buildDateField(
                            _admissionDateController,
                            'Date of Admission',
                            true,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Attender Information',
                            style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryLight),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            _attenderNameController,
                            'Name',
                            false,
                            TextInputType.name,
                          ),
                          _buildTextField(
                            _attenderPhoneController,
                            'Phone No',
                            false,
                            TextInputType.phone,
                          ),
                          _buildTextField(
                            _attenderRelationshipController,
                            'Relationship',
                            false,
                            TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.person_add),
                              label: const Text('Add Attender'),
                              onPressed: () {
                                _addAttender();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Display added attenders
                          if (_attenders.isNotEmpty)
                            ..._attenders.map((attender) => Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    title: Text(attender['name']!),
                                    subtitle: Text(
                                        '${attender['phone']} (${attender['relationship']})'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: AppColors.error),
                                      onPressed: () {
                                        setState(() {
                                          _attenders.remove(attender);
                                        });
                                      },
                                    ),
                                  ),
                                )),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitAdmission(bed);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Submit'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                      color: AppColors.primary),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }

  // Helper method for read-only fields
  Widget _buildReadonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for text input fields
  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    bool isRequired,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: '$hintText${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$hintText is required';
          }
          return null;
        },
      ),
    );
  }

  // Helper method for dropdown fields
  // Helper method for dropdown fields (SAFE VERSION)
  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
    bool isRequired, {
    List<Map<String, dynamic>>? displayValueMap,
  }) {
    // If using displayValueMap → rebuild items from it
    final dropdownItems = displayValueMap != null
        ? displayValueMap.map((map) => map['display'] as String).toList()
        : items;

    // Prevent Flutter crash: value must be in items
    final safeValue =
        dropdownItems.contains(selectedValue) ? selectedValue : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  // Helper method for date picker field
  Widget _buildDateField(
    TextEditingController controller,
    String labelText,
    bool isRequired,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: '$labelText${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }

  void _addAttender() {
    if (_attenderNameController.text.isNotEmpty &&
        _attenderPhoneController.text.isNotEmpty &&
        _attenderRelationshipController.text.isNotEmpty) {
      setState(() {
        _attenders.add({
          'name': _attenderNameController.text,
          'phone': _attenderPhoneController.text,
          'relationship': _attenderRelationshipController.text,
        });
        _attenderNameController.clear();
        _attenderPhoneController.clear();
        _attenderRelationshipController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all attender fields'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _submitAdmission(Map<String, dynamic> bed) async {
    // Validate required fields
    if (_selectedPatientId == null ||
        _admittedForController.text.isEmpty ||
        _selectedConsultingDoctorId == null ||
        _admissionDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final patients = ref.read(patientProvider);
    final doctors = ref.read(doctorProvider);

    final selectedPatient =
        patients.firstWhere((p) => p.id == _selectedPatientId);
    final patientName = selectedPatient.firstName.isNotEmpty
        ? selectedPatient.firstName
        : selectedPatient.username;

    final selectedDoctor =
        doctors.firstWhere((d) => d.id == _selectedConsultingDoctorId);
    final doctorName = selectedDoctor.firstName.isNotEmpty
        ? selectedDoctor.firstName
        : selectedDoctor.username;

    DateTime admissionDate =
        DateFormat('yyyy-MM-dd').parse(_admissionDateController.text);

    // 🔥 Build model instead of JSON map
    final model = AdmissionModel.fromForm(
      patientId: _selectedPatientId!,
      patientName: patientName,
      bedId: bed['_id'],
      admittedFor: _admittedForController.text,
      doctorId: _selectedConsultingDoctorId!,
      doctorName: doctorName,
      phoneNumber: selectedPatient.phone,
      dateOfAdmission: admissionDate,
      trackingId: _trackingIdController.text,
      attendees: _attenders,
      bedStatus: bed['status'],
    );

    // 🔥 Show Loader
    showLoadingDialog(context);

    // 🔥 Call the notifier (ONLY THIS!)
    await ref.read(admissionNotifierProvider.notifier).createAdmission(model);

    // 🔥 Hide Loader
    Navigator.pop(context);

    final state = ref.read(admissionNotifierProvider);

    // 🔥 Show response message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message ?? ""),
        backgroundColor: state.isSuccess ? AppColors.success : AppColors.error,
      ),
    );

    // 🔥 On success, close sheet + refresh beds
    if (state.isSuccess) {
      Navigator.pop(context);
      _refreshBedList();
    } else {
      Navigator.pop(context);
    }
  }
}
