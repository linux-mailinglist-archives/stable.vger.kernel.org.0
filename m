Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB87930425A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 16:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392762AbhAZPXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 10:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389107AbhAZPXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 10:23:45 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E401EC061A31;
        Tue, 26 Jan 2021 07:23:04 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id k8so16524231otr.8;
        Tue, 26 Jan 2021 07:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9HqJz4ccFu+2h4+0g/4xAgaRFGGTbElPLcdY6EqSi4g=;
        b=J9//tWL5VV1XxropJFiiLpj2bX7uW6LYBGx5uYDqyqvvMq7xfv0NTziP3AZEi4AadA
         8BiBR/BlPHs4zzP2kG2yNDQOSSi/9+DG5I8nPNz7Zek4yXtkgrokk8qJxQsIF/1UqEuf
         TzVM8oHZpUng88iju5MIeQHipRmcssLRI8g1JrIhQmyyyhh5aK/1L2/lPPpinPQuvM1X
         NNyCg5dLrLL47SIQVG8Fus8nDtfxXQHtWJgN+1DvQu7OulYWY5VlGGzRYAW9QGYmtnjq
         d5Bi6b20VSK2LRsRL9q8NwDy+ebqfgMJobIZZCSnN0lp+sQj+uKVKwtUBIb+C7rKrEKT
         GCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9HqJz4ccFu+2h4+0g/4xAgaRFGGTbElPLcdY6EqSi4g=;
        b=Hv+h+ddc5gi+x8l++Cfa6MPWx9grH+P66nbbqhfa8SR26pIAAm/4KguqQQLcyAISnJ
         el7B8iLOwg1heg8cKqiYdhjVjuzERzej8maBURUSo8N6BLcUGEfFzeimNp5CjblU7FCv
         wr3O/g8XIK4WYhkrMkopr7MDUcJJ1IGmJwL45R0TIpwFo05gl37S1sGGQHQCR9wXr1g/
         xmTDwSAzDBCUk4GKxVwog4sshiKWqpTHgyQ6csXo4Pvogj2rBzd42zN59H/NlTziM3Ih
         GbbywGkholt+MQKWIMT+1Pld2ZKMCWsW1Yx0iTVeTerSZm05hBfi+h2iBjNW97qBMqSM
         xTWA==
X-Gm-Message-State: AOAM5328ZEPTXL1apdOVqN/LRTiyFPR0G+jT50j6LfQY6kO7XFq6OnBp
        uwSFH1KiS77+ks1HVI3bALki/6c6Xw4=
X-Google-Smtp-Source: ABdhPJxgKwJGdMviBooR22j1M56rJfq2oNt3Fy+S9pjMXiciLviX4pKU78H8g03p+tKJ5WaPmKMLuA==
X-Received: by 2002:a9d:20e9:: with SMTP id x96mr4221433ota.193.1611674584069;
        Tue, 26 Jan 2021 07:23:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l64sm4191634oib.13.2021.01.26.07.23.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:23:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] watchdog: qcom: Remove incorrect usage of
 QCOM_WDT_ENABLE_IRQ
To:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        jorge@foundries.io
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <1c9d5e19-7ddd-345d-aa2d-b4fb48d9b4df@roeck-us.net>
Date:   Tue, 26 Jan 2021 07:23:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 7:02 AM, Sai Prakash Ranjan wrote:
> As per register documentation, QCOM_WDT_ENABLE_IRQ which is BIT(1)
> of watchdog control register is wakeup interrupt enable bit and
> not related to bark interrupt at all, BIT(0) is used for that.
> So remove incorrect usage of this bit when supporting bark irq for
> pre-timeout notification. Currently with this bit set and bark
> interrupt specified, pre-timeout notification and/or watchdog
> reset/bite does not occur.
> 
> Fixes: 36375491a439 ("watchdog: qcom: support pre-timeout when the bark irq is available")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

Assuming that pretimeout _does_ work with this patch applied,

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
> Reading the conversations from when qcom pre-timeout support was
> added [1], Bjorn already had mentioned it was not right to touch this
> bit, not sure which SoC the pre-timeout was tested on at that time,
> but I have tested this on SDM845, SM8150, SC7180 and watchdog bark
> and bite does not occur with enabling this bit with the bark irq
> specified in DT.
> 
> [1] https://lore.kernel.org/linux-watchdog/20190906174009.GC11938@tuxbook-pro/
> 
> ---
>  drivers/watchdog/qcom-wdt.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> index 7cf0f2ec649b..e38a87ffe5f5 100644
> --- a/drivers/watchdog/qcom-wdt.c
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -22,7 +22,6 @@ enum wdt_reg {
>  };
>  
>  #define QCOM_WDT_ENABLE		BIT(0)
> -#define QCOM_WDT_ENABLE_IRQ	BIT(1)
>  
>  static const u32 reg_offset_data_apcs_tmr[] = {
>  	[WDT_RST] = 0x38,
> @@ -63,16 +62,6 @@ struct qcom_wdt *to_qcom_wdt(struct watchdog_device *wdd)
>  	return container_of(wdd, struct qcom_wdt, wdd);
>  }
>  
> -static inline int qcom_get_enable(struct watchdog_device *wdd)
> -{
> -	int enable = QCOM_WDT_ENABLE;
> -
> -	if (wdd->pretimeout)
> -		enable |= QCOM_WDT_ENABLE_IRQ;
> -
> -	return enable;
> -}
> -
>  static irqreturn_t qcom_wdt_isr(int irq, void *arg)
>  {
>  	struct watchdog_device *wdd = arg;
> @@ -91,7 +80,7 @@ static int qcom_wdt_start(struct watchdog_device *wdd)
>  	writel(1, wdt_addr(wdt, WDT_RST));
>  	writel(bark * wdt->rate, wdt_addr(wdt, WDT_BARK_TIME));
>  	writel(wdd->timeout * wdt->rate, wdt_addr(wdt, WDT_BITE_TIME));
> -	writel(qcom_get_enable(wdd), wdt_addr(wdt, WDT_EN));
> +	writel(QCOM_WDT_ENABLE, wdt_addr(wdt, WDT_EN));
>  	return 0;
>  }
>  
> 

