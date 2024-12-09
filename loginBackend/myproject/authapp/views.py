from django.contrib.auth.hashers import make_password, check_password
from rest_framework.response import Response
from rest_framework import status
from .models import HydroVizUser
from .serializer import HydroVizUserSerializer
from rest_framework.decorators import api_view

@api_view(['POST'])
def signup(request):
    credential = request.data  #credentials from the user
    userEmail = credential['email'] 

    #if account already exists then the user should Login
    if((HydroVizUser.objects.get(email = userEmail).exists())):
        return Response({'message': 'Account already exists, Please Login'}, status = status.HTTP_400_BAD_REQUEST)
    
    #let new user create an account
    else:
        credential['password'] = make_password(credential['password']) #password is hashed
        serializer = HydroVizUserSerializer(data = credential) #data added to the serializer

        if serializer.is_valid(): 
            serializer.save() #save credentials to the database
            return Response({'message': 'Sign Up was successful'}, status = status.HTTP_201_Created)
        
        return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def login(request):
    credential = request.data
    userEmail = credential['email']

    if(HydroVizUser.objects.get(email = userEmail)): #checks for the email in DB
        user = HydroVizUser.objects.get(email = userEmail) #data related to the email assigned to the user

        #if password matches
        if check_password(credential['password'], user.password):
            return Response({'message': 'Login Successful'}, status = status.HTTP_200_OK)
        
        #else Incorrect password
        return Response({'message': 'Incorrect Password'}, status = status.HTTP_401_UNAUTHORIZED)

    else: #if email not found
        return Response({'error': 'User not found'}, status = status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def resetPassword(request):
    email = request.data['email']

