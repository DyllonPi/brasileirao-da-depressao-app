<!doctype html>
<html lang="pt-BR">
<head>

<meta charset="utf-8">

<meta
    name="viewport"
    content="width=device-width,initial-scale=1">

<title>Brasileirão da Depressão</title>

<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<style>

*{
    box-sizing:border-box
}

body{
    margin:0;
    background:#fbfaf5;
    color:#171717;
    font-family:Arial,sans-serif
}

/* =========================================================
   LOGIN
========================================================= */

#loginScreen{
    position:fixed;
    inset:0;
    z-index:9999;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:24px;
    background:linear-gradient(145deg,#071b33,#0d3157);
    overflow-y:auto;
}

.login-card{
    width:100%;
    max-width:390px;
    padding:32px 28px;
    background:#fff;
    border-radius:24px;
    text-align:center;
    box-shadow:0 20px 60px rgba(0,0,0,.30);
}

.login-logo{
    width:120px;
    height:120px;
    object-fit:contain;
    display:block;
    margin:0 auto 18px;
}

.login-title{
    margin:0;
    color:#0b2340;
    font:700 27px Georgia,serif;
}

.login-subtitle{
    margin:10px 0 26px;
    color:#687789;
    font-size:15px;
    line-height:1.5;
}

.google-login-button{
    width:100%;
    min-height:52px;
    border:1px solid #dadce0;
    border-radius:12px;
    background:#fff;
    color:#202124;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    display:flex;
    align-items:center;
    justify-content:center;
    gap:12px;
    transition:.2s;
}

.google-login-button:active{
    transform:scale(.98);
}

.google-login-button:disabled{
    opacity:.7;
}

.google-icon{
    width:20px;
    height:20px;
}

.login-divider{
    display:flex;
    align-items:center;
    gap:12px;
    margin:20px 0;
    color:#9aa3ad;
    font-size:12px;
}

.login-divider::before,
.login-divider::after{
    content:"";
    flex:1;
    height:1px;
    background:#e1e4e7;
}

.create-account-button{
    width:100%;
    min-height:50px;
    border:0;
    border-radius:11px;
    background:#254aa5;
    color:#fff;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
    transition:.2s;
}

.create-account-button:active{
    transform:scale(.98);
}

.login-button{
    width:100%;
    min-height:50px;
    margin-top:4px;
    border:0;
    border-radius:11px;
    background:#254aa5;
    color:#fff;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
    transition:.2s;
}

.login-button:active{
    transform:scale(.98);
}

.login-button:disabled,
.create-account-button:disabled{
    opacity:.65;
    cursor:not-allowed;
}

.back-login-button{
    width:100%;
    margin-top:15px;
    padding:10px;
    border:0;
    background:transparent;
    color:#254aa5;
    font-size:13px;
    cursor:pointer;
}

.login-input{
    width:100%;
    height:48px;
    margin-bottom:11px;
    padding:0 14px;
    border:1px solid #d5d9dd;
    border-radius:10px;
    background:#fff;
    color:#202124;
    font-size:14px;
    outline:none;
}

.login-input:focus{
    border-color:#254aa5;
    box-shadow:0 0 0 2px rgba(37,74,165,.10);
}

.login-input::placeholder{
    color:#8a949f;
}

select.login-input{
    appearance:auto;
}

.register-error{
    min-height:17px;
    margin:2px 0 10px;
    color:#c62828;
    font-size:12px;
    line-height:1.4;
}

.register-success{
    min-height:17px;
    margin:2px 0 10px;
    color:#28755e;
    font-size:12px;
    line-height:1.4;
}

.login-footer{
    margin-top:22px;
    color:#8a96a3;
    font-size:12px;
}

/* =========================================================
   APLICATIVO
========================================================= */

.top{
    height:64px;
    padding:0 20px;
    display:flex;
    align-items:center;
    border-bottom:1px solid #d9ddd2;
    font-weight:700
}

.mark{
    display:grid;
    place-items:center;
    width:30px;
    height:30px;
    background:#254aa5;
    color:#e2c300;
    border-radius:50%;
    font:italic 20px Georgia;
    margin-right:9px
}

.hero{
    background:#254aa5;
    color:white;
    padding:35px 23px;
    margin:20px 16px 38px;
    position:relative;
    overflow:hidden;
    border:3px solid #e2c300;
    box-shadow:5px 5px 0 #171717
}

.hero:after{
    content:'';
    position:absolute;
    right:-15px;
    bottom:-53px;
    color:#28755e;
    font:bold 150px Georgia
}

.eyebrow{
    margin:0 0 8px;
    color:#e2c300;
    font:10px monospace;
    letter-spacing:1px
}

.hero h1{
    position:relative;
    margin:0;
    font:700 35px Georgia;
    line-height:.98
}

.hero h1 i{
    color:#e2c300
}

.intro{
    position:relative;
    color:#d5e4dc;
    font-size:14px;
    line-height:1.5;
    max-width:290px
}

.timer{
    position:relative;
    border:1px solid #a2c52f;
    padding:12px;
    margin-top:24px;
    font:11px monospace;
    color:#d5e4dc
}

.timer b{
    display:block;
    color:#e2c300;
    font-size:24px;
    margin:7px 0
}

.main{
    padding:0 16px 44px
}

.head{
    display:flex;
    justify-content:space-between;
    align-items:end;
    margin-bottom:17px
}

.head h2{
    margin:0;
    font:700 26px Georgia
}

.hint{
    font-size:10px;
    color:#667169;
    text-align:right;
    max-width:150px
}

.game{
    background:white;
    border:1px solid #d9ddd2;
    padding:15px;
    margin-bottom:11px
}

.meta{
    display:flex;
    justify-content:space-between;
    color:#667169;
    font:10px monospace
}

.teams{
    display:grid;
    grid-template-columns:1fr auto 1fr;
    gap:8px;
    align-items:center;
    margin:14px 0
}

