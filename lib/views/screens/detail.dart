import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/bottomnav.dart';
import '../components/customappbar.dart';
import '../../models/barang_model.dart';
import '../../services/barang_service.dart';
import '../../utils/image_helper.dart';

class DetailScreen extends StatefulWidget {
  final int barangId;
  
  const DetailScreen({super.key, required this.barangId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  
  bool _isEdit = false;
  bool _isPrioritas = false;
  bool _isSaving = false;
  bool _isLoading = true;
  File? _selectedImage;
  Barang? _currentBarang;

  @override
  void initState() {
    super.initState();
    _loadBarangData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _jumlahController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // Load data barang berdasarkan ID
  Future<void> _loadBarangData() async {
    try {
      setState(() => _isLoading = true);
      
      final barang = await BarangService().getBarangById(widget.barangId);
      
      if (barang != null && mounted) {
        setState(() {
          _currentBarang = barang;
          _namaController.text = barang.nama;
          _alamatController.text = barang.alamat;
          _jumlahController.text = barang.jumlah.toString();
          _deskripsiController.text = barang.deskripsi;
          _isPrioritas = barang.isPriority;
          
          // Set selected image jika ada
          if (barang.imagePath != null && barang.imagePath!.isNotEmpty) {
            _selectedImage = File(barang.imagePath!);
          }
          
          _isLoading = false;
        });
      } else {
        if (mounted) {
          _showSnackBar('Barang tidak ditemukan', isError: true);
          context.pop();
        }
      }
    } catch (e) {
      print('Error loading barang: $e');
      if (mounted) {
        _showSnackBar('Gagal memuat data barang: ${e.toString()}', isError: true);
        setState(() => _isLoading = false);
      }
    }
  }

  // Method untuk handle image selection dengan GoRouter
  Future<void> _handleImageSelection({required bool fromCamera}) async {
    if (!_isEdit) return;
    
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
    if (!_isEdit) return;
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Ambil dari Kamera',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onTap: () => _handleImageSelection(fromCamera: true),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.photo_library,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      'Pilih dari Galeri',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onTap: () => _handleImageSelection(fromCamera: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk update barang
  Future<void> _updateBarang() async {
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

      final updatedBarang = Barang(
        id: _currentBarang!.id,
        nama: _namaController.text.trim(),
        jumlah: int.parse(_jumlahController.text.trim()),
        alamat: _alamatController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        imagePath: _selectedImage!.path,
        tanggalDibuat: _currentBarang!.tanggalDibuat, // Keep original date
        isPriority: _isPrioritas,
      );

      print('Updating barang: ${updatedBarang.toMap()}');
      
      await BarangService().updateBarang(updatedBarang);
      
      if (mounted) {
        _showSuccessAndExitEdit();
      }
      
    } catch (e) {
      print('Error updating barang: $e');
      if (mounted) {
        _showSnackBar('Gagal memperbarui barang: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // Method untuk delete barang
  Future<void> _deleteBarang() async {
    // Konfirmasi delete
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Hapus Barang',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Yakin ingin menghapus "${_currentBarang?.nama}"?',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && _currentBarang != null) {
      try {
        await BarangService().deleteBarang(_currentBarang!.id!);
        
        if (mounted) {
          _showSnackBar('Barang berhasil dihapus', isError: false);
          
          // Navigasi kembali setelah delay
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted && context.canPop()) {
              context.pop();
            }
          });
        }
      } catch (e) {
        print('Error deleting barang: $e');
        if (mounted) {
          _showSnackBar('Gagal menghapus barang: ${e.toString()}', isError: true);
        }
      }
    }
  }

  // Method untuk show success dan keluar dari mode edit
  void _showSuccessAndExitEdit() {
    if (!mounted) return;
    
    _showSnackBar('Barang berhasil diperbarui', isError: false);
    
    setState(() => _isEdit = false);
    _loadBarangData(); // Reload data terbaru
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

  // Helper method untuk mendapatkan warna disabled field berdasarkan tema
  Color _getDisabledFieldColor() {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3);
    } else {
      return Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const CustomAppBar(title: 'Detail Barang'),
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        bottomNavigationBar: const BottomNav(currentIndex: 1),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: _isEdit ? 'Edit Barang' : 'Detail Barang'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Barang', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaController,
                  enabled: _isEdit,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama barang',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    filled: !_isEdit,
                    fillColor: !_isEdit ? _getDisabledFieldColor() : null,
                  ),
                  validator: _isEdit ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama barang wajib diisi';
                    }
                    return null;
                  } : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Jumlah Barang', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _jumlahController,
                  enabled: _isEdit,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Masukkan jumlah barang',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    filled: !_isEdit,
                    fillColor: !_isEdit ? _getDisabledFieldColor() : null,
                  ),
                  validator: _isEdit ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Jumlah barang wajib diisi';
                    }
                    final jumlah = int.tryParse(value.trim());
                    if (jumlah == null || jumlah <= 0) {
                      return 'Jumlah harus berupa angka positif';
                    }
                    return null;
                  } : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Foto Barang', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: _selectedImage != null
                              ? _selectedImage!.path.split('/').last
                              : 'Belum ada gambar',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                          ),
                          filled: !_isEdit,
                          fillColor: !_isEdit ? _getDisabledFieldColor() : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isEdit ? _showImagePickerDialog : null,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: _isEdit 
                            ? Theme.of(context).colorScheme.primary 
                            : _getDisabledFieldColor(),
                        foregroundColor: _isEdit 
                            ? Theme.of(context).colorScheme.onPrimary 
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
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
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Center(
                            child: Icon(
                              Icons.image, 
                              size: 50, 
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Prioritas', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _isPrioritas,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: _isEdit ? (value) {
                        setState(() => _isPrioritas = value as bool);
                      } : null,
                    ),
                    Text(
                      'Ya',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(width: 16),
                    Radio(
                      value: false,
                      groupValue: _isPrioritas,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: _isEdit ? (value) {
                        setState(() => _isPrioritas = value as bool);
                      } : null,
                    ),
                    Text(
                      'Tidak',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Letak Barang', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _alamatController,
                  enabled: _isEdit,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Masukkan lokasi barang',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    filled: !_isEdit,
                    fillColor: !_isEdit ? _getDisabledFieldColor() : null,
                  ),
                  validator: _isEdit ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Letak barang wajib diisi';
                    }
                    return null;
                  } : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Deskripsi', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deskripsiController,
                  enabled: _isEdit,
                  maxLines: 3,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Masukkan deskripsi barang (opsional)',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    filled: !_isEdit,
                    fillColor: !_isEdit ? _getDisabledFieldColor() : null,
                  ),
                ),
                if (_currentBarang != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Tambahan', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal Dibuat: ${_formatDate(_currentBarang!.tanggalDibuat)}', 
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildFloatingActionButtons() {
    if (_isEdit) {
      // Mode Edit - Tombol Selesai Edit
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: _isSaving ? null : _updateBarang,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: _isSaving
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : const Text('Selesai Edit', style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    } else {
      // Mode View - Tombol Delete dan Edit
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Tombol Delete
          FloatingActionButton.extended(
            onPressed: _deleteBarang,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            heroTag: "delete_btn",
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Text('Hapus', style: TextStyle(fontSize: 16)),
            ),
          ),
          // Tombol Edit
          FloatingActionButton.extended(
            onPressed: () => setState(() => _isEdit = true),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            heroTag: "edit_btn",
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Text('Edit', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    }
  }
}