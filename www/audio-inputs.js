const buttons = document.querySelectorAll(".button");
const startAudioButton = document.querySelector("#startAudio");
const stopButton = document.querySelector("#stopAudio");
const audioList = document.querySelector("#audio-list");

let mediaRecorder = null;
let chunks = [];
let audiodata = null;

if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
  alert("Your browser does not support recording!");
}

startAudioButton.addEventListener("click", recordAudio);
stopButton.addEventListener("click", stopRecording);

function recordAudio() {
  console.log("record audio started");

  navigator.mediaDevices
    .getUserMedia({
      audio: true,
    })
    .then((stream) => {
      stopButton.disabled = false;
      startAudioButton.disabled = true;

      mediaRecorder = new MediaRecorder(stream);
      mediaRecorder.ondataavailable = (e) => {
        console.log("record audio", e.data);
        chunks.push(e.data);
      };
      mediaRecorder.onstop = (e) => {
        console.log("record screen stopped");
        createMediaElement("audio", "audio/mp3", audioList);
      };
      mediaRecorder.onerror = (e) => {
        console.log(e.error);
      };
      mediaRecorder.start(1000);
    })
    .catch((err) => {
      alert(`The following error occurred: ${err}`);
    });
}

// stops audio or video
function stopRecording() {
  stopButton.disabled = true;
  startAudioButton.disabled = false;
  mediaRecorder.stop();
}

// creates the html element with the file
function createMediaElement(mediaType, fileType, placeToAdd) {
  const blob = new Blob(chunks, {
    type: fileType,
  });

  const mediaURL = window.URL.createObjectURL(blob);
  console.log("mediaUrl", mediaURL);
  const element = document.createElement(mediaType);
  element.setAttribute("controls", "");
  element.src = mediaURL;
  
  let reader = new FileReader();
  reader.addEventListener("loadend", function () {
    Shiny.onInputChange("audiodata", reader.result);
  }, false);
  reader.readAsDataURL(blob);
  
  placeToAdd.insertBefore(element, placeToAdd.firstElementChild);
  mediaRecorder = null;
  chunks = [];
  
  stopButton.disabled = true;
  startAudioButton.disabled = false;
}