.teams b:first-child{
    text-align:right
}

.teams span{
    font:10px monospace;
    color:#8a958c
}

.score{
    display:flex;
    justify-content:center;
    gap:7px;
    align-items:center
}

.score input{
    width:45px;
    height:39px;
    text-align:center;
    border:1px solid #c5cdc4;
    font:bold 17px monospace;
    color:#254aa5
}

.score input:focus{
    outline:none;
    border-color:#254aa5;
    box-shadow:0 0 0 2px rgba(37,74,165,.10)
}

.score input:disabled{
    background:#eef1ec;
    color:#68736b;
    cursor:not-allowed;
}

.guide{
    background:#e9eee3;
    color:#536057;
    font-size:11px;
    padding:13px;
    margin:19px 0 42px
}

.rank{
    border-top:1px solid #d9ddd2;
    padding-top:28px
}

.rank h2{
    margin:0 0 14px;
    font:700 26px Georgia
}

.row{
    display:flex;
    align-items:center;
    border-top:1px solid #d9ddd2;
    padding:13px 6px
}

.pos{
    width:28px;
    height:28px;
    border-radius:50%;
    background:#e7ece4;
    display:grid;
    place-items:center;
    margin-right:12px;
    font:12px monospace
}

.row:first-of-type .pos{
    background:#f5db71
}

.who{
    font-size:14px;
    font-weight:bold
}

.who small{
    display:block;
    font-weight:normal;
    color:#667169;
    font-size:10px;
    margin-top:3px
}

.pts{
    margin-left:auto;
    color:#254aa5;
    font:bold 16px monospace
}

.tiny-logo{
    width:35px;
    height:35px;
    object-fit:cover;
    border-radius:50%;
    margin-right:9px;
    border:2px solid #e2c300
}

.crest{
    display:block;
    width:106px;
    height:106px;
    object-fit:cover;
    border-radius:50%;
    margin:-7px auto 20px;
    border:3px solid #e2c300;
    box-shadow:4px 4px 0 #171717
}

.stats{
    border-top:1px solid #d7d3c2;
    margin-top:34px;
    padding-top:25px
}

.stats h2{
    font:700 26px Georgia
}

.stats input{
    width:100%;
    padding:10px;
    border:1px solid #d7d3c2;
    margin:12px 0
}

.mini-stats{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:7px
}

.mini-stats b{
    background:#254aa5;
    color:#fff;
    text-align:center;
    padding:12px;
    font:18px monospace;
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap
}

.mini-stats small{
    display:block;
    color:#e2c300;
    font:9px Arial;
    margin-top:5px
}

.stats p{
    font-size:11px;
    color:#5e5d58;
    line-height:1.4
}

.stats details{
    border-top:1px solid #d7d3c2;
    padding:11px 0;
    font-size:11px
}

.stats summary{
    font-weight:bold
}

.stats details p{
    margin:6px 0 0
}

.logout-button{
    display:none;
    position:fixed;
    top:70px;
    right:16px;
    z-index:100;
    padding:9px 13px;
    border:1px solid #d9ddd2;
    background:#fff;
    color:#254aa5;
    border-radius:9px;
    font-size:11px;
    font-weight:bold;
    cursor:pointer;
}

</style>

</head>

<body>


<!-- =========================================================
     TELA DE LOGIN
========================================================= -->

<div id="loginScreen">

<div class="login-card">

<img
    src="images/logo-azul.jpeg"
    class="login-logo"
    alt="Brasileirão da Depressão">


<div id="loginForm">

<h1 class="login-title">
    Brasileirão da Depressão
</h1>

<p class="login-subtitle">
    Entre para salvar seus palpites,<br>
    acompanhar o ranking e disputar com a galera.
</p>


<button
    type="button"
    id="googleLoginButton"
    class="google-login-button"
    onclick="loginGoogle()">

    <svg
        class="google-icon"
        viewBox="0 0 24 24"
        xmlns="http://www.w3.org/2000/svg">

        <path
            fill="#4285F4"
            d="M21.35 12.27c0-.79-.07-1.55-.22-2.27H12v4.3h5.24a4.48 4.48 0 0 1-1.94 2.94v2.45h3.14c1.84-1.69 2.91-4.18 2.91-7.42z"/>

        <path
            fill="#34A853"
            d="M12 21.5c2.63 0 4.84-.87 6.45-2.36l-3.14-2.45c-.87.58-1.98.93-3.31.93-2.55 0-4.71-1.72-5.49-4.03H3.27v2.53A9.74 9.74 0 0 0 12 21.5z"/>

        <path
            fill="#FBBC05"
            d="M6.51 13.59A5.86 5.86 0 0 1 6.2 12c0-.55.1-1.08.31-1.59V7.88H3.27A9.5 9.5 0 0 0 2.25 12c0 1.53.37 2.97 1.02 4.12l3.24-2.53z"/>

        <path
            fill="#EA4335"
            d="M12 6.38c1.43 0 2.71.49 3.72 1.46l2.79-2.79C16.83 3.47 14.63 2.5 12 2.5a9.74 9.74 0 0 0-8.73 5.38l3.24 2.53C7.29 8.1 9.45 6.38 12 6.38z"/>

    </svg>

    Continuar com Google

</button>


<div class="login-divider">
    <span>ou</span>
</div>


<input
    id="loginEmail"
    class="login-input"
    type="email"
    placeholder="Seu e-mail"
    autocomplete="email">


<input
    id="loginPassword"
    class="login-input"
    type="password"
    placeholder="Sua senha"
    autocomplete="current-password">


<p
    id="loginError"
    class="register-error">
</p>


<button
    type="button"
    id="loginButton"
    class="login-button"
    onclick="loginUser()">

    Entrar

</button>


<button
    type="button"
    class="create-account-button"
    style="margin-top:10px"
    onclick="showRegister()">

    Criar uma conta

</button>


<div class="login-footer">

    Seus dados de conta ficam armazenados com segurança no servidor.

