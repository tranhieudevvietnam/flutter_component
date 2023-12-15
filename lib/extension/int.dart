part of 'export_part.dart';

extension IntCustom on int {
  String numberFormat() {
    return NumberFormat("#,###", 'vi').format(this).replaceAll(".", ",");
  }
}
