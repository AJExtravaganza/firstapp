enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  int year;
  Producer producer;
  Production production;

  String asString() =>
      "${this.year} ${this.producer.shorthandName} ${this.production.name}";

  Tea(this.year, this.producer, this.production);

  bool operator == (dynamic other) {
    return this.year == other.year && this.producer == other.producer && this.production.name == other.production.name;
  }
}

class Producer {
  String name;
  String shorthandName;

  Producer(this.name, [this.shorthandName]) {
    if (this.shorthandName == null) {
      this.shorthandName = this.name;
    }
  }

  bool operator == (dynamic other) {
    return this.name == other.name;
  }
}

class Production {
  String name;
  int size;
  TeaFormFactor form;

  Production(this.name, [this.size = 357, this.form = TeaFormFactor.cake]);
}

class Terroir {
  // Implement later
}

List<Tea> getSampleTeaList() {
  return [
    Tea(2007, Producer('Xizihao', 'XZH'), Production("Dingji Gushu")),
    Tea(2003, Producer('Menghai Dayi Tea Factory', 'Dayi'),
        Production("Purple Mark")),
    Tea(2003, Producer('Wisteria'), Production("Dingji Gushu")),
  ];
}

class BrewingVessel {
  int volumeMilliliters;
  ClayType material;
  VesselForm form;

  BrewingVessel(this.volumeMilliliters, this.material, this.form);

  String asString() =>
      '${this.volumeMilliliters}ml ${this.material} ${this.form.asString}';
}

enum VesselForm {
  gaiwan,
  shuiping,
  xishi
}

extension VesselFormExtension on VesselForm {
  String get asString {
    switch (this) {
      case VesselForm.gaiwan:
        return 'Gaiwan';
      case VesselForm.shuiping:
        return 'Shuiping';
      case VesselForm.xishi:
        return 'Xishi';
    }
  }
}

enum ClayType {
  yixing,
  thinlazeware,
  thickglazeware
}

extension ClayTypeExtension on ClayType {
  String get asString {
    switch (this) {
      case ClayType.thickglazeware:
        return 'Glazed';
      case ClayType.thinlazeware:
        return 'Glazed';
      case ClayType.yixing:
        return 'Yixing';
    }
  }
}

List<BrewingVessel> getSampleVesselList() {
  return [
    BrewingVessel(
      80,
      ClayType.thinlazeware,
      VesselForm.gaiwan
    ),
    BrewingVessel(
      90,
      ClayType.yixing,
      VesselForm.shuiping
    ),
    BrewingVessel(
      150,
      ClayType.yixing,
      VesselForm.shuiping
    )
  ];
}

class BrewProfile {
  Tea tea;
  int nominalRatio; // expressed as integer n for ratio n:1 water:leaf
  int brewTemperature; // expressed in degrees Celsius
  List<int> steepTimings;
  int steeps;

  BrewProfile(this.tea, this.nominalRatio, this.brewTemperature, this.steepTimings) {
    this.steeps = steepTimings.length;
  }

  double getDose(BrewingVessel vessel) {
    return vessel.volumeMilliliters / this.nominalRatio;
  }
}

List<BrewProfile> getSampleBrewProfileList() {
  List<BrewProfile> brewProfiles = [];
  List<int> sampleTimingList = [5,8,10,20,30,60];

  for (final tea in getSampleTeaList()) {
    brewProfiles.add(BrewProfile(tea, 15, 100, sampleTimingList));
  }

  return brewProfiles;
}