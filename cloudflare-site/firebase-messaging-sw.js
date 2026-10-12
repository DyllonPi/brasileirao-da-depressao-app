importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js");

firebase.initializeApp({
apiKey: "AIzaSyA8SmUZRT4LlXiU4DatFS-lPML1NsXLExg",
authDomain: "brasileirao-da-depressao.firebaseapp.com",
projectId: "brasileirao-da-depressao",
storageBucket: "brasileirao-da-depressao.firebasestorage.app",
messagingSenderId: "737231835324",
appId: "1:737231835324:web:9d3306950e32ad830ac0b9",
measurementId: "G-LMTK3Y1CST"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
const notification = payload.notification || {};
const title = notification.title || "Brasileirão da Depressão";
const options = {
body: notification.body || "Você tem um novo aviso.",
icon: "/images/logo-azul.jpeg",
data: payload.data || {},
tag: payload.data && payload.data.tipo
? payload.data.tipo + "-" + (payload.data.rodada || "")
: "brasileirao-aviso"
};

return self.registration.showNotification(title, options);
});

self.addEventListener("notificationclick", (event) => {
event.notification.close();

const targetUrl = new URL("/", self.location.origin).href;

event.waitUntil(
clients.matchAll({ type: "window", includeUncontrolled: true })
.then((windowClients) => {
for (const client of windowClients) {
if (client.url.startsWith(self.location.origin) && "focus" in client) {
return client.focus();
}
}

    return clients.openWindow(targetUrl);
  })

);
});
