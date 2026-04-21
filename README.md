README.md
# apps-vivalink

Une plateforme multi-applications hébergée sur sous-domaines du domaine `vivalink.top`. Le projet utilise **Nginx** containerisé avec **Docker** pour servir plusieurs applications web (SPA) en parallèle.

## 📋 Description

apps-vivalink/ 
├── Dockerfile 
# Configuration Docker (Alpine Nginx) 
├── nginx.conf 
# Configuration Nginx multi-apps 
└── apps/ 
# Dossier contenant les apps 
├── lou/ 
├── voyage/ 
├── agenda/ 
└── library/

Code

### Stack technique

- **Serveur Web** : Nginx (image Alpine)
- **Containerisation** : Docker
- **Routage** : Traefik (via sous-domaines)
- **Type d'apps** : Static HTML/CSS/JavaScript (SPA)

## 🚀 Démarrage rapide

### Prérequis

- Docker et Docker Compose installés
- Accès au domaine `vivalink.top`

### Installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/polpoul/apps-vivalink.git
   cd apps-vivalink
Ajouter vos applications dans le dossier apps/

bash
apps/
├── lou/index.html
├── voyage/index.html
├── agenda/index.html
└── library/index.html
Construire l'image Docker

bash
docker build -t apps-vivalink .
Lancer le conteneur

bash
docker run -d -p 80:80 --name apps-vivalink apps-vivalink
📝 Configuration Nginx
La configuration Nginx (nginx.conf) expose 4 applications sur des sous-domaines distincts :

Chaque app est une SPA : les routes non trouvées redirigent vers index.html
Cache optimisé : index.html n'est jamais en cache pour les mises à jour immédiates
Compression Gzip : activée pour HTML, CSS, JavaScript et JSON
Port 80 : exposé pour HTTP (géré par Traefik pour HTTPS)
Exemple de bloc server (nginx.conf)
Nginx
server {
    listen 80;
    server_name lou.vivalink.top;
    root /usr/share/nginx/apps/lou;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location = /index.html {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
    
    gzip on;
    gzip_types text/html text/css application/javascript application/json;
}
🔧 Ajouter une nouvelle application
Créer un dossier pour la nouvelle app dans apps/

bash
mkdir apps/monapp
Ajouter les fichiers (minimum index.html)

bash
cp -r mon-app-dist/* apps/monapp/
Ajouter un bloc server dans nginx.conf

Nginx
server {
    listen 80;
    server_name monapp.vivalink.top;
    root /usr/share/nginx/apps/monapp;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
    location = /index.html {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
    gzip on;
    gzip_types text/html text/css application/javascript application/json;
}
Rebuildérer et relancer le conteneur

bash
docker build -t apps-vivalink .
docker restart apps-vivalink
🐳 Docker
Dockerfile
Dockerfile
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/apps.conf
COPY apps/ /usr/share/nginx/apps/
EXPOSE 80
Image de base : nginx:alpine (léger et performant)
Suppression de la configuration Nginx par défaut
Copie de notre configuration et des applications
📊 Performance
✅ Gzip activé pour réduire la taille des fichiers
✅ Cache intelligent : index.html jamais en cache, assets en cache
✅ Alpine Linux : image Docker minimale (~25 MB)
✅ SPA support : toutes les routes redirigent vers index.html

