# Developer Shell - Comprehensive Usage Examples

A merged and expanded collection of developer workflows for the interactive shell.

---

## Python Development

### 1. Code Review & Optimization
```
You: Review this Python function and suggest improvements:

def process_data(data):
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
    return result
```

### 2. Performance Profiling
```
You: This function is slow, please help optimize it:
     [paste function code]
You: /run python3 -m cProfile myscript.py
You: What's the bottleneck?
```

### 3. Async/Concurrency Help
```
You: How do I implement async/await correctly in Python?
You: /run python3 examples/async_example.py
```

### 4. Debug Sessions
```
You: I'm getting AttributeError when iterating. Here's the code:
     [... paste code ...]
You: /run python3 -m pdb myscript.py
```

---

## Web Development

### 1. React/Vue Debugging
```
You: My React component keeps re-rendering infinitely.
You: [Paste component code]
Assistant: [Detailed explanation with fixes]
```

### 2. API Design
```
You: Design a RESTful API for a todo app with:
     - User authentication
     - Task management
     - Sharing between users
```

### 3. Database Query Optimization
```
You: /run sqlite3 mydb.db
You: Optimize this query:
     SELECT * FROM users WHERE email LIKE '%@gmail.com%'
```

---

## Mobile Development

### 1. Swift/Kotlin Help
```
You: How do I implement background tasks in Swift?
You: Create a safe example with error handling.
```

### 2. React Native Debugging
```
You: My React Native app crashes on startup.
You: /run adb logcat
You: [Paste the crash logs]
```

### 3. Mobile API Integration
```
You: How can I securely authenticate API requests from a mobile app?
```

---

## Security

### 1. Code Security Review
```
You: /mode review
You: Is this password hashing secure?
     password_hash = hashlib.md5(password.encode()).hexdigest()
```

### 2. SQL Injection Prevention
```
You: How do I prevent SQL injection in this code?
You: [Paste your query code]
```

### 3. API Security Audit
```
You: Audit this API authentication flow and recommend security improvements.
```

---

## DevOps & System Administration

### 1. Docker Help
```
You: /mode devops
You: Help me create a Dockerfile for a Node.js application.
You: Also create docker-compose.yml for local development.
```

### 2. CI/CD Pipeline Setup
```
You: Design a GitHub Actions workflow for:
     - Running tests
     - Building a Docker image
     - Deploying to AWS
```

### 3. Kubernetes Troubleshooting
```
You: My pod keeps crashing. Here is the error log:
     [Paste logs]
You: /run kubectl describe pod myapp-pod
```

### 4. Log Analysis
```
You: /run tail -n 50 /var/log/nginx/error.log
You: Why am I seeing 502 Bad Gateway errors?
```

---

## Data Science & Analytics

### 1. Pandas DataFrame Issues
```
You: I'm getting a KeyError when grouping. Here's the code:
     df.groupby('category')['value'].sum()
```

### 2. ML Model Debugging
```
You: My neural network validation loss is increasing while training loss decreases.
You: Here's my model architecture:
     [Paste model code]
```

### 3. SQL Query Optimization
```
You: Optimize this slow query:
     SELECT * FROM transactions t1
     WHERE t1.date > NOW() - INTERVAL 1 YEAR
     AND EXISTS (SELECT 1 FROM users u WHERE u.id = t1.user_id)
```

---

## Learning & Documentation

### 1. Learn a New Framework
```
You: Explain how the Vue 3 Composition API works.
You: Show an example of ref and reactive.
You: How do I use lifecycle hooks?
```

### 2. Design Pattern Explanation
```
You: Explain the Factory Pattern in Python.
You: Give a code example.
```

### 3. Algorithm Learning
```
You: Explain how quicksort works.
You: Show a Python implementation.
You: What's the time complexity?
```

---

## Debugging Workflows

### 1. Binary Search Debugging
```
You: I have a bug but don't know where.
You: /run python3 -m pdb script.py
You: Help me trace the execution.
```

### 2. Memory Leak Investigation
```
You: My application keeps using more memory.
You: /run python3 -m memory_profiler script.py
You: [Paste output]
```

### 3. Performance Bottleneck Analysis
```
You: This function is slow:
     [Paste function]
You: /run python3 -m cProfile myscript.py
You: What's the bottleneck?
```

---

## Deployment & Release

### 1. Version Release Planning
```
You: Plan a semantic versioning release for my project.
You: Current version: 2.5.3
You: Changes: [new feature], [bug fix], [performance improvement]
```

### 2. Migration Strategy
```
You: Design a database migration strategy for:
     - Adding a new column
     - Migrating data
     - Ensuring zero downtime
```

### 3. Rollback Plans
```
You: What's a good rollback strategy for microservices?
You: How do I handle database rollbacks?
```

---

## Project Management

### 1. Architecture Review
```
You: Here's our current microservices architecture:
     [Describe services]
You: How can we improve scalability?
You: What about resilience?
```

### 2. Tech Stack Decision
```
You: We're choosing between Node.js and Go for our backend.
You: Requirements: [list requirements]
You: Which would you recommend and why?
```

### 3. Code Quality Improvement
```
You: /run pylint mymodule.py
You: Help me improve the code quality score.
```

---

## Quick Reference

**Quick Code Review:**
```
You: Review this code for bugs:
     [paste code]
```

**Quick Learning:**
```
You: Explain [concept] in Python.
```

**Quick Debugging:**
```
You: /run python3 debug_script.py
You: Why is this failing?
```

**Quick Execution:**
```
You: /run npm test
You: /run python3 manage.py migrate
You: /run make build
```

---

## Pro Tips

1. **Use `/run` for command output** - Execute scripts and show results.
2. **Paste full context** - More code means better advice.
3. **Use `/history`** - Review previous conversation context.
4. **Use `/clear`** - Reset history for new topics.
5. **Ask follow-up questions** - Build on previous results.
6. **Be specific** - "Fix this slow query" is better than "Help me".

---

## Common Workflows

### Code Review Session
```
You: Review my PR changes:
You: [Paste code]
You: Any security concerns?
You: Performance issues?
You: Better patterns?
```

### Learning Session
```
You: Teach me about async/await.
You: Show examples.
You: Common pitfalls?
You: /run python3  # Try examples
```

### Debugging Session
```
You: Bug: Can't connect to database.
You: Here's the error:
     [Paste full error]
You: Here's my connection code:
     [Paste code]
You: /run python3 test_connection.py
```

---

## Advanced Features

### Combining Commands
```
You: /run python3 -c "print('Hello')"
You: Explain the output.
You: How can I modify it to do X?
```

### Context Across Questions
```
You: [Ask first question]
You: [Follow-up question uses previous context]
You: [Another related question]
Use /clear when starting a new unrelated topic.
```

### Multi-Language Support
```
You: How do I do this in Python?
You: How about in Go?
You: Which is better for X use case?
```

---

**For more information, see [README.md](README.md) and [QUICKSTART.md](QUICKSTART.md)**
