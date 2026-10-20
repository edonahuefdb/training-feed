# Training Feed

A TikTok-style vertical feed for a Pluralsight channel, so you can watch its videos and articles back to back.
Each item counts on Pluralsight the same way clicking its link on the channel page does.

## How it works

- `index.html` is the feed. It embeds YouTube and TikTok players and snap-scrolls between items.
  It has to be served over `http://127.0.0.1:8765` because Pluralsight's page CSP blocks YouTube iframes,
  and YouTube refuses embeds from `file://` pages (no referrer → error 153).
- The **📚 Training Feed** bookmarklet (drag it from the feed's setup screen) runs on the Pluralsight channel tab.
  It sends the channel's content and progress to the feed via `postMessage`, and records a view by making the
  same calls Pluralsight makes when you click an external link:
  - `PUT /channels/api/users/external-link/{itemId}/activity` with `{"data":{"isCompleted":true}}`
  - `POST /channels/api/channel-activity` with `{"data":{"channelId":"…"}}`
- Embedded videos count after 3 seconds on screen. Articles, and anything that can't embed, count when you click **Open**.
- Both sides only accept messages from the other's origin (`https://app.pluralsight.com` ↔ `http://127.0.0.1:8765`).

## Usage

1. Double-click `Start Training Feed.bat`. It runs `python -m http.server 8765 --bind 127.0.0.1` and opens the feed.
2. One time only: drag the **📚 Training Feed** button onto your bookmarks bar.
3. Click **Open Pluralsight channel**, then click the bookmark on the channel page. Keep that tab open while you watch.

Keys: ↑/↓ or J/K to move between items, Space to play/pause, O to open the original page.
Use the rail on the right for playback speed (YouTube) and auto-next.
