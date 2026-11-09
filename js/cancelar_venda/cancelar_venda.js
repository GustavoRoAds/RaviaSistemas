const tabelaVendas = document.getElementById('lista-vendas');
const pesquisaVendas = document.getElementById('busca-vendas');
const limiteRegistros = document.getElementById('limite-registros');
const avisoCancelamento = document.getElementById('cancelamento-aviso');
const modalMotivo = document.getElementById('modal-motivo-cancelamento');
const campoMotivo = document.getElementById('motivo-cancelamento');
const tituloMotivo = document.getElementById('titulo-motivo-cancelamento');
let vendaSelecionada = null;
let vendasCancelamento = [];
const moedaCancelamento = v => Number(v || 0).toLocaleString('pt-BR', {style:'currency',currency:'BRL'});
function textoSeguro(valor) {
  return String(valor ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}
function exibirVendas() {
  const termo = pesquisaVendas.value.trim().toLocaleLowerCase('pt-BR');
  const filtradas = vendasCancelamento.filter(v => String(v.num_venda).includes(termo) || String(v.nome_cliente || '').toLocaleLowerCase('pt-BR').includes(termo));
  const limite = Number(limiteRegistros.value);
  const visiveis = limite > 0 ? filtradas.slice(0, limite) : filtradas;
  tabelaVendas.innerHTML = visiveis.length ? visiveis.map(v => `<tr>
    <td>${textoSeguro(v.num_venda)}</td>
    <td>${textoSeguro(String(v.data_venda).slice(0,10).split('-').reverse().join('/'))}</td>
    <td>${textoSeguro(v.nome_cliente || '—')}</td>
    <td>${moedaCancelamento(v.valor_total)}</td>
    <td>${textoSeguro(v.situacao)}</td>
    <td><div class="cancelamento-acoes">
      <a class="cancelamento-imprimir" href="../../api/venda/imprimir_venda.php?id=${encodeURIComponent(v.num_venda)}" target="_blank" rel="noopener" title="Imprimir venda ${Number(v.num_venda)}">Imprimir</a>
      ${v.situacao === 'ATIVA' ? `<button type="button" data-cancelar="${Number(v.num_venda)}">Cancelar</button>` : ''}
    </div></td>
  </tr>`).join('') : '<tr><td colspan="6">Nenhuma venda encontrada.</td></tr>';
}
async function carregarVendas() {
  try {
    const resposta = await fetch('../../api/venda/venda.php', {credentials:'same-origin'});
    const dados = await resposta.json();
    if (!resposta.ok || !Array.isArray(dados)) throw new Error(dados.erro || 'Erro ao consultar vendas');
    vendasCancelamento = dados;
    exibirVendas();
  } catch (erro) { Notificacao.erro(erro.message); tabelaVendas.innerHTML = ''; }
}
pesquisaVendas.addEventListener('input', exibirVendas);
limiteRegistros.addEventListener('change', exibirVendas);
function fecharModalMotivo() {
  modalMotivo.hidden = true;
  vendaSelecionada = null;
}
tabelaVendas.addEventListener('click', evento => {
  const botao = evento.target.closest('[data-cancelar]');
  if (!botao) return;
  vendaSelecionada = Number(botao.dataset.cancelar);
  tituloMotivo.textContent = `Motivo do cancelamento — Venda ${vendaSelecionada}`;
  campoMotivo.value = '';
  modalMotivo.hidden = false;
  campoMotivo.focus();
});
document.getElementById('fechar-motivo').addEventListener('click', fecharModalMotivo);
modalMotivo.addEventListener('click', evento => { if (evento.target === modalMotivo) fecharModalMotivo(); });
document.addEventListener('keydown', evento => { if (evento.key === 'Escape' && !modalMotivo.hidden) fecharModalMotivo(); });
document.getElementById('form-motivo-cancelamento').addEventListener('submit', async evento => {
  evento.preventDefault();
  const numero = vendaSelecionada;
  const motivo = campoMotivo.value.trim();
  if (!numero) return;
  if (!motivo) { Notificacao.atencao('Informe o motivo do cancelamento.'); campoMotivo.focus(); return; }
  if (motivo.length > 255) { Notificacao.atencao('O motivo deve ter no máximo 255 caracteres.'); return; }
  fecharModalMotivo();
  const confirmado = await mostrarConfirmacao({
    titulo: 'Cancelar venda',
    mensagem: `Deseja cancelar a venda ${numero}? O estoque será restabelecido e o recebimento será estornado.`,
    textoSim: 'Sim, cancelar', textoNao: 'Voltar', perigo: true
  });
  if (!confirmado) return;
  const botao = tabelaVendas.querySelector(`[data-cancelar="${numero}"]`);
  if (botao) botao.disabled = true;
  try {
    const resposta = await fetch('../../api/venda/cancelar_venda.php', {
      method: 'POST', credentials: 'same-origin', headers: {'Content-Type':'application/json'},
      body: JSON.stringify({num_venda:numero,motivo})
    });
    const dados = await resposta.json();
    if (!resposta.ok) throw new Error(dados.erro || 'Falha ao cancelar venda');
    Notificacao.sucesso(dados.mensagem || 'Venda cancelada e estornada com sucesso.');
    await carregarVendas();
  } catch (erro) {
    Notificacao.erro(erro.message);
    if (botao) botao.disabled = false;
  }
});
carregarVendas();
