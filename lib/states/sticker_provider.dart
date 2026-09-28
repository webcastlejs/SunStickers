import 'package:flutter/foundation.dart';

import '../data/_data.dart';
import 'sticker_state.dart';

/// Provider: ChangeNotifier хранит неизменяемое состояние _state
/// и после каждого изменения вызывает notifyListeners().
class StickerProvider extends ChangeNotifier {
  StickerState _state = StickerState.initial();
  StickerState get state => _state;

  void _emit(StickerState next) {
    if (next == _state) return;
    _state = next;
    notifyListeners();
  }

  // Шаги 1, 2: подсветка выбранной категории и продукты по категории
  void onCategoryTap(StickerCategory category) {
    final categories = state.categories.map((e) {
      if (e.type == category.type) {
        return e.copyWith(isSelected: true);
      }
      return e.copyWith(isSelected: false);
    }).toList();
    _emit(state.withStickers(state.stickers, categories: categories));
  }

  // Шаги 4, 9: количество
  void onIncreaseQuantityTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(quantity: e.quantity + 1);
      }
      return e;
    }).toList();
    _emit(state.withStickers(stickers));
  }

  void onDecreaseQuantityTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.quantity == 1 ? e : e.copyWith(quantity: e.quantity - 1);
      }
      return e;
    }).toList();
    _emit(state.withStickers(stickers));
  }

  // Шаг 6: добавление в корзину
  void onAddToCartTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(cart: true);
      }
      return e;
    }).toList();
    _emit(state.withStickers(stickers));
  }

  // Шаг 10: удаление из корзины
  void onRemoveFromCartTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(cart: false, quantity: 1);
      }
      return e;
    }).toList();
    _emit(state.withStickers(stickers));
  }

  // Шаг 11: чистка корзины на checkout
  void onCheckOutTap() {
    final cartIds = state.cart.map((e) => e.id).toSet();
    final stickers = state.stickers.map((e) {
      if (cartIds.contains(e.id)) {
        return e.copyWith(cart: false, quantity: 1);
      }
      return e;
    }).toList();
    _emit(state.withStickers(stickers));
  }

  // Шаг 13: добавление/удаление из избранного
  void onAddRemoveFavoriteTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(favorite: !e.favorite);
      }
      return e;
    }).toList();
    _emit(state.withStickers(stickers));
  }

  // Шаг 14: смена темы
  void toggleTheme() {
    _emit(state.copyWith(light: !state.light));
  }
}
