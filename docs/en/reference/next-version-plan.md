# Next Version Plan

This document records planned features for the next version. It does not mean these features are already implemented.

## Large File Recognition

The current `POST /api/v1/asr` endpoint is synchronous. It is suitable for short audio, functional verification, and Swagger testing. Large files or long audio keep HTTP requests occupied for a long time and are more likely to be affected by client, reverse proxy, or server timeouts.

The next version plans to add asynchronous task APIs:

```text
POST /api/v1/asr/jobs
GET  /api/v1/asr/jobs/{job_id}
GET  /api/v1/asr/jobs/{job_id}/result
```

Suggested states:

```text
pending
running
succeeded
failed
expired
```

## Task Persistence

Large file recognition should not rely only on in-memory state. The next version should introduce lightweight persistence:

- Use SQLite to save task status, file path, recognition result, error message, and timestamps.
- Store uploaded files in a task directory such as `/app/tmp/jobs/{job_id}`.
- Let a background worker fetch pending tasks and run recognition.
- After service restart, recover unfinished tasks or mark them as failed.

## Cache Design

Cache should be split into two categories.

### Result Cache

Calculate a digest for uploaded files, such as SHA-256. If the same file has already been recognized successfully and the result has not expired, return the existing result directly to avoid duplicate recognition.

Useful scenarios:

- Users upload the same file repeatedly.
- Callers retry after failures.
- Swagger or test environments repeatedly verify the same audio.

### Task State Cache

Task state should be stored reliably and not only in memory. SQLite can be used as task state storage. If multi-instance deployment is needed later, Redis can be considered.

## Concurrency Control

FunASR offline recognition is usually resource-intensive. Background tasks in the next version should continue to limit recognition concurrency:

```text
ASR_RECOGNITION_CONCURRENCY=10
```

Adjust it later according to machine resources and FunASR Server capacity.

## Cleanup Strategy

Clean these items regularly:

- Temporary uploaded files for completed tasks.
- Expired task records.
- Expired result cache.

Suggested configuration:

```env
JOB_RETENTION_HOURS=24
RESULT_CACHE_TTL_HOURS=168
```

## Current Recommendation

- The current synchronous API limit is 30MB.
- Large files, long audio, and production batch transcription should use the next version's async task design.
- Prioritize SQLite task persistence and result cache in the next version. Redis/Celery is not urgent.