</div>

</div>


<!-- =========================================================
     CADASTRO
========================================================= -->

<div
    id="registerForm"
    style="display:none">

<h1 class="login-title">
    Criar conta
</h1>

<p class="login-subtitle">
    Crie seu perfil e escolha seu clube do coração.
</p>


<form onsubmit="createAccount(event)">


<input
    id="registerEmail"
    class="login-input"
    type="email"
    placeholder="Seu e-mail"
    autocomplete="email"
    required>


<input
    id="registerPassword"
    class="login-input"
    type="password"
    placeholder="Senha"
    autocomplete="new-password"
    minlength="6"
    required>


<input
    id="registerPasswordConfirm"
    class="login-input"
    type="password"
    placeholder="Confirme sua senha"
    autocomplete="new-password"
    minlength="6"
    required>


<select
    id="registerClub"
    class="login-input"
    required>

<option value="">
    Clube do coração
</option>

<option value="Atlético-MG">Atlético-MG</option>
<option value="Athletico-PR">Athletico-PR</option>
<option value="Bahia">Bahia</option>
<option value="Botafogo">Botafogo</option>
<option value="Bragantino">Bragantino</option>
<option value="Chapecoense">Chapecoense</option>
<option value="Corinthians">Corinthians</option>
<option value="Coritiba">Coritiba</option>
<option value="Cruzeiro">Cruzeiro</option>
<option value="Flamengo">Flamengo</option>
<option value="Fluminense">Fluminense</option>
<option value="Grêmio">Grêmio</option>
<option value="Internacional">Internacional</option>
<option value="Mirassol">Mirassol</option>
<option value="Palmeiras">Palmeiras</option>
<option value="Remo">Remo</option>
<option value="Santos">Santos</option>
<option value="São Paulo">São Paulo</option>
<option value="Vasco">Vasco</option>
<option value="Vitória">Vitória</option>

</select>


<p
    id="registerError"
    class="register-error">
</p>


<p
    id="registerSuccess"
    class="register-success">
</p>


<button
    type="submit"
    id="registerButton"
    class="create-account-button">

    Criar minha conta

</button>


</form>


<button
    type="button"
    class="back-login-button"
    onclick="showLogin()">

    ← Voltar para o login

</button>

</div>

</div>

</div>


<!-- =========================================================
     APLICATIVO
========================================================= -->

<header class="top">

<span class="mark">
    B
</span>

Brasileirão da Depressão

</header>


<button
    id="logoutButton"
    class="logout-button"
    onclick="logoutUser()">

    Sair

</button>


<section class="hero">

<p
    class="eyebrow"
    id="heroEyebrow">

    CAMPEONATO BRASILEIRO · CARREGANDO...

</p>

<h1>
    Seus palpites,<br>
    <i>sua torcida.</i>
</h1>

<p class="intro">
    Acerte os placares, suba no ranking e prove que você entende de futebol.
</p>

<div class="timer">

<span id="timerLabel">
    PRÓXIMA RODADA
</span>

<b id="clock">
    ...
</b>

<span id="deadlineText">
    Carregando calendário...
</span>

</div>

</section>


<img
    class="crest"
    src="images/logo-azul.jpeg"
    alt="Logo">


<main class="main">


<div class="head">

<div>

<p
    class="eyebrow"
    style="color:#254aa5">

    SELECIONE OS PLACARES

</p>

<h2 id="roundTitle">
    Jogos da rodada
</h2>

</div>


<span
    id="status"
    class="hint">

    Conectando...

</span>

</div>


<div id="games"></div>


<p class="guide">

<b>Como pontuar:</b>

Resultado correto com mesmo saldo de gols = 2 pontos ·
Empate correto = 1 ponto ·
Placar exato = +1 ·
Placar exato com o clube do coração = +1

</p>


<section class="rank">

<p
    class="eyebrow"
    style="color:#254aa5">

DISPUTA ACIRRADA

</p>

<h2>
    Ranking da galera
</h2>


<div id="rankingList">

<div class="row">

<span class="pos">—</span>

<span class="who">
    Carregando...
    <small>Ranking</small>
</span>

<span class="pts">--</span>

</div>

</div>

</section>


<section class="stats">

<p
    class="eyebrow"
    style="color:#254aa5">

PALPITÔMETRO

</p>

<h2>
    Estatísticas
</h2>


<div id="aStats"></div>


<input
    id="aSearch"
    placeholder="Buscar participante">


<p id="aNote"></p>


<div id="aHistory"></div>

</section>

</main>


<script>

/* ============================================================
   CONFIGURAÇÃO SUPABASE
============================================================ */

const SUPABASE_URL =
    "https://molcumgrqhmefzdrkrsb.supabase.co";

const SUPABASE_PUBLISHABLE_KEY =
    "sb_publishable_QJ1lvq5gMu7zhfM3Efe4XQ_E1mpI85P";

const supabaseClient =
    window.supabase.createClient(
        SUPABASE_URL,
        SUPABASE_PUBLISHABLE_KEY
    );


/* ============================================================
   CONFIGURAÇÃO
============================================================ */

const TEMPORADA_ATUAL = 2026;


/*
 * NÃO existe rodada fixa.
 *
 * A aplicação descobre automaticamente
 * a rodada atual através do calendário.
 */


/* ============================================================
   ESTADO
============================================================ */

let currentUser = null;

let currentProfile = null;

let currentRound = null;

let calendarGames = [];

let saveTimers = {};


/* ============================================================
   ELEMENTOS
============================================================ */

const gamesElement =
    document.querySelector("#games");


/* ============================================================
   STATUS
============================================================ */

function setStatus(message){

    const element =
        document.getElementById("status");

    if(element){

        element.textContent = message;

    }

}


function setLoginError(message){

    const element =
        document.getElementById("loginError");

    if(element){

        element.textContent = message;

    }

}


