Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1C10253D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfKSNRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:17:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33447 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSNRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 08:17:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id w9so23814328wrr.0;
        Tue, 19 Nov 2019 05:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UDi5Rs2tkahgTIzvDec007Gq0kmoW8wmGYBniT9RwHk=;
        b=KCG6tC9WRNTRYmkoBlK5eRluHXMDhWP3nR513n/riJReegx5A9FH8ygUAIU9glAb3I
         pX7i7ybFak5vv5/KlMmGG+5yHkWttBYcEpBlphZStr6DhfRm8xWA9+hs9A1AlArZ9DT2
         0yifdGiWCCmlb/8oUimstaYA0YAAABrNFZcrBmlWpKwxEZO0UlEoeNRb9X8eIjyfpGx5
         cDVuP/sE8ortOoO4dZXytj6GIGYCkzzoadYnaNLlAPkVbVtoXLE66EkWksgESKep/2uG
         eOW8Bx0+0hnQErEwyypjTAPYAwtuVOTJczORfUEu76e4EF1ezUAHhtaj56oAxYxu4VMU
         Go6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UDi5Rs2tkahgTIzvDec007Gq0kmoW8wmGYBniT9RwHk=;
        b=b56PwuNoqpgVxxlh+RNMNHjJuDuKoq5n7MmJvJCZJ+PzzQk8ktIjBphC7MoYGKKKfo
         fi7NXCCUy2+PV0ZwwNELehg+/7L++th55D6RC7WyjE680OsWbRiqSrsoMF6Oxam7ru/a
         Dmmiyw0xFSrGx3XHGXcyP+CA0PgsZmQyVUv/F+B3+16Ooy/YnDY7EFZiY7YCW3w674qv
         SBz3TFESylAtKA+0eramwR7flGdJxMskG5o9Zs81nVdgRhokKcObT15u1esNqvKTludl
         id4ndOdrfs7NAZl2awJtJd7fq0kLNF6svtViH83zh+n6FaZgOv9CeDLr9KP6768sBd8s
         LA4w==
X-Gm-Message-State: APjAAAXRAsB+YW8wh1H2GavGBpnYi9srB+0xFpHWinVA2evXf5azVoum
        auUc6hsHtSw2mkLNIjHVe/E=
X-Google-Smtp-Source: APXvYqw44wJMKWzEoFcP299Hryu6L/U1GgbtoeAyUt5FDAF32fNuCzj1uYmn7AfkNi4Y601SnsNmbw==
X-Received: by 2002:adf:da52:: with SMTP id r18mr37094834wrl.167.1574169438645;
        Tue, 19 Nov 2019 05:17:18 -0800 (PST)
Received: from [192.168.2.41] ([46.227.18.67])
        by smtp.gmail.com with ESMTPSA id f24sm2967970wmb.37.2019.11.19.05.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 05:17:17 -0800 (PST)
Subject: Re: [PATCH 4.19 150/422] tty/serial: atmel: Change the driver to work
 under at91-usart MFD
To:     Richard Genoud <richard.genoud@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radu Pirea <radu_nicolae.pirea@upb.ro>,
        Sasha Levin <sashal@kernel.org>
Cc:     "stable # 4 . 4+" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051408.360814564@linuxfoundation.org>
 <86754813-17ae-46c1-f222-1635c535668e@gmail.com>
From:   Richard Genoud <richard.genoud@gmail.com>
Message-ID: <ee45d6af-82c1-86e6-1abe-d9ac97307eec@gmail.com>
Date:   Tue, 19 Nov 2019 14:17:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <86754813-17ae-46c1-f222-1635c535668e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 19/11/2019 à 13:01, Richard Genoud a écrit :
> Hi all,
> 
> Le 19/11/2019 à 06:15, Greg Kroah-Hartman a écrit :
>> From: Radu Pirea <radu.pirea@microchip.com>
>>
>> [ Upstream commit c24d25317a7c6bb3053d4c193b3cf57d1e9a3e4b ]
>>
>> This patch modifies the place where resources and device tree properties
>> are searched.
> 
> Maybe I missed something, but I don't see why this is backported to stable.
> I don't think that this patch was send with a Cc: stable (I just came
> back from holidays, so I may be wrong :))
> 
> Moreover, it's part of a series that introduce "config MFD_AT91_USART",
> but grepping MFD_AT91_USART on stable-rc/linux-4.19.y only returns:
> drivers/tty/serial/Kconfig:     select MFD_AT91_USART
> 
> So I think this is a mistake (but how it got there ? it is by a bot or
> something ?)
Replying to myself :)

