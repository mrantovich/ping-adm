// Выбираем элемент по классу, куда будет добавляться код со статусами серверов.
const servers = document.querySelector('.servers');

// Получаем данные из JSON-файла, который формируется скриптом.
// Возвращает JSON-объект.
async function fetchingServersStatus() {
    //const response = await fetch("./server_status.json");
    const response = await fetch("../server_status.json");
    return response.json();
};

// Шаблоны HTML для построения блока со статусами.
let serverNameOK = '<div class="servers__item"><div class="servers__name name__ok">';
let serverNameDown = '<div class="servers__item"><div class="servers__name name__down">';
let serverStatusOK = '<div class="servers__status">';
let serverStatusDown = '<div class="servers__status status__down">';
let closingTag = '</div>';

// Переменная, в которой хранятся полный HTML-код с данными о статусе серверов.
let changableServerData = "";

// Функция формирует HTML-код для отдельного сервера
// в зависимости от статуса.
// Возвращает сроку с HTML-кодом, который затем добавляется в changableServerData.
function formServerEntry(name, status, req) {
    if (status === "down"){
        serverString = serverNameDown + name + closingTag + serverStatusDown + status + ": " + req + closingTag + closingTag;
    }
    else {
        serverString = serverNameOK + name + closingTag + serverStatusOK + status + ": " + req + closingTag + closingTag;
    }
    return serverString;
};

// Проходит по JSON-файлу циклом, извлекая данные о статусе серверов.
// Формирует полный код блока с данными о статусе серверов.
// Этот код пишется в выбранный селектор (".servers").
function handleServerData(serverData) {
    arrayLength = serverData.length;
    for (let i=0; i<arrayLength; i++) {
        let name = serverData[i]["server"];
        let status = serverData[i]["status"];
        let req = serverData[i]["req"];
        changableServerData += formServerEntry(name, status, req);
    };
    servers.innerHTML = changableServerData;
};

// Получени и обработка данных через fetch-API.
let res = fetchingServersStatus();
res.then((data) => handleServerData(data));

// Установка данных о серверах.
// Очистка переменной, куда пишется код блока с данными о статусе серверов.
servers.innerHTML = changableServerData;
changableServerData = "";

// Цикл для автоматического обновления страницы,
// чтобы были видны изменения статуса.
//setTimeout(function(){
//    window.location.reload(1);
//}, 6000);

