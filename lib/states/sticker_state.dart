import 'package:equatable/equatable.dart';

import '../data/_data.dart';

/// Неизменяемое состояние магазина стикеров (ветка state_structure_copy_with).
/// Любое изменение создаёт новый экземпляр через copyWith,
/// поэтому Riverpod видит, что данные изменились, и перестраивает UI.
class StickerState extends Equatable {
  //Переменные
  final List<StickerCategory> categories;
  final List<Sticker> stickers;
  final List<Sticker> stickersByCategory;
  final List<Sticker> cart;
  final List<Sticker> favorite;
  final bool light;

  const StickerState({
    required this.categories,
    required this.stickers,
    required this.stickersByCategory,
    required this.cart,
    required this.favorite,
    required this.light,
  });

  factory StickerState.initial() {
    return StickerState(
      categories: AppData.categories,
      stickers: AppData.stickers,
      stickersByCategory: AppData.stickers,
      cart: const <Sticker>[],
      favorite: const <Sticker>[],
      light: true,
    );
  }

  StickerState copyWith({
    List<StickerCategory>? categories,
    List<Sticker>? stickers,
    List<Sticker>? stickersByCategory,
    List<Sticker>? cart,
    List<Sticker>? favorite,
    bool? light,
  }) {
    return StickerState(
      categories: categories ?? this.categories,
      stickers: stickers ?? this.stickers,
      stickersByCategory: stickersByCategory ?? this.stickersByCategory,
      cart: cart ?? this.cart,
      favorite: favorite ?? this.favorite,
      light: light ?? this.light,
    );
  }

  @override
  List<Object?> get props => [categories, stickers, stickersByCategory, cart, favorite, light];

  /// Новое состояние после изменения списка stickers:
  /// пересчитываются stickersByCategory, cart и favorite.
  StickerState withStickers(List<Sticker> stickers, {List<StickerCategory>? categories}) {
    final nextCategories = categories ?? this.categories;
    return copyWith(
      categories: nextCategories,
      stickers: stickers,
      stickersByCategory: byCategory(stickers, nextCategories),
      cart: stickers.where((e) => e.cart).toList(),
      favorite: stickers.where((e) => e.favorite).toList(),
    );
  }

  /// Шаг 2: продукты по выбранной категории
  static List<Sticker> byCategory(List<Sticker> stickers, List<StickerCategory> categories) {
    final selected = categories.firstWhere((e) => e.isSelected, orElse: () => categories.first);
    if (selected.type == StickerType.all) return stickers;
    return stickers.where((e) => e.type == selected.type).toList();
  }

  //Вспомогательные методы
  Sticker getStickerById(int stickerId) {
    return stickers.firstWhere((e) => e.id == stickerId);
  }

  // Шаг 8: стоимость корзины
  double get taxes => 5.0;

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
