shinyServer(function(input, output,session){
  
  observe({
    selected1=unique(SGSIN[SGSIN$neighbourhood_group==input$selected0,'neighbourhood'])
    updateSelectizeInput(
      session,'selected1',
      choices = selected1,
      selected = selected1[1]
    )
  })
  
  
  listingSGSIN <- reactive({
    selected0 = input$selected0
    selected1 = input$selected1
    selected2 = input$selected2
    SGSIN %>%
      select(neighbourhood_group, neighbourhood,room_type, longitude,latitude,price) %>%
      filter(neighbourhood_group == selected0 & neighbourhood == selected1 & room_type == selected2)
  })  
  output$map <- renderLeaflet({
    leaflet()%>% setView(lng = 103.851959, lat = 1.290270, zoom = 11) %>% 
      addTiles() %>% addMarkers(lng = listingSGSIN()$longitude, lat = listingSGSIN()$latitude)
  })
  
  output$plotmap <- renderPlot({
    ggplot(listingSGSINplot %>% filter(neighbourhood_group == input$selected0 & neighbourhood == input$selected1), aes(price, color=room_type)) + geom_freqpoly()
  })
  
  listingSGSINplot <- SGSIN %>%
    select(neighbourhood_group, neighbourhood, room_type, price, minimum_nights)
  
  output$plot1 <- renderPlot({
    ggplot(listingSGSINplot %>% filter(minimum_nights >= input$selected4[1] & minimum_nights <= input$selected4[2] &
                                       price >= input$selected3[1] & price <= input$selected3[2]), aes(neighbourhood_group)) + 
      geom_bar(aes(fill=room_type), position = position_dodge())
  })
  
  output$plot2 <- renderPlot({
    # listingSGSINplot %>% group_by(neighbourhood_group) %>% su
    ggplot(listingSGSINplot %>% filter(minimum_nights >= input$selected6[1] & minimum_nights <= input$selected6[2]),
           aes(neighbourhood_group, price)) + 
      geom_bar(aes(fill=room_type), position = position_dodge(),stat = "identity")
  })
  output$plot3 <- renderPlot({
    ggplot(listingSGSINplot %>% filter(minimum_nights >= input$selected5[1] & minimum_nights <= input$selected5[2] & neighbourhood_group == input$selected7),
           aes(neighbourhood, price)) + 
      geom_bar(aes(fill=room_type), position = position_dodge(),stat = "identity") +
      theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
  })
  output$table <- DT::renderDataTable({
    datatable(SGSIN, rownames=FALSE)
  })
  
  
  # show the map view
  output$mapplot <- mapview::renderMapview({
    mapview::mapview(data_locations_sf,
                     zcol = "hostname",
                     legend = T,
                     legend.opacity = 0.5,
                     layer.name = 'Host Name'
    )
  })
  
  
})