const paginaCadastroProduto = document.querySelector(".prod-pagina");
const formularioProduto = document.getElementById("prod-form");
const botaoSalvarProduto = document.getElementById("prod-btn-salvar");
const botaoExcluirProduto = document.getElementById("prod-btn-excluir");

const campoIdProduto = document.getElementById("prod-id");
const campoNomeProduto = document.getElementById("prod-nome");
const campoDescricaoProduto = document.getElementById("prod-descricao");
const campoCategoriaProduto = document.getElementById("prod-categoria");
const campoCustoProduto = document.getElementById("prod-custo");
const campoVendaProduto = document.getElementById("prod-venda");

const API_PRODUTOS_CADASTRO = paginaCadastroProduto?.dataset.apiUrl;
const API_CATEGORIAS_CADASTRO = paginaCadastroProduto?.dataset.categoriasUrl;

let modoEdicaoProduto = false;
let produtoExistenteConsultado = false;
let categoriasProduto = [];
let produtoAtivoCadastro = true;

function mostrarMensagemProduto(texto, sucesso = false) {
  Notificacao.mostrar(sucesso ? "sucesso" : "erro", texto);
}

function converterValorProduto(valor) {
  let texto = String(valor ?? "")
    .trim()
    .replace(/\s/g, "")
    .replace(/^R\$/i, "");

  if (texto.includes(",")) {
    texto = texto.replace(/\./g, "").replace(",", ".");
  }

  if (texto === "") {
    return null;
  }

  const numero = Number(texto);

  return Number.isFinite(numero) ? numero : NaN;
}

