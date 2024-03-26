from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

# Load the trained model
model = joblib.load('backend/task2fooddelivery.pkl')
@app.route('/predict', methods=['POST'])
def predict():
    # Get the JSON data from the request
    data = request.json
    
    # Extract features from JSON data
    features = [float(data.get('Delivery_person_Age', 0)),
                float(data.get('Restaurant_latitude', 0)),
                float(data.get('Restaurant_longitude', 0)),
                float(data.get('Delivery_location_latitude', 0)),
                float(data.get('Delivery_location_longitude', 0)),
                float(data.get('Type_of_order', 0)),
                float(data.get('Type_of_vehicle', 0))]
    
    # Make prediction
    prediction = model.predict([features])[0]
    
    # Convert prediction to regular Python float
    prediction = float(prediction)

    # Return prediction as JSON response
    return jsonify({'prediction': prediction})

if __name__ == '__main__':
    app.run(debug=True)
