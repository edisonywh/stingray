import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ViewType {
  compactTile,
  itemCard,
  itemTile,
}

final viewProvider = StateNotifierProvider<ViewManager, ViewType>((ref) {
  return ViewManager();
});

class ViewManager extends StateNotifier<ViewType> {
  ViewManager() : super(ViewType.itemCard);

  setView(ViewType type) async {
    state = type;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('view', viewName(type));
  }

  static ViewType fromViewName(String? viewName) {
    if (viewName == "itemCard") return ViewType.itemCard;
    if (viewName == "compactTile") return ViewType.compactTile;
    if (viewName == "itemTile") return ViewType.itemTile;
    return ViewType.itemCard; // Default
  }

  String viewName(ViewType type) {
    if (type == ViewType.itemCard) return "itemCard";
    if (type == ViewType.compactTile) return "compactTile";
    if (type == ViewType.itemTile) return "itemTile";
    return 'itemCard';
  }
}
