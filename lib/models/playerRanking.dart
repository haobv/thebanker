class PlayerRanking {
  int rank;
  String name;
  int total;
  String logo;

  PlayerRanking(this.rank, this.name, this.total, this.logo);

  @override
  String toString() {
    return '{ ${this.name}, ${this.total} }';
  }
}
