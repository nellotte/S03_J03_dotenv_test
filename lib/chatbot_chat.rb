require 'dotenv' # Appelle la gem Dotenv
require 'json'
require 'http'

Dotenv.load

# création de la clé d'api et indication de l'url utilisée.
api_key = ENV["OPENAI_API_KEY"]
url = "https://api.openai.com/v1/engines/text-davinci-003/completions"

# un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}
# Crée un tableau vide pour stocker les questions et réponses
conversation_history = []

loop do
  puts "BOT : demande moi ce que tu veux..."
  puts "Nelly :" 
  user_input = gets.chomp
  conversation_history << "Nelly : #{user_input}" # Ajoute la réponse à l'historique de conversation
 
  if user_input.downcase == "stop"
    puts "Arrêt du programme."
    break
  elsif user_input.downcase == "historique"
    # Affiche l'historique complet de la conversation
    puts "Historique complet de la conversation :"
    conversation_history.each do |entry|
      puts entry
    end
  else
    # Un peu de JSON pour envoyer des informations directement à l'API
    data = {
      "prompt" => "#{conversation_history}",
      "max_tokens" => 150,
      "n" => 1,
      "temperature" => 0
    }
    
    response = HTTP.post(url, headers: headers, body: data.to_json)
    response_body = JSON.parse(response.body.to_s)
    response_string = response_body['choices'][0]['text'].strip

    puts "Voici ma réponse de Bot :" 
    puts response_string
  
    # Ajoute la réponse à l'historique de conversation
    conversation_history << "Bot : #{response_string}"
  end
end



