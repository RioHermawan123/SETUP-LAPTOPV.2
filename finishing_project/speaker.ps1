<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Speaker Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #1e1e1e;
            color: white;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: #2c2c2c;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.2);
            max-width: 400px;
            width: 90%;
            text-align: center;
        }
        button {
            margin: 10px;
            padding: 12px 18px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 90%;
        }
        .left { background-color: #3498db; color: white; }
        .all { background-color: #2ecc71; color: white; }
        .right { background-color: #e74c3c; color: white; }
        .stop { background-color: #f39c12 !important; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Speaker Test</h2>
        <p>Click a button to test speaker output.</p>
        <button class="left" onclick="toggleSound(this, 'left.mp3')">🔊 Left</button>
        <button class="all" onclick="toggleSound(this, 'all.mp3')">🔊 All</button>
        <button class="right" onclick="toggleSound(this, 'right.mp3')">🔊 Right</button>
        <audio id="audioPlayer"></audio>
    </div>

    <script>
        let audioPlayer = document.getElementById('audioPlayer');
        let activeButton = null;

        function toggleSound(button, file) {
            if (activeButton === button) {
                stopAudio();
                return;
            }

            playSound(button, file);
        }

        function playSound(button, file) {
            stopAudio();

            audioPlayer.src = file;
            audioPlayer.play();

            activeButton = button;
            button.classList.add('stop');
            button.textContent = "⏹️ Stop";

            audioPlayer.onended = stopAudio;
        }

        function stopAudio() {
            if (audioPlayer && !audioPlayer.paused) {
                audioPlayer.pause();
                audioPlayer.currentTime = 0;
            }

            if (activeButton) {
                activeButton.classList.remove('stop');
                activeButton.textContent = activeButton.classList.contains('left') ? "🔊 Left" :
                                           activeButton.classList.contains('all') ? "🔊 All" :
                                           "🔊 Right";
                activeButton = null;
            }
        }
    </script>
</body>
</html>
