document.addEventListener("DOMContentLoaded", function() {
    document.getElementById('startButton').addEventListener('click', startClearing);
    document.getElementById('stopButton').addEventListener('click', stopClearing);
    document.getElementById('closeButton').addEventListener('click', closeMenu);
    document.getElementById('youtubeLink').addEventListener('click', function(e) {
        e.preventDefault();
        fetch(`https://${GetParentResourceName()}/openLink`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ url: 'https://www.youtube.com/c/SpocksFridayNights' })
        });
    });
});

let config = {};

window.addEventListener('message', function(event) {
    if (event.data.type === "ui") {
        if (event.data.display === true) {
            document.getElementById('menu').style.display = 'flex';
            config = event.data.config; // Get the config data from Lua

            // Set the menu text based on the selected language
            document.getElementById('startButton').innerText = event.data.locales.start_button;
            document.getElementById('stopButton').innerText = event.data.locales.stop_button;
            document.getElementById('closeButton').innerText = event.data.locales.close_button;
        } else {
            document.getElementById('menu').style.display = 'none';
        }
    } else if (event.data.type === 'openLink') {
        window.open(event.data.url, '_blank');
    }
});

function playClickSound() {
    if (config.MenuClickSound) { // Use the config value
        var audio = new Audio('select.wav');
        audio.play();
    }
}

function startClearing() {
    playClickSound();
    fetch(`https://${GetParentResourceName()}/startClearingPeds`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => console.log(resp));
}

function stopClearing() {
    playClickSound();
    fetch(`https://${GetParentResourceName()}/stopClearingPeds`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => console.log(resp));
}

function closeMenu() {
    playClickSound();
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => {
        document.getElementById('menu').style.display = 'none';
        console.log(resp);
    });
}
