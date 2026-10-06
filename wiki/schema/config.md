---
version: 1
updated: 2026-10-06
auto_suggestion_count: 0
---

# Wiki Schema Configuration

This file governs how the LLM builds and maintains your Wiki. Edit it freely.

## Wiki Structure
- Entity pages: `entities/` (person, organization, project, product, event, location, other)
- Concept pages: `concepts/` (theory, method, technology, term, other)
- Source pages: `sources/`
- Index: `index.md`
- Log: `log.md`

## Entity Page Template
Pages in `entities/` MUST follow this structure:

**Frontmatter fields:**
- `type: entity` — page category (MUST be exactly "entity")
- `created:` — ISO date of first creation
- `sources:` — array of source file wiki-links
- `tags:` — entity subtype, MUST be one of: person, organization, project, product, event, location, other
- `aliases:` (optional) — alternative names (translations, abbreviations)
- `reviewed:` (optional) — if true, page is human-verified and protected

**Sections:**
1. **Basic Information**: Type, source file link
2. **Description**: 3-6 sentences with concrete facts, bidirectional links
3. **Related Entities**: Links to related entities using [[entities/...]]
4. **Related Concepts**: Links to related concepts using [[concepts/...]]
5. **Mentions in Source**: Verbatim quotes with source attribution — see [Mentions Format](#mentions-format) below

## Concept Page Template
Pages in `concepts/` MUST follow this structure:

**Frontmatter fields:**
- `type: concept` — page category (MUST be exactly "concept")
- `created:` — ISO date of first creation
- `sources:` — array of source file wiki-links
- `tags:` — concept subtype, MUST be one of: theory, method, technology, term, other
- `aliases:` (optional) — alternative names (translations, abbreviations)
- `reviewed:` (optional) — if true, page is human-verified and protected

**Sections:**
1. **Definition**: Clear, concise definition
2. **Key Characteristics**: Bullet list of defining traits
3. **Applications**: Real-world usage scenarios
4. **Related Concepts**: Links using [[concepts/...]]
5. **Related Entities**: Links using [[entities/...]]
6. **Mentions in Source**: Verbatim quotes with source attribution — see [Mentions Format](#mentions-format) below

## Naming Conventions
- Filenames: lowercase-with-hyphens (slugified)
- Entity/concept names: Preserve original language from source, NEVER translate
- Wiki-links: Use full paths [[entities/page-name|Display Name]] or [[concepts/page-name|Display Name]]

## Source Page Template
Pages in `sources/` MUST follow this structure:

**Frontmatter fields:**
- `type: source` — page category (MUST be exactly "source")
- `tags:` — INHERITED from the source note's frontmatter (do NOT use LLM-derived concept names). The system programmatically populates this from the source file; the LLM must not overwrite it with extracted concept names. This preserves the user's existing tag vocabulary and prevents pollution from LLM hallucinations.
- `sources:` — array of related wiki page links created from this source
- `created:` / `updated:` — set by the system, see Date Fields below

**Sections:**
1. **Summary**: Brief description of the source content (2-4 sentences)
2. **Key Points**: Bullet list of main insights
3. **Mentioned Pages**: List of [[entities/...]] and [[concepts/...]] pages created from this source

## Date Fields
- `created:` and `updated:` are filled by the system programmatically — NEVER LLM-generated
- The LLM may produce wrong dates during extraction; the system overrides them post-write to ensure correctness
- `created:` is preserved on merge (older value kept); `updated:` is always set to the current date
- `source_note:` (optional) — wiki-link to the original source file

## Mentions Format
"Mentions in Source" entries use academic-footnote style with source attribution. The format is:
- "Verbatim quote in original language (optional translation)" — [[source-name|display-name]]

Rules:
- Quotes must be VERBATIM — never paraphrase, summarize, or translate away the original
- The source wiki-link is required so future page merges can trace each quote to its origin
- Multiple quotes from the same source go in the same block, separated by newlines

## Content Rules
- mentions_in_source MUST be VERBATIM quotes — never paraphrase or translate
- Summaries/descriptions should use the wiki output language
- Entity/concept names must match the source file's original language exactly
- All pages must include bidirectional links where relevant

## Classification Rules
- **type field:** entity | concept | source — the page category
- **tags field:** stores the subtype (entity_type or concept_type)
- Entity subtypes (valid tags for type=entity): person, organization, project, product, event, location, other
- Concept subtypes (valid tags for type=concept): theory, method, technology, term, other
- Source types: document, conversation, note
- **Rule:** tags MUST only contain values from the corresponding subtype list above. A tag not in the valid list will be removed by the system.

## Multi-Source Merge Rules
- Sources array: Append new sources, never overwrite
- Aliases: Append alternative names (translations, abbreviations) without overwriting existing ones
- reviewed flag: If true, preserve all existing content, only append genuinely new info
- Contradictions: Preserve both sides with attribution, add to ## Contradictions section
- NO_NEW_CONTENT: Return this signal if source adds nothing new

## Maintenance Policies
- Stale threshold: 90 days without updates
- Contradiction severity: warning, conflict, error
- Orphan page: no inbound links from other wiki pages
- Missing page: referenced by [[link]] but does not exist
