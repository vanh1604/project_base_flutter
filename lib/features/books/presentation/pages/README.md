# Books Feature - Pages

Simple screens that use ONLY the Books feature (1 BLoC).

## Folder Purpose

According to Hybrid Architecture:
- **Simple Screen (1 feature)** → `features/[name]/presentation/pages/`
- **Composite Screen (≥2 features)** → `screens/composite/[name]/`

## Current Pages

- `book_details_screen.dart`: Display detailed book information (Will be moved here from screens/)

## When to add pages here

Add pages to this folder when:
- Screen uses ONLY BooksBloc
- No other features involved
- Simple single-feature screen

If screen uses ≥2 features, move to `screens/composite/` instead.
