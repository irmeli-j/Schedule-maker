#detta är jag helt säker på att det är fel men hinner inte sätta mig in i hur man faktiskt ska göra. 
#Ska på något vis kunna koppla slim filen till ruby koden. (tror jag lol)
require "sinatra"
require "slim"

get "/" do
  slim :layout
end