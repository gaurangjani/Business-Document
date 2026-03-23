# User Manual

## Purpose

This manual explains how to configure and use the Business Document Copilot extension inside Business Central.

It is written for:

- Administrators who configure Copilot and templates
- End users in sales and purchasing who generate document text

## 1. Administrator Guide

### 1.1 Configure Azure OpenAI

Before users can generate content, an administrator must configure the Azure OpenAI connection.

Steps:

1. Open the `Copilot Config` page.
2. Fill in these fields:
   - `Endpoint`
   - `Deployment`
   - `ApiKey`
3. Close the page after saving the values.

Notes:

- The API key is stored using isolated storage.
- If the endpoint, deployment, or API key is missing, generation will fail.

### 1.2 Configure global document generation settings

Steps:

1. Open `Document Generator Setup`.
2. Review these fields:
   - `Default Tone`
   - `Default Max Length`
   - `Allow Line Suggestions`
   - `Global Instructions`
3. Save the page.

Guidance:

- `Default Tone` defines the baseline writing style.
- `Default Max Length` helps keep generated output within a reasonable size.
- `Global Instructions` are added to every prompt.

Example of useful global instructions:

```text
Write in clear business language. Avoid filler text. Keep the result suitable for customer-facing use unless the context indicates an internal accounting document.
```

### 1.3 Review or adjust templates

The system creates a default template for each supported document type automatically.

Supported types:

- Sales Quote
- Sales Order
- Sales Invoice
- Purchase Order
- Purchase Invoice

Steps:

1. Open `Document Generator Setup`.
2. Choose `Templates`.
3. Open the relevant template.
4. Adjust:
   - `Template Name`
   - `Prompt Text`
   - `Tone`
   - `Max Length`
   - `Active`
5. Save the template.

Prompt writing tips:

- Keep the prompt specific to the document type.
- Tell Copilot what style and intent you want.
- Avoid asking for long layouts, because the current version writes to `Posting Description`.

Good example:

```text
Generate a clear sales order summary including delivery expectations, scope, and customer-facing language.
```

Avoid:

```text
Create a full multi-page printable report with line tables and totals.
```

## 2. End User Guide

### 2.1 Supported documents

End users can generate text from these pages:

- Sales Quote
- Sales Order
- Sales Invoice
- Purchase Order
- Purchase Invoice

### 2.2 Generate text for a document

Steps:

1. Open a supported document.
2. Choose `Generate with Copilot`.
3. In the dialog, enter optional instructions.
4. Choose `Generate`.
5. Review the generated text.
6. If needed, choose `Regenerate`.
7. Choose `Apply` to write the result back to the document.

What happens after `Apply`:

- The generated text is copied into the document `Posting Description`
- An audit record is created

### 2.3 Examples of user instructions

Sales Order example:

```text
Emphasize the requested delivery timing and keep the wording customer-friendly.
```

Sales Invoice example:

```text
Keep the wording concise and professional. Mention that the invoice relates to the completed delivery.
```

Purchase Order example:

```text
Write the description for vendor communication and mention the requested receipt date.
```

### 2.4 When to use Regenerate

Use `Regenerate` when:

- The tone is not right
- The text is too long or too short
- Important context is missing
- You want an alternative wording option

Before regenerating, update the optional instructions to steer the result.

## 3. What the System Uses as Context

For sales documents, Copilot uses document header values such as:

- Document number
- Document type
- Customer number
- Customer name
- Currency code
- Requested delivery date
- Current posting description

For purchase documents, Copilot uses values such as:

- Document number
- Document type
- Vendor number
- Vendor name
- Currency code
- Requested receipt date
- Current posting description

## 4. Current Functional Limitation

The current version does not create a full report layout or complete printable business document.

It currently generates and applies short business text to the `Posting Description` field.

If you need full report generation later, the next stage should add:

- Rich body text storage
- Printable report layout handling
- PDF export
- Email delivery
- Line-level generation

## 5. Troubleshooting

### Issue: Generate does not return a result

Check:

- Azure OpenAI endpoint is correct
- Deployment name is correct
- API key is valid
- The deployed model supports chat completions

### Issue: Output is too generic

Try:

- Improving `Global Instructions`
- Making the template prompt more specific
- Adding better document-specific instructions in the dialog

### Issue: Output is cut off

Check:

- `Default Max Length`
- Template `Max Length`
- The Business Central target field length for `Posting Description`

### Issue: Output applied but not visible as a full document body

This is expected in the current version.

The extension currently writes to `Posting Description`, not to a full report body or document layout.

## 6. Recommended Operating Practice

- Use templates for each document type instead of relying only on free-text instructions
- Keep prompts short and precise
- Review generated text before applying it
- Treat generated text as a draft that still requires business validation

## 7. Summary

This extension currently provides a practical first step toward a no-code business document solution in Business Central:

- Admins configure prompts and defaults
- Users generate text inside standard document pages
- Applied results are stored on the document and logged for audit

For the next phase, the solution can be extended into richer report and document output generation.
