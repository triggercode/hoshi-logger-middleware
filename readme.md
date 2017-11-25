# hoshi-logger-middleware

Logging middleware for express. Combines important modules with important techniques:

- morgan
- winston
- sentry
- daily file rotation

# important env vars

| Var | Description |
|---|---|
| **process.env.NODE_ENV** | Standard var, in prod console is not used |
| **process.env.LOG_PATH** | The path to the logs |
| **process.env.LOG_LEVEL** | The log level to be logged |
| **process.env.SENTRY_DSN** | The Sentry DSN (to be looked up in sentry) |
