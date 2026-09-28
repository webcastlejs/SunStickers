import 'package:mobx/mobx.dart';

import '../data/_data.dart';

/// Состояние магазина стикеров на MobX (без кодогенерации).
/// Списки - ObservableList, тема - Observable<bool>.
/// Модель Sticker мутабельная (ветка state_structure_stateless), её поля
/// сами по себе не наблюдаемы, поэтому после изменения стикера вызывается
/// _sync(): он пересобирает наблюдаемые списки, и Observer перестраивает UI.
/// Все изменения выполняются внутри runInAction.
class StickerStore {
  //Переменные
  final ObservableList<StickerCategory> categories = ObservableList.of(AppData.categories);
  final ObservableList<Sticker> stickers = ObservableList.of(AppData.stickers);
  final ObservableList<Sticker> stickersByCategory = ObservableList.of(AppData.stickers);
  final ObservableList<Sticker> cart = ObservableList<Sticker>();
  final ObservableList<Sticker> favorite = ObservableList<Sticker>();
  final Observable<bool> light = Observable(true);

  final double taxes = 5.0;

  //Действия
  // Шаги 1, 2: подсветка категории и продукты по категории
  void onCategoryTap(StickerCategory category) {
    runInAction(() {
      for (final e in categories) {
        e.isSelected = e.type == category.type;
      }
      _refresh(categories);
      stickersByCategory
        ..clear()
        ..addAll(
          category.type == StickerType.all ? stickers : stickers.where((e) => e.type == category.type),
        );
    });
  }

  // Шаги 4, 9: количество
  void onIncreaseQuantityTap(Sticker sticker) {
    runInAction(() {
      sticker.quantity++;
      _sync();
    });
  }

  void onDecreaseQuantityTap(Sticker sticker) {
    if (sticker.quantity == 1) return;
    runInAction(() {
      sticker.quantity--;
      _sync();
    });
  }

  // Шаг 6: добавление в корзину
  void onAddToCartTap(Sticker sticker) {
    runInAction(() {
      sticker.cart = true;
      _sync();
    });
  }

  // Шаг 10: удаление из корзины
  void onRemoveFromCartTap(Sticker sticker) {
    runInAction(() {
      sticker.cart = false;
      sticker.quantity = 1;
      _sync();
    });
  }

  // Шаг 11: чистка корзины на checkout
  void onCheckOutTap() {
    runInAction(() {
      for (final e in cart) {
        e.cart = false;
        e.quantity = 1;
      }
      _sync();
    });
  }

  // Шаг 13: добавление/удаление из избранного
  void onAddRemoveFavoriteTap(Sticker sticker) {
    runInAction(() {
      sticker.favorite = !sticker.favorite;
      _sync();
    });
  }

  // Шаг 14: смена темы
  void toggleTheme() {
    runInAction(() {
      light.value = !light.value;
    });
  }

  //Вспомогательные методы
  void _refresh<T>(ObservableList<T> list) {
    final items = list.toList();
    list
      ..clear()
      ..addAll(items);
  }

  void _sync() {
    final inCart = stickers.where((e) => e.cart).toList();
    final inFavorite = stickers.where((e) => e.favorite).toList();
    cart
      ..clear()
      ..addAll(inCart);
    favorite
      ..clear()
      ..addAll(inFavorite);
    _refresh(stickers);
    _refresh(stickersByCategory);
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
