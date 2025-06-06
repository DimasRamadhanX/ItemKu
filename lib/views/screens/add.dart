// Di bagian import, pastikan menambahkan go_router
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ Tambahkan ini

import '../components/bottomnav.dart';
import '../components/customappbar.dart';
import '../../models/barang_model.dart';
import '../../services/barang_service.dart';
import '../../utils/image_helper.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  bool _isPrioritas = true;
  bool _isSaving = false;
  File? _selectedImage;

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // ✅ Method untuk handle image selection dengan GoRouter
  Future<void> _handleImageSelection({required bool fromCamera}) async {
    // Tutup bottom sheet dulu dengan GoRouter
    if (context.canPop()) {
      context.pop();
    }
    
    // Tunggu sebentar untuk memastikan dialog tertutup
    await Future.delayed(const Duration(milliseconds: 150));
    
    try {
      final file = await ImageHelper.pickImage(fromCamera: fromCamera);
      if (file != null && mounted) {
        setState(() => _selectedImage = file);
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        _showSnackBar('Gagal memilih gambar: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _showImagePickerDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () => _handleImageSelection(fromCamera: true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () => _handleImageSelection(fromCamera: false),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Method untuk save barang dengan GoRouter navigation
  Future<void> _saveBarang() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      _showSnackBar('Gambar barang wajib dipilih', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Validasi file gambar
      if (!await _selectedImage!.exists()) {
        throw Exception('File gambar tidak ditemukan');
      }

      final barang = Barang(
        nama: _namaController.text.trim(),
        jumlah: 1,
        alamat: _alamatController.text.trim(),
        deskripsi: '',
        imagePath: _selectedImage!.path,
        tanggalDibuat: DateTime.now(),
        isPriority: _isPrioritas,
      );

      print('Saving barang: ${barang.toMap()}');
      
      await BarangService().addBarang(barang);
      
      if (mounted) {
        _showSuccessAndNavigateBack();
      }
      
    } catch (e) {
      print('Error saving barang: $e');
      if (mounted) {
        _showSnackBar('Gagal menambahkan barang: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ✅ Method untuk show success dan navigasi kembali dengan GoRouter
  void _showSuccessAndNavigateBack() {
    if (!mounted) return;
    
    _showSnackBar('Barang berhasil ditambahkan', isError: false);
    
    // Navigasi kembali dengan GoRouter setelah delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && context.canPop()) {
        // Bisa kembali ke dashboard atau list-barang tergantung dari mana datangnya
        context.goNamed('dashboard'); // atau context.pop() jika ingin kembali ke halaman sebelumnya
      }
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(milliseconds: isError ? 3000 : 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Tambah Barang'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama barang',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama barang wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Foto Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _selectedImage != null
                              ? _selectedImage!.path.split('/').last
                              : 'Belum ada gambar',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _showImagePickerDialog,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : Center(
                            child: Icon(Icons.image, size: 50, color: Theme.of(context).hintColor),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Prioritas', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _isPrioritas,
                      onChanged: (value) {
                        setState(() => _isPrioritas = value as bool);
                      },
                    ),
                    const Text('Ya'),
                    const SizedBox(width: 16),
                    Radio(
                      value: false,
                      groupValue: _isPrioritas,
                      onChanged: (value) {
                        setState(() => _isPrioritas = value as bool);
                      },
                    ),
                    const Text('Tidak'),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Letak Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan lokasi barang',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Letak barang wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: _isSaving ? null : _saveBarang, // ✅ Gunakan method terpisah
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Tambahkan', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}