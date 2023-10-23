async function logTXT() {
    const response = await fetch("../server_status.txt");
    console.log(response.text());
  }

logTXT();