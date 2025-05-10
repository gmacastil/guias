package com.example.rabbitmq.consumer;

import com.example.rabbitmq.model.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Service;

@Service
public class MessageConsumer {

    private static final Logger LOGGER = LoggerFactory.getLogger(MessageConsumer.class);

    @RabbitListener(queues = {"${rabbitmq.queue.name}"})
    public void consumeMessage(Message message) {
        LOGGER.info("Mensaje leeido de la cola -> {}", message);
        
        // Aquí puedes procesar el mensaje recibido
        // Por ejemplo, guardar en base de datos, enviar notificaciones, et

        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } // Simulando un procesamiento lento
        
        LOGGER.info("Mensaje enviado a correo");

        // OTEL tracing

    }
}
