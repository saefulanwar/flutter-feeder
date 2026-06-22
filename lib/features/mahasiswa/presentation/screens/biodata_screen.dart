import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class BiodataScreen extends StatelessWidget {
  const BiodataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          'Biodata Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthAuthenticated) {
            final biodata = state.biodata;
            final String name = biodata['nama_mahasiswa'] ?? 'Saeful Anwar';
            final String nim = biodata['nim'] ?? '22520241029';
            final String gender = biodata['jenis_kelamin'] ?? 'Laki-laki';
            final String email = biodata['email'] ?? 'saeful.anwar@student.uny.ac.id';
            final String birthPlace = biodata['tempat_lahir'] ?? 'Sleman';
            final String birthDate = biodata['tanggal_lahir'] ?? '2004-05-12';
            final String programStudi = biodata['nama_program_studi'] ?? 'Pendidikan Teknik Informatika';

            final String angkatan = biodata['angkatan'] ?? '2022';
            final String status = biodata['status_mahasiswa'] ?? 'Aktif';
            final String phone = biodata['handphone'] ?? '0812-3456-7890';
            final String address = biodata['alamat'] ?? 'Jl. Colombo No. 1, Karangmalang, Yogyakarta';
            final String motherName = biodata['nama_ibu_kandung'] ?? 'Siti Aminah';

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header Banner & Profile Card
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade800, Colors.blue.shade500],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.blue.shade100,
                                  child: CircleAvatar(
                                    radius: 41,
                                    backgroundColor: Colors.blue.shade800,
                                    child: const Text(
                                      'SA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'NIM. $nim',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green.shade200),
                                  ),
                                  child: Text(
                                    'Status: $status',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 180), // Spacer to push contents down due to floating card

                  // Detail Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Informasi Akademik'),
                        _buildCard([
                          _buildDetailRow(Icons.school, 'Program Studi', programStudi),
                          _buildDetailRow(Icons.calendar_today, 'Angkatan', angkatan),
                        ]),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Informasi Pribadi'),
                        _buildCard([
                          _buildDetailRow(Icons.wc, 'Jenis Kelamin', gender),
                          _buildDetailRow(Icons.location_on, 'Tempat Lahir', birthPlace),
                          _buildDetailRow(Icons.cake, 'Tanggal Lahir', birthDate),
                          _buildDetailRow(Icons.family_restroom, 'Ibu Kandung', motherName),
                        ]),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Kontak & Alamat'),
                        _buildCard([
                          _buildDetailRow(Icons.email, 'Email Student', email),
                          _buildDetailRow(Icons.phone, 'No. Handphone', phone),
                          _buildDetailRow(Icons.home, 'Alamat', address, isMultiLine: true),
                        ]),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Belum login atau data tidak tersedia'));
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          if (index == children.length - 1) {
            return children[index];
          }
          return Column(
            children: [
              children[index],
              Divider(height: 1, color: Colors.grey.shade100, indent: 50),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
