class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String color;
  final int seats;

  final String plateNumber;
  final String? vin;

  final String? category;
  final String? transmission;
  final String? fuelType;

  final double pricePerDay;
  final int currentMileage;

  final String? insuranceCompany;
  final String? insuranceNumber;
  final DateTime? insuranceExpiryDate;

  final DateTime? lastTechVisitDate;
  final DateTime? nextTechVisitDate;

  final int? nextOilChangeKm;

  final DateTime? lastMaintenanceDate;
  final DateTime? nextMaintenanceDate;
  final int? nextMaintenanceKm;

  final String? notes;
  final List<String> photos;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.seats,
    required this.plateNumber,
    this.vin,
    this.category,
    this.transmission,
    this.fuelType,
    required this.pricePerDay,
    required this.currentMileage,
    this.insuranceCompany,
    this.insuranceNumber,
    this.insuranceExpiryDate,
    this.lastTechVisitDate,
    this.nextTechVisitDate,
    this.nextOilChangeKm,
    this.lastMaintenanceDate,
    this.nextMaintenanceDate,
    this.nextMaintenanceKm,
    this.notes,
    required this.photos,
  });

  String get displayName => '$brand $model';

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      year: map['year'] as int,
      color: map['color'] as String? ?? '',
      seats: map['seats'] as int? ?? 5,
      plateNumber: map['plate_number'] as String,
      vin: map['vin'] as String?,
      category: map['category'] as String?,
      transmission: map['transmission'] as String?,
      fuelType: map['fuel_type'] as String?,
      pricePerDay: (map['price_per_day'] as num).toDouble(),
      currentMileage: map['current_mileage'] as int,
      insuranceCompany: map['insurance_company'] as String?,
      insuranceNumber: map['insurance_number'] as String?,
      insuranceExpiryDate: map['insurance_expiry_date'] != null
          ? DateTime.parse(map['insurance_expiry_date'] as String)
          : null,
      lastTechVisitDate: map['last_tech_visit_date'] != null
          ? DateTime.parse(map['last_tech_visit_date'] as String)
          : null,
      nextTechVisitDate: map['next_tech_visit_date'] != null
          ? DateTime.parse(map['next_tech_visit_date'] as String)
          : null,
      nextOilChangeKm: map['next_oil_change_km'] as int?,
      lastMaintenanceDate: map['last_maintenance_date'] != null
          ? DateTime.parse(map['last_maintenance_date'] as String)
          : null,
      nextMaintenanceDate: map['next_maintenance_date'] != null
          ? DateTime.parse(map['next_maintenance_date'] as String)
          : null,
      nextMaintenanceKm: map['next_maintenance_km'] as int?,
      notes: map['notes'] as String?,
      photos: (map['photos'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'year': year,
      'color': color,
      'seats': seats,
      'plate_number': plateNumber,
      'vin': vin,
      'category': category,
      'transmission': transmission,
      'fuel_type': fuelType,
      'price_per_day': pricePerDay,
      'current_mileage': currentMileage,
      'insurance_company': insuranceCompany,
      'insurance_number': insuranceNumber,
      'insurance_expiry_date': insuranceExpiryDate?.toIso8601String(),
      'last_tech_visit_date': lastTechVisitDate?.toIso8601String(),
      'next_tech_visit_date': nextTechVisitDate?.toIso8601String(),
      'next_oil_change_km': nextOilChangeKm,
      'last_maintenance_date': lastMaintenanceDate?.toIso8601String(),
      'next_maintenance_date': nextMaintenanceDate?.toIso8601String(),
      'next_maintenance_km': nextMaintenanceKm,
      'notes': notes,
      'photos': photos,
    };
  }
}
