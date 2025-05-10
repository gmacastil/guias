package com.example.rabbitmq.producer;

import com.example.rabbitmq.model.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class MessageProducer {

    private static final Logger LOGGER = LoggerFactory.getLogger(MessageProducer.class);

    @Value("${rabbitmq.exchange.name}")
    private String exchangeName;

    @Value("${rabbitmq.routing.key}")
    private String routingKey;

    private final RabbitTemplate rabbitTemplate;

    public MessageProducer(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    // Enviar un mensaje a RabbitMQ manualmente
    public void sendMessage(String content) {
        Message message = new Message(
            UUID.randomUUID().toString(),
            content,
            LocalDateTime.now()
        );
        
        LOGGER.info("Enviando mensaje a rabbit-> {}", message);
        
        rabbitTemplate.convertAndSend(exchangeName, routingKey, message);
    }
    
    // Enviar un mensaje automáticamente cada 10 segundos
    //@Scheduled(fixedRate = 10000)
    //public void sendPeriodicMessage() {
    //    Message message = new Message(
    //        UUID.randomUUID().toString(),
    //        "Mensaje automático: " + LocalDateTime.now(),
    //        LocalDateTime.now()
    //    );
    //    
    //    LOGGER.info("Enviando mensaje periódico -> {}", message);
    //    
    //    rabbitTemplate.convertAndSend(exchangeName, routingKey, message);
    //}
}
