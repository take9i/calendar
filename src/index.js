import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

// Elm.Main.init({
//   node: document.getElementById('root')
// });

function getJSON(url) {
  const fetch = url => {
    return new Promise((resolve, reject) => {
      const req = new XMLHttpRequest();
      req.open('GET', url);
      req.onload = () => {
        if (req.status == 200) {
          resolve(req.response);
        } else {
          reject(new Error(req.statusText));
        }
      };
      req.onerror = () => {
        reject(new Error('Network Error'));
      };
      req.send();
    });
  };
  return fetch(url).then(JSON.parse);
}

getJSON('holidays.json').then(json => {
  const app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: json
  });
});


// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
// serviceWorker.unregister();
serviceWorker.register();
