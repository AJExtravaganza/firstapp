enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  int year;
  Producer producer;
  Production production;

  String asString() =>
      "${this.year} ${this.producer.shorthandName} ${this.production}";

  Tea(this.year, this.producer, this.production);
}

class Producer {
  String name;
  String shorthandName;

  Producer(this.name, [this.shorthandName]) {
    if (this.shorthandName == null) {
      this.shorthandName = this.name;
    }
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
