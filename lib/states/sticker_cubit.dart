import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/_data.dart';
import 'sticker_state.dart';

/// Cubit: методы сразу вызывают emit с новым неизменяемым состоянием.
class StickerCubit extends Cubit<StickerState> {
  StickerCubit() : super(StickerState.initial());

  // Шаги 1, 2: подсветка выбранной категории и продукты по категории
  void onCategoryTap(StickerCategory category) {
    final categories = state.categories.map((e) {
      if (e.type == category.type) {
        return e.copyWith(isSelected: true);
      }
      return e.copyWith(isSelected: false);
    }).toList();
    emit(state.withStickers(state.stickers, categories: categories));
  }

  // Шаги 4, 9: количество
  void onIncreaseQuantityTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(quantity: e.quantity + 1);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  void onDecreaseQuantityTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.quantity == 1 ? e : e.copyWith(quantity: e.quantity - 1);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 6: добавление в корзину
  void onAddToCartTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(cart: true);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 10: удаление из корзины
  void onRemoveFromCartTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(cart: false, quantity: 1);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
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
    emit(state.withStickers(stickers));
  }

  // Шаг 13: добавление/удаление из избранного
  void onAddRemoveFavoriteTap(int stickerId) {
    final stickers = state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.copyWith(favorite: !e.favorite);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 14: смена темы
  void toggleTheme() {
    emit(state.copyWith(light: !state.light));
  }
}
