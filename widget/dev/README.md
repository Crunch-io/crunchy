# CrunchBox dev pages

These pages are copied from sites where a crunchbox may be or has been embedded. They define, within a bunch of text, an `iframe` containing a link to a hosted *development* version of our crunchbox application (on the ‘playertest’ bucket, which is updated whenever test01 deploys)

## How to work locally

1. Set your `widget_root` in whaam’s `host.info` to the test bucket cdn location:

  ```
  widget_root https://d27smwjmpxcjmb.cloudfront.net/test01/snapshots/cubes
  ```
1. `grunt serve:widget` in whaam. It will serve on port 8001.
1. Change the first part of the iframe src to `http://local.crunch.io:8001<DATASET_PART>`

## Pages in here:

- `index.html` is a Huffington Post page at desktop size that appears always to be the desktop verison of the page
- `mobile.html` is a Huffington Post page saved after having forced user-agent to Safari/iOS 10. It loads local `mobile.css` which has at least a couple `@media max-width` settings that may cause “less than amazing” results.
- `cbs.html` is a CBS desktop page with a cbs survey in it.

### Safari ‘responsive design mode’

After having enabled the [Develop menu](https://support.apple.com/kb/PH21491?locale=en_US), go to “Enter responsive design mode” and pick your poison.