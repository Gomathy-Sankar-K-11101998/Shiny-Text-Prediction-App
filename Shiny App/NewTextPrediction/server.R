#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)
library(stringi)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    source('Prediction_New.R')
    
    Word = reactive({
        string = input$InputText 
        tolower(string)
    })
    
    word_count = reactive({
        stri_count_words(Word())
    })
    
    display_num = 5
    
    Words_List = reactive({
        if(word_count() >= 3) {
            Words = strsplit(Word(), " ") %>% unlist()
            Words = tail(Words, 2)
            Word_local = paste(Words[1], Words[2], sep = " ") %>% tolower()
            word_count_local = stri_count_words(Word_local)
        }
        
        if(word_count() < 3) {
            Word_local = Word()
            word_count_local = word_count()
        }
        
        if(word_count_local == 2) {
            Words = strsplit(Word_local, " ") %>% unlist()
            tri_words = TrigramPredictor(Words)
            bi_words = BigramPredictor(Words[2])
            uni_words = UnigramPredictor()
            list_of_words_local = c(tri_words, bi_words, uni_words)
        }
        
        if(word_count_local == 1) {
            bi_words = BigramPredictor(Word_local)
            uni_words = UnigramPredictor()
            list_of_words_local = c(bi_words, uni_words)
        }
        
        if(word_count_local == 0) {
            list_of_words_local = UnigramPredictor()
        }
        
        list_of_words_local
    })
    
    output$PredictWord = renderText({
        Words_List()[1]
    })
    
    output$WordsTable = renderTable({
        Words_List()[2:5]
    })
    
    output$Predict_Word_Sent = renderUI({
        "The most accurate predicted word is : "
    })
    
    output$Other_Word_Sent = renderUI({
        "The other predicted words are: "
    })
    
    output$Information = renderUI({
        "The help page for the application's working is shown  in the nearby tab named 
        \"Help Documentation\". You can view this help page for information about the 
        app's working, methodology implemented and any other information on the application."
    })
    
    output$Advanced_App = renderUI({
        "This is another Text Prediction Application an advanced app, I have designed. Similar to this 
        application it works but in a much more precise and accurate way. All the users are kindly asked for 
        trying out this application also for fun."
    })
    
    URL = a("Advanced Text Prediction App", href = "https://gomathy-sankar-k-11101998.shinyapps.io/Advanced_Text_Prediction_App/")
    
    output$Website = renderUI({
        tagList("URL Link is : ", URL)
    })
    
    output$Document = renderText({
        "\"HELP DOCUMENT PAGE\" 
        
        About the Application:  
        
        This appplication is completely dedicated for predicting the next word based on the word (or) set 
        of words that is given as the input by the user.  
        An example of this application's performing is if the user writes an input 'he is a friend of' then 
        some of the next words that are predicted and displayed are 'mine', 'him', 'hers' and so on.  
        So, this example is depicted in order to understand the basics of this application's operation.  
        
        Datasets Used:  
        
        Three Datasets are considered for this text prediction operation.  
        1. Blogs Text file  
        2. News Text file  
        3. Twitter Text file  
        
        All the lines in the 3 datasets are read into separate variables and then combined and a small part 
        of the combined dataset is sampled to get a training dataset.
        
        N-Gram Modelling:  
        
        The training dataset is tokenized and 1, 2 and 3 gram modelling is performed. 
        
        Unigram - Modelling: The text dataset is split into single words and frequency of occurence of 
        each word is noted.  
        
        Bigram - Modelling: The text dataset is split into a combination of 2 words and the frequency of 
        each word set is calculated.  
        
        Trigram - Modelling: The text dataset is split into a combination of 3 words and the frequency of 
        each word set is calculated.  
        
        Prediction Algorithm:  
        
        This text prediction application works on the method of stupid back-off algorithm. 
        
        Application Usage:  
        
        This application is very user-friendly. Below is the tasks required for using this application. 
        
        1. The user needs to mention the word (or) set of words in the input text box provided in the top left 
        corner of the application.  
        
        2. The most accurate (or) the best possible word being predicted will be displayed in the first in 
        the top of the main panel. The next 4 possible predicted words are displayed below this first word 
        in the main panel.
        
        This is the main help page representing the application's working. For better understanding, usage 
        of the application will be a better way............"
    })
})
