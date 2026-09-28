import 'package:flutter_bloc/flutter_bloc.dart';

import 'sticker_event.dart';
import 'sticker_state.dart';

/// BLoC: UI отправляет события (add), блок обрабатывает их в on<Event>
/// и выдаёт новое неизменяемое состояние через emit.
class StickerBloc extends Bloc<StickerEvent, StickerState> {
  StickerBloc() : super(StickerState.initial()) {
    on<CategoryTapped>(_onCategoryTapped);
    on<QuantityIncreased>(_onQuantityIncreased);
    on<QuantityDecreased>(_onQuantityDecreased);
    on<AddedToCart>(_onAddedToCart);
    on<RemovedFromCart>(_onRemovedFromCart);
    on<CheckoutTapped>(_onCheckoutTapped);
    on<FavoriteToggled>(_onFavoriteToggled);
    on<ThemeToggled>(_onThemeToggled);
  }

  // Шаги 1, 2: подсветка выбранной категории и продукты по категории
  void _onCategoryTapped(CategoryTapped event, Emitter<StickerState> emit) {
    final categories = state.categories.map((e) {
      if (e.type == event.category.type) {
        return e.copyWith(isSelected: true);
      }
      return e.copyWith(isSelected: false);
    }).toList();
    emit(state.withStickers(state.stickers, categories: categories));
  }

  // Шаги 4, 9: количество
  void _onQuantityIncreased(QuantityIncreased event, Emitter<StickerState> emit) {
    final stickers = state.stickers.map((e) {
      if (e.id == event.stickerId) {
        return e.copyWith(quantity: e.quantity + 1);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  void _onQuantityDecreased(QuantityDecreased event, Emitter<StickerState> emit) {
    final stickers = state.stickers.map((e) {
      if (e.id == event.stickerId) {
        return e.quantity == 1 ? e : e.copyWith(quantity: e.quantity - 1);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 6: добавление в корзину
  void _onAddedToCart(AddedToCart event, Emitter<StickerState> emit) {
    final stickers = state.stickers.map((e) {
      if (e.id == event.stickerId) {
        return e.copyWith(cart: true);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 10: удаление из корзины
  void _onRemovedFromCart(RemovedFromCart event, Emitter<StickerState> emit) {
    final stickers = state.stickers.map((e) {
      if (e.id == event.stickerId) {
        return e.copyWith(cart: false, quantity: 1);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 11: чистка корзины на checkout
  void _onCheckoutTapped(CheckoutTapped event, Emitter<StickerState> emit) {
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
  void _onFavoriteToggled(FavoriteToggled event, Emitter<StickerState> emit) {
    final stickers = state.stickers.map((e) {
      if (e.id == event.stickerId) {
        return e.copyWith(favorite: !e.favorite);
      }
      return e;
    }).toList();
    emit(state.withStickers(stickers));
  }

  // Шаг 14: смена темы
  void _onThemeToggled(ThemeToggled event, Emitter<StickerState> emit) {
    emit(state.copyWith(light: !state.light));
  }
}