function setRegisterError(message){

    const element =
        document.getElementById("registerError");

    if(element){

        element.textContent = message;

    }

}


function setRegisterSuccess(message){

    const element =
        document.getElementById("registerSuccess");

    if(element){

        element.textContent = message;

    }

}


/* ============================================================
   NORMALIZAÇÃO DE TIMES
============================================================ */

function normalizarTime(nome){

    if(!nome){

        return "";

    }

    return nome
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g,"")
        .toLowerCase()
        .trim();

}


/* ============================================================
   DATAS
============================================================ */

function criarDataLocal(data){

    if(!data){

        return null;

    }

    const dataObj =
        new Date(
            data + "T12:00:00"
        );

    if(
        Number.isNaN(
            dataObj.getTime()
        )
    ){

        return null;

    }

    return dataObj;

}


function formatarDataJogo(data){

    const dataObj =
        criarDataLocal(data);

    if(!dataObj){

        return "Data não definida";

    }

    return dataObj.toLocaleDateString(
        "pt-BR",
        {
            weekday:"short",
            day:"2-digit",
            month:"2-digit"
        }
    );

}


/* ============================================================
   ATUALIZAR INFORMAÇÕES DA RODADA
============================================================ */

function atualizarInformacoesRodada(){

    if(currentRound === null){

        return;

    }


    const heroEyebrow =
        document.getElementById(
            "heroEyebrow"
        );


    const roundTitle =
        document.getElementById(
            "roundTitle"
        );


    if(heroEyebrow){

        heroEyebrow.textContent =
            "CAMPEONATO BRASILEIRO · RODADA " +
            currentRound;

    }


    if(roundTitle){

        roundTitle.textContent =
            "Jogos da rodada " +
            currentRound;

    }


    const hero =
        document.querySelector(
            ".hero"
        );


    if(hero){

        hero.style.setProperty(
            "--round-number",
            "'" + currentRound + "'"
        );

    }

}


/* ============================================================
   TIMER / INFORMAÇÃO DA PRÓXIMA DATA
============================================================ */

function atualizarTimer(){

    const clock =
        document.getElementById(
            "clock"
        );

    const deadlineText =
        document.getElementById(
            "deadlineText"
        );

    const timerLabel =
        document.getElementById(
            "timerLabel"
        );


    if(!calendarGames.length){

        if(clock){

            clock.textContent = "...";

        }

        if(deadlineText){

            deadlineText.textContent =
                "Nenhum jogo disponível";

        }

        return;

    }


    const jogosAbertos =
        calendarGames.filter(
            jogo =>
                String(
                    jogo.status || ""
                ).toLowerCase() !==
                "finished"
        );


    if(jogosAbertos.length === 0){

        if(timerLabel){

            timerLabel.textContent =
                "RODADA ENCERRADA";

        }

        if(clock){

            clock.textContent =
                "✓";

        }

        if(deadlineText){

            deadlineText.textContent =
                "A próxima rodada será carregada automaticamente.";

        }

        return;

    }


    const datas =
        jogosAbertos
            .map(
                jogo =>
                    criarDataLocal(
                        jogo.data_prevista
                    )
            )
            .filter(Boolean)
            .sort(
                (a,b) =>
                    a.getTime() -
                    b.getTime()
            );


    if(!datas.length){

        if(timerLabel){

            timerLabel.textContent =
                "PALPITES ABERTOS";

        }

        if(clock){

            clock.textContent =
                "ABERTA";

        }

        if(deadlineText){

            deadlineText.textContent =
                "Data dos jogos ainda não definida.";

        }

        return;

    }


    const primeiraData =
        datas[0];


    if(timerLabel){

        timerLabel.textContent =
            "PRÓXIMA DATA DE JOGO";

    }


    if(clock){

        clock.textContent =
            primeiraData.toLocaleDateString(
                "pt-BR",
                {
                    day:"2-digit",
                    month:"2-digit",
                    year:"numeric"
                }
            );

    }


    if(deadlineText){

        deadlineText.textContent =
            "Os jogos são carregados automaticamente do calendário.";

    }

}


/* ============================================================
   LOGIN / CADASTRO
============================================================ */

function showLogin(){

    document
        .getElementById("registerForm")
        .style.display = "none";

    document
        .getElementById("loginForm")
        .style.display = "block";

    setRegisterError("");

    setRegisterSuccess("");

    setLoginError("");

}


function showRegister(){

    document
        .getElementById("loginForm")
        .style.display = "none";

    document
        .getElementById("registerForm")
        .style.display = "block";

    setRegisterError("");

    setRegisterSuccess("");

}


/* ============================================================
   CRIAR CONTA
============================================================ */

async function createAccount(event){

    event.preventDefault();


    const email =
        document
            .getElementById("registerEmail")
            .value
            .trim()
            .toLowerCase();


    const password =
        document
            .getElementById("registerPassword")
            .value;


    const confirmation =
        document
            .getElementById("registerPasswordConfirm")
            .value;


    const club =
        document
            .getElementById("registerClub")
            .value;


    const button =
        document
            .getElementById("registerButton");


    setRegisterError("");

    setRegisterSuccess("");


    if(
        !email ||
        !password ||
        !confirmation ||
        !club
    ){

        setRegisterError(
            "Preencha todos os campos."
        );

        return;

    }


    if(password.length < 6){

        setRegisterError(
            "A senha deve ter pelo menos 6 caracteres."
        );

        return;

    }


    if(password !== confirmation){

        setRegisterError(
            "As senhas não coincidem."
        );

        return;

    }


    button.disabled = true;

    button.textContent =
        "Criando conta...";


    try{

        const {
            data,
            error
        } =
            await supabaseClient.auth.signUp({

                email:email,

                password:password,

                options:{
                    data:{
                        clube:club
                    }
                }

            });


        if(error){

            console.error(
                "Erro Supabase:",
                error
            );


            let message =
                error.message ||
                "Não foi possível criar a conta.";


            if(
                message
                    .toLowerCase()
                    .includes("already registered")
            ){

                message =
                    "Este e-mail já está cadastrado.";

            }


            setRegisterError(message);

            return;

        }


        if(
            data &&
            data.user
        ){

            setRegisterSuccess(
                "Conta criada com sucesso!"
            );


            document
                .getElementById("registerPassword")
                .value = "";


            document
                .getElementById("registerPasswordConfirm")
                .value = "";


            setTimeout(
                function(){

                    showLogin();


                    document
                        .getElementById("loginEmail")
                        .value = email;


                    document
                        .getElementById("loginPassword")
                        .focus();

                },
                800
            );

        }


    }catch(error){

        console.error(
            "Erro inesperado:",
            error
        );


        setRegisterError(
            "Erro ao conectar ao servidor."
        );


    }finally{

        button.disabled = false;

        button.textContent =
            "Criar minha conta";

    }

}


