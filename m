Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C24E6004FD
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 03:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJQB6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 21:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJQB6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 21:58:11 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C984153F
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 18:58:10 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id B13286010B
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:58:09 +0900 (JST)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 0E63A6010A
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:58:09 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id mq15-20020a17090b380f00b0020ad26fa5edso8919619pjb.7
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 18:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LMPN0sybycmWeAJCPFWn1JumG1pmDxpM9H7ocBblHGY=;
        b=KU/+3Qb8XVF6tlx+56080CiGEdDWhzZo7tME1fTZz1JfB52iy00XHZg88V5WbJmc1C
         gZein1H21tjFUzw5w1WCOL4o6FsY/jEgKtt8lyZVu2WKOn4jRW0ydEWZ7gqU/n0sWDqP
         OUNnW6ZFmNHap+fJsNolYfz5tCu3cJ4bAtnG6fpeDKzTCkX5V4krx18BpRIlQe+tNzLV
         nhgXwiv6q2WDkqKvnimwXcrmvHSMu3c9Ph90e8asEErQRYism93utoY85AsPPBXYcqSY
         o9LGc6jEdPUkW5SlXjHjTHGZJA/D7zRNB9PLEAw8ZlgK4NUUBY9WyCwuy+RbLlkXzhdO
         CSDg==
X-Gm-Message-State: ACrzQf0Cu698boGlpuA77OvdLsBLzzIvuZitgcp65bZnw5AlDrU4qmv8
        xYVypMS3DGg9u9WCIGNn915tDj3Doh8nRvqhAMLtG9KtZEwwuqH97thEsWSvyDzkcLNsChcqgn4
        40Nz3lhWdnynSc225L8rF
X-Received: by 2002:a17:902:7792:b0:182:9404:f226 with SMTP id o18-20020a170902779200b001829404f226mr9811201pll.76.1665971888137;
        Sun, 16 Oct 2022 18:58:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6HnRrJtnrTz7kI00GhGInkTcDKvhNcKcKerDEZtaVySb4sCzdo0fLq7dIoabqczWxCgmajqg==
X-Received: by 2002:a17:902:7792:b0:182:9404:f226 with SMTP id o18-20020a170902779200b001829404f226mr9811184pll.76.1665971887874;
        Sun, 16 Oct 2022 18:58:07 -0700 (PDT)
Received: from pc-zest.atmarktech (162.198.187.35.bc.googleusercontent.com. [35.187.198.162])
        by smtp.gmail.com with ESMTPSA id t22-20020a170902b21600b0017f75bc7a61sm5337714plr.166.2022.10.16.18.58.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Oct 2022 18:58:07 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1okFOI-0003b0-1h;
        Mon, 17 Oct 2022 10:58:06 +0900
Date:   Mon, 17 Oct 2022 10:57:56 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org
Cc:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH 5.10 2/2] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y0y2pPwf2yxA2tQe@atmark-techno.com>
References: <20221017013807.34614-1-dominique.martinet@atmark-techno.com>
 <20221017013908.34770-2-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221017013908.34770-2-dominique.martinet@atmark-techno.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dominique Martinet wrote on Mon, Oct 17, 2022 at 10:39:10AM +0900:
> diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
> index a2c4eab0b470..5ca61fa50efd 100644
> --- a/drivers/tty/serial/fsl_lpuart.c
> +++ b/drivers/tty/serial/fsl_lpuart.c
> @@ -2667,10 +2667,6 @@ static int lpuart_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto failed_irq_request;
>  
> -	ret = uart_add_one_port(&lpuart_reg, &sport->port);
> -	if (ret)
> -		goto failed_attach_port;
> -
>  	ret = uart_get_rs485_mode(&sport->port);
>  	if (ret)
>  		goto failed_get_rs485;
> @@ -2683,6 +2679,9 @@ static int lpuart_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
>  
>  	sport->port.rs485_config(&sport->port, &sport->port.rs485);

Ah, I've been quick on the review, sorry: this rs485_config() should
probably be removed.
(the similar uart_rs485_config() was removed in the upstream patch)

I'll send a v2 after this has gotten another review or when prompted,
sorry for the trouble.

> +	ret = uart_add_one_port(&lpuart_reg, &sport->port);
> +	if (ret)
> +		goto failed_attach_port;
>  
>  	return 0;
>  


