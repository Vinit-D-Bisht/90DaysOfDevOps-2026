# Day 54 – Kubernetes ConfigMaps and Secrets

## What are ConfigMaps and Secrets?

**ConfigMaps** store non-sensitive configuration data such as environment variables, application settings, and config files.

**Secrets** store sensitive information such as passwords, API keys, and tokens.

Use:

* ConfigMaps for normal configuration.
* Secrets for confidential data.

---

## Environment Variables vs Volume Mounts

### Environment Variables

* Inject values directly into a container.
* Easy to use for simple settings.
* Changes do not update automatically.

### Volume Mounts

* Mount ConfigMaps or Secrets as files.
* Good for configuration files.
* Updates can be reflected automatically.

---

## Why Base64 Is Not Encryption

Kubernetes stores Secret data in Base64 format.

Base64 only changes how data is represented and can be easily decoded.

Example:

```bash id="1q9b6v"
echo "cGFzc3dvcmQ=" | base64 --decode
```

Output:

```text id="tl1ll4"
password
```

So Base64 is **encoding**, not **encryption**.

---

## ConfigMap Updates

When a ConfigMap is mounted as a volume, changes are automatically updated inside the Pod after some time.

When a ConfigMap is used as an environment variable, the value is loaded only when the Pod starts.

| Method                | Auto Update |
| --------------------- | ----------- |
| Environment Variables | No          |
| Volume Mounts         | Yes         |

---

## Key Takeaways

* ConfigMaps store non-sensitive configuration.
* Secrets store sensitive data.
* Base64 is encoding, not encryption.
* Volume-mounted ConfigMaps update automatically.
* Environment variables require a Pod restart to get updated values.

