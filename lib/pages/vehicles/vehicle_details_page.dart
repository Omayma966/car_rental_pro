import 'package:flutter/material.dart';

import '../../models/vehicle.dart';

class VehicleDetailsPage extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailsPage({super.key, required this.vehicle});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;

    return Scaffold(
      appBar: AppBar(
        title: Text(v.displayName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🖼️ Bandeau photos
          _buildPhotosSection(v),

          const SizedBox(height: 16),

          // 🔧 Infos principales
          _sectionTitle('Infos principales'),
          _infoRow('Marque', v.brand),
          _infoRow('Modèle', v.model),
          _infoRow('Année', v.year.toString()),
          _infoRow('Couleur', v.color),
          _infoRow('Places', v.seats.toString()),
          _infoRow('Plaque', v.plateNumber),

          const SizedBox(height: 16),
          _sectionTitle('Caractéristiques'),
          _infoRow('Catégorie', v.category ?? '-'),
          _infoRow('Transmission', v.transmission ?? '-'),
          _infoRow('Carburant', v.fuelType ?? '-'),

          const SizedBox(height: 16),
          _sectionTitle('Tarification & Kilométrage'),
          _infoRow(
              'Prix par jour', '${v.pricePerDay.toStringAsFixed(2)} TND'),
          _infoRow('Kilométrage', '${v.currentMileage} km'),

          const SizedBox(height: 16),
          _sectionTitle('Assurance'),
          _infoRow('Compagnie', v.insuranceCompany ?? '-'),
          _infoRow('N° police', v.insuranceNumber ?? '-'),
          _infoRow(
            'Expiration',
            v.insuranceExpiryDate != null
                ? _formatDate(v.insuranceExpiryDate!)
                : '-',
          ),

          const SizedBox(height: 16),
          _sectionTitle('Contrôle technique'),
          _infoRow(
            'Dernier contrôle',
            v.lastTechVisitDate != null
                ? _formatDate(v.lastTechVisitDate!)
                : '-',
          ),
          _infoRow(
            'Prochain contrôle',
            v.nextTechVisitDate != null
                ? _formatDate(v.nextTechVisitDate!)
                : '-',
          ),

          const SizedBox(height: 16),
          _sectionTitle('Maintenance & vidange'),
          _infoRow(
            'Dernière maintenance',
            v.lastMaintenanceDate != null
                ? _formatDate(v.lastMaintenanceDate!)
                : '-',
          ),
          _infoRow(
            'Prochaine maintenance',
            v.nextMaintenanceDate != null
                ? _formatDate(v.nextMaintenanceDate!)
                : '-',
          ),
          _infoRow(
            'Prochaine maintenance (km)',
            v.nextMaintenanceKm != null
                ? '${v.nextMaintenanceKm} km'
                : '-',
          ),
          _infoRow(
            'Prochaine vidange (km)',
            v.nextOilChangeKm != null
                ? '${v.nextOilChangeKm} km'
                : '-',
          ),

          const SizedBox(height: 16),
          _sectionTitle('Notes'),
          Text(
            v.notes?.trim().isNotEmpty == true ? v.notes! : 'Aucune note.',
            style: const TextStyle(color: Colors.black12),
          ),
        ],
      ),
    );
  }

  // 🔹 Titre de section
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // 🔹 Ligne info label : valeur
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Format simple AAAA-MM-JJ
  String _formatDate(DateTime date) {
    return date.toLocal().toString().substring(0, 10);
  }

  // 🖼️ Section photos : slider + miniatures
  Widget _buildPhotosSection(Vehicle v) {
    if (v.photos.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[900],
        ),
        child: const Center(
          child: Text(
            'Aucune photo pour ce véhicule.',
            style: TextStyle(color: Colors.black12),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Photo principale (grande)
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            itemCount: v.photos.length,
            controller: PageController(initialPage: _currentPhotoIndex),
            onPageChanged: (index) {
              setState(() {
                _currentPhotoIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final url = v.photos[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 40),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Petits indicateurs (ronds) pour le slider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            v.photos.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPhotoIndex == index ? 10 : 8,
              height: _currentPhotoIndex == index ? 10 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPhotoIndex == index
                    ? Colors.black38
                    : Colors.black26,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Miniatures cliquables
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: v.photos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final url = v.photos[index];
              final isSelected = index == _currentPhotoIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPhotoIndex = index;
                  });
                },
                child: Opacity(
                  opacity: isSelected ? 1.0 : 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      width: 80,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: Colors.grey[800],
                          child:
                          const Icon(Icons.broken_image, size: 24),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