/* ============================================================
   LOGIN
============================================================ */

async function loginUser(){

    const email =
        document
            .getElementById("loginEmail")
            .value
            .trim()
            .toLowerCase();


    const password =
        document
            .getElementById("loginPassword")
            .value;


    const button =
        document
            .getElementById("loginButton");


    setLoginError("");


    if(
        !email ||
        !password
    ){

        setLoginError(
            "Digite seu e-mail e sua senha."
        );

        return;

    }


    button.disabled = true;

    button.textContent =
        "Entrando...";


    try{

        const {
            data,
            error
        } =
            await supabaseClient.auth.signInWithPassword({

                email:email,

                password:password

            });


        if(error){

            console.error(
                "Erro de login:",
                error
            );


            setLoginError(
                "E-mail ou senha incorretos."
            );

            return;

        }


        if(!data.user){

            setLoginError(
                "Não foi possível iniciar a sessão."
            );

            return;

        }


        currentUser =
            data.user;


        await entrarNoAplicativo();


    }catch(error){

        console.error(
            "Erro:",
            error
        );


        setLoginError(
            "Erro ao conectar ao servidor."
        );


    }finally{

        button.disabled = false;

        button.textContent =
            "Entrar";

    }

}


/* ============================================================
   GOOGLE
============================================================ */

async function loginGoogle(){

    const button =
        document.getElementById(
            "googleLoginButton"
        );


    button.disabled = true;

    button.textContent =
        "Conectando...";


    try{

        const {
            error
        } =
            await supabaseClient.auth.signInWithOAuth({

                provider:"google",

                options:{
                    redirectTo:
                        window.location.href
                }

            });


        if(error){

            console.error(
                "Google OAuth:",
                error
            );


            setLoginError(
                "Não foi possível iniciar o login com Google."
            );

        }


    }catch(error){

        console.error(
            error
        );


        setLoginError(
            "Erro ao conectar com o Google."
        );


    }finally{

        button.disabled = false;

        button.innerHTML = `
            <svg
                class="google-icon"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg">

                <path
                    fill="#4285F4"
                    d="M21.35 12.27c0-.79-.07-1.55-.22-2.27H12v4.3h5.24a4.48 4.48 0 0 1-1.94 2.94v2.45h3.14c1.84-1.69 2.91-4.18 2.91-7.42z"/>

                <path
                    fill="#34A853"
                    d="M12 21.5c2.63 0 4.84-.87 6.45-2.36l-3.14-2.45c-.87.58-1.98.93-3.31.93-2.55 0-4.71-1.72-5.49-4.03H3.27v2.53A9.74 9.74 0 0 0 12 21.5z"/>

                <path
                    fill="#FBBC05"
                    d="M6.51 13.59A5.86 5.86 0 0 1 6.2 12c0-.55.1-1.08.31-1.59V7.88H3.27A9.5 9.5 0 0 0 2.25 12c0 1.53.37 2.97 1.02 4.12l3.24-2.53z"/>

                <path
                    fill="#EA4335"
                    d="M12 6.38c1.43 0 2.71.49 3.72 1.46l2.79-2.79C16.83 3.47 14.63 2.5 12 2.5a9.74 9.74 0 0 0-8.73 5.38l3.24 2.53C7.29 8.1 9.45 6.38 12 6.38z"/>

            </svg>

            Continuar com Google
        `;

    }

}


/* ============================================================
   PERFIL
============================================================ */

async function loadCurrentProfile(){

    if(!currentUser){

        return;

    }


    try{

        const {
            data,
            error
        } =
            await supabaseClient
                .from("profiles")
                .select("*")
                .eq(
                    "id",
                    currentUser.id
                )
                .maybeSingle();


        if(error){

            console.error(
                "Erro ao carregar perfil:",
                error
            );

            return;

        }


        currentProfile =
            data || null;


    }catch(error){

        console.error(
            error
        );

    }

}


/* ============================================================
   ENTRAR NO APLICATIVO
============================================================ */

async function entrarNoAplicativo(){

    await loadCurrentProfile();


    document
        .getElementById("loginScreen")
        .style.display = "none";


    document
        .getElementById("logoutButton")
        .style.display = "block";


    document
        .getElementById("loginPassword")
        .value = "";


    setStatus(
        "✓ Sessão ativa: " +
        currentUser.email
    );


    await carregarDadosAplicativo();

}


/* ============================================================
   SAIR
============================================================ */

async function logoutUser(){

    try{

        await supabaseClient.auth.signOut();

    }catch(error){

        console.error(
            error
        );

    }


    currentUser = null;

    currentProfile = null;

    currentRound = null;

    calendarGames = [];


    document
        .getElementById("logoutButton")
        .style.display = "none";


    document
        .getElementById("loginScreen")
        .style.display = "flex";


    setLoginError("");

    setStatus(
        "✓ Faça login para continuar"
    );

}


/* ============================================================
   CARREGAR CALENDÁRIO
============================================================ */

