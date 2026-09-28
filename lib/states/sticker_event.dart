import 'package:equatable/equatable.dart';

import '../data/_data.dart';

/// События BLoC: UI сообщает блоку, что произошло.
abstract class StickerEvent extends Equatable {
  const StickerEvent();

  @override
  List<Object?> get props => [];
}

// Шаги 1, 2
class CategoryTapped extends StickerEvent {
  final StickerCategory category;
  const CategoryTapped(this.category);

  @override
  List<Object?> get props => [category];
}

// Шаги 4, 9
class QuantityIncreased extends StickerEvent {
  final int stickerId;
  const QuantityIncreased(this.stickerId);

  @override
  List<Object?> get props => [stickerId];
}

class QuantityDecreased extends StickerEvent {
  final int stickerId;
  const QuantityDecreased(this.stickerId);

  @override
  List<Object?> get props => [stickerId];
}

// Шаг 6
class AddedToCart extends StickerEvent {
  final int stickerId;
  const AddedToCart(this.stickerId);

  @override
  List<Object?> get props => [stickerId];
}

// Шаг 10
class RemovedFromCart extends StickerEvent {
  final int stickerId;
  const RemovedFromCart(this.stickerId);

  @override
  List<Object?> get props => [stickerId];
}

// Шаг 11
class CheckoutTapped extends StickerEvent {
  const CheckoutTapped();
}

// Шаг 13
class FavoriteToggled extends StickerEvent {
  final int stickerId;
  const FavoriteToggled(this.stickerId);

  @override
  List<Object?> get props => [stickerId];
}

// Шаг 14
class ThemeToggled extends StickerEvent {
  const ThemeToggled();
}
