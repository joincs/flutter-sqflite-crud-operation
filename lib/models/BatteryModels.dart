class Battery {
  int id;
  String name;
  DateTime date;
  String chargeStatus;
  String batteryType;
  String numberOfCharge;
  String storageLocation;
  DateTime purchaseData;

  Battery({
    this.id,
    this.name,
    this.date,
    this.chargeStatus,
    this.batteryType,
    this.purchaseData,
    this.numberOfCharge,
    this.storageLocation,
  });
  Battery.withId({
    this.id,
    this.name,
    this.date,
    this.chargeStatus,
    this.batteryType,
    this.purchaseData,
    this.numberOfCharge,
    this.storageLocation,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['chargeStatus'] = chargeStatus;
    map['batteryType'] = batteryType;
    map['date'] = date.toIso8601String();
    map['storageLocation'] = storageLocation;
    map['numberOfCharge'] = numberOfCharge;
    map['purchaseData'] = purchaseData.toIso8601String();
    return map;
  }

  factory Battery.fromMap(Map<String, dynamic> map) {
    return Battery.withId(
      id: map['id'],
      name: map['name'],
      chargeStatus: map['chargeStatus'],
      batteryType: map['batteryType'],
      date: DateTime.parse(map['date']),
      storageLocation: map['storageLocation'],
      numberOfCharge: map['numberOfCharge'],
      purchaseData: DateTime.parse(map['purchaseData']),
    );
  }
}