async function loadCalendar(){

    setStatus(
        "Carregando calendário..."
    );


    try{

        const {
            data,
            error
        } =
            await supabaseClient
                .from("calendario_brasileirao")
                .select(`
                    ref_cbf,
                    rodada,
                    mandante,
                    visitante,
                    data_prevista,
                    status,
                    resultado_mandante,
                    resultado_visitante
                `)
                .eq(
                    "temporada",
                    TEMPORADA_ATUAL
                )
                .order(
                    "rodada",
                    {
                        ascending:true
                    }
                )
                .order(
                    "data_prevista",
                    {
                        ascending:true
                    }
                )
                .order(
                    "ref_cbf",
                    {
                        ascending:true
                    }
                );


        if(error){

            console.error(
                "Erro ao carregar calendário:",
                error
            );


            gamesElement.innerHTML = `
                <div class="game">

                    <b>
                        Não foi possível carregar o calendário.
                    </b>

                    <p
                        style="font-size:11px;color:#667169">

                        Verifique sua conexão e tente novamente.

                    </p>

                </div>
            `;


            setStatus(
                "⚠ Erro ao carregar calendário"
            );


            return;

        }


        if(
            !data ||
            data.length === 0
        ){

            gamesElement.innerHTML = `
                <div class="game">

                    <b>
                        Nenhum jogo encontrado.
                    </b>

                    <p
                        style="font-size:11px;color:#667169">

                        O calendário ainda não foi cadastrado.

                    </p>

                </div>
            `;


            setStatus(
                "⚠ Calendário vazio"
            );


            return;

        }


        /*
         * Agrupa os jogos por rodada.
         */

        const rodadas = {};


        data.forEach(
            jogo => {

                const rodada =
                    Number(jogo.rodada);


                if(
                    !rodadas[rodada]
                ){

                    rodadas[rodada] = [];

                }


                rodadas[rodada].push(
                    jogo
                );

            }
        );


        const numerosRodadas =
            Object.keys(rodadas)
                .map(Number)
                .sort(
                    (a,b) =>
                        a - b
                );


        /*
         * Procura a primeira rodada que ainda
         * possui pelo menos um jogo aberto.
         */

        currentRound = null;


        for(
            const rodada of numerosRodadas
        ){

            const jogos =
                rodadas[rodada];


            const possuiJogoAberto =
                jogos.some(
                    jogo =>
                        String(
                            jogo.status || ""
                        ).toLowerCase() !==
                        "finished"
                );


            if(possuiJogoAberto){

                currentRound =
                    rodada;

                break;

            }

        }


        /*
         * Se todas estiverem finalizadas,
         * utiliza a última rodada cadastrada.
         */

        if(currentRound === null){

            currentRound =
                numerosRodadas[
                    numerosRodadas.length - 1
                ];

        }


        calendarGames =
            rodadas[currentRound] || [];


        /*
         * Ordena os jogos por data e REF CBF.
         */

        calendarGames.sort(
            (a,b) => {

                const dataA =
                    criarDataLocal(
                        a.data_prevista
                    );

                const dataB =
                    criarDataLocal(
                        b.data_prevista
                    );


                if(
                    dataA &&
                    dataB
                ){

                    const diferenca =
                        dataA.getTime() -
                        dataB.getTime();


                    if(diferenca !== 0){

                        return diferenca;

                    }

                }


                return (
                    Number(a.ref_cbf || 0) -
                    Number(b.ref_cbf || 0)
                );

            }
        );


        atualizarInformacoesRodada();

        atualizarTimer();

        renderGames();


        setStatus(
            "✓ Rodada " +
            currentRound +
            " carregada · " +
            calendarGames.length +
            " jogos"
        );


    }catch(error){

        console.error(
            "Erro inesperado ao carregar calendário:",
            error
        );


        setStatus(
            "⚠ Erro de conexão"
        );

    }

}


/* ============================================================
   RENDERIZAR JOGOS
============================================================ */

function renderGames(){

    if(!gamesElement){

        return;

    }


    if(
        !calendarGames.length
    ){

        gamesElement.innerHTML = `
            <div class="game">

                <b>
                    Nenhum jogo encontrado para esta rodada.
                </b>

            </div>
        `;

        return;

    }


    gamesElement.innerHTML =
        calendarGames
            .map(
                (game,index) => {

                    const finalizado =
                        String(
                            game.status || ""
                        ).toLowerCase() ===
                        "finished";


                    const temResultado =
                        game.resultado_mandante !== null &&
                        game.resultado_visitante !== null;


                    const placarReal =
                        finalizado &&
                        temResultado
                            ? `

                                <div
                                    style="
                                        margin-top:9px;
                                        text-align:center;
                                        font:11px monospace;
                                        color:#28755e;
                                    ">

                                    RESULTADO:

                                    <b>
                                        ${game.resultado_mandante}
                                        x
                                        ${game.resultado_visitante}
                                    </b>

                                </div>

                              `
                            : "";


                    return `

                        <article
                            class="game"
                            data-ref="${game.ref_cbf}">

                            <div class="meta">

                                <span>
                                    ${formatarDataJogo(
                                        game.data_prevista
                                    )}
                                </span>

                                <span>
                                    RODADA ${currentRound}
                                </span>

                            </div>


                            <div class="teams">

                                <b>
                                    ${game.mandante}
                                </b>

                                <span>
                                    VS
                                </span>

                                <b>
                                    ${game.visitante}
                                </b>

                            </div>


                            <div class="score">

                                <input
                                    data-i="${index}"
                                    data-s="h"
                                    type="number"
                                    min="0"
                                    max="20"
                                    step="1"
                                    inputmode="numeric"
                                    placeholder="–"
                                    ${finalizado ? "disabled" : ""}>


                                <span>
                                    –
                                </span>


                                <input
                                    data-i="${index}"
                                    data-s="a"
                                    type="number"
                                    min="0"
                                    max="20"
                                    step="1"
                                    inputmode="numeric"
                                    placeholder="–"
                                    ${finalizado ? "disabled" : ""}>

                            </div>


                            ${placarReal}

                        </article>

                    `;

                }
            )
            .join("");


    attachPredictionEvents();

}


