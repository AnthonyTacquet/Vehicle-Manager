'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"main.dart.js": "4b644a7f8967db8fd92495944b62a026",
"version.json": "9b42f6248cb3daa76b34123c03c23294",
"assets/resources/database.db": "584a9092e533f001212f6230ee6f7255",
"assets/resources/icon.png": "9bdc8af54b87d930d8ee123668097140",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/fonts/MaterialIcons-Regular.otf": "a9deb135e22934b47c630acbb37adba7",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "89d1f5974de3d4605d59af5f1f4665b5",
"assets/AssetManifest.json": "301d0db73352c248a8dc9d411f39d444",
"assets/NOTICES": "c94fb2381778dc93c554ee7543326b7b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"index.html": "99b2f2207c74b2021cbf0761c0caa707",
"/": "99b2f2207c74b2021cbf0761c0caa707",
"icons/old/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/old/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/old/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/old/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/favicon.ico": "40b24b15d51208ac3b340b7fd06464ff",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/android-icon-36x36.png": "d202b09e29434a200631eeacbc946bff",
"icons/android-icon-48x48.png": "d18601e0fdf085452e36d7c99b59e913",
"icons/android-icon-72x72.png": "7f899e698f2d89abdc6938f72c3aae41",
"icons/android-icon-96x96.png": "747649f3a8a98db998dc33f804c80987",
"icons/android-icon-144x144.png": "04e1d8900bd22389181bd325e65cc14f",
"icons/android-icon-192x192.png": "67b6b6d7e9264afc1e90a013b58df123",
"icons/apple-icon-57x57.png": "9ea48137e37151c69e1d9f71eb549a44",
"icons/apple-icon-60x60.png": "ed3eeb34f5d70660789d3a159778dfb9",
"icons/apple-icon-72x72.png": "7f899e698f2d89abdc6938f72c3aae41",
"icons/apple-icon-76x76.png": "d149eb9db3bf050080761c91b35dcd88",
"icons/apple-icon-114x114.png": "f3167ec37dd8e1a1304d4078d7a82391",
"icons/apple-icon-120x120.png": "2e32a5e266116896b96d84bab0c235fe",
"icons/apple-icon-144x144.png": "04e1d8900bd22389181bd325e65cc14f",
"icons/apple-icon-152x152.png": "73e76339acf2898f914563a35387d98c",
"icons/apple-icon-180x180.png": "b706feb6a8070e3818e5b8c8f4c3e855",
"icons/apple-icon-precomposed.png": "31b0f06ea830a85a0c74caf580fefb7e",
"icons/apple-icon.png": "31b0f06ea830a85a0c74caf580fefb7e",
"icons/ms-icon-70x70.png": "7e5aa0e833e26a4b9c8a969c8c915b9d",
"icons/ms-icon-144x144.png": "04e1d8900bd22389181bd325e65cc14f",
"icons/ms-icon-150x150.png": "ba714f397b06fccb71a78218875ddd28",
"icons/ms-icon-310x310.png": "1efad435b5fac661157b90ed3e0740ce",
"icons/favicon-16x16.png": "c5d1541ba87350c4b2276d8d858e6369",
"icons/favicon-32x32.png": "9cb3c7e336a731b4c5ed1f9f130c3c98",
"icons/favicon-96x96.png": "747649f3a8a98db998dc33f804c80987",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "de22cde5a41aef2cff586bf6c6cab2a8",
"sqflite_sw.js": "4b5adf53ab6ced76e28b1adc17565e8b",
"sqlite3.wasm": "2068781fd3a05f89e76131a98da09b5b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
