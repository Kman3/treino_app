import 'dart:math' as math;

import '../../core/db/app_database.dart';
import '../../core/db/repositorios/plano_repository.dart';

/// "Só tenho 20 minutos": a versão reduzida do treino do dia. O plano não muda;
/// só este treino usa menos exercícios, menos séries e menos descanso.
abstract final class VersaoVinteMinutos {
  static const maxExercicios = 4;
  static const minExercicios = 3;
  static const series = 2;
  static const descansoS = 60;
}

/// Padrões de movimento que trabalham várias articulações: são os
/// "principais" que a versão de 20 minutos mantém.
const padroesMultiarticulares = {
  'empurrar-horizontal',
  'empurrar-vertical',
  'puxar-horizontal',
  'puxar-vertical',
  'agachar',
  'dobrar-quadril',
  'avanco',
};

/// Escolhe os exercícios da versão de 20 minutos: os multiarticulares na
/// ordem do plano, até 4; se forem menos de 3, completa com os seguintes na
/// ordem. Cada um fica com 2 séries e até 60 s de descanso, com as mesmas
/// cargas do plano.
List<ItemComExercicio> versaoVinteMinutos(List<ItemComExercicio> itens) {
  final escolhidos = itens
      .where(
        (i) => padroesMultiarticulares.contains(i.exercicio.padraoMovimento),
      )
      .take(VersaoVinteMinutos.maxExercicios)
      .toSet();
  for (final item in itens) {
    if (escolhidos.length >= VersaoVinteMinutos.minExercicios) break;
    escolhidos.add(item);
  }
  return [
    for (final i in itens)
      if (escolhidos.contains(i))
        ItemComExercicio(
          i.item.copyWith(
            series: math.min(i.item.series, VersaoVinteMinutos.series),
            descansoS: math.min(i.item.descansoS, VersaoVinteMinutos.descansoS),
          ),
          i.exercicio,
          original: i.original,
        ),
  ];
}

/// A sessão do dia na versão de 20 minutos, para a prévia da tela Hoje.
SessaoComItens sessaoVinteMinutos(SessaoComItens sessao) =>
    SessaoComItens(sessao.sessao, versaoVinteMinutos(sessao.itens));

/// O treino foi iniciado na versão de 20 minutos?
bool ehVinteMinutos(Treino treino) => treino.modo == ModoTreino.vinteMin;