/* ============================================================
   CARREGAR PALPITES
============================================================ */

async function loadUserPredictions(){

    if(!currentUser){

        return;

    }


    if(
        currentRound === null ||
        !calendarGames.length
    ){

        return;

    }


    try{

        const {
            data,
            error
        } =
            await supabaseClient
                .from("palpites")
                .select("*")
                .eq(
                    "user_id",
                    currentUser.id
                )
                .eq(
                    "rodada",
                    currentRound
                );


        if(error){

            console.error(
                "Erro ao carregar palpites:",
                error
            );

            return;

        }


        if(!data){

            return;

        }


        data.forEach(
            prediction => {

                const index =
                    calendarGames.findIndex(
                        game =>

                            normalizarTime(
                                game.mandante
                            ) ===
                            normalizarTime(
                                prediction.mandante
                            )

                            &&

                            normalizarTime(
                                game.visitante
                            ) ===
                            normalizarTime(
                                prediction.visitante
                            )
                    );


                /*
                 * Palpites antigos que não correspondem
                 * ao calendário atual são simplesmente
                 * ignorados na tela.
                 *
                 * Eles continuam no banco/histórico.
                 */

                if(index < 0){

                    console.warn(
                        "Palpite fora do calendário atual:",
                        prediction.mandante,
                        prediction.visitante
                    );

                    return;

                }


                const home =
                    document.querySelector(
                        `.score input[data-i="${index}"][data-s="h"]`
                    );


                const away =
                    document.querySelector(
                        `.score input[data-i="${index}"][data-s="a"]`
                    );


                if(home){

                    home.value =
                        prediction.palpite_mandante ?? "";

                }


                if(away){

                    away.value =
                        prediction.palpite_visitante ?? "";

                }

            }
        );


    }catch(error){

        console.error(
            "Erro ao carregar palpites:",
            error
        );

    }

}


/* ============================================================
   VALIDAR PLACAR
============================================================ */

function validarPlacar(valor){

    if(
        valor === null ||
        valor === undefined ||
        valor === ""
    ){

        return false;

    }


    const numero =
        Number(valor);


    return (
        Number.isInteger(numero) &&
        numero >= 0 &&
        numero <= 20
    );

}


/* ============================================================
   SALVAR PALPITE
============================================================ */

async function savePrediction(index){

    if(!currentUser){

        setStatus(
            "⚠ Faça login para salvar seus palpites"
        );

        return;

    }


    const game =
        calendarGames[index];


    if(!game){

        return;

    }


    /*
     * Nunca permite alterar um jogo finalizado.
     */

    if(
        String(
            game.status || ""
        ).toLowerCase() ===
        "finished"
    ){

        return;

    }


    const homeInput =
        document.querySelector(
            `.score input[data-i="${index}"][data-s="h"]`
        );


    const awayInput =
        document.querySelector(
            `.score input[data-i="${index}"][data-s="a"]`
        );


    if(
        !homeInput ||
        !awayInput
    ){

        return;

    }


    const homeValue =
        homeInput.value === ""
            ? null
            : Number(homeInput.value);


    const awayValue =
        awayInput.value === ""
            ? null
            : Number(awayInput.value);


    if(
        !validarPlacar(homeValue) ||
        !validarPlacar(awayValue)
    ){

        setStatus(
            "⚠ Digite um placar entre 0 e 20"
        );

        return;

    }


    try{

        const {
            error
        } =
            await supabaseClient
                .from("palpites")
                .upsert(
                    {

                        user_id:
                            currentUser.id,

                        rodada:
                            currentRound,

                        data_jogo:
                            game.data_prevista,

                        mandante:
                            game.mandante,

                        visitante:
                            game.visitante,

                        palpite_mandante:
                            homeValue,

                        palpite_visitante:
                            awayValue,

                        updated_at:
                            new Date().toISOString()

                    },
                    {

                        onConflict:
                            "user_id,rodada,mandante,visitante"

                    }
                );


        if(error){

            console.error(
                "Erro ao salvar palpite:",
                error
            );


            setStatus(
                "⚠ Não foi possível salvar"
            );


            return;

        }


        setStatus(
            "✓ Palpite da Rodada " +
            currentRound +
            " salvo"
        );


    }catch(error){

        console.error(
            "Erro inesperado:",
            error
        );


        setStatus(
            "⚠ Erro de conexão"
        );

    }

}


/* ============================================================
   EVENTOS DOS PALPITES
============================================================ */

function attachPredictionEvents(){

    document
        .querySelectorAll(
            ".score input:not([disabled])"
        )
        .forEach(
            element => {

                element.addEventListener(
                    "input",
                    function(){

                        if(
                            this.value !== "" &&
                            Number(this.value) > 20
                        ){

                            this.value = "20";

                        }


                        if(
                            this.value !== "" &&
                            Number(this.value) < 0
                        ){

                            this.value = "0";

                        }


                        const index =
                            Number(
                                this.dataset.i
                            );


                        clearTimeout(
                            saveTimers[index]
                        );


                        saveTimers[index] =
                            setTimeout(
                                function(){

                                    savePrediction(index);

                                },
                                500
                            );

                    }
                );

            }
        );

}


/* ============================================================
   NOME DO PARTICIPANTE
============================================================ */

function participantName(email){

    if(!email){

        return "Participante";

    }


    return email
        .split("@")[0]
        .replace(/[._-]/g," ");

}


/* ============================================================
   ESTATÍSTICAS
============================================================ */

