extension StringExtesion on String {
  String fixUsCode() {
    return this.contains('+US1') ? this.replaceAll('+US1', '+1') : this;
  }
}
