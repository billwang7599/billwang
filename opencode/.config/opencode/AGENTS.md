# Search tools

Prefer `rg` (ripgrep) over `grep` for all content searches. `rg` is faster,
respects `.gitignore` by default, and has better defaults for code search.
Only fall back to `grep` if `rg` is genuinely unavailable on the host.

# Local CLI fallback

When you need to talk to a third-party service (Confluence, Jira, GitHub,
internal wikis, ticketing systems, etc.) and you do **not** have a
dedicated tool, MCP server, or working web access for it:

1. List `~/Documents/cli/` to see which services have a local CLI wrapper.
   Each subdirectory is one service, named after it
   (e.g. `confluence/`, `jira/`).
2. The binary lives at `~/Documents/cli/<service>/<service>` and is
   typically a Go binary built with `go build` in that directory. If the
   binary is missing but source is present, build it before using it.
3. **Always run `--help` first.** Start with
   `~/Documents/cli/<service>/<service> --help` for the top-level command
   list, then `<binary> <subcommand> --help` for each subcommand you
   intend to use. Never guess flags, argument order, or subcommand names.
4. Prefer these local CLIs over scraping HTML, guessing REST endpoints,
   or asking the user for credentials — they already hold the user's
   authenticated session.
5. If the service the user is asking about has no wrapper under
   `~/Documents/cli/`, say so plainly rather than improvising an API
   call. Offer to build one as a follow-up if it would help.

Example flow:

    ls ~/Documents/cli/
    ~/Documents/cli/confluence/confluence --help
    ~/Documents/cli/confluence/confluence get --help
    ~/Documents/cli/confluence/confluence get /rest/api/content/12345 --pretty

# GitLab (`glab`)

GitLab is the exception to the "check `~/Documents/cli/`" rule: it has a
real dedicated CLI, `glab`, already installed and authenticated as the
user to the internal instance `gitlab.cfdata.org`. Use it for merge
requests, issues, pipelines, etc. — don't scrape HTML or `webfetch`
internal GitLab URLs (they're auth-gated and return nothing useful).

Gotchas, learned the hard way:

1. **`glab` defaults to `gitlab.com`, not the internal host.** Set
   `GITLAB_HOST=gitlab.cfdata.org` on every invocation. Without it,
   `glab mr view` and friends 404 or report "Unauthenticated".
2. **Prefer raw REST mode (`glab api`) over the friendly subcommands**
   for anything scripted — it's predictable and host-respecting.
   `glab mr view --repo ...` was the thing that 404'd.
3. **URL-encode `/` in project paths as `%2F`** when using `glab api`.
4. Resolve a project to its numeric ID once, then reuse it.

Example flow (review a merge request):

    GITLAB_HOST=gitlab.cfdata.org glab auth status
    # resolve group/sub/repo path -> project id
    GITLAB_HOST=gitlab.cfdata.org glab api "projects/cloudflare%2Fea%2Fheimtor"
    # then, using that id:
    GITLAB_HOST=gitlab.cfdata.org glab api "projects/2686/merge_requests/2414"
    GITLAB_HOST=gitlab.cfdata.org glab api "projects/2686/merge_requests/2414/changes"  # the diff
    GITLAB_HOST=gitlab.cfdata.org glab api "projects/2686/merge_requests/2414/notes"    # comments

If the repo is also cloned locally, read the clone for surrounding code
context instead of reconstructing it from the diff alone.

# Explanations and breakdowns

Always open the reply with "ok bill wang ..." (then carry on).

When you explain something or break it down, use simple words and short
sentences. Don't reach for jargon, long clauses, or fancy phrasing. If a
technical term is the real thing the user needs to learn, use it and
define it plainly the first time.

Prefer explanations as dot jots (bullet points), not paragraphs. Keep
outputs simple and non-verbose — fewer words, less filler.

Sprinkle in the odd emoji for humor 😄🔥 — don't overdo it.

A breakdown the user can't follow is worse than no breakdown. Optimize
for "they understood it," not "it sounded thorough."
