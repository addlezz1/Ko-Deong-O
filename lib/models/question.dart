enum Type {
  multiple,
  boolean
}

enum Difficulty {
  easy,
  medium,
  hard
}

class Question {
  final String categoryName;
  final Type type;
  final Difficulty difficulty;
  final String question;
  final String audioUrl;
  final String mediaUrl;
  final String kor;
  final String eng;
  final String correctAnswer;
  final List<dynamic> incorrectAnswers;
  final List<dynamic> words;
  bool isSaved;
  final String vocaSeq;

  Question({this.categoryName, this.type, this.difficulty, this.question, this.correctAnswer, this.incorrectAnswers, this.words, this.audioUrl, this.mediaUrl, this.kor, this.eng, this.isSaved, this.vocaSeq});

  Question.fromMap(Map<String, dynamic> data):
    categoryName = data["category"],
    type = data["type"] == "multiple" ? Type.multiple : Type.boolean,
    difficulty = data["difficulty"] == "easy" ? Difficulty.easy : data["difficulty"] == "medium" ? Difficulty.medium : Difficulty.hard,
    question = data["question"],
    correctAnswer = data["correct_answer"],
    incorrectAnswers = data["incorrect_answers"],
        words = data["words"],
    audioUrl = data["audio_url"],
    mediaUrl = data["media_url"],
    kor = data["kor"],
    eng = data["eng"],
    isSaved = (data["is_saved"] == '1')? true : false,
    vocaSeq = data["voca_seq"];

  static List<Question> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => Question.fromMap(question)).toList();
  }

}