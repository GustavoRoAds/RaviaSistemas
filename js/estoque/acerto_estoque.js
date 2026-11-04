const API_ACERTO = BASE_ACERTO + '/api/estoque/acerto.php';
const API_PRODUTO = BASE_ACERTO + '/api/produto/produtos.php';
const API_SALDO = BASE_ACERTO + '/api/produto/estoque.php';
const codigo = document.getElementById('produto-codigo');
const busca = document.getElementById('produto-busca');
const saldo = document.getElementById('produto-saldo');
const quantidade = document.getElementById('quantidade');
const resultados = document.getElementById('produto-resultados');
const dataEmissao = document.getElementById('data-emissao');
const itens = [];
let produtoAtual = null;
let buscaSequencia = 0;
dataEmissao.value = new Date(Date.now() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0,10);
function aviso(mensagem, tipo='atencao') { if (typeof Notificacao !== 'undefined' && typeof Notificacao[tipo] === 'function') Notificacao[tipo](mensagem); else alert(mensagem); }
async function requisitar(url, opcoes) { const resposta = await fetch(url,opcoes); const dados = await resposta.json(); if (!resposta.ok) throw new Error(dados.erro || 'Erro na requisição'); return dados; }
async function selecionarProduto(id) {
 try { const produto = await requisitar(API_SALDO+'?id='+encodeURIComponent(id)); produtoAtual = produto; codigo.value=produto.codigo; busca.value=produto.nome; saldo.textContent=produto.estoque; resultados.hidden=true; quantidade.focus(); }
 catch(e) { produtoAtual=null; saldo.textContent='0'; aviso(e.message); }
}
codigo.addEventListener('keydown', e=>{if(e.key==='Enter'){e.preventDefault();selecionarProduto(codigo.value);}});
codigo.addEventListener('change',()=>{if(codigo.value) selecionarProduto(codigo.value);});
busca.addEventListener('input', async()=>{
 produtoAtual=null; codigo.value=''; saldo.textContent='0'; const texto=busca.value.trim(); const seq=++buscaSequencia;
 if(texto.length<2){resultados.hidden=true;return;}
 try {const produtos=await requisitar(API_PRODUTO+'?busca='+encodeURIComponent(texto));if(seq!==buscaSequencia)return;resultados.replaceChildren();produtos.slice(0,15).forEach(p=>{const b=document.createElement('button');b.type='button';b.textContent=p.id+' - '+p.nome;b.onclick=()=>selecionarProduto(p.id);resultados.appendChild(b);});resultados.hidden=!produtos.length;}catch(e){resultados.hidden=true;}
});
function renderizar() {
 const corpo=document.getElementById('itens-acerto'); corpo.replaceChildren();
 if(!itens.length){const tr=corpo.insertRow();const td=tr.insertCell();td.colSpan=4;td.className='acerto-vazio';td.textContent='Nenhum produto lançado.';}
 itens.forEach((item,i)=>{const tr=corpo.insertRow();[item.produto_id,item.nome,(item.quantidade>0?'+':'')+item.quantidade].forEach(v=>{tr.insertCell().textContent=v;});const td=tr.insertCell();const b=document.createElement('button');b.type='button';b.className='acerto-remover';b.textContent='×';b.title='Remover';b.onclick=()=>{itens.splice(i,1);renderizar();};td.appendChild(b);});
 document.getElementById('contador').textContent=itens.length+' produto(s)';
}
function adicionar(){
 if(!produtoAtual){aviso('Selecione um produto');return;}
 const n=Number(quantidade.value);if(!Number.isSafeInteger(n)||n===0){aviso('Informe uma quantidade inteira diferente de zero');return;}
 const anterior=itens.find(x=>x.produto_id===produtoAtual.codigo);const total=n+(anterior?anterior.quantidade:0);
 if(Number(produtoAtual.estoque)+total<0){aviso('Quantidade maior que o saldo disponível');return;}
 if(anterior){if(total===0)itens.splice(itens.indexOf(anterior),1);else anterior.quantidade=total;}
 else itens.push({produto_id:produtoAtual.codigo,nome:produtoAtual.nome,quantidade:n});
 renderizar();quantidade.value='';quantidade.focus();
}
document.getElementById('adicionar').onclick=adicionar;
quantidade.addEventListener('keydown',e=>{if(e.key==='Enter'){e.preventDefault();adicionar();}});
document.getElementById('limpar').onclick=()=>{itens.length=0;renderizar();};
document.getElementById('salvar').onclick=async()=>{
 if(!dataEmissao.value||!itens.length){aviso('Informe a data e pelo menos um produto');return;}
 const botao=document.getElementById('salvar');botao.disabled=true;
 try {const resposta=await requisitar(API_ACERTO,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({data_emissao:dataEmissao.value,itens:itens.map(({produto_id,quantidade})=>({produto_id,quantidade}))})});aviso('Acerto nº '+resposta.id+' salvo com sucesso','sucesso');itens.length=0;renderizar();produtoAtual=null;codigo.value='';busca.value='';saldo.textContent='0';quantidade.value='';carregarHistorico();}
 catch(e){aviso(e.message);}finally{botao.disabled=false;}
};
async function carregarHistorico(){const div=document.getElementById('historico');div.textContent='Carregando...';try{const registros=await requisitar(API_ACERTO+'?data='+encodeURIComponent(dataEmissao.value));div.replaceChildren();if(!registros.length){div.textContent='Nenhum acerto registrado nesta data.';return;}registros.forEach(a=>{const details=document.createElement('details');const summary=document.createElement('summary');summary.textContent='Acerto #'+a.id+' — '+a.itens.length+' produto(s)';details.appendChild(summary);a.itens.forEach(i=>{const linha=document.createElement('div');linha.style.padding='6px 12px';linha.textContent=i.produto_id+' - '+i.nome+' — '+(i.quantidade>0?'+':'')+i.quantidade;details.appendChild(linha);});div.appendChild(details);});}catch(e){div.textContent=e.message;}}
dataEmissao.addEventListener('change',carregarHistorico);document.getElementById('atualizar-historico').onclick=carregarHistorico;carregarHistorico();
