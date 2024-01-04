class Badges {
   static String getBadgesByAchiement(String achivement) {
    final List<String> badges = [
      'badge-01.png',
      'badge-02.png',
      'badge-03.png',
      'badge-04.png',
    ];
    int index = 0;

    if (achivement == 'O') return '';
    if (achivement == 'A') index = 3;
    if (achivement == 'B') index = 3;
    if (achivement == 'C') index = 2;
    if (achivement == 'D') index = 1;
    if (achivement == 'E') index = 1;

    return "assets/asset/badges/${badges[index]}";
  }

}