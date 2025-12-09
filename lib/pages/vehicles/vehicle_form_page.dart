import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/vehicle_controller.dart';
import '../../models/vehicle.dart';
import '../../services/supabase_service.dart';
import '../../widgets/app_button.dart';

class VehicleFormPage extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormPage({super.key, this.vehicle});

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _brandCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _yearCtrl = TextEditingController(text: '2025');
  final _colorCtrl = TextEditingController();
  final _seatsCtrl = TextEditingController(text: '5');

  final _plateCtrl = TextEditingController();
  final _vinCtrl = TextEditingController();

  final _categoryCtrl = TextEditingController();
  final _transmissionCtrl = TextEditingController();
  final _fuelCtrl = TextEditingController();

  final _priceCtrl = TextEditingController(text: '150');
  final _mileageCtrl = TextEditingController(text: '0');

  final _notesCtrl = TextEditingController();

  // 👉 Liste des URLs des photos
  List<String> _photos = [];

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      final v = widget.vehicle!;
      _brandCtrl.text = v.brand;
      _modelCtrl.text = v.model;
      _yearCtrl.text = v.year.toString();
      _colorCtrl.text = v.color;
      _seatsCtrl.text = v.seats.toString();
      _plateCtrl.text = v.plateNumber;
      _vinCtrl.text = v.vin ?? '';
      _categoryCtrl.text = v.category ?? '';
      _transmissionCtrl.text = v.transmission ?? '';
      _fuelCtrl.text = v.fuelType ?? '';
      _priceCtrl.text = v.pricePerDay.toString();
      _mileageCtrl.text = v.currentMileage.toString();
      _notesCtrl.text = v.notes ?? '';
      _photos = List<String>.from(v.photos); // 🔥 récupérer les photos existantes
    }
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _colorCtrl.dispose();
    _seatsCtrl.dispose();
    _plateCtrl.dispose();
    _vinCtrl.dispose();
    _categoryCtrl.dispose();
    _transmissionCtrl.dispose();
    _fuelCtrl.dispose();
    _priceCtrl.dispose();
    _mileageCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // 👉 Choisir et uploader une photo dans Supabase Storage
  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();

      final XFile? picked =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (picked == null) return; // utilisateur a annulé

      final bytes = await picked.readAsBytes();

      final fileName =
          'vehicle_${DateTime.now().millisecondsSinceEpoch}_${picked.name}';

      final storage = SupabaseService.client.storage.from('vehicle-photos');
      final path = 'vehicles/$fileName';

      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          cacheControl: '3600',
          upsert: false,
          contentType: 'image/jpeg',
        ),
      );

      final publicUrl = storage.getPublicUrl(path);

      setState(() {
        _photos.add(publicUrl);
      });
    } catch (e) {
      debugPrint('Erreur upload photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'upload de la photo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<VehicleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.vehicle == null ? 'Ajouter une voiture' : 'Modifier le véhicule'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Informations générales',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(_brandCtrl, 'Marque *'),
            _buildTextField(_modelCtrl, 'Modèle *'),
            _buildTextField(_yearCtrl, 'Année *',
                keyboardType: TextInputType.number),
            _buildTextField(_colorCtrl, 'Couleur'),
            _buildTextField(_seatsCtrl, 'Nombre de places *',
                keyboardType: TextInputType.number),

            const SizedBox(height: 16),
            const Text('Identification',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(_plateCtrl, 'Plaque d\'immatriculation *'),
            _buildTextField(_vinCtrl, 'Numéro VIN (optionnel)'),

            const SizedBox(height: 16),
            const Text('Caractéristiques',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(_categoryCtrl, 'Catégorie'),
            _buildTextField(_transmissionCtrl, 'Transmission'),
            _buildTextField(_fuelCtrl, 'Type de carburant'),

            const SizedBox(height: 16),
            const Text('Tarification',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField(_priceCtrl, 'Prix par jour (TND) *',
                keyboardType: TextInputType.number),
            _buildTextField(_mileageCtrl, 'Kilométrage actuel (km) *',
                keyboardType: TextInputType.number),

            const SizedBox(height: 16),
            const Text('Notes',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Informations supplémentaires sur le véhicule...',
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Photos du véhicule',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickAndUploadPhoto,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Ajouter une photo'),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Appui long sur une photo pour la supprimer.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (_photos.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final url = _photos[index];
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _photos.removeAt(index);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Text(
                'Aucune photo pour le moment.',
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Annuler',
                    primary: false,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Enregistrer',
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final payload = {
                        'brand': _brandCtrl.text.trim(),
                        'model': _modelCtrl.text.trim(),
                        'year': int.tryParse(_yearCtrl.text) ?? 2025,
                        'color': _colorCtrl.text.trim(),
                        'seats': int.tryParse(_seatsCtrl.text) ?? 5,
                        'plate_number': _plateCtrl.text.trim(),
                        'vin': _vinCtrl.text.trim().isEmpty
                            ? null
                            : _vinCtrl.text.trim(),
                        'category': _categoryCtrl.text.trim(),
                        'transmission': _transmissionCtrl.text.trim(),
                        'fuel_type': _fuelCtrl.text.trim(),
                        'price_per_day':
                        double.tryParse(_priceCtrl.text) ?? 0,
                        'current_mileage':
                        int.tryParse(_mileageCtrl.text) ?? 0,
                        'notes': _notesCtrl.text.trim().isEmpty
                            ? null
                            : _notesCtrl.text.trim(),
                        // 🔥 on enregistre toutes les URLs des photos
                        'photos': _photos,
                      };
                      await ctrl.saveVehicle(
                          existing: widget.vehicle, payload: payload);
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    final requiredField = label.contains('*');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.replaceAll('*', '')),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: requiredField
              ? (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Champ obligatoire';
            }
            return null;
          }
              : null,
          decoration: const InputDecoration(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
