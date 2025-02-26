
     @%%#%@%%%@%@@@@%@@@@#*@@%%%%%%%@%%%@@@@@
     %%%#%@@@@@@@@%%%%##*+===*%%%%%%%%%@@@@@@
     %%%#@@@%#**#%%##**+++*####****+++@@@@@@@
     %%%#@%#**++++++++*#++#***#####*==+@@@@@@
     %%%%%##+++***###**********###%%%=++@@@@@
     %%%@%#++++**######**+++++==*##%%%++%@%@@
     %%%%%+++++***#*####*+++**-.:-###%++*%%@@
     %%%%%+=+=+*+...:###*+==**...-=##%+++%%@@
     %##%%-===.... .:####+==.....:*##%+++%%@@
     %%%%%%===::-=:=*####+++==--==####+*+%%@@
     @@@%%%#+++=:-****###++++++++**##*+*#%%@@
     @@@@@%%#*++++++*#%%%####+:*#####*++#%@@@
     +%@%@@@%%##*******++++++++-+***###%%@@@@
     @@@@@@@%%###******####%####*+++*#%%%%@@@
     @@@@@@@@@%%##+++****++***%##++**#%%%@@@@
     @@@@@%@@@@%%#.:++==+==--+###++**%%%@@@@@
     @@@%%%@@@%@%#=++:.::---:*##*****%%@@@@%%
     @@@%@@@@@@%@%##*++++****+==*****%%%%%%%%
     @@@@@@@@@@%@%#####++*##*******##%%%%%%%@
     @@@@@@@@@@@@@@%%###**###%%%%%%*%%%%%%%@@
     @@@@@@@@@@@@@@@@@@@@@@@@@@%%###@@%%%%%%%
     @@@@@@@@@@@@@@@@@@@@@%%%%*###*%%%@#%%%%%
     %@@@@@@@@@@@@@@@@@%%@%##@@@%#%%%%%@%%%%%
                                          

## What is 790:

* A docker that receives Defender webhooks and notifies a WhatsApp account of DDoS events

## Licence

* 790 is Opensource. 
* 790 uses gazoo as a base, gazoo is also opensource. https://github.com/sigreen-nokia/gazoo 

* The topology could not be much simpler
   
           ############      ############            ######################
           #          #      #          #            #                    #
           # Network  #      # Deefield #            # osx/linux/win      #
           # Under    # ---> # Defender # -webhook-> #                    # -WhatsApp message API->
           # Attack   #      #          #            # running 790        #
           #          #      #          #            # docker             #
           #          #      #          #            #                    #
           ############      ############            ######################
     
## platforms

* should run on pretty much any docker or docker desktop
* I've tested this on my mac running docker for desktop (for ARM CPU's enable rosseta in advanced settings)
* I've also tested this on Ubuntu Linux 20.04. Install docker using your favorite site 
* I've also tested this on Windows 10 using wsl and docker for desktop 

## pre requisits

* Docker 

## Steps to configure your WhatsApp account for message api (if you have not already)

```
create a Meta developer account
on the console https://developers.facebook.com/apps/
   create an app 
       name: deepfield 
       email: [your email] 
       other->Business
       WhatsApp
Login to Meta Business Suite https://business.facebook.com
       Make sure you have a system user
       Create a perminent access token with admin user, permission whatsapp_business_messaging (see https://developers.facebook.com/blog/post/2022/12/05/auth-tokens/)
```

## configure 790 to use your WhatsApp account

* Set these three variables in file scripts/default.sh 

```
export WHATSAPP_PHONE_NUMBER_ID="642398275615559"
export META_PERMANENT_ACCESS_TOKEN="EAARZCIZBewkk8BO7iPSXXkfAbiNY90NoyrnQNLMYGxLHc2mRBnhNHZAHTKpSoxyKZCvFf7dgj4bSTF1mFCqzFAAf3GnZCO7pEdXuZBtW72x1fIY6Y2tnuEb5Gh5AZARr7wK7yICblIN740az34QIFpU8YZCDSGBLWlaStgEXEQZCkwfUiRtPS5aG6y6dXe47qcll7rwZDZD"
export WHATSAPP_PHONE_NUMBER_TO_CALL="447801878914"
```

* Note: Whatsapp text messages will not work unless the user (The WHATSAPP_PHONE_NUMBER_TO_CALL) has previously sent you a text message, 

## run 790 as follows 

```
cd  790 #(you must be in this 790  git when you run docker)
docker run -d  -v /tmp/gazoo-commands:/tmp/gazoo-commands --restart always --name=gazoo -v ${PWD}/scripts:/scripts -p 8080:8080 simonjohngreen/gazoo
```

## Steps to configure the webhook on Deepfield
* The assumption is that you have port 8080 opened up all the way to the docker
*  In the defender ui
*  Admin->notification->[add]
*  name 790        
*  tick webhook         
*  url: http://[your docker hosts ip or fqdn]:8080
*  click test, you should see a green test sent successfully if your firewall routers and docker allow the 8080 port traffic
*  save
*  add this notification as the action in your Defender policies

## Then what ?

* start or wait for a DDoS event 
* you should see DDoS related messages on your WhatsApp account

## Developer ? 
* If you are a developer and would preffer to build your own container using my source code see https://github.com/sigreen-nokia/gazoo 

## Screen Shots

<img src="https://github.com/sigreen-nokia/790/blob/main/pics/whatsapp-phone-app.png" alt="Alt Text" width="200" height="600">




