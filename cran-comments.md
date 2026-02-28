# CRAN Submission Comments

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔


* this is a resubmission

# Response to CRAN Team (2026-02-04)

Dear Prof. Ripley and CRAN Team,

Thank you for notifying me about the check results for cardargus.

Changes made:

1. **Startup message fixed**: Corrected the unsuppressible startup message issue 
   by ensuring all package messages use `packageStartupMessage()` properly and 
   can be suppressed with `suppressPackageStartupMessages()`.

2. **Documentation updated**: Adjusted documentation to resolve the reported 
   NOTEs and WARNs on macOS platforms.

### R CMD check results

0 errors | 0 warnings | 0 notes

Thank you for your review.

Best regards,
Andre Leite



# Dear Konstanze, Thank you for your review and feedback. I have made the requested changes:

1. **Single quotes**: Removed single quotes from terms that are not package/software names (e.g., 'SVG' → SVG)

2. **\dontrun{} replacement**: 
   - Replaced `\dontrun{}` with `\donttest{}` for examples that download data or require external resources (Chrome, files, network access)
   - Unwrapped examples that execute in < 5 seconds and don't require external dependencies
   - The svg_to_*_chrome() example uses \dontrun{} because it requires an external Chrome/Chromium installation
     and the chromote package leaves supervisor connections open that cannot be cleanly closed within the example context.

3. **Examples structure**: Functions that download data (e.g., `install_fonts()`) now use `\donttest{}` instead of `\dontrun{}`


# Uwe Ligges: Found the following (possibly) invalid URLs:
  - URL: https://monitoramento.pe.gov.br/cardargus/
  - Thank you for your feedback. The invalid URL has been removed. 

## Test environments

* local R installation (macOS), R 4.3.x
* GitHub Actions (ubuntu-latest), R release
* GitHub Actions (windows-latest), R release
* R-hub (multiple platforms)

## Package purpose

cardargus creates self-contained SVG information cards with embedded Google Fonts, 
badges, and logos. The cards are portable SVG files that can be used in dashboards, 
reports, and web applications.

## Dependencies

The package depends on:
- gdtools: For text metrics and font handling
- digest: For generating unique IDs
- stringr: For string manipulation
- rsvg: For SVG to PNG conversion
- magick: For image processing

All dependencies are on CRAN.

## Notes

- This is the first CRAN submission for this package
- The package includes bundled SVG logos in inst/svgs/ for demonstration purposes
- Font management functions require internet access to download Google Fonts
