Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDE5C192A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 21:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfI2TjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 15:39:21 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33640 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbfI2TjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 15:39:21 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so3026829pls.0;
        Sun, 29 Sep 2019 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cWzyN/kk5zIsu98AByAT+qCphFKK3lgjqUy370laSJ4=;
        b=QtAWw1m1CSD8Rp40KtFAtfv3dYr25cIprGMRAQVhF8jPjPpT23hhtxADKEZtnu8REF
         C6bQSIBnmLr504LwkeqIUR6RThWPjAF6pQVzK3XtXJooJc41ar0Rcy4j2HZ80YXgiakx
         y/+sAwhESf9Z7rGVZhtF7xVJU7RowIhF/z79l7eK8UvRxJBCLsDRhFM8XthihU48idGd
         J9rOgfS298WcxWboFdkpL6IKYFFS51Rnz5yj6v0Rg+ywDt5WLPbeiApLhymX6kQhLApq
         BpVsKe4x4q6CK/SkjdoJvUQccDtvpfFk1vVgiZoebbEgWEjKsjHCccy8/oRVS9iYgiUx
         8JUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cWzyN/kk5zIsu98AByAT+qCphFKK3lgjqUy370laSJ4=;
        b=BlWozANw510e7bmmA5JaxaUIZYsH+TPt0m3oYydGeaizmwWmFV4tS/1qBFnHskMecU
         /UQW87DSGL69AOcf+4JmvBG3V5Y2LQIAoweJbZz5HSrZf+3tWG/m/nNhwdcxG94OfnFY
         rE+mZ8pJikbiLKIIlNxDuCMe71Iis/Vm09p6iYYut+IvL9Milx9VehfRqHZ8+lD3OtV4
         hZHA4c9V9E7sqDkTgc4FHJWxtwURrsUCu5dh6U7XzhkjB2PC+gtUWfzDZndtQMLsaJBb
         267rls+vGlTL4LdM8CdnlpDWGB12vvlEwMeU+iYSb/t3gY7OkY+tpcrajymNrQnREHSh
         s2HA==
X-Gm-Message-State: APjAAAV1upc/OAyaaMaCsnGw4prg+yb9Osoio4Lz9UA7SYUAKnGKuUK7
        9RQ2iUNZKUEnnFa5Aau9vEErzKcu
X-Google-Smtp-Source: APXvYqx3hRo7qRmfXjwZA1sflWvx1xzryy0SWuJwjsbpyCv4hSp8+/ComVDoxShk76M7DtWCwZahPw==
X-Received: by 2002:a17:902:b48f:: with SMTP id y15mr9037039plr.168.1569785959926;
        Sun, 29 Sep 2019 12:39:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v43sm26851393pjb.1.2019.09.29.12.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Sep 2019 12:39:19 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.3 20/49] firmware: bcm47xx_nvram: Correct size_t
 printf format
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Paul Burton <paul.burton@mips.com>, linux-mips@linux-mips.org,
        joe@perches.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-mips@vger.kernel.org
References: <20190929173053.8400-1-sashal@kernel.org>
 <20190929173053.8400-20-sashal@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <feb780d4-c9f7-b662-729c-babd361b223e@gmail.com>
Date:   Sun, 29 Sep 2019 12:39:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190929173053.8400-20-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/29/2019 10:30 AM, Sasha Levin wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit feb4eb060c3aecc3c5076bebe699cd09f1133c41 ]
> 
> When building on a 64-bit host, we will get warnings like those:
> 
> drivers/firmware/broadcom/bcm47xx_nvram.c:103:3: note: in expansion of macro 'pr_err'
>    pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
>    ^~~~~~
> drivers/firmware/broadcom/bcm47xx_nvram.c:103:28: note: format string is defined here
>    pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
>                            ~^
>                            %li
> 
> Use %zu instead for that purpose.

This is not a fix that should be backported as it was done only to allow
the driver to the made buildable with COMPILE_TEST. Please drop it from
your auto-selection.

> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Cc: linux-mips@linux-mips.org
> Cc: joe@perches.com
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Cc: linux-mips@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/firmware/broadcom/bcm47xx_nvram.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/broadcom/bcm47xx_nvram.c b/drivers/firmware/broadcom/bcm47xx_nvram.c
> index 77eb74666ecbc..6d2820f6aca13 100644
> --- a/drivers/firmware/broadcom/bcm47xx_nvram.c
> +++ b/drivers/firmware/broadcom/bcm47xx_nvram.c
> @@ -96,7 +96,7 @@ static int nvram_find_and_copy(void __iomem *iobase, u32 lim)
>  		nvram_len = size;
>  	}
>  	if (nvram_len >= NVRAM_SPACE) {
> -		pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
> +		pr_err("nvram on flash (%zu bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
>  		       nvram_len, NVRAM_SPACE - 1);
>  		nvram_len = NVRAM_SPACE - 1;
>  	}
> @@ -148,7 +148,7 @@ static int nvram_init(void)
>  	    header.len > sizeof(header)) {
>  		nvram_len = header.len;
>  		if (nvram_len >= NVRAM_SPACE) {
> -			pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
> +			pr_err("nvram on flash (%zu bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
>  				header.len, NVRAM_SPACE);
>  			nvram_len = NVRAM_SPACE - 1;
>  		}
> 

-- 
Florian
