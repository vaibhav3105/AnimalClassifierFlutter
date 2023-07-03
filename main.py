from fastapi import FastAPI,UploadFile,File
import tensorflow as tf
import uvicorn
app=FastAPI()

MODEL=tf.keras.models.load_model('animal_model')
class_names=['antelope',
 'badger',
 'bat',
 'bear',
 'bee',
 'beetle',
 'bison',
 'boar',
 'butterfly',
 'cat',
 'caterpillar',
 'chimpanzee',
 'cockroach',
 'cow',
 'coyote',
 'crab',
 'crow',
 'deer',
 'dog',
 'dolphin',
 'donkey',
 'dragonfly',
 'duck',
 'eagle',
 'elephant',
 'flamingo',
 'fly',
 'fox',
 'goat',
 'goldfish',
 'goose',
 'gorilla',
 'grasshopper',
 'hamster',
 'hare',
 'hedgehog',
 'hippopotamus',
 'hornbill',
 'horse',
 'hummingbird',
 'hyena',
 'jellyfish',
 'kangaroo',
 'koala',
 'ladybugs',
 'leopard',
 'lion',
 'lizard',
 'lobster',
 'mosquito',
 'moth',
 'mouse',
 'octopus',
 'okapi',
 'orangutan',
 'otter',
 'owl',
 'ox',
 'oyster',
 'panda',
 'parrot',
 'pelecaniformes',
 'penguin',
 'pig',
 'pigeon',
 'porcupine',
 'possum',
 'raccoon',
 'rat',
 'reindeer',
 'rhinoceros',
 'sandpiper',
 'seahorse',
 'seal',
 'shark',
 'sheep',
 'snake',
 'sparrow',
 'squid',
 'squirrel',
 'starfish',
 'swan',
 'tiger',
 'turkey',
 'turtle',
 'whale',
 'wolf',
 'wombat',
 'woodpecker',
 'zebra']
@app.get('/ping')
async  def ping():
    return "I am vaibhav"
@app.post('/predict')
async def predict(
        file:UploadFile=File(...)
):
    image=await file.read()

    image=tf.io.decode_image(image)
    image = tf.expand_dims(image, axis=0)
    prediction=MODEL.predict(image)
    print(max(prediction[0]))
    return {'predicted_class':class_names[prediction.argmax()],'confidence':str(max(prediction[0]))}



if __name__=='__main__':
    uvicorn.run(app,port=8000,host='localhost')