Mystery solved, it was added by Sasha's bot/AI
[PATCH AUTOSEL 4.19 118/205] tty/serial: atmel: Change the driver to work under at91-usart MFD

So Greg, you can safely drop this patch.

Thanks,

Richard.
> 
> regards,
> Richard
> 
>>
>> Signed-off-by: Radu Pirea <radu.pirea@microchip.com>
>> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Acked-by: Richard Genoud <richard.genoud@gmail.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/tty/serial/Kconfig        |  1 +
>>  drivers/tty/serial/atmel_serial.c | 42 ++++++++++++++++++++-----------
>>  2 files changed, 28 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index df8bd0c7b97db..32886c3046413 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -118,6 +118,7 @@ config SERIAL_ATMEL
>>  	depends on ARCH_AT91 || COMPILE_TEST
>>  	select SERIAL_CORE
>>  	select SERIAL_MCTRL_GPIO if GPIOLIB
>> +	select MFD_AT91_USART
>>  	help
>>  	  This enables the driver for the on-chip UARTs of the Atmel
>>  	  AT91 processors.
>> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
>> index dd8949e8fcd7a..251f708f47f76 100644
>> --- a/drivers/tty/serial/atmel_serial.c
>> +++ b/drivers/tty/serial/atmel_serial.c
>> @@ -195,8 +195,7 @@ static struct console atmel_console;
>>  
>>  #if defined(CONFIG_OF)
>>  static const struct of_device_id atmel_serial_dt_ids[] = {
>> -	{ .compatible = "atmel,at91rm9200-usart" },
>> -	{ .compatible = "atmel,at91sam9260-usart" },
>> +	{ .compatible = "atmel,at91rm9200-usart-serial" },
>>  	{ /* sentinel */ }
>>  };
>>  #endif
>> @@ -926,6 +925,7 @@ static void atmel_tx_dma(struct uart_port *port)
>>  static int atmel_prepare_tx_dma(struct uart_port *port)
>>  {
>>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>> +	struct device *mfd_dev = port->dev->parent;
>>  	dma_cap_mask_t		mask;
>>  	struct dma_slave_config config;
>>  	int ret, nent;
>> @@ -933,7 +933,7 @@ static int atmel_prepare_tx_dma(struct uart_port *port)
>>  	dma_cap_zero(mask);
>>  	dma_cap_set(DMA_SLAVE, mask);
>>  
>> -	atmel_port->chan_tx = dma_request_slave_channel(port->dev, "tx");
>> +	atmel_port->chan_tx = dma_request_slave_channel(mfd_dev, "tx");
>>  	if (atmel_port->chan_tx == NULL)
>>  		goto chan_err;
>>  	dev_info(port->dev, "using %s for tx DMA transfers\n",
>> @@ -1104,6 +1104,7 @@ static void atmel_rx_from_dma(struct uart_port *port)
>>  static int atmel_prepare_rx_dma(struct uart_port *port)
>>  {
>>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>> +	struct device *mfd_dev = port->dev->parent;
>>  	struct dma_async_tx_descriptor *desc;
>>  	dma_cap_mask_t		mask;
>>  	struct dma_slave_config config;
>> @@ -1115,7 +1116,7 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
>>  	dma_cap_zero(mask);
>>  	dma_cap_set(DMA_CYCLIC, mask);
>>  
>> -	atmel_port->chan_rx = dma_request_slave_channel(port->dev, "rx");
>> +	atmel_port->chan_rx = dma_request_slave_channel(mfd_dev, "rx");
>>  	if (atmel_port->chan_rx == NULL)
>>  		goto chan_err;
>>  	dev_info(port->dev, "using %s for rx DMA transfers\n",
>> @@ -2246,8 +2247,8 @@ static const char *atmel_type(struct uart_port *port)
>>   */
>>  static void atmel_release_port(struct uart_port *port)
>>  {
>> -	struct platform_device *pdev = to_platform_device(port->dev);
>> -	int size = pdev->resource[0].end - pdev->resource[0].start + 1;
>> +	struct platform_device *mpdev = to_platform_device(port->dev->parent);
>> +	int size = resource_size(mpdev->resource);
>>  
>>  	release_mem_region(port->mapbase, size);
>>  
>> @@ -2262,8 +2263,8 @@ static void atmel_release_port(struct uart_port *port)
>>   */
>>  static int atmel_request_port(struct uart_port *port)
>>  {
>> -	struct platform_device *pdev = to_platform_device(port->dev);
>> -	int size = pdev->resource[0].end - pdev->resource[0].start + 1;
>> +	struct platform_device *mpdev = to_platform_device(port->dev->parent);
>> +	int size = resource_size(mpdev->resource);
>>  
>>  	if (!request_mem_region(port->mapbase, size, "atmel_serial"))
>>  		return -EBUSY;
>> @@ -2365,27 +2366,28 @@ static int atmel_init_port(struct atmel_uart_port *atmel_port,
>>  {
>>  	int ret;
>>  	struct uart_port *port = &atmel_port->uart;
>> +	struct platform_device *mpdev = to_platform_device(pdev->dev.parent);
>>  
>>  	atmel_init_property(atmel_port, pdev);
>>  	atmel_set_ops(port);
>>  
>> -	uart_get_rs485_mode(&pdev->dev, &port->rs485);
>> +	uart_get_rs485_mode(&mpdev->dev, &port->rs485);
>>  
>>  	port->iotype		= UPIO_MEM;
>>  	port->flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP;
>>  	port->ops		= &atmel_pops;
>>  	port->fifosize		= 1;
>>  	port->dev		= &pdev->dev;
>> -	port->mapbase	= pdev->resource[0].start;
>> -	port->irq	= pdev->resource[1].start;
>> +	port->mapbase		= mpdev->resource[0].start;
>> +	port->irq		= mpdev->resource[1].start;
>>  	port->rs485_config	= atmel_config_rs485;
>> -	port->membase	= NULL;
>> +	port->membase		= NULL;
>>  
>>  	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
>>  
>>  	/* for console, the clock could already be configured */
>>  	if (!atmel_port->clk) {
>> -		atmel_port->clk = clk_get(&pdev->dev, "usart");
>> +		atmel_port->clk = clk_get(&mpdev->dev, "usart");
>>  		if (IS_ERR(atmel_port->clk)) {
>>  			ret = PTR_ERR(atmel_port->clk);
>>  			atmel_port->clk = NULL;
>> @@ -2718,13 +2720,22 @@ static void atmel_serial_probe_fifos(struct atmel_uart_port *atmel_port,
>>  static int atmel_serial_probe(struct platform_device *pdev)
>>  {
>>  	struct atmel_uart_port *atmel_port;
>> -	struct device_node *np = pdev->dev.of_node;
>> +	struct device_node *np = pdev->dev.parent->of_node;
>>  	void *data;
>>  	int ret = -ENODEV;
>>  	bool rs485_enabled;
>>  
>>  	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
>>  
>> +	/*
>> +	 * In device tree there is no node with "atmel,at91rm9200-usart-serial"
>> +	 * as compatible string. This driver is probed by at91-usart mfd driver
>> +	 * which is just a wrapper over the atmel_serial driver and
>> +	 * spi-at91-usart driver. All attributes needed by this driver are
>> +	 * found in of_node of parent.
>> +	 */
>> +	pdev->dev.of_node = np;
>> +
>>  	ret = of_alias_get_id(np, "serial");
>>  	if (ret < 0)
>>  		/* port id not found in platform data nor device-tree aliases:
>> @@ -2860,6 +2871,7 @@ static int atmel_serial_remove(struct platform_device *pdev)
>>  
>>  	clk_put(atmel_port->clk);
>>  	atmel_port->clk = NULL;
>> +	pdev->dev.of_node = NULL;
>>  
>>  	return ret;
>>  }
>> @@ -2870,7 +2882,7 @@ static struct platform_driver atmel_serial_driver = {
>>  	.suspend	= atmel_serial_suspend,
>>  	.resume		= atmel_serial_resume,
>>  	.driver		= {
>> -		.name			= "atmel_usart",
>> +		.name			= "atmel_usart_serial",
>>  		.of_match_table		= of_match_ptr(atmel_serial_dt_ids),
>>  	},
>>  };
>>
> 

