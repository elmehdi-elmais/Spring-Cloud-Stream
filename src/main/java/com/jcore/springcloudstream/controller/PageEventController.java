package com.jcore.springcloudstream.controller;

import com.jcore.springcloudstream.event.PageEvent;
import lombok.AllArgsConstructor;
import org.springframework.cloud.stream.function.StreamBridge;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.Random;


@RestController
@AllArgsConstructor
public class PageEventController {

    StreamBridge streamBridge;

    @GetMapping("/publish")
    public PageEvent publish(String name, String topic) {
        PageEvent event = new PageEvent(
                name,
                Math.random()>0.5?"U1":"U2",
                new Date(),
                new Random().nextInt(10000)
        );
        streamBridge.send(topic, event);
        return event;
    }
}
