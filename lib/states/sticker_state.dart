import 'package:get/get.dart';

import '../data/_data.dart';

/// Состояние магазина стикеров на GetX.
/// Модель Sticker мутабельная (ветка state_structure_stateless),
/// поэтому после изменения полей стикера вызывается _sync(),
/// который обновляет реактивные списки и перестраивает Obx.
class StickerState extends GetxController {
  //Переменные
  final RxList<StickerCategory> categories = List<StickerCategory>.from(AppData.categories).obs;
  final RxList<Sticker> stickers = List<Sticker>.from(AppData.stickers).obs;
  final RxList<Sticker> stickersByCategory = List<Sticker>.from(AppData.stickers).obs;
  final RxList<Sticker> cart = <Sticker>[].obs;
  final RxList<Sticker> favorite = <Sticker>[].obs;
  final RxBool light = true.obs;

  final double taxes = 5.0;

  //Действия
  // Шаги 1, 2: подсветка категории и продукты по категории
  Future<void> onCategoryTap(StickerCategory category) async {
    for (final e in categories) {
      e.isSelected = e.type == category.type;
    }
    if (category.type == StickerType.all) {
      stickersByCategory.assignAll(stickers);
    } else {
      stickersByCategory.assignAll(stickers.where((e) => e.type == category.type));
    }
    categories.refresh();
  }

  // Шаги 4, 9: количество
  Future<void> onIncreaseQuantityTap(Sticker sticker) async {
    sticker.quantity++;
    _sync();
  }

  Future<void> onDecreaseQuantityTap(Sticker sticker) async {
    if (sticker.quantity == 1) return;
    sticker.quantity--;
    _sync();
  }

  // Шаг 6: добавление в корзину
  Future<void> onAddToCartTap(Sticker sticker) async {
    sticker.cart = true;
    _sync();
  }

  // Шаг 10: удаление из корзины
  Future<void> onRemoveFromCartTap(Sticker sticker) async {
    sticker.cart = false;
    sticker.quantity = 1;
    _sync();
  }

  // Шаг 11: чистка корзины на checkout
  Future<void> onCheckOutTap() async {
    for (final e in cart) {
      e.cart = false;
      e.quantity = 1;
    }
    _sync();
  }

  // Шаг 13: добавление/удаление из избранного
  Future<void> onAddRemoveFavoriteTap(Sticker sticker) async {
    sticker.favorite = !sticker.favorite;
    _sync();
  }

  // Шаг 14: смена темы
  void toggleTheme() {
    light.value = !light.value;
  }

  //Вспомогательные методы
  void _sync() {
    cart.assignAll(stickers.where((e) => e.cart));
    favorite.assignAll(stickers.where((e) => e.favorite));
    stickers.refresh();
    stickersByCategory.refresh();
  }

  Sticker stickerById(int id) => stickers.firstWhere((e) => e.id == id);

  // Шаг 8: стоимость
  String stickerPrice(Sticker sticker) {
    return (sticker.quantity * sticker.price).toString();
  }

  double get subtotal {
    double amount = 0.0;
    for (final e in cart) {
      amount = amount + e.price * e.quantity;
    }
    return amount;
  }

  double get total => subtotal + taxes;
}
