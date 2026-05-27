## 1: Build Your Own App Stack

### Project Structure
```text
project/
├── docker-compose.yml
└── app/
    ├── app.py
        ├── requirements.txt
            └── Dockerfile

```

### app.py

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask App"

    app.run(host="0.0.0.0", port=5000)

```

### requirements.txt

```text
flask
```

### Dockerfile

```Dockerfile

FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

### docker-compose.yml

```yaml
services:
  web:
  build: ./app
  ports:
    - "5000:5000"
  depends_on:
    db:
      condition: service_healthy


  db:
   image: postgres
   environment:
     POSTGRES_DB: appdb
     POSTGRES_USER: admin
     POSTGRES_PASSWORD: password

  redis:                                                                
    image: redis

```

---

## Task 2: depends_on & Healthchecks

### Add Healthcheck

```yaml
db:
  image: postgres
  environment:
    POSTGRES_DB: appdb
    POSTGRES_USER: admin
    POSTGRES_PASSWORD: password

healthcheck:
  test: ["CMD-SHELL", "pg_isready -U admin"]
  interval: 10s
  timeout: 5s
  retries: 5

```

### Observation
The web service waited until PostgreSQL became healthy before starting.

---

## Task 3: Restart Policies

### Restart Always

```yaml
restart: always
```

### Restart On Failure

```yaml
restart: on-failure
```

### Notes
- `always` restarts the container regardless of exit reason.
- `on-failure` only restarts when the container exits with an error.

---

## Task 4: Custom Dockerfiles in Compose

### Build from Dockerfile

```yaml
web:
  build: ./app
  ```

  ### Rebuild After Changes

  ```bash
  docker compose up --build
  ```

  ---

  ## Task 5: Named Networks & Volumes

  ### Updated Compose File

 ```yaml
  services:
    web:
     build: ./app
     ports:
       - "5000:5000".
     networks:
       - app-network
     labels:
       project: day34

   db:
     image: postgres
     restart: always
     environment:
       POSTGRES_DB: appdb
       POSTGRES_USER: admin
       POSTGRES_PASSWORD: password
     volumes:
       - postgres-data:/var/lib/postgresql/data                     
     networks:
       - app-network    
     labels:
       project: day34                                               

   redis:                           
     image: redis
     networks:
       - app-network
     labels:
       project: day34

volumes:
  postgres-data:

networks:
  app-network:

```

---

## Task 6: Scaling

### Scale Web Service

```bash
docker compose up --scale web=3
```

### Observation
Multiple web containers were created.

### What Breaks?
Port mapping conflicts occur because multiple containers cannot use the same host port.

### Why?
A host port can only be bound once, making simple scaling difficult with direct port mappings.

---

## Key Learnings
1. Docker Compose can manage complete application stacks using a single YAML file.
2. Healthchecks and depends_on help services start in the correct order.
3. Named volumes, networks, and restart policies make applications more reliable.
