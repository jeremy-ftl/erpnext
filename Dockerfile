FROM frappe/erpnext:v15.54.5

RUN echo '{"socketio_port": 9000}' > /home/frappe/frappe-bench/sites/common_site_config.json

RUN cd /home/frappe/frappe-bench/apps && \
  bench get-app hrms --branch v15.41.0

USER frappe

WORKDIR /home/frappe/frappe-bench

VOLUME [ \
  "/home/frappe/frappe-bench/sites", \
  "/home/frappe/frappe-bench/logs" \
]

CMD [ \
  "/home/frappe/frappe-bench/env/bin/gunicorn", \
  "--chdir=/home/frappe/frappe-bench/sites", \
  "--bind=0.0.0.0:8000", \
  "--threads=4", \
  "--workers=2", \
  "--worker-class=gthread", \
  "--worker-tmp-dir=/dev/shm", \
  "--timeout=120", \
  "--preload", \
  "frappe.app:application" \
]
