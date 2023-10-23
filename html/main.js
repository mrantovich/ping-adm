const servers = document.querySelector('.servers');

async function fetchingServersStatus() {
    const response = await fetch("../server_status.json");
    return response.json();
};

let serverNameTags = '<div class="servers__item"><div class="servers__name">';
let serverStatusTags = '<div class="servers__status">';
let closingTag = '</div>';

let changableServerData = "";

function formServerEntry(name, status) {
    serverString = serverNameTags + name + closingTag + serverStatusTags + status + closingTag + closingTag;
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
