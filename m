Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F383A4F3E5B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiDEOlt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 5 Apr 2022 10:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388412AbiDEOji (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 10:39:38 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D34122989;
        Tue,  5 Apr 2022 06:16:21 -0700 (PDT)
Received: by mail-qt1-f169.google.com with SMTP id 10so10862160qtz.11;
        Tue, 05 Apr 2022 06:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f8BEQiIeTdZ8MUyIQgmfaD47+sl12jVUvr2inorvkYY=;
        b=CO1zsIydre5IRFvbHul/n+haDWvCdFh+lQnpypN4rPSGKzqeM3Y3praSkStx+3sboz
         NsHTAGMckfUCDeUofd27QhbOHd+i4iVq4Onit94xjOUXMq0ivEq0ywoasJQBqKeex1cS
         vps8bz2pNPTZzoHKCqAlNzjU3QB7xx8T6IgmqaYN4+IiIWmQupgjdP9cxOizVTsmibFG
         rhN9zQA6tu6SKVKryjyb5jzyd5iWGyGLKS1thCHJmxsBjLx4slGiQ66G28CrsC10SHAB
         9omAm4umSVUr3sG5jGk/fbkyfyhAf8tRIBmKlqWpJqhpOU5BTGssRbtGSyy5p9ushgS7
         9LPQ==
X-Gm-Message-State: AOAM530IuYlX5Kqh4Uc7/l/kvZwoexyxe1e1UILcluDu5j3RyLk1RTWg
        cCL5od0akOCgjHB4i/W4ry27zbJ5zTqXOQ==
X-Google-Smtp-Source: ABdhPJzbpt6KwS0oVo7YyWK5hM6fEkqyKsKkrKg6DxzjQJS2xNze2wodNokqsSKIKJxG9/rtyx56xQ==
X-Received: by 2002:a05:620a:450f:b0:67d:b1ee:bd3 with SMTP id t15-20020a05620a450f00b0067db1ee0bd3mr2117460qkp.766.1649164579659;
        Tue, 05 Apr 2022 06:16:19 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id y24-20020a37e318000000b0067d43d76184sm7804021qki.97.2022.04.05.06.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:16:19 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2eb57fd3f56so71376607b3.8;
        Tue, 05 Apr 2022 06:16:18 -0700 (PDT)
X-Received: by 2002:a81:3d81:0:b0:2eb:8069:5132 with SMTP id
 k123-20020a813d81000000b002eb80695132mr2587791ywa.438.1649164578752; Tue, 05
 Apr 2022 06:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070354.155796697@linuxfoundation.org> <20220405070359.334460978@linuxfoundation.org>
In-Reply-To: <20220405070359.334460978@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Apr 2022 15:16:07 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUovU-zaPPCV0tbOMEy3GsH6heSe+21koW3Ti3S+4qD5g@mail.gmail.com>
Message-ID: <CAMuHMdUovU-zaPPCV0tbOMEy3GsH6heSe+21koW3Ti3S+4qD5g@mail.gmail.com>
Subject: Re: [PATCH 5.16 0172/1017] media: gpio-ir-tx: fix transmit with long
 spaces on Orange Pi PC
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?0JzQuNGF0LDQuNC7?= <vrserver1@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 5, 2022 at 1:33 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Sean Young <sean@mess.org>
>
> commit 5ad05ecad4326ddaa26a83ba2233a67be24c1aaa upstream.
>
> Calling udelay for than 1000us does not always yield the correct
> results.
>
> Cc: stable@vger.kernel.org
> Reported-by: Михаил <vrserver1@gmail.com>
> Signed-off-by: Sean Young <sean@mess.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/media/rc/gpio-ir-tx.c |   28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
>
> --- a/drivers/media/rc/gpio-ir-tx.c
> +++ b/drivers/media/rc/gpio-ir-tx.c
> @@ -48,11 +48,29 @@ static int gpio_ir_tx_set_carrier(struct
>         return 0;
>  }
>
> +static void delay_until(ktime_t until)
> +{
> +       /*
> +        * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
> +        * m68k ndelay(s64) does not compile; so use s32 rather than s64.
> +        */
> +       s32 delta;
> +
> +       while (true) {
> +               delta = ktime_us_delta(until, ktime_get());
> +               if (delta <= 0)
> +                       return;
> +
> +               /* udelay more than 1ms may not work */
> +               delta = min(delta, 1000);
> +               udelay(delta);
> +       }

Yeah, that's why we have mdelay(), which loops around udelay() if no
arch-specific implementation is provided.

> +}
> +
>  static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
>                                    uint count)
>  {
>         ktime_t edge;
> -       s32 delta;
>         int i;
>
>         local_irq_disable();
> @@ -63,9 +81,7 @@ static void gpio_ir_tx_unmodulated(struc
>                 gpiod_set_value(gpio_ir->gpio, !(i % 2));
>
>                 edge = ktime_add_us(edge, txbuf[i]);
> -               delta = ktime_us_delta(edge, ktime_get());
> -               if (delta > 0)
> -                       udelay(delta);
> +               delay_until(edge);
>         }
>
>         gpiod_set_value(gpio_ir->gpio, 0);
> @@ -97,9 +113,7 @@ static void gpio_ir_tx_modulated(struct
>                 if (i % 2) {
>                         // space
>                         edge = ktime_add_us(edge, txbuf[i]);
> -                       delta = ktime_us_delta(edge, ktime_get());
> -                       if (delta > 0)
> -                               udelay(delta);
> +                       delay_until(edge);
>                 } else {
>                         // pulse
>                         ktime_t last = ktime_add_us(edge, txbuf[i]);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