function formatarCampoMoeda(valor) {
  if (valor === "" || valor === null || valor === undefined) {
    return "";
  }

  const numero = Number(String(valor).replace(",", "."));

  if (!Number.isFinite(numero)) {
    return "";
  }

  return numero.toLocaleString("pt-BR", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}

function aplicarMascaraMoeda(campo) {
  campo.addEventListener("input", function () {
    const numeros = campo.value.replace(/\D/g, "");

    if (numeros === "") {
      campo.value = "";
      return;
    }

    const valor = Number(numeros) / 100;

    campo.value = valor.toLocaleString("pt-BR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
  });
}

function obterIdCategoria(categoria) {
  return (
    categoria.id ??
    categoria.categoria_id ??
    categoria.idCategoria ??
    categoria.codigo ??
    ""
  );
}

function obterNomeCategoria(categoria) {
  return (
    categoria.nomeCategoria ??
    categoria.nome ??
    categoria.descricaoCategoria ??
    categoria.descricao ??
    categoria.categoria ??
    categoria.titulo ??
    ""
  );
}

async function carregarCategoriasProduto() {
  try {
    const resposta = await fetch(API_CATEGORIAS_CADASTRO);
    const dados = await resposta.json();

    if (!resposta.ok || !Array.isArray(dados)) {
      throw new Error(
        dados?.erro || "Não foi possível carregar as categorias.",
      );
    }

    categoriasProduto = dados;

    campoCategoriaProduto.innerHTML = '<option value="">Sem categoria</option>';

    dados.forEach((categoria) => {
      const id = obterIdCategoria(categoria);
      const nome = obterNomeCategoria(categoria);

      if (id === "" || nome === "") {
        return;
      }

      const opcao = document.createElement("option");
      opcao.value = String(nome);
      opcao.textContent = nome;

      campoCategoriaProduto.appendChild(opcao);
    });
  } catch (erro) {
    console.error("Erro ao carregar categorias:", erro);
    mostrarMensagemProduto(
      "Não foi possível carregar as categorias. Confira a conexão com a API de categorias.",
    );
  }
}

function preencherCategoriaProduto(valorCategoria) {
  if (
    valorCategoria === "" ||
    valorCategoria === null ||
    valorCategoria === undefined
  ) {
    campoCategoriaProduto.value = "";
    return;
  }

  const valor = String(valorCategoria);

  let opcao = Array.from(campoCategoriaProduto.options).find(
    (item) => item.value === valor || item.textContent.trim() === valor,
  );

  if (!opcao) {
    const categoriaEncontrada = categoriasProduto.find(
      (item) =>
        String(obterIdCategoria(item)) === valor ||
        obterNomeCategoria(item).trim() === valor,
    );

    if (categoriaEncontrada) {
      opcao = Array.from(campoCategoriaProduto.options).find(
        (item) =>
          item.value === String(obterNomeCategoria(categoriaEncontrada)),
      );
    }
  }

  if (opcao) {
    campoCategoriaProduto.value = opcao.value;
  } else {
    const novaOpcao = document.createElement("option");
    novaOpcao.value = valor;
    novaOpcao.textContent = valor;
    campoCategoriaProduto.appendChild(novaOpcao);
    campoCategoriaProduto.value = valor;
  }
}

function preencherFormularioProduto(produto) {
  campoIdProduto.value = produto.id ?? "";
  campoNomeProduto.value = produto.nome ?? "";
  campoDescricaoProduto.value = produto.descricao ?? "";

  preencherCategoriaProduto(produto.categoria ?? "");

  campoCustoProduto.value = formatarCampoMoeda(produto.valor_custo ?? 0);
  campoVendaProduto.value = formatarCampoMoeda(produto.valor_venda ?? 0);
  produtoAtivoCadastro = Number(produto.ativo ?? 1) === 1;
}

function definirModoEdicaoProduto(ativo) {
  modoEdicaoProduto = ativo;
  campoIdProduto.readOnly = ativo;
  botaoExcluirProduto.textContent = "Excluir";
  botaoExcluirProduto.classList.remove("reativar");

  document.querySelector(".prod-topo h1").textContent = ativo
    ? "Editar Produto"
    : "Novo Produto";

  document.querySelector(".prod-topo .migalhas span:last-child").textContent =
    ativo ? "Editar produto" : "Novo produto";

  botaoSalvarProduto.textContent = ativo
    ? "Salvar alterações"
    : "Salvar produto";
}

async function consultarProdutoPorId(id, edicao = false) {
  if (!id || !/^\d+$/.test(String(id))) {
    Notificacao.atencao("Informe um código numérico válido.");
    return false;
  }

  try {
    const resposta = await fetch(
      `${API_PRODUTOS_CADASTRO}?id=${encodeURIComponent(id)}`,
    );

    const produto = await resposta.json();

    if (!resposta.ok || produto.erro) {
      produtoExistenteConsultado = false;

      return false;
    }

    preencherFormularioProduto(produto);
    produtoExistenteConsultado = true;

    definirModoEdicaoProduto(edicao);

    return true;
  } catch (erro) {
    console.error("Erro ao consultar produto:", erro);

    return false;
  }
}

campoIdProduto.addEventListener("keydown", async function (evento) {
  if (evento.key === "Enter") {
    evento.preventDefault();

    if (modoEdicaoProduto) {
      return;
    }

    const id = campoIdProduto.value.trim();

    if (id !== "") {
      await consultarProdutoPorId(id, false);
    }
  }
});

formularioProduto.addEventListener("submit", async function (evento) {
  evento.preventDefault();

  const nome = campoNomeProduto.value.trim();
  const descricao = campoDescricaoProduto.value.trim();
  const custoTexto = campoCustoProduto.value.trim();
  const vendaTexto = campoVendaProduto.value.trim();
  const codigoDigitado = campoIdProduto.value.trim();

  if (nome === "") {
    Notificacao.atencao("Informe o nome do produto.");
    campoNomeProduto.focus();
    return;
  }

  if (vendaTexto === "") {
    Notificacao.atencao("Informe o valor de venda.");
    campoVendaProduto.focus();
    return;
  }

  const valorVenda = converterValorProduto(vendaTexto);
  const valorCusto = converterValorProduto(custoTexto);

  if (valorVenda === null || !Number.isFinite(valorVenda) || valorVenda < 0) {
    Notificacao.atencao("Informe um valor de venda válido.");
    campoVendaProduto.focus();
    return;
  }

  if (
    custoTexto !== "" &&
    (valorCusto === null || !Number.isFinite(valorCusto) || valorCusto < 0)
  ) {
    Notificacao.atencao("Informe um valor de custo válido.");
    campoCustoProduto.focus();
    return;
  }

  // O ID é gerado automaticamente pelo banco ao cadastrar.
  // Se houver um código digitado em modo de cadastro, ele não pode ser reutilizado.
  if (!modoEdicaoProduto && codigoDigitado !== "") {
    let encontrado = produtoExistenteConsultado;

    if (!encontrado) {
      encontrado = await consultarProdutoPorId(codigoDigitado, false);
    }

    if (encontrado) {
      mostrarMensagemProduto(
        `O código ${codigoDigitado} já existe. Para alterar esse produto, use o botão Editar na listagem. Para cadastrar um novo produto, limpe o campo Código.`,
      );
    } else {
      mostrarMensagemProduto(
        `Não foi encontrado um produto com o código ${codigoDigitado}. Para cadastrar um produto novo, deixe o campo Código vazio, pois o banco gera o ID automaticamente.`,
      );
    }

    campoIdProduto.focus();
    return;
  }

  const categoriaSelecionada =
    campoCategoriaProduto.selectedOptions[0]?.textContent.trim() ?? "";

  const produto = {
    nome: nome,
    descricao: descricao || null,
    categoria:
      categoriaSelecionada === "Sem categoria" ? null : categoriaSelecionada,
    custo: valorCusto ?? 0,
    valor: valorVenda,
    preco: valorVenda,
  };

  botaoSalvarProduto.disabled = true;
  botaoSalvarProduto.textContent = modoEdicaoProduto
    ? "Salvando alterações..."
    : "Salvando...";

  try {
    const url = modoEdicaoProduto
      ? `${API_PRODUTOS_CADASTRO}?id=${encodeURIComponent(campoIdProduto.value)}`
      : API_PRODUTOS_CADASTRO;

    const resposta = await fetch(url, {
      method: modoEdicaoProduto ? "PUT" : "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(produto),
    });

    const dados = await resposta.json();

    if (resposta.status === 201 && !modoEdicaoProduto) {
      const novoId = dados.id;

      formularioProduto.reset();
      campoIdProduto.value = "";
      produtoExistenteConsultado = false;

      mostrarMensagemProduto(
        `Produto cadastrado com sucesso. Código: ${novoId}.`,
        true,
      );
    } else if (resposta.ok && modoEdicaoProduto) {
      mostrarMensagemProduto("Produto atualizado com sucesso.", true);
    } else {
      mostrarMensagemProduto(
        dados?.erro || "Não foi possível salvar o produto.",
      );
    }
  } catch (erro) {
    console.error("Erro ao salvar produto:", erro);
    mostrarMensagemProduto("Não foi possível conectar à API de produtos.");
  } finally {
    botaoSalvarProduto.disabled = false;
    botaoSalvarProduto.textContent = modoEdicaoProduto
      ? "Salvar alterações"
      : "Salvar produto";
  }
});

// Mesmo fluxo de exclusão utilizado no cadastro de clientes.
async function excluirProduto() {
  const codigo = campoIdProduto.value.trim();

  if (!/^\d+$/.test(codigo) || Number(codigo) <= 0) {
    Notificacao.atencao("Informe o código do produto para excluir");
    return;
  }

  // Um código digitado manualmente também pode ser excluído, desde que exista.
  const confirmado = await mostrarConfirmacao({
    titulo: "Excluir",
    mensagem: "Tem certeza que deseja excluir este produto?",
    textoSim: "Sim",
    textoNao: "Não",
    focoInicial: "nao",
  });

  if (!confirmado) {
    return;
  }

  botaoExcluirProduto.disabled = true;

  try {
    const resposta = await fetch(
      `${API_PRODUTOS_CADASTRO}?id=${encodeURIComponent(codigo)}`,
      { method: "DELETE" },
    );
    const dados = await resposta.json();

    if (!resposta.ok || dados.erro) {
      Notificacao.erro(dados.erro || "Erro ao excluir produto");
      return;
    }

    Notificacao.sucesso("Produto inativado com sucesso");
    formularioProduto.reset();
    campoIdProduto.value = "";
    produtoExistenteConsultado = false;
    produtoAtivoCadastro = true;

    definirModoEdicaoProduto(false);
  } catch (erro) {
    console.error("Erro ao excluir produto:", erro);
    Notificacao.erro("Não foi possível conectar ao servidor");
  } finally {
    botaoExcluirProduto.disabled = false;
  }
}

botaoExcluirProduto.addEventListener("click", excluirProduto);

document.getElementById("prod-limpar").addEventListener("click", function () {
  if (modoEdicaoProduto) {
    window.location.href = "produto_cadastro.php";
    return;
  }

  formularioProduto.reset();
  campoIdProduto.readOnly = false;
  produtoExistenteConsultado = false;

  definirModoEdicaoProduto(false);
});

async function iniciarCadastroProduto() {
  await carregarCategoriasProduto();

  const parametros = new URLSearchParams(window.location.search);
  const id = parametros.get("id");

  if (id) {
    await consultarProdutoPorId(id, true);
  } else {
    definirModoEdicaoProduto(false);
  }
}

aplicarMascaraMoeda(campoCustoProduto);
aplicarMascaraMoeda(campoVendaProduto);

const categoriaModal = document.getElementById("categoria-modal");
const categoriaForm = document.getElementById("categoria-form");
document.getElementById("categoria-abrir").addEventListener("click", () => {
  categoriaForm.reset();
  categoriaModal.showModal();
});
document
  .getElementById("categoria-cancelar")
  .addEventListener("click", () => categoriaModal.close());
categoriaForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const botao = document.getElementById("categoria-salvar");
  const codigo = codigoCategoria.value;
  const descricao = descricaoCategoria.value.trim();
  const editando = codigoCategoria.readOnly;
  if (codigo && !editando) {
    await consultarCodigoCategoria();
    return;
  }
  if (!descricao) {
    avisarCategoria("atencao", "Informe a descrição.");
    return;
  }
  botao.disabled = true;
  try {
    const resposta = await fetch(API_CATEGORIAS_CADASTRO, {
      method: editando ? "PUT" : "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ codigo, descricao }),
    });
    const dados = await resposta.json();
    if (!resposta.ok)
      throw new Error(dados.erro || "Erro ao cadastrar categoria.");
    categoriaModal.close();
    await carregarCategoriasProduto();
    preencherCategoriaProduto(dados.nome);
    Notificacao.sucesso(
      editando
        ? "Categoria alterada com sucesso."
        : "Categoria cadastrada com sucesso.",
    );
  } catch (erro) {
    avisarCategoria("erro", erro.message || "Erro ao cadastrar categoria.");
  } finally {
    botao.disabled = false;
  }
});
const listaModal = document.getElementById("categoria-lista-modal");
const pesquisaCategoria = document.getElementById("categoria-pesquisa");
const corpoCategorias = document.getElementById("categoria-lista-corpo");
const codigoCategoria = document.getElementById("categoria-codigo");
const descricaoCategoria = document.getElementById("categoria-descricao");
// Native dialogs are above body notifications; move the shared container temporarily.
function avisarCategoria(tipo, mensagem) {
  Notificacao[tipo](mensagem);
  const container = document.getElementById("notificacoes");
  if (container && categoriaModal.open) categoriaModal.appendChild(container);
}
categoriaModal.addEventListener("close", () => {
  const container = document.getElementById("notificacoes");
  if (container && categoriaModal.contains(container))
    document.body.appendChild(container);
});
function carregarCategoriaEdicao(c) {
  codigoCategoria.value = obterIdCategoria(c);
  descricaoCategoria.value = obterNomeCategoria(c);
  codigoCategoria.readOnly = true;
  descricaoCategoria.readOnly = false;
  document.getElementById("categoria-excluir").disabled = false;
  document.getElementById("categoria-salvar").textContent = "Salvar alterações";
  descricaoCategoria.focus();
}
let consultandoCategoria = false;
async function consultarCodigoCategoria() {
  if (consultandoCategoria || codigoCategoria.readOnly) return;
  const codigo = codigoCategoria.value.trim();
  if (!codigo) {
    descricaoCategoria.focus();
    return;
  }
  consultandoCategoria = true;
  try {
    const resposta = await fetch(
      `${API_CATEGORIAS_CADASTRO}?id=${encodeURIComponent(codigo)}`,
      { cache: "no-store" },
    );
    const dados = await resposta.json();
    if (!categoriaModal.open || codigoCategoria.value.trim() !== codigo) return;
    if (!resposta.ok) {
      descricaoCategoria.value = "";
      avisarCategoria(
        resposta.status === 404 ? "atencao" : "erro",
        dados.erro || "Erro ao consultar categoria.",
      );
      codigoCategoria.select();
      return;
    }
    carregarCategoriaEdicao(dados);
  } catch (erro) {
    avisarCategoria("erro", "Não foi possível consultar a categoria.");
  } finally {
    consultandoCategoria = false;
  }
}
codigoCategoria.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    consultarCodigoCategoria();
  }
});
function limparCategoria() {
  categoriaForm.reset();
  codigoCategoria.readOnly = false;
  document.getElementById("categoria-excluir").disabled = true;
  descricaoCategoria.readOnly = false;
  document.getElementById("categoria-salvar").textContent = "Salvar categoria";
  codigoCategoria.focus();
}
document
  .getElementById("categoria-abrir")
  .addEventListener("click", limparCategoria);
