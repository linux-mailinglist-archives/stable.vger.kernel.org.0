Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0949245196A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346723AbhKOXTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350129AbhKOVam (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:30:42 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906DCC02C322;
        Mon, 15 Nov 2021 13:15:31 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y7so15655399plp.0;
        Mon, 15 Nov 2021 13:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xHNx600LacDDvdaPgToGQdsVvGhdyIzYhehFyyrMX6Q=;
        b=qZ34WRjn7XiYl6fhNEnFTnE+rB+hkm08jxb86pMdjIFxbsu5t+J8SE0qtnOiM5hztX
         bKfFOe+J3NPxf7qpMUl1HGIDmMPb4UrdYPWXxugC/JvPwABoKr8ggYHnA4Xl3YUn5QXC
         /m7vbQbiNizX0SLjzX+qui1HOl+NO7d/OleLVmGK5A3SVVUPJmEhDVihYQfE1U7oG0dA
         YasMrdhTEEHNgYncm4QIRwWE0lW8O6G+2a7caNwNL8ZxZG//qgm5P7Eq11kh8dy5kI2h
         zLBO90xK5GjEZjc/hAC9hAgD70Y1DcJ2EdWRDmh0eW4xx2L4SpO4md4sl376VPr/mBc2
         t5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xHNx600LacDDvdaPgToGQdsVvGhdyIzYhehFyyrMX6Q=;
        b=DmKY1gGrhrRaLsqJxnGCzDgZWlH5mmMqBWeCUsCyc46rrqnxo/ZNPVD/aVMEnwfJn0
         vnZwh6K2ZdqwOEKgDWET3TnMmm2nDc1DFNi4efDZZaGT7W6jMUHdBPmXsjhnmspyIXyO
         S3s16kuBRypkkrwX2jqCU9d9CDwGuEayDRMtkoT1KjpRUsOGlOFIbdBHYR7JyHU+H70E
         0A0n/2tHI/fq1zkCMFZhFBLccjPt+Hip3/ZahR5Kij9UKTnCnogYRAQqiJzeOndfivYK
         4+NCv1nxZMfSyGrMYe7SipGuyRaF5ztKjpepq9Oxmat/tZ5EvojKW5VbfAqokXB5dYZc
         gpxw==
X-Gm-Message-State: AOAM531gkfW9gO+TW9adp5kqBURP/AqF/zVuUBlWDTYKOiP/Tyi5cwIt
        jK582oxkuKPeEentW4pPj1qHMyzraeU=
X-Google-Smtp-Source: ABdhPJzdQPNsx4eUXdWuRNDkDU3Xv2eXnXr7Dl74EDFbePrbJjVElqMtHHVIbmkHwGHe+falNL1ddQ==
X-Received: by 2002:a17:902:c412:b0:141:f710:2a94 with SMTP id k18-20020a170902c41200b00141f7102a94mr39004528plk.1.1637010931030;
        Mon, 15 Nov 2021 13:15:31 -0800 (PST)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
        by smtp.gmail.com with ESMTPSA id b21sm16229592pff.179.2021.11.15.13.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:15:30 -0800 (PST)
Date:   Tue, 16 Nov 2021 06:15:28 +0900
From:   Stafford Horne <shorne@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Filip Kokosinski <fkokosinski@antmicro.com>
Subject: Re: [PATCH 1/3] serial: liteuart: fix compile testing
Message-ID: <YZLN8LXHl9FURgsU@antec>
References: <20211115133745.11445-1-johan@kernel.org>
 <20211115133745.11445-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115133745.11445-2-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 02:37:43PM +0100, Johan Hovold wrote:
> Allow the liteuart driver to be compile tested by fixing the broken
> Kconfig dependencies.
> 
> Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
> Cc: stable@vger.kernel.org	# 5.11
> Cc: Filip Kokosinski <fkokosinski@antmicro.com>
> Cc: Mateusz Holenko <mholenko@antmicro.com>
> Cc: Stafford Horne <shorne@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Stafford Horne <shorne@gmail.com>

> ---
>  drivers/tty/serial/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 6ff94cfcd9db..67de892e0947 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1531,9 +1531,9 @@ config SERIAL_MILBEAUT_USIO_CONSOLE
>  
>  config SERIAL_LITEUART
>  	tristate "LiteUART serial port support"
> +	depends on LITEX || COMPILE_TEST
>  	depends on HAS_IOMEM
> -	depends on OF || COMPILE_TEST
> -	depends on LITEX
> +	depends on OF
>  	select SERIAL_CORE
>  	help
>  	  This driver is for the FPGA-based LiteUART serial controller from LiteX
> -- 
> 2.32.0
> 
