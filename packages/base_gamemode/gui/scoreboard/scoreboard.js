// Default table look
let header = `
	<tr>
		<th>ID</th>
		<th>Player</th>
		<th>Kills</th>
		<th>Deaths</th>
		<th>Bounty</th>
		<th>Ping</th>
	</tr>
`

// Set the table default
document.getElementById("playertabe").innerHTML = header

// Creating functions that we can use on the client side Lua code
function SetServerName(servername) {

	// Process the bbcode and store the new, processed 
    servername = XBBCODE.process({
		text: name,
		removeMisalignedTags: false,
		addInLineBreaks: false
    }).html

	// Dispaly the server name to the player
	document.getElementById("servername").innerHTML = servername
}

function SetPlayerCount(playercount, maxplayers) {
	document.getElementById("playercount").innerHTML = playercount + " / " + maxplayers
}

function RemovePlayers() {
	// Modify the contents of the table
	document.getElementById("playertabe").innerHTML = header
}

function AddPlayer(id, name, kills, deaths, bounty, ping) {
	let row = document.createElement("tr")
	row.innerHTML = "<td>"+id+"</td><td>"+name+"</td><td>"+kills+"</td><td>"+deaths+"</td><td>"+bounty+"</td><td>"+ping+"</td>"
	document.getElementById("playertable").appendChild(row)
}