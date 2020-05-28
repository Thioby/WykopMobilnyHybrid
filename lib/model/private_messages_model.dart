import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/InputData.dart';
import 'package:wykop_api/data/model/PmMessageDto.dart';
import 'package:owmflutter/model/input_model.dart';

class PrivateMessagesModel extends InputModel {
  List<PmMessageDto> _messages;
  bool _loading = false;
  AuthorDto _receiver;

  AuthorDto get receiver => _receiver;
  String get lastUpdate => _messages.last.date;
  bool get isLoading => _loading;
  List<PmMessageDto> get messages => _messages;

  final String receiverNickname;
  PrivateMessagesModel({this.receiverNickname});

  @override
  Future<void> onInputSubmitted(InputData data) async {
    var pm = await api.pm.sendMessage(receiverNickname, data);
    _messages.add(pm);
    notifyListeners();
  }

  Future<void> loadMessages() async {
    _loading = true;
    notifyListeners();
    var conversation = await api.pm.getConversation(this.receiverNickname);

    _messages = conversation.messages;
    _receiver = conversation.receiver;

    _loading = false;
    notifyListeners();
  }
}
