// Выбираем элемент по классу, куда будет добавляться код со статусами серверов.
const servers = document.querySelector('.servers');

async function fetchingServersStatus() {
    const response = await fetch("./server_status.json");
    return response.json();
};

let serverNameOK = '<div class="servers__item"><div class="servers__name name__ok">';
let serverNameDown = '<div class="servers__item"><div class="servers__name name__down">';
let serverStatusOK = '<div class="servers__status">';
let serverStatusDown = '<div class="servers__status status__down">';
let closingTag = '</div>';

let changableServerData = "";

function formServerEntry(name, status) {
    if (status === "down"){
        serverString = serverNameDown + name + closingTag + serverStatusDown + status + closingTag + closingTag;
    }
    else {
        serverString = serverNameOK + name + closingTag + serverStatusOK + status + closingTag + closingTag;
    }
    return serverString;
};

function handleServerData(serverData) {
    arrayLength = serverData.length;
    for (let i=0; i<arrayLength; i++) {
        let name = serverData[i]["server"];
        let status = serverData[i]["status"];
        changableServerData += formServerEntry(name, status);
    };
    servers.innerHTML = changableServerData;
};

let res = fetchingServersStatus();
res.then((data) => handleServerData(data));

servers.innerHTML = changableServerData;
changableServerData = "";

setTimeout(function(){
    window.location.reload(1);
}, 6000);

