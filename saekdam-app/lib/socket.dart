import 'package:web_socket_channel/web_socket_channel.dart';




class WebSocketChannelService {



  // 싱글톤 인스턴스를 생성
  static final WebSocketChannelService _instance = WebSocketChannelService._internal();
  WebSocketChannelService._internal();
  // factory 생성자를 통해 항상 동일한 인스턴스를 반환
  factory WebSocketChannelService() {
    return _instance;
  }

  WebSocketChannel? _channel;
  Stream? _broadcastStream;


  /// 메시지 전송

  void sendMessage(dynamic message) {
    if (_channel != null) {
      print('Sending message: $message');
      _channel!.sink.add(message);
    } else {
      print('Cannot send message, channel is null.');
    }
  }
  /// UUID를 인자로 받아 웹소켓 채널 생성 및 연결
  void connect(String uuid) {
    // UUID를 URL의 경로에 포함하여 연결합니다.
    final url = 'ws://saekdam.kro.kr/ws/tasks/$uuid';
    print('Attempting to connect to $url');
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _broadcastStream = _channel!.stream.asBroadcastStream();
    // 채널을 통해 들어오는 메시지 수신
    _broadcastStream!.listen(
          (data) {
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');
        print('Received message: $data');

      },
      onError: (error) {
        print('Channel error: $error');
      },
      onDone: () {
        print('Channel closed');
      },
      cancelOnError: true,
    );

    // 연결이 성공적으로 이루어진 후 첫 데이터가 오지 않더라도,
    // 연결 자체는 WebSocketChannel.connect()에서 즉시 반환됩니다.
    // 추가적으로 연결 성공 여부를 확인할 수 있는 별도 이벤트는 없으므로,
    // 정상 연결된 후 첫 메시지 또는 onDone, onError 콜백으로 확인할 수 있습니다.
    print('WebSocketChannel created, connection in progress...');
  }

  /// 채널 연결 해제
  void disconnect() {
    if (_channel != null) {
      print('Disconnecting WebSocket channel.');
      _channel!.sink.close();
    } else {
      print('Channel already null, nothing to disconnect.');
    }
  }
  Stream get stream => _broadcastStream ?? Stream.empty();

}
final wsService = WebSocketChannelService();
