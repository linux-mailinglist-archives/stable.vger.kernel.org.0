Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72335047B9
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 14:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiDQM1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 08:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiDQM1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 08:27:12 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A681713D07;
        Sun, 17 Apr 2022 05:24:36 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c64so14817726edf.11;
        Sun, 17 Apr 2022 05:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0hD9MkT8n+yyS1RvNUh1Aeb6lxcf/70szx3L5/Yc7mw=;
        b=NqSMs+meV0qbtuK2CN0JXky08NlnjDT77JKXPXMg7IdXWbDmBwmmjihFmP5g+cY4uz
         f4alPXWkhAHlmHlX6pbDQZm7k5vgBjfnUm4pKPBG+067CnYDDfRFMPtQ5/l55HiEJldo
         Gno6TNqQeG3uwSV7PeT41sgKAKCM38qc268Cu2tE+j7/RZjrWGhed+B9K/cl2cUBExpU
         KNjLRLK2DwOsiiI+JkXBpJ3oCMsSON1h5MlrrsH2Kx36LHvcI9oYtnOasKvwQ0xuMuwA
         aoHdU0RFXulv+fKdUeT5NVffa8KjcNLJB3N0GVS8tq5T1h/Trs6H97KYDPN6RJjrZq3/
         CDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0hD9MkT8n+yyS1RvNUh1Aeb6lxcf/70szx3L5/Yc7mw=;
        b=kmWK7tmLfPxbfvRjhps/he6NhGVkgGQjm8k83GBCkMfoakRkNgCzYRdAvdkznBpqtN
         MeCfwutEaoEc/OK9GLLx1OnOZPeEvNA6rBgNYwuv13JVA15XzU1ayR5EXky9/HMsKg2q
         qs/qRXgey4/7QD0kjqlLURUid3Wu2/9+RI8GmoLDkke/NdWfzfLVMOUFRyMIt5WZwNLo
         59ub2+y5sEb1f1HFfu3Pq2s5K6V0fXbY+bG71AKkm6a0pKBXWL4BOOiOsSVZAdeuY1Ja
         kKX6/rd3H8To5sFR76NJTp9xRKOlhUNZJfELyVtlYUWFkFbj7GZufboy4uLrlSUJIrNo
         +x8w==
X-Gm-Message-State: AOAM531eujaqx3R1DqQx7f5KWo+hJbRqbL/1YUcyXj1Ubs0vVR6Boi9E
        +dlb5WUrmZZDsxVrt98WiG4=
X-Google-Smtp-Source: ABdhPJxG9QJK7v74CMy/iZ8ck9cA+lnnKPWyCatSPNJZ16MBfMutne7viq5sY/Cmx6Pm2Ma2unf6cA==
X-Received: by 2002:a05:6402:5212:b0:41d:7e13:b817 with SMTP id s18-20020a056402521200b0041d7e13b817mr7729270edd.224.1650198275163;
        Sun, 17 Apr 2022 05:24:35 -0700 (PDT)
Received: from [192.168.1.76] (130.43.111.128.dsl.dyn.forthnet.gr. [130.43.111.128])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05640204d000b0042062f9f0e1sm5550484edw.15.2022.04.17.05.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 05:24:34 -0700 (PDT)
Message-ID: <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com>
Date:   Sun, 17 Apr 2022 15:24:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-GB-large
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        stable@vger.kernel.org
References: <20220414025705.598-1-mario.limonciello@amd.com>
From:   firew4lker <firew4lker@gmail.com>
In-Reply-To: <20220414025705.598-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/22 05:57, Mario Limonciello wrote:
> commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before
> initialization") attempted to fix a race condition that lead to a NULL
> pointer, but in the process caused a regression for _AEI/_EVT declared
> GPIOs. This manifests in messages showing deferred probing while trying
> to allocate IRQs like so:
>
> [    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
> [    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
> [    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
> [    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003E to IRQ, err -517
> [    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003A to IRQ, err -517
> [    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003B to IRQ, err -517
> [    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0002 to IRQ, err -517
> [    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0011 to IRQ, err -517
> [    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0012 to IRQ, err -517
> [    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0007 to IRQ, err -517
>
> The code for walking _AEI doesn't handle deferred probing and so this leads
> to non-functional GPIO interrupts.
>
> Fix this issue by moving the call to `acpi_gpiochip_request_interrupts` to
> occur after gc->irc.initialized is set.
>
> Cc: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>   drivers/gpio/gpiolib.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 085348e08986..b7694171655c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>   
>   	gpiochip_set_irq_hooks(gc);
>   
> -	acpi_gpiochip_request_interrupts(gc);
> -
>   	/*
>   	 * Using barrier() here to prevent compiler from reordering
>   	 * gc->irq.initialized before initialization of above
> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>   
>   	gc->irq.initialized = true;
>   
> +	acpi_gpiochip_request_interrupts(gc);
> +
>   	return 0;
>   }
>   

Tested-By:firew4lker@gmail.com

This patch addresses the issue. Tested on a Lenovo T14 with AMD Ryzen 5 
PRO 4650U with Radeon Graphics Graphics.

Without this patch the laptop is impossible to wake from S3 and S0ix.

