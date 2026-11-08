import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:treino_app/core/marca.dart';

/// A identidade Caramelo Mutante espalhada pelos arquivos de cada plataforma.
void main() {
  test('a versão do Sobre é a do pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final versao = RegExp(
      r'^version: (\S+)\+',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(Marca.versao, versao);
  });

  test('Android: nome completo no app, curto embaixo do ícone', () {
    final manifesto = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    expect(manifesto, contains('android:label="${Marca.nome}"'));
    expect(manifesto, contains('android:label="${Marca.nomeCurto}"'));
  });

  test('Android: camadas do ícone e da notificação em todas as densidades', () {
    const res = 'android/app/src/main/res';
    for (final densidade in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']) {
      for (final arquivo in [
        'mipmap-$densidade/ic_launcher.png',
        'mipmap-$densidade/ic_launcher_foreground.png',
        'mipmap-$densidade/ic_launcher_monochrome.png',
        'drawable-$densidade/ic_notificacao.png',
      ]) {
        expect(File('$res/$arquivo').existsSync(), isTrue, reason: arquivo);
      }
    }
    final adaptativo = File('$res/mipmap-anydpi-v26/ic_launcher.xml')
        .readAsStringSync();
    expect(adaptativo, contains('@mipmap/ic_launcher_foreground'));
    expect(adaptativo, contains('@mipmap/ic_launcher_monochrome'));
  });

  test('os logos usados no app existem', () {
    expect(File(Marca.icone).existsSync(), isTrue);
    expect(File(Marca.logoVertical).existsSync(), isTrue);
    expect(File(Marca.logoHorizontal).existsSync(), isTrue);
  });
}
