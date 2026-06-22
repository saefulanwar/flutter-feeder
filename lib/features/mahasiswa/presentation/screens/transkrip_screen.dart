import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/mahasiswa_bloc.dart';
import '../bloc/mahasiswa_event.dart';
import '../bloc/mahasiswa_state.dart';
import '../../data/models/mahasiswa_models.dart';

class TranskripScreen extends StatefulWidget {
  const TranskripScreen({super.key});

  @override
  State<TranskripScreen> createState() => _TranskripScreenState();
}

class _TranskripScreenState extends State<TranskripScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<TranskripItem> _allTranscriptItems = [];
  List<TranskripItem> _filteredTranscriptItems = [];

  @override
  void initState() {
    super.initState();
    context.read<MahasiswaBloc>().add(FetchTranskripRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
      case 'A-':
        return Colors.green;
      case 'B+':
      case 'B':
      case 'B-':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.amber.shade700;
      case 'E':
      default:
        return Colors.red;
    }
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTranscriptItems = _allTranscriptItems;
      } else {
        _filteredTranscriptItems = _allTranscriptItems.where((item) {
          final nameLower = item.namaMatakuliah.toLowerCase();
          final codeLower = item.kodeMatakuliah.toLowerCase();
          final searchLower = query.toLowerCase();
          return nameLower.contains(searchLower) || codeLower.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          'Transkrip Nilai',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<MahasiswaBloc, MahasiswaState>(
        listener: (context, state) {
          if (state is TranskripLoaded) {
            setState(() {
              _allTranscriptItems = state.transkrip.listTranskrip;
              _filteredTranscriptItems = _allTranscriptItems;
            });
          }
        },
        builder: (context, state) {
          if (state is TranskripLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TranskripFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MahasiswaBloc>().add(FetchTranskripRequested());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TranskripLoaded) {
            final transkrip = state.transkrip;

            return Column(
              children: [
                // Top Summary Card
                Container(
                  width: double.infinity,
                  color: Colors.blue.shade700,
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          label: 'IPK KUMULATIF',
                          value: transkrip.ipk.toStringAsFixed(2),
                          icon: Icons.auto_awesome_outlined,
                        ),
                      ),
                      Container(
                        width: 1.5,
                        height: 50,
                        color: Colors.white.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          label: 'TOTAL SKS LULUS',
                          value: transkrip.totalSks.toString(),
                          icon: Icons.bookmark_added_outlined,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      hintText: 'Cari mata kuliah atau kode...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterItems('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),

                // Courses Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searchQuery.isEmpty
                            ? 'Seluruh Mata Kuliah (${_allTranscriptItems.length})'
                            : 'Hasil Pencarian (${_filteredTranscriptItems.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Transcripts List
                Expanded(
                  child: _filteredTranscriptItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'Mata kuliah tidak ditemukan',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredTranscriptItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredTranscriptItems[index];

                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200, width: 1),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // SKS badge
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                           Text(
                                             item.sks.toString(),
                                             style: TextStyle(
                                               fontSize: 14,
                                               fontWeight: FontWeight.w800,
                                               color: Colors.blue.shade800,
                                             ),
                                           ),
                                          const Text(
                                            'SKS',
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Course Title and Code
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.kodeMatakuliah,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.namaMatakuliah,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Grade badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getGradeColor(item.nilaiHuruf).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _getGradeColor(item.nilaiHuruf).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        item.nilaiHuruf,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _getGradeColor(item.nilaiHuruf),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text('Menunggu memuat data...'));
        },
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 30),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
