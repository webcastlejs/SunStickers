import '../data/_data.dart';
import 'sticker_actions.dart';
import 'sticker_state.dart';

/// Redux: чистая функция reducer получает текущее состояние и действие
/// и возвращает новое неизменяемое состояние.
StickerState stickerReducer(StickerState state, dynamic action) {
  // Шаги 1, 2: подсветка выбранной категории и продукты по категории
  if (action is CategoryTappedAction) {
    final categories = state.categories.map((e) {
      if (e.type == action.category.type) {
        return e.copyWith(isSelected: true);
      }
      return e.copyWith(isSelected: false);
    }).toList();
    return state.withStickers(state.stickers, categories: categories);
  }

  // Шаги 4, 9: количество
  if (action is QuantityIncreasedAction) {
    return state.withStickers(_update(state.stickers, action.stickerId, (e) => e.copyWith(quantity: e.quantity + 1)));
  }

  if (action is QuantityDecreasedAction) {
    return state.withStickers(
      _update(state.stickers, action.stickerId, (e) => e.quantity == 1 ? e : e.copyWith(quantity: e.quantity - 1)),
    );
  }

  // Шаг 6: добавление в корзину
  if (action is AddedToCartAction) {
    return state.withStickers(_update(state.stickers, action.stickerId, (e) => e.copyWith(cart: true)));
  }

  // Шаг 10: удаление из корзины
  if (action is RemovedFromCartAction) {
    return state.withStickers(_update(state.stickers, action.stickerId, (e) => e.copyWith(cart: false, quantity: 1)));
  }

  // Шаг 11: чистка корзины на checkout
  if (action is CheckoutTappedAction) {
    final cartIds = state.cart.map((e) => e.id).toSet();
    final stickers = state.stickers.map((e) {
      if (cartIds.contains(e.id)) {
        return e.copyWith(cart: false, quantity: 1);
      }
      return e;
    }).toList();
    return state.withStickers(stickers);
  }

  // Шаг 13: добавление/удаление из избранного
  if (action is FavoriteToggledAction) {
    return state.withStickers(_update(state.stickers, action.stickerId, (e) => e.copyWith(favorite: !e.favorite)));
  }

  // Шаг 14: смена темы
  if (action is ThemeToggledAction) {
    return state.copyWith(light: !state.light);
  }

  return state;
}

/// Заменяет стикер с нужным id его изменённой копией (copyWith).
List<Sticker> _update(List<Sticker> stickers, int stickerId, Sticker Function(Sticker) change) {
  return stickers.map((e) => e.id == stickerId ? change(e) : e).toList();
}
