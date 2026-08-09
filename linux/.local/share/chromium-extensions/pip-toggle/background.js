// Toggles Picture-in-Picture on the active tab.
//
// Two ways to trigger it, both landing in the same handler:
//   - clicking the extension button in the toolbar;
//   - a keyboard shortcut, via `_execute_action` in the manifest, which
//     Hyprland injects with `dispatch sendshortcut` from Super+Y.
//
// Using `_execute_action` rather than a custom command is not incidental:
// requestPictureInPicture() requires a user gesture, and invoking the action
// counts as one -- a generic command does not always.

function togglePip() {
  if (document.pictureInPictureElement) {
    document.exitPictureInPicture();
    return;
  }

  const videos = [...document.querySelectorAll("video")].filter(
    (v) => v.readyState > 0 && !v.disablePictureInPicture
  );
  if (!videos.length) return;

  // Prefere um video tocando; entre empatados, o de maior area na tela.
  const area = (v) => v.clientWidth * v.clientHeight;
  const playing = videos.filter((v) => !v.paused);
  const target = (playing.length ? playing : videos).sort(
    (a, b) => area(b) - area(a)
  )[0];

  target.requestPictureInPicture().catch((e) => console.warn("PiP:", e));
}

chrome.action.onClicked.addListener((tab) => {
  if (!tab?.id) return;

  // allFrames: o video pode estar num iframe (embeds).
  chrome.scripting.executeScript({
    target: { tabId: tab.id, allFrames: true },
    func: togglePip,
  });
});
