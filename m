Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BCD195F67
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgC0UDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 16:03:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43908 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbgC0UDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 16:03:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id m11so7111867wrx.10
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 13:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=j/OkHoE9ro+FS7kIKsKj8MxdkSIGzorOdjF2lgklWaU=;
        b=Wqt247jBbkcmuopxr4bZf+nX1skD780fSsrsQe7h6+1a2FKAbKthwzOP37uekv7brs
         2utFa4d9xWPo7RNEmZAsdqG68IfYzVAdDeCox+goaOCUJpzoqNJBYgLHu4g1/lQv0o22
         yNgDkhvbYygkGw+y6Y8+u8rAMffLaB3Syx50OfFMhBJG1+T/Jp17c3NrKdqFrsZdfvyp
         LUNnJ0LGfhQbwgdJC6L9fKPg3mCG3hLtgK7mNlT0FI0dobAr0NcdOKpK5bc4xhJGwXBJ
         Zg/PeQ7K5QurQQ75MFX2jXVEAlRvA3bwL48uAFJJyP7Rs89bwjq4u4FCGswqVu8tQxXK
         Y48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=j/OkHoE9ro+FS7kIKsKj8MxdkSIGzorOdjF2lgklWaU=;
        b=p5Qm+woxzeDmYD1cz2cL/udTE7fq/bFSAN/DsGdMeATxOGSiusC3hIfR2XYxpLomIO
         sxjIJbx6FdWkHxgTYUiaXojOSnl0c/eaervwUXQP2NrELY+7Qnmm64fJPmD2m7YyjTn9
         m0ANlkzX811GY+mqiKfcLBLeRl38BkVqcoDqUkGZVzgVoxoKQyUwY0MhAdecMFL2QBKd
         CKLV2kfQMjjvRfbCg5VYIpLkkYHZZaaz39VVQU15pBaXnym7y8g7pXaFhq/mioIClg1z
         oIaqOcyUwgia3Um+U/PNmoF3aDJc3eOanPV5ABoc6cOpcLWGVfnYPJuCCd4DbxJXEiGA
         jrIg==
X-Gm-Message-State: ANhLgQ1yoEcSnLwV1x5UBsGE8a7rNH1tcogBN5/iHAhLbXvJlY+Ko7jd
        4dK/xQrUHfDOOZI+bpj/LQ==
X-Google-Smtp-Source: ADFU+vtsg0ksxBGhkyw2URPPe2qJfEMV56TeAw+wCauhFrp3b/TrMbhNOjZUSxxtv606eUxa4KefAQ==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr1140550wrs.4.1585339385869;
        Fri, 27 Mar 2020 13:03:05 -0700 (PDT)
Received: from ninjahost.lan (host-92-23-82-35.as13285.net. [92.23.82.35])
        by smtp.gmail.com with ESMTPSA id r9sm9752815wma.47.2020.03.27.13.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 13:03:05 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
X-Google-Original-From: Jules Irenge <alien@ninjahost.lan>
Date:   Fri, 27 Mar 2020 20:02:57 +0000 (GMT)
To:     Jules Irenge <jbi.octave@gmail.com>
cc:     Corentin Labbe <clabbe@baylibre.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01/11] rtc: max8907: add missing select REGMAP_IRQ
In-Reply-To: <20200327195150.378413-1-jbi.octave@gmail.com>
Message-ID: <alpine.LFD.2.21.2003272002120.381538@ninjahost.lan>
References: <20200327195150.378413-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, 27 Mar 2020, Jules Irenge wrote:

> From: Corentin Labbe <clabbe@baylibre.com>
> 
> I have hit the following build error:
> 
>   armv7a-hardfloat-linux-gnueabi-ld: drivers/rtc/rtc-max8907.o: in function `max8907_rtc_probe':
>   rtc-max8907.c:(.text+0x400): undefined reference to `regmap_irq_get_virq'
> 
> max8907 should select REGMAP_IRQ
> 
> Fixes: 94c01ab6d7544 ("rtc: add MAX8907 RTC driver")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/rtc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 34c8b6c7e095..8e503881d9d6 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -327,6 +327,7 @@ config RTC_DRV_MAX6900
>  config RTC_DRV_MAX8907
>  	tristate "Maxim MAX8907"
>  	depends on MFD_MAX8907 || COMPILE_TEST
> +	select REGMAP_IRQ
>  	help
>  	  If you say yes here you will get support for the
>  	  RTC of Maxim MAX8907 PMIC.
> -- 
> 2.25.1
> 
> 
Apology. I sent this one by mistake.
Please disregard it.

Polite regards,
Jules

