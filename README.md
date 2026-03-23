# Business Document Copilot for Business Central

## Overview

This extension adds a Copilot-assisted document generation flow to Microsoft Dynamics 365 Business Central.

The current implementation allows users to generate business-ready text for these document types directly inside the Business Central UI:

- Sales Quote
- Sales Order
- Sales Invoice
- Purchase Order
- Purchase Invoice

The generated result is applied to the document `Posting Description` field and logged in an audit table for traceability.

## Current Scope

The extension currently provides:

- Azure OpenAI configuration page
- Document generator setup page
- Template management for each supported document type
- Prompt dialog for generating and reviewing output
- Page actions on supported sales and purchase document pages
- Audit logging of applied generated text

The extension does not yet provide:

- Line item generation
- PDF export
- Email sending
- SharePoint storage
- External portal or self-service request flow
- Full report layout generation

## How It Works

1. A user opens a supported document in Business Central.
2. The user chooses `Generate with Copilot`.
3. The prompt dialog opens and allows optional extra instructions.
4. The extension builds a prompt using:
   - Global setup instructions
   - The selected document template
   - Context from the current document header
   - Any additional user instructions
5. Copilot returns generated text.
6. When the user chooses `Apply`, the text is written to `Posting Description`.
7. The generated result is stored in the audit table.

## Main Objects

### Core configuration

- `Copilot Config` page: stores Azure OpenAI endpoint, deployment, and API key
- `Doc. Generator Setup` table and page: stores global prompt settings
- `Doc. Template` table and related pages: stores per-document prompts and output settings

### Generation flow

- `Copilot` codeunit: sends prompts to Azure OpenAI
- `Document Generator` codeunit: builds prompts, applies results, and writes audit entries
- `Document Generation Dialog` page: prompt dialog for generation and apply flow

### Audit and support objects

- `Doc. Generation Audit` table: logs applied generation output
- `Document Template Type` enum: supported document types
- `Doc. Dialog Source Kind` enum: sales or purchase source routing

### Page extensions

Actions are added to these Business Central pages:

- Sales Quote
- Sales Order
- Sales Invoice
- Purchase Order
- Purchase Invoice

## Installation and Setup

### Prerequisites

- Business Central runtime compatible with the extension configuration in `app.json`
- Access to Azure OpenAI
- A deployed chat-completions model in Azure OpenAI

### Initial setup

1. Publish the extension to Business Central.
2. Open `Copilot Config`.
3. Enter:
   - Endpoint
   - Deployment
   - API key
4. Open `Document Generator Setup`.
5. Review or update:
   - Default Tone
   - Default Max Length
   - Global Instructions
   - Allow Line Suggestions
6. Open `Templates` from the setup page.
7. Review the default templates created automatically for each supported document type.

## Template Behavior

Each template can define:

- Template Name
- Prompt Text
- Tone
- Max Length
- Active flag

If a template does not exist, the extension creates a default one automatically.

## Generated Output Destination

At the moment, generated content is applied to:

- `Sales Header`.`Posting Description`
- `Purchase Header`.`Posting Description`

This means the feature currently supports short, document-level business text rather than full printable layouts.

## Audit Logging

Each applied generation writes an audit entry containing:

- Created At
- Created By
- Document Type
- Source Table No.
- Document No.
- Generated Text

## Known Limitations

- Output is written only to `Posting Description`
- No document body or layout rendering is generated yet
- No line creation or line suggestion application is implemented yet
- No separate end-user history page is available yet for audit review

## Suggested Next Enhancements

- Apply generated content to `Work Description` or dedicated custom fields
- Add a list page for audit review
- Add line suggestion generation for sales and purchase lines
- Add PDF and email distribution flows
- Add a richer no-code document template and report output model
