# AI-Powered PO Fraud Detection API

<<<<<<< HEAD
A basic MuleSoft API that leverages AI Chain connector with OpenAI GPT-4 to detect fraudulent patterns in Purchase Orders (POs). This API uses advanced AI prompts to analyze fraud indicators and provides intelligent risk assessments with actionable recommendations.
=======
A sophisticated MuleSoft API that leverages MuleSoft Inference connector with OpenAI GPT-4 to detect fraudulent patterns in Purchase Orders (POs). This API uses advanced AI prompts to analyze fraud indicators and provides intelligent risk assessments with actionable recommendations.
>>>>>>> 3506572 (Replace MuleChain AI by Mule Inference + Refactor config API KEY to env variable)

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
- [Historical Data Integration](#historical-data-integration)
- [Application Architecture](#application-architecture)
- [AI Analysis Process](#ai-analysis-process)
- [Running the Application](#running-the-application)
- [Testing the API](#testing-the-api)
- [Postman Collection](#postman-collection)
- [Running Tests](#running-tests)
- [Deployment](#deployment)
- [Monitoring and Logging](#monitoring-and-logging)
- [Error Handling](#error-handling)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Performance](#performance)
- [Support](#support)
- [Version History](#version-history)

## Features

### AI-Powered Fraud Detection Capabilities
- **AI Amount Analysis**: Uses GPT-4 to detect suspicious high amounts, round number patterns, and amount inconsistencies
- **AI Vendor Analysis**: Leverages AI to identify suspicious vendor IDs, shell companies, and vendor-related fraud indicators
- **AI Timing Analysis**: AI-powered detection of future-dated POs, timing inconsistencies, and suspicious processing patterns
- **AI Risk Scoring**: Intelligent risk scoring (0-100) with AI confidence levels
- **Multi-Stage AI Analysis**: Sequential AI analysis with specialized prompts for each fraud category
- **Comprehensive Validation**: Validates all required PO fields before AI analysis

### Risk Levels
- **MINIMAL** (0-19): Low fraud risk - Approve
- **LOW** (20-49): Minor concerns - Monitor
- **MEDIUM** (50-79): Moderate risk - Manual review recommended
- **HIGH** (80+): High fraud risk - Reject transaction

## Prerequisites

Before running this application, ensure you have:

### Required Software
- Java 17 or higher
- Maven 3.6+
- MuleSoft Runtime 4.4.0+

### Required Dependencies
- **MuleSoft Inference Connector**: This project uses the MuleSoft Inference connector for AI/ML capabilities
  - The connector is included as part of the MuleSoft runtime and Exchange
  - Provides native integration with OpenAI and other AI services
  - No additional dependency installation required for standard MuleSoft environments

### OpenAI API Setup
1. **Create OpenAI Account**: Sign up at [https://platform.openai.com](https://platform.openai.com)
2. **Generate API Key**: Go to [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
3. **Copy API Key**: You'll need this for the configuration step below

## Configuration

### Essential Configuration Files

#### 1. Application Configuration (`src/main/resources/config.properties`)
Configure the HTTP listener and OpenAI API key:

```properties
# HTTP Listener Configuration
# Host and port for the HTTP listener
http.host=0.0.0.0
http.port=8081

# OpenAI API Configuration
# Set via environment variable for security
llm.openai.api.key=${LLM_OPENAI_API_KEY}
```

#### 2. Environment Variable Setup
**CRITICAL**: Set your OpenAI API key as an environment variable:

**For Local Development:**
```bash
# macOS/Linux
export LLM_OPENAI_API_KEY="your-actual-openai-api-key-here"

# Windows
set LLM_OPENAI_API_KEY=your-actual-openai-api-key-here
```

**For IDE (IntelliJ/Eclipse):**
- Add `LLM_OPENAI_API_KEY=your-actual-openai-api-key-here` to your run configuration environment variables

**Important Setup Notes:**
1. Replace `your-actual-openai-api-key-here` with your actual OpenAI API key
2. The environment variable name must be exactly `LLM_OPENAI_API_KEY`
3. **SECURITY BENEFIT**: API keys are never stored in files or committed to version control
4. **DEPLOYMENT FRIENDLY**: Easy to configure across different environments

### AI Model Configuration
The MuleSoft Inference connector is configured in `global.xml` with these settings:
- **Model**: `gpt-4o-mini` (optimized for fraud detection)
- **Connection Type**: `openai-connection`
- **Configuration**: Environment variable-based API key
- **Connector Namespace**: `ms-inference` (MuleSoft Inference Connector)
- **Temperature**: 0 (deterministic responses)
- **Top P**: 1 (full probability distribution)

## API Endpoints

### POST /api/fraud-detection/analyze
Analyzes a Purchase Order for fraud indicators.

#### Request Body
```json
{
  "poNumber": "PO-2023-001",
  "vendorId": "VENDOR-12345",
  "amount": 50000,
  "poDate": "2023-12-01",
  "description": "Office equipment purchase"
}
```

#### Response
```json
{
  "transactionId": "550e8400-e29b-41d4-a716-446655440000",
  "timeStamp": "2023-12-03T17:15:30.123Z",
  "poNumber": "PO-2023-001",
  "fraudAssessment": {
    "riskLevel": "MEDIUM",
    "riskScore": 65,
    "fraudIndicators": [
      "High amount transaction with round number pattern",
      "Vendor ID format appears legitimate but requires monitoring",
      "Processing timing within normal business parameters"
    ],
    "recommendation": "REVIEW - Manual review recommended due to amount patterns",
    "aiConfidence": 87,
    "analysisDetails": "AI analysis identified moderate risk based on amount patterns. The $50,000 round number amount combined with office equipment description suggests potential fraud indicators that warrant manual review."
  },
  "status": "ANALYZED"
}
```

## Historical Data Integration

The API leverages historical partner transaction data to enhance AI analysis accuracy:

### Historical Data Features
- **Partner History Loading**: Automatically loads historical transaction data for each vendor
- **Data Filtering**: Filters historical data by vendor ID for contextual analysis
- **AI Context Enhancement**: Provides historical patterns to AI models for better fraud detection
- **Data Source**: `src/main/resources/data/partner-history-data.json`

### How Historical Data Works
1. **Data Loading Flow**: The `load-historical-data-flow` retrieves and filters partner history
2. **Vendor-Specific Filtering**: Historical data is filtered by the current PO's vendor ID
3. **AI Integration**: Historical patterns are included in all three AI analysis stages
4. **Context Enhancement**: AI models use historical data to identify anomalies and patterns

### Historical Data Structure
The historical data includes:
- Previous transaction amounts and patterns
- Vendor transaction history
- Timing patterns and frequencies
- Risk indicators from past transactions

This historical context significantly improves the accuracy of fraud detection by allowing AI models to compare current transactions against established vendor patterns.

## Application Architecture

### Flow Architecture Overview
The application follows a modular flow-based architecture with clear separation of concerns:

```
HTTP Request → Validation → Historical Data Loading → AI Analysis → Response Formation
     ↓              ↓              ↓                    ↓              ↓
  api.xml    api-implementation.xml  common.xml    api-implementation.xml  api.xml
```

### Core Flow Components

#### 1. Main Flow (`main-flow`)
- **Location**: `src/main/mule/api.xml`
- **Purpose**: Entry point for all fraud detection requests
- **Responsibilities**: HTTP listener, request logging, orchestration, response formatting, error handling

#### 2. Validation Flow (`validate-po-data-flow`)
- **Location**: `src/main/mule/api-implementation.xml`
- **Purpose**: Comprehensive input validation
- **Validations**: Required fields, data types, business rules (positive amounts, valid dates)

#### 3. Historical Data Flow (`load-historical-data-flow`)
- **Location**: `src/main/mule/common.xml`
- **Purpose**: Load and filter partner transaction history
- **Process**: Reads `partner-history-data.json`, filters by vendor ID, provides context for AI analysis

#### 4. AI Analysis Flows
All located in `src/main/mule/api-implementation.xml`:
- **Amount Analysis Flow** (`ai-amount-analysis-flow`): Analyzes transaction amounts for fraud patterns
- **Vendor Analysis Flow** (`ai-vendor-analysis-flow`): Evaluates vendor information for suspicious patterns  
- **Timing Analysis Flow** (`ai-timing-analysis-flow`): Examines temporal fraud indicators
- **Final Assessment Flow** (`ai-final-assessment-flow`): Synthesizes all analysis results

### Data Flow Sequence
1. **Request Reception**: HTTP listener receives POST request
2. **Input Validation**: All required fields and business rules validated
3. **Historical Context**: Partner history loaded and filtered by vendor ID
4. **AI Analysis Chain**: Sequential execution of specialized AI analysis flows
5. **Result Synthesis**: Final assessment combines all analysis results
6. **Response Formation**: Structured JSON response with fraud assessment

### Configuration Management
- **Global Configuration**: `src/main/mule/global.xml` - HTTP listener, MuleSoft Inference connector, error handlers
- **Properties**: `src/main/resources/config.properties` - HTTP host/port and OpenAI API key configuration
- **Environment Variables**: `LLM_OPENAI_API_KEY` - Secure OpenAI API key storage
- **Prompts**: `src/main/resources/prompts/` - Specialized AI prompts for each analysis type

## AI Analysis Process

The API performs a sophisticated 4-stage AI analysis using specialized prompts and historical data:

### 1. AI Amount Analysis
- **Prompt Focus**: Analyzes transaction amounts for fraud patterns
- **Detection**: Unusual amounts, round numbers, amount-description inconsistencies
- **AI Model**: GPT-4o-mini with financial fraud expertise context
- **Output**: Risk score, indicators, reasoning, confidence level

### 2. AI Vendor Analysis  
- **Prompt Focus**: Evaluates vendor information for suspicious patterns
- **Detection**: Shell companies, test vendors, suspicious ID formats
- **AI Model**: GPT-4o-mini with vendor fraud detection expertise
- **Output**: Risk score, vendor-specific indicators, detailed analysis

### 3. AI Timing Analysis
- **Prompt Focus**: Examines temporal fraud indicators
- **Detection**: Future dates, processing delays, timing inconsistencies
- **AI Model**: GPT-4o-mini with business process timing expertise
- **Output**: Timing risk assessment with contextual reasoning

### 4. AI Final Assessment
- **Prompt Focus**: Synthesizes all analysis results into final recommendation
- **Process**: Combines amount, vendor, and timing analysis results
- **AI Model**: Senior fraud expert persona for comprehensive assessment
- **Output**: Final risk level, consolidated indicators, actionable recommendations

## Running the Application

### Local Development
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd po-fraud-detection-api
   ```

2. **Set OpenAI API Key Environment Variable**
   ```bash
   # macOS/Linux
   export LLM_OPENAI_API_KEY="your-actual-openai-api-key-here"
   
   # Windows
   set LLM_OPENAI_API_KEY=your-actual-openai-api-key-here
   ```

3. **Run the application**
   ```bash
   mvn clean compile
   mvn mule:run
   ```

4. **Verify startup**
   - The API will be available at `http://localhost:8081`
   - Check logs for successful startup messages
   - Verify the environment variable is loaded correctly

## Testing the API

### Quick Test with curl

#### Test with low-risk PO
```bash
curl -X POST http://localhost:8081/api/fraud-detection/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "poNumber": "PO-2023-001",
    "vendorId": "VENDOR-12345",
    "amount": 5000,
    "poDate": "2023-12-01",
    "description": "Office supplies"
  }'
```

#### Test with high-risk PO
```bash
curl -X POST http://localhost:8081/api/fraud-detection/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "poNumber": "PO-2023-002",
    "vendorId": "12",
    "amount": 150000,
    "poDate": "2025-01-01",
    "description": "Suspicious purchase"
  }'
```

## Postman Collection

This project includes an essential Postman test collection for API validation:

### Files Available
- `integration-tests/postman/api-test-suite.json` - Essential test collection

### Collection Details
- **Name**: "PO Fraud Detection API - Essential Test Suite"
- **Description**: Essential test collection with AI-powered analysis validation
- **Base URL**: `http://localhost:8081` (configurable via environment variables)

### Test Cases Included
- ✅ **Success Case - Partner with History**: Tests vendor with historical data (`APL-RSLR-0101`)
- ✅ **Success Case - No Historical Data**: Tests vendor without historical data (`APL-RESSELER`)
- 🔍 **Automated Validation**: Response structure, risk levels, and field validation

### Quick Setup
1. **Import Collection**: Import `integration-tests/postman/api-test-suite.json` into Postman
2. **Set Base URL**: The collection uses `{{baseUrl}}` variable (defaults to `http://localhost:8081`)
3. **Run Tests**: Execute individual requests or run the entire collection

### Test Scenarios
Both test cases use realistic scenarios:
- **Vendor ID**: Tests both partners with and without historical transaction data
- **Amount**: $1,998.00 (realistic iPhone purchase amount)
- **Description**: "iPhone 15, 2 unit" (legitimate business purchase)
- **Date**: Current date (2025-12-08)

### Automated Test Validations
Each test case includes comprehensive validations:
- HTTP 200 status code verification
- Required response fields validation
- Risk level validation (HIGH, MEDIUM, LOW, MINIMAL)
- Risk score range validation (0-100)
- Status field verification ("ANALYZED")
- Fraud assessment structure validation

## Running Tests

Execute MUnit tests:
```bash
mvn test
```

The test suite includes:
- Low risk PO validation
- High risk detection (large amounts)
- Medium risk detection (suspicious vendors)
- Validation error handling
- Round number detection
- Future date detection

## Deployment

### CloudHub 2.0 Deployment
1. **Set Environment Variable in CloudHub**:
   - In Anypoint Platform, go to Runtime Manager
   - Select your application → Settings → Properties
   - Add: `LLM_OPENAI_API_KEY=your-actual-openai-api-key-here`

2. **Deploy the application**:
   ```bash
   mvn clean package deploy -DmuleDeploy
   ```

### Runtime Fabric Deployment
1. **Configure Environment Variables**:
   - Set `LLM_OPENAI_API_KEY` in your Runtime Fabric environment
   - Use Kubernetes secrets or environment configuration

2. **Deploy with environment configuration**:
   ```bash
   mvn clean package deploy -DmuleDeploy -Denv=production
   ```

### Environment Variable Configuration by Platform
- **CloudHub**: Set in Runtime Manager → Application Settings → Properties
- **Runtime Fabric**: Configure via Kubernetes environment variables or secrets
- **On-Premises**: Set system environment variables on the Mule runtime server
- **Docker**: Use `-e LLM_OPENAI_API_KEY=your-key` or environment files

**Security Note**: Environment variables provide secure API key management across all deployment platforms without storing sensitive data in application files.

## Monitoring and Logging

The API includes comprehensive logging:
- Request/response logging
- Fraud analysis details
- Error tracking
- Performance metrics

Log levels can be configured in `src/main/resources/log4j2.xml`.

## Error Handling

### Validation Errors (400)
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Invalid input data provided",
  "details": "PO Number is required",
  "timestamp": "2023-12-03T17:15:30.123Z"
}
```

### Processing Errors (500)
```json
{
  "error": "PROCESSING_ERROR",
  "message": "An error occurred during fraud analysis",
  "details": "Internal processing error",
  "timestamp": "2023-12-03T17:15:30.123Z"
}
```

## Troubleshooting

### Common Issues

#### 1. Environment Variable Configuration Problems
**Problem**: API returns errors about AI service unavailable or missing API key
**Solutions**:
- Verify `LLM_OPENAI_API_KEY` environment variable is set correctly
- Check that the API key has sufficient credits/quota on OpenAI platform
- Ensure the environment variable is available to the Mule runtime process
- For IDE: Verify environment variable is set in run configuration

#### 2. Connection Issues
**Problem**: Cannot connect to the API
**Solutions**:
- Verify the application started successfully (check logs)
- Confirm the port 8081 is not in use by another application
- Check firewall settings if accessing remotely

#### 3. Validation Errors
**Problem**: All requests return validation errors
**Solutions**:
- Ensure all required fields are provided: `poNumber`, `vendorId`, `amount`, `poDate`, `description`
- Verify `amount` is a positive number
- Check date format is valid (YYYY-MM-DD)

#### 4. AI Analysis Failures
**Problem**: API returns default risk scores instead of AI analysis
**Solutions**:
- Check application logs for MuleSoft Inference connector errors
- Verify OpenAI API key permissions and quota
- Ensure internet connectivity for OpenAI API calls
- Confirm environment variable is properly loaded in application startup logs

### Environment Variable Debugging
1. **Local Development**: 
   - Run `echo $LLM_OPENAI_API_KEY` (macOS/Linux) or `echo %LLM_OPENAI_API_KEY%` (Windows)
   - Check IDE environment variable configuration
2. **CloudHub**: Verify in Runtime Manager → Application Settings → Properties
3. **Runtime Fabric**: Check Kubernetes environment configuration
4. **Application Logs**: Look for property resolution errors during startup

### Debugging Tips
1. **Check Logs**: Review `logs/` directory for detailed error information
2. **Test OpenAI Key**: Verify your API key works with OpenAI's API directly
3. **Environment Variables**: Confirm environment variable is set and accessible
4. **Network Issues**: Ensure outbound HTTPS connections are allowed
5. **Connector Logs**: Look for MuleSoft Inference connector specific error messages

### Getting Help
If issues persist:
1. Check the application logs for detailed error messages
2. Verify environment variable configuration is correct
3. Test with the provided Postman collection to isolate issues
4. Review the MUnit test cases for usage examples
5. Confirm MuleSoft Inference connector is properly configured in `global.xml`

## Security Considerations

### Enhanced Security with Environment Variables
- **Environment Variable Security**: OpenAI API keys are stored as environment variables, never in files
- **Version Control Safety**: No sensitive data can be accidentally committed to repositories
- **Deployment Security**: Different API keys can be used across environments (dev, staging, production)
- **Access Control**: Environment variables provide better access control and audit trails

### Application Security
- **Input Validation**: All fields are validated before processing
<<<<<<< HEAD
=======
- **Secure HTTP Headers**: Security headers are enabled
- **CORS Configuration**: CORS is properly configured
- **Request Size Limits**: Payload size is limited for security
- **Rate Limiting**: Consider implementing rate limiting for production use

### Best Practices
- **API Key Rotation**: Regularly rotate OpenAI API keys
- **Environment Isolation**: Use different API keys for different environments
- **Monitoring**: Monitor API key usage and set up alerts for unusual activity
- **Principle of Least Privilege**: Grant minimal necessary permissions to API keys
- **Secure Storage**: Use secure secret management systems in production (e.g., HashiCorp Vault, AWS Secrets Manager)

## Performance

- **Lightweight Processing**: Efficient fraud detection algorithms
- **Optimized DataWeave**: Efficient DataWeave transformations
- **AI Response Caching**: Consider implementing caching for repeated analyses
- **Configurable Timeouts**: Timeout settings can be adjusted as needed
- **High Throughput**: Optimized for concurrent request processing
>>>>>>> 3506572 (Replace MuleChain AI by Mule Inference + Refactor config API KEY to env variable)

## Support

For issues and questions:
1. **Check Logs**: Review detailed error information in application logs
2. **Verify Configuration**: Ensure OpenAI API key and other settings are correct
3. **Test with Postman**: Use the provided collection to validate functionality
4. **Review Tests**: Check MUnit test cases for usage examples
5. **Configuration Issues**: Verify all required fields are provided in requests

## Version History

- **v1.0.0**: Initial release with comprehensive AI-powered fraud detection capabilities
  - Multi-stage AI analysis with GPT-4o-mini
  - Comprehensive validation and error handling
  - Postman collection for easy testing
  - Complete documentation and troubleshooting guide
