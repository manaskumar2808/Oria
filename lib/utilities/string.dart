String capitalize(String s) {
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}