document
  .getElementById("categoria-limpar")
  .addEventListener("click", limparCategoria);
function renderizarCategorias() {
  const termo = pesquisaCategoria.value.trim().toLocaleLowerCase("pt-BR");
  corpoCategorias.replaceChildren();
  const itens = categoriasProduto.filter(
    (c) =>
      String(obterIdCategoria(c)).includes(termo) ||
      String(obterNomeCategoria(c)).toLocaleLowerCase("pt-BR").includes(termo),
  );
  for (const c of itens) {
    const linha = corpoCategorias.insertRow();
    linha.insertCell().textContent = obterIdCategoria(c);
    linha.insertCell().textContent = obterNomeCategoria(c);
    const botao = document.createElement("button");
    botao.type = "button";
    botao.className = "botao-cancelar";
    botao.textContent = "Selecionar";
    botao.addEventListener("click", () => {
      listaModal.close();
      carregarCategoriaEdicao(c);
    });
    linha.insertCell().append(botao);
  }
  if (!itens.length) {
    const celula = corpoCategorias.insertRow().insertCell();
    celula.colSpan = 3;
    celula.textContent = "Nenhuma categoria encontrada.";
  }
}
document.getElementById("categoria-consultar").addEventListener("click", () => {
  pesquisaCategoria.value = "";
  renderizarCategorias();
  listaModal.showModal();
  pesquisaCategoria.focus();
});
document
  .getElementById("categoria-lista-fechar")
  .addEventListener("click", () => listaModal.close());
