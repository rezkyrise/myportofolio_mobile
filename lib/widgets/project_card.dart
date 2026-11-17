import 'package:material_ui/material_ui.dart';

/// Data and card widget for an action on the portfolio home screen.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final Color foregroundColor;
  final Color iconColor;
  final List<String>? details;

  ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.details,
    this.foregroundColor = Colors.white,
    this.iconColor = Colors.white,
  });
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final bool isCompact;
  final VoidCallback? onPressed;

  const ItemCard(
    this.item, {
    super.key,
    this.isCompact = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: isCompact
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: item.iconColor, size: 24),
                    const SizedBox(width: 10),
                    _itemLabel(),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: item.iconColor, size: 42),
                      const SizedBox(height: 8),
                      _itemLabel(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _itemLabel() {
    return Text(
      item.name,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: item.foregroundColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}
