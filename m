Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0527A50181F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350293AbiDNQBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359010AbiDNPmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:42:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3963AF211A;
        Thu, 14 Apr 2022 08:26:01 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bg10so10752416ejb.4;
        Thu, 14 Apr 2022 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0EhNSpMEIQGwegy6XwubyizxkyeN0Yst2h+T5pwc7wQ=;
        b=XSdI9SNB3jBQqpAUl2AkG4FTRNx/rdgEV/ie4LGU/cNA+rGhpI1sdCNLipuVapA0uo
         JRw6MqoFe3lSaO9LY7dB8t7RMDFS9yyI44MU9veZ8hi9/HgRly2OP7Ax9KVEzxwehmMW
         42QJpXyApV/qSQDgVxunEy/DsnNErAsOTkMzIW/94gU9eQTpQgaCeZZ9HwHYeAfojxEq
         2mxP4lSaiteo310zBUdYGqnoFjef3Dt3PglOjgNzV+ajpubTaGw6KdHieGIgtrft6pw9
         anQwFYnG43K9KulTzEPzYvHoXtYkldZczBhtINTfNMMhY3+RpPZUzpQvCoM0AoDQtVC1
         bMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0EhNSpMEIQGwegy6XwubyizxkyeN0Yst2h+T5pwc7wQ=;
        b=O9dLuhfTGVulnkb8OLtdWp8bGz0YHCYkrw2y4B4AErsNTVeld0dMmY9Jh5u0CqCy39
         qgbo0sPcaO/AJ/EAP/xM64zQ2qV4HGERSvxQIhEQ75pyBVG9PdmnInN52UpPlNxwiI3z
         Ram1EY3jE88wzdK74u+KnICj9kGipm5UYih2l9LTuu2MMeuQaTRGbO6pM/bIE8KDH+r/
         Xy1KzQg9xNSLtHCUVDOnCIfv4BDqWsC0CNSNTe7ys3wYfp9R/S/Dqpbl9nwaBXuNFKQL
         MMcp9z3Sal2JxNCQFl5wMGIvgP9ds6cX7v9vjE+hsYdIbZ+UTG21U7KHlI006mcYrDxe
         f4dQ==
X-Gm-Message-State: AOAM531lm4bE2WGn20VW/BdNYH77OvEmpvTc+g2ocQU4gXZ2psn8/KWQ
        wU0If+cbQrD44luYmGW4KpCTvXcWL8wloV3F9+g=
X-Google-Smtp-Source: ABdhPJzje0FYaro4GDs25WGq9DJiciPtbOYkFrF+6xfThZJOs30FaUMCXOrLnhtC+hG05TTiN9HH49esY1mMEsGnvdA=
X-Received: by 2002:a17:906:1692:b0:6e8:d245:44a9 with SMTP id
 s18-20020a170906169200b006e8d24544a9mr2783204ejd.639.1649949959614; Thu, 14
 Apr 2022 08:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220414025705.598-1-mario.limonciello@amd.com>
In-Reply-To: <20220414025705.598-1-mario.limonciello@amd.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 14 Apr 2022 18:25:23 +0300
Message-ID: <CAHp75Vcxw+4mqfkiaDid-n4_n=Bg49UzH8X-12H2MQwEcNXQoA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Richard.Gong@amd.com, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 5:57 AM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
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

Good catch, Mario, and thanks for the prompt fix!
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Cc: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/gpio/gpiolib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 085348e08986..b7694171655c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>
>         gpiochip_set_irq_hooks(gc);
>
> -       acpi_gpiochip_request_interrupts(gc);
> -
>         /*
>          * Using barrier() here to prevent compiler from reordering
>          * gc->irq.initialized before initialization of above
> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>
>         gc->irq.initialized = true;
>
> +       acpi_gpiochip_request_interrupts(gc);
> +
>         return 0;
>  }
>
> --
> 2.34.1
>


-- 
With Best Regards,
Andy Shevchenko
