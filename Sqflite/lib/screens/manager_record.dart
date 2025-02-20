import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/data/DatabaseHelper.dart';
import 'package:quan_ly_benh_nhan_sqlite/models/MedicalRecord.dart';
import 'package:quan_ly_benh_nhan_sqlite/models/Patient.dart';

class ManagerRecord extends StatefulWidget {
  const ManagerRecord({Key? key}) : super(key: key);

  @override
  State<ManagerRecord> createState() => _ManagerRecordState();
}

class _ManagerRecordState extends State<ManagerRecord> {
  List<MedicalRecord> medicalRecords = [];
  List<Patient> patients = [];
  late TextEditingController diagnosisController;
  int? selectedPatientId;
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    diagnosisController = TextEditingController();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    patients = await dbHelper.getAllPatients();
    medicalRecords = await dbHelper.getAllMedicalRecords();

    if (patients.isNotEmpty) {
      selectedPatientId = patients.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Medical Records'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            value: selectedPatientId,
            items: patients.map((patient) {
              return DropdownMenuItem<int>(
                value: patient.id,
                child: Text(patient.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedPatientId = value);
            },
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: diagnosisController,
            decoration: const InputDecoration(
              labelText: 'Diagnosis',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveMedicalRecord,
            child: const Text('Save'),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: medicalRecords.isNotEmpty
                ? ListView.builder(
                    itemCount: medicalRecords.length,
                    itemBuilder: (context, index) {
                      return _buildRecordTile(medicalRecords[index]);
                    },
                  )
                : const Center(child: Text('No medical records available')),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordTile(MedicalRecord record) {
    return ListTile(
      title: Text('Diagnosis: ${record.diagnosis}'),
      subtitle: Text('Patient: ${record.patientId}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editMedicalRecord(record),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteMedicalRecord(record.id),
          ),
        ],
      ),
    );
  }

  void _saveMedicalRecord() async {
    if (selectedPatientId != null) {
      MedicalRecord newRecord = MedicalRecord(
        id: generateRandomId(),
        diagnosis: diagnosisController.text,
        patientId: selectedPatientId!,
      );
      await DatabaseHelper.instance.insertMedicalRecord(newRecord);
      setState(() {
        _loadDataFuture = _loadData();
      });
    }
  }

  void _editMedicalRecord(MedicalRecord record) {
    diagnosisController.text = record.diagnosis;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Medical Record'),
          content: TextField(controller: diagnosisController),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                MedicalRecord updatedRecord = record.copyWith(
                  diagnosis: diagnosisController.text,
                );
                await DatabaseHelper.instance
                    .updateMedicalRecord(updatedRecord);
                setState(() {
                  _loadDataFuture = _loadData();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMedicalRecord(int id) async {
    await DatabaseHelper.instance.deleteMedicalRecord(id);
    setState(() {
      _loadDataFuture = _loadData();
    });
  }

  int generateRandomId() {
    return Random().nextInt(1000000);
  }
}
