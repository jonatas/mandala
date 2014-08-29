---
---

window.Mandalas = []
window.Editora =
  vr:
    nome: "V&R editora"
    razao_social: "Vergara & Riba Editora"
  isis:
    nome: "Isis"
    razao_social: "Editora Isis LTDA"

window.Livros =
  "1":
    nome: "Mandalas de bolso 1"
    total_mandalas: 41
    coloridas: 41
    abandonadas: 1
    contribuicoes:
      jonatas: 8
      cilene: 6
      hercilio: 1
      edi: 1
      ana_carla: 1
      carol: 1
      eliege: 4
      carolina: 1
      luane: 1
      tania: 2
      julia: 2
      sol: 1
      ari: 3
      leticia: 1
      mercia: 2
      angelica: 1
      irapua: 1
      vanice: 2
    autor: "Christian Pilastre"
    ano: 2006
    editora:  Editora.vr
    passou_por:
      PR: ["Francisco Beltrão"]
      SC: ["Florianópolis", "São Miguel do Oeste", "Anchieta"]
      RS: ["Passo Fundo"]

  "2":
    nome: "Mandalas de bolso 2"
    coloridas: 36
    autor: "Marie Pré"
    ano: 2008
    abandonadas: 0
    editora:  Editora.vr
    passou_por:
      PR: ["Francisco Beltrão"]
      SC: ["Florianópolis", "São Miguel do Oeste", "Anchieta"]

  "3":
    nome: "Mandalas de bolso 3"
    coloridas: 31
    autor: "Françoise Rougeau"
    ano: 2005
    editora: Editora.vr
    passou_por:
      PR: ["Francisco Beltrão"]
      SC: ["Florianópolis", "São Miguel do Oeste"]
    abandonadas: 2
    contribuicoes:
      jonatas: 6
      vanice: 2
      salete: 1
      tania: 1
      melissa: 16
      daise: 1
      david: 1
      ari: 1
      marco: 2

  "4":
    nome: "Mandalas de bolso 10"
    coloridas: 46
    autor: "Glória Falcón"
    ano: 2009
    editora:  Editora.vr
    passou_por:
      PR: ["Francisco Beltrão"]
    abandonadas: 0
    contribuicoes:
      jonatas: 1
      lorenzo: 1
      iran: 11
      debora: 2
      vanice: 12
      mari: 1
      jean: 2
      aline: 8
      eliege: 2
      charla: 1
      "iran, aline": 3
      "vanice, charla": 1
  "5":
    nome: "Mandalas de bolso 12"
    total_mandalas: 44
    coloridas: 25
    abandonadas: 2
    contribuicoes:
      cilene: 10
      irma: 1
      desire: 1
      isabela: 2
      cinara: 2
      sandra: 1
      sem_nome: 1
      pablo: 1
      ana_carla: 1
      julia: 1
      leila: 3
      "pablo, cilene": 1
    autor: "Christian Pilastre"
    ano: 2011
    editora:  Editora.vr
    passou_por:
      PR: ["Curitiba"]
      SP: ["Porangaba"]
      RS: ["Passo Fundo", "Palmeiras das Missões", "Porto Alegre", "Sarandi", "Carazinho"]

  "6":
    nome: "Mandalas de bolso 6 - Modernistas"
    coloridas: 18
    autor: "Montserrat Vidal"
    ano: 2009
    editora:  Editora.vr
    passou_por:
      PR: ["Francisco Beltrão", "Curitiba"]
      SC: ["São Miguel do Oeste"]
    abandonadas: 3
    contribuicoes:
      jonatas: 2
      vanice: 7
      edson: 1
      mercia: 2
      juliane: 1
      tania: 1
      brunna: 2
      eliege: 1

  "7":
    nome: "A Força das Mandalas"
    coloridas: 30
    autor: "Rashe Baguera"
    ano: 2014
    editora:  Editora.isis
    passou_por:
      PR: ["Francisco Beltrão", "Alagado de Nova Prata do Iguaçu", "Camping do Dário"]
    abandonadas: 5
    contribuicoes:
      clelia: 4
      mercia: 8
      edson: 1
      marco_aurelio: 3
      eliege: 2
      vanice: 3
      mister: 1
      joyce: 1
      mozi: 1
      sem_nome: 1
      eliege: 1
      ari: 2
      tuka: 1
      "doty, cintia, pati": 1
  "8":
    nome: "Mandalas da Espiritualidade"
    coloridas: 1
    autor: "Magela Borbagatto, Silvia Bigareli e Victor Menezes"
    ano: 2013
    editora:  Editora.isis
    passou_por:
      PR: ["Francisco Beltrão"]
      SC: ["Chapecó"]
    contribuicoes:
      sem_nome: 1
  "9":
    nome: "Mandalas Mágicas 1"
    coloridas: 9
    autor: "Magela Borbagatto, Silvia Bigareli e Victor Menezes"
    ano: 2013
    editora:  Editora.isis
    passou_por:
      PR: ["Francisco Beltrão"]
      SC: ["Chapecó"]
    contribuicoes:
      jonatas: 1
      tania: 1
      daiana: 1
      lauana: 1
      adriane: 1
      aglair: 1
      simone: 1
      claudia: 1
      arlete: 1

window.Pessoa = {}
window.Cidade = {}
window.Estado = {}
for dir, livro of Livros
  livro.mandalas = []
  livro.capa = 'mandalas/'+dir+'/capa.jpg'
  while livro.mandalas.length < livro.coloridas
    number = livro.mandalas.length + 1
    src = "mandalas/#{dir}/#{number}.jpg"
    livro.mandalas.push src: src, number: number
    Mandalas.push(src)

  for pessoa, quantidade of livro.contribuicoes
    if not Pessoa[pessoa]
      Pessoa[pessoa] = quantidade
    else
      Pessoa[pessoa] += quantidade

  for estado, cidades of livro.passou_por
    if not Estado[estado]
      Estado[estado] = 1
    else
      Estado[estado] += 1
    for cidade in cidades
      if not Cidade[cidade] 
        Cidade[cidade] = 1
      else
        Cidade[cidade] += 1

window.Estatisticas =
  mandalas_por:
    livro: ->
      for id, livro of Livros
        livro: livro.nome, mandalas: livro.coloridas
    pessoa: ->
      for pessoa, contribuicoes of Pessoa
        pessoa: pessoa, mandalas: contribuicoes

    cidade: ->
      for cidade, livros of Cidade
        cidade: cidade, livros: livros

    estado: ->
      for estado, livros of Estado
        estado: estado, livros: livros
  total:
    mandalas: Mandalas.length
    livros: Object.keys(Livros).length
    pessoas: Object.keys(Pessoa).length
    cidades: Object.keys(Cidade).length
    estados: Object.keys(Estado).length
    sem_nome: Pessoa["sem_nome"]
    abandonadas: (->
      total_abandonadas = 0
      for id, livro of Livros
        total_abandonadas += livro.abandonadas if livro.abandonadas
      total_abandonadas)()