pesquisaCategoria.addEventListener("input", renderizarCategorias);
iniciarCadastroProduto();

const botaoExcluirCategoria = document.getElementById("categoria-excluir");
botaoExcluirCategoria.addEventListener("click", async () => {
  if (!codigoCategoria.readOnly || botaoExcluirCategoria.disabled) return;
  const codigo = codigoCategoria.value;
  // Native confirmation remains visible above the open dialog.
  if (!window.confirm("Tem certeza que deseja excluir esta categoria?")) return;
  botaoExcluirCategoria.disabled = true;
  try {
    const resposta = await fetch(
      `${API_CATEGORIAS_CADASTRO}?id=${encodeURIComponent(codigo)}`,
      { method: "DELETE" },
    );
    const dados = await resposta.json();
    if (!resposta.ok)
      throw new Error(dados.erro || "Erro ao excluir categoria.");
    const selecao = campoCategoriaProduto.value;
    const removida = descricaoCategoria.value;
    limparCategoria();
    categoriaModal.close();
    await carregarCategoriasProduto();
    preencherCategoriaProduto(selecao === removida ? "" : selecao);
    Notificacao.sucesso("Categoria excluída com sucesso.");
  } catch (erro) {
    categoriaModal.close();
    Notificacao.erro(erro.message || "Não foi possível excluir a categoria.");
  } finally {
    botaoExcluirCategoria.disabled = !codigoCategoria.readOnly;
  }
});
