import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_dados;
import 'package:timezone/timezone.dart' as tz;

import '../theme/tokens.dart';

/// Aviso de fim do descanso, inclusive com o app em segundo plano.
abstract interface class AvisoDescanso {
  /// Pede a permissão de notificação (Android 13+) na primeira vez.
  Future<void> pedirPermissao();

  /// Agenda o aviso para [quando], trocando um aviso anterior.
  Future<void> agendar(DateTime quando, {required String texto});

  Future<void> cancelar();
}

/// Sem aviso: nos testes e nas plataformas sem notificação local.
class AvisoDescansoNulo implements AvisoDescanso {
  const AvisoDescansoNulo();

  @override
  Future<void> pedirPermissao() async {}

  @override
  Future<void> agendar(DateTime quando, {required String texto}) async {}

  @override
  Future<void> cancelar() async {}
}

/// Notificação local agendada para o horário exato do fim do descanso. Toca o
/// som de notificação (que respeita o modo silencioso) e vibra.
class AvisoDescansoLocal implements AvisoDescanso {
  AvisoDescansoLocal._(this._plugin);

  static const _id = 1;
  static const _canal = AndroidNotificationDetails(
    'descanso',
    'Fim do descanso',
    channelDescription: 'Avisa quando o descanso entre as séries acaba.',
    importance: Importance.high,
    priority: Priority.high,
    category: AndroidNotificationCategory.alarm,
    playSound: true,
    enableVibration: true,
    // Halter branco (res/drawable/ic_notificacao.xml), pintado de Brasa.
    icon: _icone,
    color: Cores.brasa,
  );
  static const _icone = 'ic_notificacao';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _permissaoPedida = false;

  /// Só existe no Android; nas outras plataformas devolve o aviso nulo.
  static Future<AvisoDescanso> criar() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const AvisoDescansoNulo();
    }
    tz_dados.initializeTimeZones();
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_icone),
      ),
    );
    return AvisoDescansoLocal._(plugin);
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> pedirPermissao() async {
    if (_permissaoPedida) return;
    _permissaoPedida = true;
    await _android?.requestNotificationsPermission();
  }

  @override
  Future<void> agendar(DateTime quando, {required String texto}) async {
    await cancelar();
    if (!quando.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: _id,
      title: 'Descanso acabou',
      body: texto,
      // Um instante absoluto: o fuso não importa.
      scheduledDate: tz.TZDateTime.from(quando.toUtc(), tz.UTC),
      notificationDetails: const NotificationDetails(android: _canal),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelar() => _plugin.cancel(id: _id);
}
