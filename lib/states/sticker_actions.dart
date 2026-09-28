import '../data/_data.dart';

/// Действия Redux: описывают, что произошло в UI.

// Шаги 1, 2
class CategoryTappedAction {
  final StickerCategory category;
  const CategoryTappedAction(this.category);
}

// Шаги 4, 9
class QuantityIncreasedAction {
  final int stickerId;
  const QuantityIncreasedAction(this.stickerId);
}

class QuantityDecreasedAction {
  final int stickerId;
  const QuantityDecreasedAction(this.stickerId);
}

// Шаг 6
class AddedToCartAction {
  final int stickerId;
  const AddedToCartAction(this.stickerId);
}

// Шаг 10
class RemovedFromCartAction {
  final int stickerId;
  const RemovedFromCartAction(this.stickerId);
}

// Шаг 11
class CheckoutTappedAction {
  const CheckoutTappedAction();
}

// Шаг 13
class FavoriteToggledAction {
  final int stickerId;
  const FavoriteToggledAction(this.stickerId);
}

// Шаг 14
class ThemeToggledAction {
  const ThemeToggledAction();
}
