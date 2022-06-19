class Player {
  String id;
  String name;
  int buyIn;
  int buyOut;
  int total;
  String logo;

  Player(this.id, this.name, this.buyIn, this.buyOut, this.total, this.logo);

  @override
  String toString() {
    return '{ ${this.name}, ${this.total} }';
  }
}
