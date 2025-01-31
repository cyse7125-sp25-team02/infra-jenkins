#!/bin/bash
sudo certbot --nginx \
    --non-interactive \
    --agree-tos \
    --staging \
    --email ${certbot_email} \
    --domains ${domain_name}
