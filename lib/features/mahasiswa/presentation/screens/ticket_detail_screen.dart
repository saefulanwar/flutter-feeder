import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/ticket_model.dart';
import '../bloc/ticket_bloc.dart';
import '../bloc/ticket_event.dart';
import '../bloc/ticket_state.dart';

class TicketDetailScreen extends StatefulWidget {
  final int ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _pesanController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  XFile? _replyLampiran;
  final ImagePicker _picker = ImagePicker();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    context.read<TicketBloc>().add(FetchTicketDetailRequested(widget.ticketId));
  }

  @override
  void dispose() {
    _pesanController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickAttachment() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Lampiran Balasan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPickerOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Kamera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildPickerOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Galeri',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue.shade800, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _replyLampiran = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil file: $e')),
      );
    }
  }

  Future<void> _sendReply() async {
    final text = _pesanController.text.trim();
    if (text.isEmpty && _replyLampiran == null) return;

    List<int>? fileBytes;
    String? fileName;
    if (_replyLampiran != null) {
      fileBytes = await _replyLampiran!.readAsBytes();
      fileName = _replyLampiran!.name;
    }

    if (!mounted) return;
    context.read<TicketBloc>().add(
      SendTicketReplyRequested(
        ticketId: widget.ticketId,
        pesan: text,
        fileBytes: fileBytes,
        fileName: fileName,
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green.shade50;
      case 'in_progress':
      case 'process':
        return Colors.amber.shade50;
      case 'closed':
        return Colors.grey.shade100;
      default:
        return Colors.blue.shade50;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green.shade700;
      case 'in_progress':
      case 'process':
        return Colors.amber.shade900;
      case 'closed':
        return Colors.grey.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  String _formatTime(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final minuteStr = dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
      final hourStr = dateTime.hour < 10 ? '0${dateTime.hour}' : '${dateTime.hour}';
      return '$hourStr:$minuteStr';
    } catch (_) {
      return '';
    }
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: const Text('Gagal memuat gambar bukti'),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Warna background chat netral
      appBar: AppBar(
        title: const Text(
          'Detail Aduan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketReplySendSuccess) {
            setState(() {
              _pesanController.clear();
              _replyLampiran = null;
              _isSending = false;
            });
            // Re-fetch detail to reload conversation
            context.read<TicketBloc>().add(FetchTicketDetailRequested(widget.ticketId));
          } else if (state is TicketReplySendInProgress) {
            setState(() {
              _isSending = true;
            });
          } else if (state is TicketReplySendFailure) {
            setState(() {
              _isSending = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal mengirim balasan: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TicketDetailLoadSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        child: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            // Jika statusnya load error pada detail aduan
            if (state is TicketDetailLoadFailure) {
              return _buildErrorState(state.errorMessage);
            }

            // Jika state load progress, dan kita tidak punya model di UI
            if (state is TicketDetailLoadInProgress && !_isSending) {
              return const Center(child: CircularProgressIndicator());
            }

            TicketModel? ticket;
            if (state is TicketDetailLoadSuccess) {
              ticket = state.ticket;
            } else if (state is TicketReplySendInProgress || state is TicketReplySendSuccess || state is TicketReplySendFailure) {
              // Pertahankan data sebelumnya jika sedang reply
              // (Biasanya State management menyimpan data lama atau kita bisa handle fallback)
              // Tapi demi simplicity, kita bisa handle state bloc di UI dengan menyimpan data lokal.
            }

            // Jika belum ada data sama sekali
            if (ticket == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final isClosed = ticket.status.toLowerCase() == 'closed';

            return Column(
              children: [
                // Collapsible/Static Header info aduan
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ticket.kategori.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusBgColor(ticket.status),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ticket.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getStatusTextColor(ticket.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ticket.judul,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ticket.deskripsi,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      if (ticket.lampiran != null) ...[
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () => _showFullScreenImage(ticket!.lampiran!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_outlined, size: 16, color: Colors.blue.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'Lihat Lampiran Utama',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.grey.shade200),

                // Chat Messages Thread
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: ticket.replies.length,
                    itemBuilder: (context, index) {
                      final reply = ticket!.replies[index];
                      final isMe = reply.senderType.toLowerCase() == 'mahasiswa';

                      return _buildChatBubble(reply, isMe);
                    },
                  ),
                ),

                // Reply Attachment Preview
                if (_replyLampiran != null)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(_replyLampiran!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _replyLampiran!.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _replyLampiran = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                // Chat Input Field Footer
                if (!isClosed)
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 10,
                      bottom: MediaQuery.of(context).padding.bottom + 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_photo_alternate_rounded, color: Colors.blue.shade800),
                          onPressed: _isSending ? null : _pickAttachment,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _pesanController,
                              enabled: !_isSending,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'Tulis balasan...',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              style: const TextStyle(fontSize: 13.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.blue.shade800,
                                radius: 20,
                                child: IconButton(
                                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                  onPressed: _sendReply,
                                ),
                              ),
                      ],
                    ),
                  )
                else
                  Container(
                    color: Colors.grey.shade100,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline_rounded, color: Colors.grey.shade500, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Aduan ini telah ditutup',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatBubble(TicketReplyModel reply, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Nama admin pengirim (jika bukan mahasiswa)
          if (!isMe) ...[
            Padding(
              padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
              child: Text(
                reply.user?.name ?? 'Admin Akademik',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],

          // Bubble Box
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue.shade800 : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: isMe ? null : Border.all(color: Colors.grey.shade200, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reply.lampiran != null) ...[
                  GestureDetector(
                    onTap: () => _showFullScreenImage(reply.lampiran!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(reply.lampiran!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
                if (reply.pesan.isNotEmpty)
                  Text(
                    reply.pesan,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),

          // Jam Kirim
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 4, right: 4),
            child: Text(
              _formatTime(reply.createdAt),
              style: TextStyle(
                fontSize: 9.5,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Percakapan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<TicketBloc>().add(FetchTicketDetailRequested(widget.ticketId));
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
