# Debtor Management

Single-file debtor management app (`index.html`). Open it in Chrome or Edge.

- Upload PDF invoices (auto-extracts debtor, invoice no., date, items, amount; OCR fallback for scans) or key invoices in manually
- Record collections and apply them to invoices (oldest first by default)
- Dashboard with ageing, per-debtor balances and statements
- Data is stored in the browser (localStorage + IndexedDB); use the Backup tab to export
