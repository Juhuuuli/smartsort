class HistoryItem {
  final String imagePath;
  final String category;

  HistoryItem({required this.imagePath, required this.category});
}

class HistoryStore {
  static final List<HistoryItem> items = [];
}
