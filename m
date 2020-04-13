Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5178C1A6135
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 02:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgDMARs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 20:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDMARs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 20:17:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD6DC0A3BE0;
        Sun, 12 Apr 2020 17:17:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q16so2766116pje.1;
        Sun, 12 Apr 2020 17:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZJx+iIoXdFOCo0a3+sYBpXzK6TRwjiSbpc9BUVsuCgg=;
        b=QEOQJkIHrSfe8h9gwFT373EtUEgqTKbhNwE8kLbWTCgZI+zW3yOhpL1HA0Zep94kQw
         oQPpGLi26ko05puhLLkzLm9XcKY098R0SSXH+JrsDJwcMNPJKlcgrgOqKHd+R6gvtN11
         vtNGKBW2PlKY3wvwgPJiRFkpBnadbJmqHoavoH9S2tF/aMHYD85h6OADP7zL1WNmJOXy
         cTlLmUW3tsi30g/D+022cLz87lvEJQy/M7I0qY4Ubvnd4xe8pZPAyWpjF0bFhkPBiPQo
         NwUgHafM+XrcmBf/U1qHF9zV3zDS6qJ/w/eebUs6wZzZVOJhhZK+wuKZtlH6LSld9Cuy
         d3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZJx+iIoXdFOCo0a3+sYBpXzK6TRwjiSbpc9BUVsuCgg=;
        b=fKsy8Hbmm6Kf3VtBwhIwUXroN7Xf05Crnmcz8WezXlD5B9ui07Itwj1Y0kKl1ecdof
         Tvr/ImATiFGMr/dlyRW0iMkzXEpMXQC0NyJkn3zJ1xtnSwbILOoGJRVXKMjZ4C9ixHDD
         /3/ekD/sTQ9Jyh4QBXJQfBZazGB0j/B19IFTCJvbowFLvFizI1GDAwAaVfB99c0HC9MO
         R4iuMZ0kL+nlgJ+u6FpMT0dOCQJICnVkC9qDDaxODrZmfjlHEBePrTDXd3vweHVS9x3j
         QXKd+yX0p9ZxmBtd0OdGqJ5JZqxUAMPKgrfispCZMvxDKaMmjEUlg8na/RwJ5em4E6q7
         cV+g==
X-Gm-Message-State: AGi0PuYS0Pr/Sc7/CoeFFofDsvyqdlzMmn9zvTAxj3sp2spqMLlh7dqY
        yleA/DY1fDea5EVruQLRets86NR4
X-Google-Smtp-Source: APiQypJozxk+0E8H9WbA+w5VV5XtRB2Ql5ed2qZkqtvzhP7qRKngkppX9wM929Iqv7VRikeMyQx+aw==
X-Received: by 2002:a17:90a:bf84:: with SMTP id d4mr18785592pjs.82.1586737067586;
        Sun, 12 Apr 2020 17:17:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u186sm7134428pfu.205.2020.04.12.17.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 17:17:47 -0700 (PDT)
Subject: Re: [PATCH] watchdog: imx_sc_wdt: Fix reboot on crash
To:     Fabio Estevam <festevam@gmail.com>
Cc:     wim@linux-watchdog.org, linux-imx@nxp.com,
        linux-watchdog@vger.kernel.org, brenomatheus@gmail.com,
        stable@vger.kernel.org
References: <20200412230122.5601-1-festevam@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <9a59ecda-785e-1e26-110d-7951af650c89@roeck-us.net>
Date:   Sun, 12 Apr 2020 17:17:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200412230122.5601-1-festevam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/20 4:01 PM, Fabio Estevam wrote:
> Currently when running the samples/watchdog/watchdog-simple.c
> application and forcing a kernel crash by doing:
> 
> # ./watchdog-simple &
> # echo c > /proc/sysrq-trigger
> 
> The system does not reboot as expected.
> 
> Fix it by calling imx_sc_wdt_set_timeout() to configure the i.MX8QXP
> watchdog with a proper timeout.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 986857acbc9a ("watchdog: imx_sc: Add i.MX system controller watchdog support")
> Reported-by: Breno Lima <breno.lima@nxp.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/imx_sc_wdt.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/watchdog/imx_sc_wdt.c b/drivers/watchdog/imx_sc_wdt.c
> index 60a32469f7de..e9ee22a7cb45 100644
> --- a/drivers/watchdog/imx_sc_wdt.c
> +++ b/drivers/watchdog/imx_sc_wdt.c
> @@ -175,6 +175,11 @@ static int imx_sc_wdt_probe(struct platform_device *pdev)
>  	wdog->timeout = DEFAULT_TIMEOUT;
>  
>  	watchdog_init_timeout(wdog, 0, dev);
> +
> +	ret = imx_sc_wdt_set_timeout(wdog, wdog->timeout);
> +	if (ret)
> +		return ret;
> +
>  	watchdog_stop_on_reboot(wdog);
>  	watchdog_stop_on_unregister(wdog);
>  
> 

