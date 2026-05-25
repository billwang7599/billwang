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