async function loadStatistics(){

    const statsElement =
        document.querySelector(
            "#aStats"
        );


    const historyElement =
        document.querySelector(
            "#aHistory"
        );


    if(!currentUser){

        return;

    }


    try{

        const {
            data,
            error
        } =
            await supabaseClient
                .from("palpites")
                .select("*")
                .eq(
                    "user_id",
                    currentUser.id
                )
                .order(
                    "rodada",
                    {
                        ascending:false
                    }
                );


        if(error){

            console.error(
                "Erro nas estatísticas:",
                error
            );

            return;

        }


        const predictions =
            data || [];


        const {
            data:scoreData,
            error:scoreError
        } =
            await supabaseClient
                .from("pontuacoes")
                .select(
                    "rodada,pontos"
                )
                .eq(
                    "user_id",
                    currentUser.id
                );


        if(scoreError){

            console.error(
                "Erro nas pontuações:",
                scoreError
            );

        }


        const scores =
            scoreData || [];


        const totalPoints =
            scores.reduce(
                (total,item) =>
                    total +
                    Number(
                        item.pontos || 0
                    ),
                0
            );


        statsElement.innerHTML = `

            <div class="mini-stats">

                <b>

                    ${predictions.length}

                    <small>
                        palpites
                    </small>

                </b>


                <b>

                    ${
                        currentProfile &&
                        currentProfile.clube
                            ? currentProfile.clube
                            : "—"
                    }

                    <small>
                        clube
                    </small>

                </b>


                <b>

                    ${totalPoints}

                    <small>
                        pontos
                    </small>

                </b>

            </div>

        `;


        document
            .getElementById("aNote")
            .textContent =
                "Seus palpites e pontuações estão sincronizados com o banco online.";


        historyElement.innerHTML =
            predictions
                .map(
                    prediction => `

                    <details>

                        <summary>

                            Rodada
                            ${prediction.rodada}

                            ·

                            ${prediction.mandante}

                            x

                            ${prediction.visitante}

                        </summary>


                        <p>

                            Palpite:

                            <b>
                                ${prediction.palpite_mandante}
                                x
                                ${prediction.palpite_visitante}
                            </b>

                        </p>

                    </details>

                `
                )
                .join("");


    }catch(error){

        console.error(
            "Erro nas estatísticas:",
            error
        );

    }

}


/* ============================================================
   RANKING
============================================================ */

async function loadRanking(){

    const rankingElement =
        document.getElementById(
            "rankingList"
        );


    /*
     * A RLS atual da tabela pontuacoes permite
     * que cada participante veja apenas suas
     * próprias pontuações.
     *
     * Portanto, não mostramos pontuação falsa
     * dos demais participantes.
     */

    if(!currentUser){

        rankingElement.innerHTML = `
            <div class="row">

                <span class="who">

                    Faça login para visualizar sua pontuação.

                    <small>
                        Ranking
                    </small>

                </span>

            </div>
        `;

        return;

    }


    try{

        const {
            data,
            error
        } =
            await supabaseClient
                .from("pontuacoes")
                .select(
                    "rodada,pontos"
                )
                .eq(
                    "user_id",
                    currentUser.id
                );


        if(error){

            console.error(
                "Erro no ranking:",
                error
            );


            rankingElement.innerHTML = `
                <div class="row">

                    <span class="who">

                        Pontuação indisponível.

                        <small>
                            Tente novamente.
                        </small>

                    </span>

                </div>
            `;

            return;

        }


        const total =
            (data || []).reduce(
                (sum,item) =>
                    sum +
                    Number(
                        item.pontos || 0
                    ),
                0
            );


        rankingElement.innerHTML = `

            <div class="row">

                <span class="pos">
                    —
                </span>


                <span class="who">

                    ${participantName(
                        currentUser.email
                    )}

                    <small>
                        ${
                            currentProfile &&
                            currentProfile.clube
                                ? currentProfile.clube
                                : "Participante"
                        }
                    </small>

                </span>


                <span class="pts">
                    ${total}
                </span>

            </div>

        `;


    }catch(error){

        console.error(
            error
        );

    }

}


/* ============================================================
   BUSCA NO HISTÓRICO
============================================================ */

document
    .getElementById("aSearch")
    .addEventListener(
        "input",
        function(){

            const value =
                this.value
                    .toLowerCase()
                    .trim();


            document
                .querySelectorAll(
                    "#aHistory details"
                )
                .forEach(
                    item => {

                        item.style.display =
                            item.textContent
                                .toLowerCase()
                                .includes(value)
                                    ? ""
                                    : "none";

                    }
                );

        }
    );


/* ============================================================
   CARREGAR DADOS DO APLICATIVO
============================================================ */

async function carregarDadosAplicativo(){

    await loadCalendar();

    await loadUserPredictions();

    await loadStatistics();

    await loadRanking();

}


/* ============================================================
   INICIALIZAÇÃO
============================================================ */

async function initializeApp(){

    setStatus(
        "Conectando ao servidor..."
    );


    try{

        const {
            data
        } =
            await supabaseClient.auth.getSession();


        if(
            data &&
            data.session &&
            data.session.user
        ){

            currentUser =
                data.session.user;


            await entrarNoAplicativo();


        }else{

            /*
             * O calendário pode ser carregado
             * mesmo antes do login.
             */

            await loadCalendar();


            setStatus(
                "Faça login para continuar"
            );

        }


    }catch(error){

        console.error(
            "Erro na inicialização:",
            error
        );


        setStatus(
            "⚠ Não foi possível conectar ao servidor"
        );

    }


    /*
     * Mantém a sessão sincronizada.
     */

    supabaseClient.auth.onAuthStateChange(
        async (event,session) => {

            if(
                event === "SIGNED_IN" &&
                session
            ){

                currentUser =
                    session.user;


                await entrarNoAplicativo();

            }


            if(
                event === "SIGNED_OUT"
            ){

                currentUser = null;

                currentProfile = null;

                currentRound = null;

                calendarGames = [];


                document
                    .getElementById("loginScreen")
                    .style.display = "flex";


                document
                    .getElementById("logoutButton")
                    .style.display = "none";

            }

        }
    );

}


initializeApp();

</script>

</body>
</html>