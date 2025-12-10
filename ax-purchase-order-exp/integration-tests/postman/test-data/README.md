# Test Data Files

This folder contains sample files for testing the Purchase Order API.

## Required Files for Testing

You need to create the following files to run the complete test suite:

### 1. sample-purchase-order.pdf
**Purpose**: Valid PDF file for positive testing
**Requirements**: 
- Must be a valid PDF file
- Should contain purchase order-like content
- File size should be reasonable (< 10MB)

**How to create**:
- Use any word processor (Microsoft Word, Google Docs, LibreOffice Writer)
- Create a document with sample purchase order content
- Export/Save as PDF
- Place in this folder as `sample-purchase-order.pdf`

**Sample Content**:
```
PURCHASE ORDER

PO Number: PO-2025-001
Date: December 9, 2025
Vendor: ABC Supply Company
Address: 123 Business St, City, State 12345

Items:
1. Office Supplies - Quantity: 10 - Unit Price: $25.50 - Total: $255.00
2. Software License - Quantity: 1 - Unit Price: $500.00 - Total: $500.00
3. Hardware Equipment - Quantity: 2 - Unit Price: $150.00 - Total: $300.00

Subtotal: $1,055.00
Tax (8%): $84.40
Total Amount: $1,139.40

Terms: Net 30 days
Delivery Date: December 20, 2025
```

### 2. health-check.pdf
**Purpose**: Small PDF file for health check testing
**Requirements**:
- Must be a valid PDF file
- Should be small in size (< 1MB)
- Simple content is sufficient

**How to create**:
- Create a simple one-page document
- Add minimal content like "Health Check Test Document"
- Export as PDF
- Place in this folder as `health-check.pdf`

### 3. invalid-file.txt ✅
**Purpose**: Non-PDF file for validation testing
**Status**: Already created
**Content**: Text file that should trigger validation errors

## Alternative Methods to Create PDF Files

### Method 1: Online PDF Generators
1. Visit any online PDF generator (e.g., SmallPDF, ILovePDF)
2. Create a document with the sample content above
3. Download the generated PDF
4. Rename and place in this folder

### Method 2: Print to PDF
1. Create the content in any application
2. Use "Print" function
3. Select "Save as PDF" or "Microsoft Print to PDF"
4. Save to this folder with the correct filename

### Method 3: Use Existing PDF Files
1. Find any existing PDF files on your system
2. Copy them to this folder
3. Rename them to match the required filenames
4. Ensure they are valid PDF files

## File Validation

Before running tests, verify your PDF files:

### Check File Properties
```bash
# On macOS/Linux
file sample-purchase-order.pdf
file health-check.pdf

# Should output something like:
# sample-purchase-order.pdf: PDF document, version 1.4
```

### Check File Size
```bash
# On macOS/Linux
ls -lh *.pdf

# On Windows
dir *.pdf
```

### Test File Opening
- Try opening each PDF file in a PDF viewer
- Ensure they display correctly without errors

## Testing Notes

### Content Requirements
- The actual content of the PDF files doesn't need to be perfect
- The API focuses on file format validation and IDP processing
- Any valid PDF content will work for testing purposes

### File Size Considerations
- Keep files reasonably sized (< 10MB) for faster testing
- Very large files may cause timeout issues during testing
- Small files (100KB - 1MB) are ideal for automated testing

### Security Note
- These are test files only
- Don't include any sensitive or real business data
- Use fictional company names, addresses, and financial information

## Troubleshooting

### PDF Creation Issues
- **Problem**: Can't create PDF files
- **Solution**: Use online PDF generators or ask a colleague to create them

### File Format Errors
- **Problem**: API rejects PDF files
- **Solution**: Verify files are actually PDF format, not renamed documents

### File Not Found Errors
- **Problem**: Postman can't find the files
- **Solution**: Ensure files are in the correct folder with exact filenames

### Large File Issues
- **Problem**: Upload timeouts or errors
- **Solution**: Use smaller PDF files (< 5MB recommended)

## Quick Start

If you need to get testing quickly:

1. **Find any existing PDF file** on your computer
2. **Copy it twice** to this folder
3. **Rename the copies**:
   - First copy → `sample-purchase-order.pdf`
   - Second copy → `health-check.pdf`
4. **Run the Postman tests**

This will allow you to test the API functionality even without custom content.
