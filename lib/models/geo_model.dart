enum PositionItemType {
  log,
  position,
}

class PositionItem {
  PositionItem(this.type, this.displayValue, this.latitude, this.longitude);

  final PositionItemType type;
  final String displayValue;
  final double? latitude;
  final double? longitude;
}
