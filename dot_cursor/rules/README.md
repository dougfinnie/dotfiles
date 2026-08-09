# Global Cursor User Rules (chezmoi)

These `.mdc` files install to `~/.cursor/rules/` and are the **source of truth** for Doug’s always-on Agent preferences (formerly Customize → User Rules).

Edit via:

```bash
chezmoi edit ~/.cursor/rules/workflow-tdd-cursor-notes.mdc
chezmoi apply
```

After changing rules, start a **new** Agent chat. Clear any remaining text under **Customize → Rules → User Rules** so guidance is not double-injected.

Per-repo `.cursor/` notes (specs, working memory) stay **gitignored** in project repos — that is separate from this global rules tree.
