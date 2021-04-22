Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DE1367938
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 07:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhDVFZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 01:25:42 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:46833 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhDVFZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 01:25:41 -0400
Received: by mail-ej1-f54.google.com with SMTP id u21so66882362ejo.13;
        Wed, 21 Apr 2021 22:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PPxY5pAae5K/jAdG0xim+cgi+yd0HHjywqb/GEeizxo=;
        b=adyoN0b2cfucnurkU7eGcyKVYRUenLPOqjDiH3Tf5tyuzq2amtK3EltwTNdK0sjEFJ
         55jt3YiWsFS4Ecf5+Z+tHZWnUQNNX1UYSNqHOG1i2VE7GB5bNTVZHQK1tQrcKjEVI4oi
         N6MwJ7rXfNuBMkKRy30R8x9hRnaTHnj45SE7VjHzV5B3bAzb/7CYygIaBgyT9qzzKnU6
         8PsLzeBf73IgG1ryrFN7gPd1fnOiJEREo3wH3Y8E73nqGHguyqIlFZEvRkKp3HCg1r90
         41emGiVH6KrO7hR9fD0pZ49d/DSq3sf1cnatKSv7sS5WxqvWqjk/X+NyCoUaS+vARApv
         2mhA==
X-Gm-Message-State: AOAM530JPGeO1L3SsfINUfu9GOopfJzGFq/f3I0F9KSs7ZpGxGvc2q8t
        Wic/Z8mgyzaRLXckkFLFBCftmiaLsjk=
X-Google-Smtp-Source: ABdhPJzKCzdZMgfQncovGIz7iQdPSVWSXAQZOtXjdy6Fyl9yOLKKws8AmZkAagyfS0cWbkhGwqi/Ng==
X-Received: by 2002:a17:906:26c9:: with SMTP id u9mr1445918ejc.520.1619069105796;
        Wed, 21 Apr 2021 22:25:05 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id q19sm1055098ejy.50.2021.04.21.22.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 22:25:05 -0700 (PDT)
Subject: Re: [PATCH 121/190] Revert "serial: mvebu-uart: Fix to avoid a
 potential NULL pointer dereference"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, stable <stable@vger.kernel.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-122-gregkh@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <2b25dfc9-6eec-4db6-1878-5618ffcef54a@kernel.org>
Date:   Thu, 22 Apr 2021 07:25:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421130105.1226686-122-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 04. 21, 14:59, Greg Kroah-Hartman wrote:
> This reverts commit 32f47179833b63de72427131169809065db6745e.
> 
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
> 
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
> 
> Cc: Aditya Pakki <pakki001@umn.edu>
> Cc: stable <stable@vger.kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/tty/serial/mvebu-uart.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
> index e0c00a1b0763..51b0ecabf2ec 100644
> --- a/drivers/tty/serial/mvebu-uart.c
> +++ b/drivers/tty/serial/mvebu-uart.c
> @@ -818,9 +818,6 @@ static int mvebu_uart_probe(struct platform_device *pdev)
>   		return -EINVAL;
>   	}
>   
> -	if (!match)
> -		return -ENODEV;

The original fix doesn't hurt, but is useless. ->probe is called when 
of_match_device matched.

So the revert is OK.

>   	/* Assume that all UART ports have a DT alias or none has */
>   	id = of_alias_get_id(pdev->dev.of_node, "serial");
>   	if (!pdev->dev.of_node || id < 0)
> 


-- 
js
suse labs
