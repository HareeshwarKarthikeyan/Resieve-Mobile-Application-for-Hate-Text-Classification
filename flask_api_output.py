# Load libraries
import flask
import pandas as pd
import numpy as np
import tensorflow as tf
import keras
from tensorflow.python.keras.models import load_model
from tensorflow.python.keras.backend import set_session
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from decimal import Decimal
import re

# instantiate flask 
app = flask.Flask(__name__)



# tf_config = some_custom_config
sess = tf.Session()
graph = tf.get_default_graph()


# IMPORTANT: models have to be loaded AFTER SETTING THE SESSION for keras! 
# Otherwise, their weights will be unavailable in the threads after the session there has been set
set_session(sess)
model = load_model('Model3.h5')
model._make_predict_function()
tokenizer = Tokenizer(num_words=10000, lower=True)
xtrain = pd.read_csv('finalcleandataTraining.csv')
xtrain = xtrain['message']
tokenizer.fit_on_texts(xtrain)



@app.route('/api/<message>')
def api(message):
	message = message.split()
	df = pd.DataFrame(data=message, columns=['message'])
	dataTrain = df['message']
	xtestdata = tokenizer.texts_to_sequences(dataTrain)
	# print(xtestdata)
	xfinal = pad_sequences(xtestdata, value = 0,padding='post', maxlen=64)
	print(xfinal)

	global sess
	global graph
	with graph.as_default():
		set_session(sess)
		answer = model.predict(xfinal)
		s = str(answer[0])
		print(s)
		re.sub('[^0-9.]+', '', s)
		res = s.split()
		res[0] = res[0][1:]
		res[4] = res[4][:8]
		answer = []
		for x in range(len(res)):
			if(Decimal(res[x])>0.5):
				answer.append('1')
			else:
				answer.append('0')
		print(answer)
		result = ''
		for x in answer:
			result += x

	return result


app.run(host='0.0.0.0', debug=True, port=5005)
