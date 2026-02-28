/// Maps OpenWeatherMap icon codes to emoji-based weather icons.
String weatherIconEmoji(String iconCode) {
  switch (iconCode.replaceAll(RegExp(r'[dn]$'), '')) {
    case '01':
      return iconCode.endsWith('n') ? '\u{1F319}' : '\u{2600}\u{FE0F}'; // 🌙 / ☀️
    case '02':
      return iconCode.endsWith('n') ? '\u{1F324}\u{FE0F}' : '\u{26C5}'; // 🌤️ / ⛅
    case '03':
      return '\u{2601}\u{FE0F}'; // ☁️
    case '04':
      return '\u{2601}\u{FE0F}'; // ☁️ (overcast)
    case '09':
      return '\u{1F327}\u{FE0F}'; // 🌧️
    case '10':
      return '\u{1F326}\u{FE0F}'; // 🌦️
    case '11':
      return '\u{26C8}\u{FE0F}'; // ⛈️
    case '13':
      return '\u{2744}\u{FE0F}'; // ❄️
    case '50':
      return '\u{1F32B}\u{FE0F}'; // 🌫️
    default:
      return '\u{1F321}\u{FE0F}'; // 🌡️
  }
}
