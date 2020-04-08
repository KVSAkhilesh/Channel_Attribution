library(shiny)
library(magrittr)
library(ChannelAttribution)
library(reshape2)
library(ggplot2)
library(dplyr)

shinyServer(
  function(input, output) {
    
    
    data <- reactive({
      inFile <- input$file1
      
      if (is.null(inFile))
        return(NULL)
      
      read.csv(inFile$datapath, header=input$header, sep=input$sep, 
               quote=input$quote)
      
    })
    
   
    Results <- reactive({ 
     
      H <- heuristic_models(data(), 'path', 'conversion','conversion')
      M <- markov_model(data(),'path', 'conversion', var_value='conversion', order=input$markov_order)
      R <- merge(H,M,by='channel_name') 
      R1 <- R[,(colnames(R)%in%c("channel_name","first_touch_conversions","last_touch_conversions" ,"linear_touch_conversions","total_conversion"))] 
      colnames(R1) <- c('channel_name','first_touch','last_touch','linear_touch','markov_model') 
      R1 <- melt(R1,id="channel_name")
      R1
    })
    
    
    output$results <- renderTable({
      Results()
    })
    
    
    output$table <- renderTable(data())
    
    
    
    
    output$plots <- renderPlot({
      
      Results2 <- reactive({ 
        
        Results() %>%
            filter(variable== c('markov_model','first_touch','last_touch','linear_touch')) %>%
            mutate(value2 = round(value,2))
        
        
      })
      
      ggplot(Results(), aes(x=channel_name, y=value, fill = variable)) + 
        geom_bar(stat="identity", position = "dodge") + 
        #geom_text(aes(label=value), position=position_dodge(width=0.9),vjust=-0.5)+
        ggtitle("Attribution Model") + 
        theme(axis.title.x = element_text(vjust=-2))+ 
        theme(axis.title.y = element_text(vjust=+2))+ 
        theme(title = element_text(vjust=2))+ 
        theme(text = element_text(size=16)) + 
        theme(plot.title=element_text(size=20)) + 
        ylab("Number of Conversions")
      
      
   
    })
      
    
    output$downloadData <- downloadHandler(
      filename = function(){
                    paste(input$dataset, '.csv', sep ='')
        
      },
      
      content = function(file){
                    write.csv(Results(), file)
      }
      
    )
    
  })
