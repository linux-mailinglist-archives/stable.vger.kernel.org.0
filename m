Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E330330714F
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 09:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhA1IUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 03:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbhA1IUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 03:20:10 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A7EC0613ED
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 00:19:27 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m2so3557909wmm.1
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 00:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries.io; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OaDHkLa3cmo9Wol8qwuGHS4BgxQz50ECcY1Y3aHRi6Q=;
        b=Oyowa+rFa3kOXPrSNGP8xvv2Po05U/VFpGV3TJrHKgGX9preexld2hw22odEfHnPBZ
         y/yQb/XstNbl5yWuyyOZ9cBJoXwCUu5qe/fwBhgZsDXOy4M3Pm1HdroNQEW4sxD0nkEx
         R4i36WB0qL4o1k/NE7dEYvbHCjerTayhM733OY6AhMiYeMOeDZotm1j21cuDj+Rqr7rX
         v0ymsGRhdQhbR7lonQIc9W98g8ysqfNThJ5NxNaDvxmXj9EJFsDp7Rrrrx49ZKPxeoJG
         irqO/wzKPyTfunE7EGyfob7MRaOQC6YbCrbn8kbq6IEkmTBtDWt+52yTvKVZqAe98NJA
         P31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OaDHkLa3cmo9Wol8qwuGHS4BgxQz50ECcY1Y3aHRi6Q=;
        b=oU+rdjsCu6sSSrimCBLmg+RtPd4GY18hlXG+qGzCSXsP0phsyTadQ0PCe97KRDza06
         4QmpZzzh0E6gDncNVI5BDGbTZPX0728+cZga93V8+DtBBYG2unEy9eEosa5Z9YkAOSAG
         qt2WELIQKfISHcf/l6NkCt6uNkK0SMrlIGBdlsJjt64rvOm7N7vOvmnsdhfIqbxRZpCz
         55F55jtcLgAtVhy+5H55nl/akDRdm9kzVGhJFLSAfS7XQFaTyQtYdhx8b2yUqJiDtXqe
         EeTKYY95qcdfYTNf8Squ9riZhq96W6Vmu5XJpT+N8NFUm/r3NF5CHNg5F/ew9gFBRgR5
         6dfA==
X-Gm-Message-State: AOAM532jzX/uC4b97cZtQB0h3bpnxaPKjsuP11jLift8GxWs8VncDJiO
        hOS4lTj/INj16SejsGLS8W288A==
X-Google-Smtp-Source: ABdhPJyMZil5oITulxkk1okkcwfpreeNR6ghrVtonTPnww4tQokRLCN7uNH8lckATwV1szUgwO8IaA==
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr7382596wmi.127.1611821965902;
        Thu, 28 Jan 2021 00:19:25 -0800 (PST)
Received: from trex (182.red-79-146-86.dynamicip.rima-tde.net. [79.146.86.182])
        by smtp.gmail.com with ESMTPSA id g187sm5242347wmf.1.2021.01.28.00.19.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Jan 2021 00:19:25 -0800 (PST)
From:   "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
X-Google-Original-From: "Jorge Ramirez-Ortiz, Foundries" <JorgeRamirez-Ortiz>
Date:   Thu, 28 Jan 2021 09:19:24 +0100
To:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-watchdog@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        jorge@foundries.io, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] watchdog: qcom: Remove incorrect usage of
 QCOM_WDT_ENABLE_IRQ
Message-ID: <20210128081924.GA30289@trex>
References: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126150241.10009-1-saiprakash.ranjan@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/01/21, Sai Prakash Ranjan wrote:
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
> ---
> 
> Reading the conversations from when qcom pre-timeout support was
> added [1], Bjorn already had mentioned it was not right to touch this
> bit, not sure which SoC the pre-timeout was tested on at that time,
> but I have tested this on SDM845, SM8150, SC7180 and watchdog bark
> and bite does not occur with enabling this bit with the bark irq
> specified in DT.

this was tested on QCS404. have you validated there? unfortunately I
no longer have access to that hardware or the documentation


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
> -- 
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> 
