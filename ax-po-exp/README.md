# AI-Enhanced Anypoint Partner Manager - Technology Demo

A proof-of-concept demonstration showcasing the integration of MuleSoft Intelligent Document Processing (IDP) with Large Language Models for enhanced B2B document processing.

## Overview

This demo demonstrates how to enhance Anypoint Partner Manager with AI capabilities:
- **Document Processing**: PDF extraction using MuleSoft IDP
- **AI Analysis**: Fraud detection using GPT-4o-mini
- **Real-time Monitoring**: Live dashboard for processing status
- **Partner Integration**: Multi-format B2B document handling

## Technology Stack

- **MuleSoft Runtime**: 4.9.11
- **AI Model**: GPT-4o-mini
- **Document Processing**: MuleSoft IDP
- **Integration**: Anypoint Partner Manager
- **Frontend**: HTML5 Dashboard

## Projects

### ax-po-exp (Document Processing API)
Processes PDF purchase orders through MuleSoft IDP and returns structured JSON data.

**Key Features:**
- PDF upload via multipart/form-data
- MuleSoft IDP integration for data extraction
- Partner-specific data transformations (TechWave, BrightView)
- BigCompass canonical format output

### ax-po-proc (AI Processing & Fraud Detection)
AI-powered fraud detection using GPT-4o-mini with real-time dashboard monitoring.

**Key Features:**
- GPT-4o-mini fraud pattern detection
- Risk scoring (0-100 scale)
- Live dashboard at `/report` endpoint
- Status tracking: APPROVE, REJECT, REVIEW, INVESTIGATION

## Quick Setup

### Prerequisites
- Java 8/11/17+, Maven 3.6+
- MuleSoft IDP credentials
- OpenAI API key

### Environment Variables
```bash
export IDP_CLIENT_ID="your_idp_client_id"
export IDP_CLIENT_SECRET="your_idp_client_secret"
export LLM_OPENAI_API_KEY="your_openai_api_key"
```

### Start Applications
```bash
# Document Processing API
cd ax-po-exp && mvn clean compile && mvn mule:run

# AI Processing API
cd ax-po-proc && mvn clean compile && mvn mule:run
```

## Demo Endpoints

**Document Processing:**
```bash
curl -X POST 'http://localhost:8081/api/v1/order' \
  -H 'Accept: application/json' \
  -F 'file=@"purchase-order.pdf"'
```

**Fraud Detection:**
```bash
curl -X POST 'http://localhost:8081/api/fraud-detection/analyze' \
  -H 'Content-Type: application/json' \
  -d '{"poNumber":"PO-001","vendorId":"VENDOR-001","amount":5000,"poDate":"2023-12-01","description":"Office supplies"}'
```

**Live Dashboard:**
- Open: `http://localhost:8081/report`
- Auto-refreshes every 5 seconds
- Shows real-time processing statistics and transaction details

## Architecture Flow

```
PDF Upload → MuleSoft IDP → MuleSoft Partner Manager → Structured Data → Process API → GPT-4o-mini Analysis → Risk Assessment → Dashboard
```

## Demo Database

This demo uses **MuleSoft Object Store** as the database layer to avoid unnecessary dependencies and complexities. The Object Store mimics database functionality for storing and retrieving purchase order data, processing status, and fraud analysis results.

## Demo Scenarios

1. **Standard Processing**: Upload `purchase-order-00137.pdf` → View extraction → Check low risk score
2. **Fraud Detection**: Submit suspicious high-value transaction → Review AI analysis → Monitor dashboard alerts
3. **Multi-Partner**: Process different format documents (PDF, EDI) → Compare transformations

## Technologies Demonstrated

- **MuleSoft IDP**: Automated document data extraction
- **GPT-4o-mini**: AI-powered fraud pattern recognition
- **Anypoint Partner Manager**: B2B integration and canonical data formats
- **Real-time Dashboards**: Live monitoring and status tracking
- **DataWeave**: Complex data transformations and mappings

---

**Note**: This is a proof-of-concept demonstration for showcasing AI-enhanced document processing capabilities in MuleSoft environments.
