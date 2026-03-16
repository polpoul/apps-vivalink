FROM nginx:alpine

# Supprimer la config nginx par défaut
RUN rm /etc/nginx/conf.d/default.conf

# Copier notre config nginx
COPY nginx.conf /etc/nginx/conf.d/apps.conf

# Copier toutes les apps dans le dossier nginx
COPY apps/ /usr/share/nginx/apps/

EXPOSE 80
