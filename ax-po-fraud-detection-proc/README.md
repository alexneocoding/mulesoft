# AI-Powered PO Fraud Detection API

MuleSoft API using OpenAI GPT-4 to detect fraudulent patterns in Purchase Orders with intelligent risk scoring (0-100).

## Prerequisites

- Java 17+
- Maven 3.6+
- MuleSoft Runtime 4.4.0+
- OpenAI API Key

## Quick Setup

1. **Set OpenAI API Key**
   ```bash
   export LLM_OPENAI_API_KEY="your-openai-api-key"
   ```

2. **Run Application**
   ```bash
   mvn clean compile
   mvn mule:run
   ```

3. **Verify**: API available at `http://localhost:8081`

## API Usage

### POST /api/fraud-detection/analyze

**Request:**
```json
{
  "poNumber": "PO-2023-001",
  "vendorId": "VENDOR-12345",
  "amount": 50000,
  "poDate": "2023-12-01",
  "description": "Office equipment"
}
```

**Response:**
```json
{
  "transactionId": "550e8400-e29b-41d4-a716-446655440000",
  "timeStamp": "2023-12-03T17:15:30.123Z",
  "poNumber": "PO-2023-001",
  "fraudAssessment": {
    "riskLevel": "MEDIUM",
    "riskScore": 65,
    "fraudIndicators": ["High amount with round number pattern"],
    "recommendation": "Manual review recommended",
    "aiConfidence": 87
  },
  "status": "ANALYZED"
}
```

## Risk Levels

- **MINIMAL** (0-19): Approve
- **LOW** (20-49): Monitor  
- **MEDIUM** (50-79): Manual review
- **HIGH** (80+): Reject

## Testing

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

## Deployment

### CloudHub
1. Set environment variable: `LLM_OPENAI_API_KEY=your-key`
2. Deploy: `mvn clean package deploy -DmuleDeploy`

## Troubleshooting

**Missing API Key**: Verify `LLM_OPENAI_API_KEY` environment variable is set

**Connection Failed**: Check port 8081 availability and application startup logs

**Validation Errors**: Ensure all required fields (poNumber, vendorId, amount, poDate, description) are provided
