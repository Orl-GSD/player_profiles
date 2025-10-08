enum Level {
  beginner,
  intermediate,
  levelG,
  levelF,
  levelE,
  levelD,
  openPlayer
}

enum Strength {
  weak,
  mid,
  strong
}

const levelString = {
  Level.beginner: 'Beginner',
  Level.intermediate: 'Intermediate',
  Level.levelG: 'G',
  Level.levelF: 'F',
  Level.levelE: 'E',
  Level.levelD: 'D',
  Level.openPlayer: 'Open'
};

const strengthString = {
  Strength.weak: 'Weak',
  Strength.mid: 'Mid',
  Strength.strong: 'Strong',
};

class Player {
  final String id;
  final String nickname;
  final String name;
  final String contactNum;
  final String emailAd;
  final String address;
  final String remarks;
  final Level levelStart;
  final Level levelEnd;
  final Strength? strengthStart;
  final Strength? strengthEnd;

  Player({
    required this.id,
    required this.nickname,
    required this.name,
    required this.contactNum,
    required this.emailAd,
    required this.address,
    required this.remarks,
    required this.levelStart,
    required this.levelEnd,
    this.strengthStart,
    this.strengthEnd
  });

  String get levelStartString {
    return '${strengthString[strengthStart]} ${levelString[levelStart]}';
  }

  String get levelEndString {
    if (levelEnd == Level.openPlayer) {
      return 'Open';
    } else {
      return '${strengthString[strengthEnd]} ${levelString[levelEnd]}';
    }
  }
}
