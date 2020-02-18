enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  int year;
  Producer producer;
  Production production;

  String asString() =>
      "${this.year} ${this.producer.shorthandName} ${this.production.name}";

  Tea(this.year, this.producer, this.production);

  bool operator ==(dynamic other) {
    return this.year == other.year &&
        this.producer == other.producer &&
        this.production.name == other.production.name;
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

  bool operator ==(dynamic other) {
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
    Tea(2005, Producer('Menghai Dayi Tea Factory', 'Dayi'),
        Production("502-7542")),
    Tea(2005, Producer('Menghai Dayi Tea Factory', 'Dayi'),
        Production("504-8542")),
    Tea(2009, Producer('Menghai Dayi Tea Factory', 'Dayi'),
        Production("901-7542")),
    Tea(2007, Producer('Wisteria'), Production("Honyin (Red Mark)")),
    Tea(2007, Producer('Wisteria'), Production("Lanyin (Blue Mark)")),
    Tea(2003, Producer('Wisteria'), Production("Ziyin Youle (Purple Mark)")),
    Tea(2003, Producer('Wisteria'), Production("Ziyin Nannuo (Blue Mark)")),
    Tea(2001, Producer('Xiaguan'), Production("8653 Tiebing")),
    Tea(2013, Producer('Xiaguan'), Production("Love Forever (Paper Tong)")),
    Tea(2004, Producer('Xiaguan'), Production("Jinsi")),
  ];
}
