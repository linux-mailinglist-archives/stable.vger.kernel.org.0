Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27E44AAA70
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 18:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380567AbiBERMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 12:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380560AbiBERMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 12:12:42 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83472C061348;
        Sat,  5 Feb 2022 09:12:41 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s24so4748830oic.6;
        Sat, 05 Feb 2022 09:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K64DI3f2xpyuX8EZ/v7jh79NUcV+tOMvVQl1dOHD5EM=;
        b=Zyvpr0QrZL5q1bSwqx9IfJhZevK73VLIBZKma5oUNPfAfopl/+6G+6u0S8qjm1Sf4B
         KxhsmNCJs2kPZmidhEC3CzaiMQGjE1A0b7pzPOP5xew0ql2M0XbblrJuHO/5uLbgMLU/
         li2MZHovsoM/3jbMl2s5K3E6rnbDgtaBBGn5+0m4Frc+m4p9df1nt1EJH0SxWDykQBiC
         9tGd8eDHwr5o9M85mNRqszsgg5RYkLR2UMzMU0FHpG21FvpFlxSfiXMHUs/e1dhBvbO3
         uTmJGN+1Q94TO7fhsdGnaypCEGMHrvcD7pD8mAM9BCBEQYLSXDQyJH4mc2UoQc3ivtIV
         oxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=K64DI3f2xpyuX8EZ/v7jh79NUcV+tOMvVQl1dOHD5EM=;
        b=h9nQw0w9eHCfCdrBN053UyN1ZM9ZGvxMNidJDaLeFdlsoU091eP+nU5RtqD2ob5Jby
         vr+L+Sr7DfHE6RSPgU7JPk/8RWiKfvkXGyiSpD5dU2ZvpT4LANMtGhCxWxaBykVrMTn9
         q89Py14clYOzsmAQxj+om9F6H/AQJkmKA5trlPldYU5lIclXJNZ3XejyZqSXTr5zcfWQ
         Zp9jwtCbc0iHMmT1oYRENngrgwJKqOwy59+elV48/7xrneLznsu2czadBz84eQPHYCLo
         kg+aow3mLdbyQVWZv+gN0kMfwCSJkMiG0jh3vKZ9niJ+ri4J4bI1f2+UVtFWV08FaIiG
         O11A==
X-Gm-Message-State: AOAM530a8oRpySArnwUvNsFKK26H3Oreytq8rS4yCRpkf9nlxsZttJHY
        37+msQlhfMv9vX0VmT0SN4u3mJHd0PHTFA==
X-Google-Smtp-Source: ABdhPJxyxUg6PR6D9Ym1sYxWwsoc/MnfwT67LnulORICP68/yTl3sfq2LGxUAb9QOcyVRfjdx2dqwA==
X-Received: by 2002:a05:6808:124b:: with SMTP id o11mr4124826oiv.239.1644081160865;
        Sat, 05 Feb 2022 09:12:40 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o144sm2085210ooo.25.2022.02.05.09.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 09:12:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 5 Feb 2022 09:12:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH 5.15 05/32] drm/vc4: hdmi: Make sure the device is
 powered with CEC
Message-ID: <20220205171238.GA3073350@roeck-us.net>
References: <20220204091915.247906930@linuxfoundation.org>
 <20220204091915.421812582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091915.421812582@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:22:15AM +0100, Greg Kroah-Hartman wrote:
> From: Maxime Ripard <maxime@cerno.tech>
> 
> Commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.
> 
> The original commit depended on a rework commit (724fc856c09e ("drm/vc4:
> hdmi: Split the CEC disable / enable functions in two")) that
> (rightfully) didn't reach stable.
> 
> However, probably because the context changed, when the patch was
> applied to stable the pm_runtime_put called got moved to the end of the
> vc4_hdmi_cec_adap_enable function (that would have become
> vc4_hdmi_cec_disable with the rework) to vc4_hdmi_cec_init.
> 
> This means that at probe time, we now drop our reference to the clocks
> and power domains and thus end up with a CPU hang when the CPU tries to
> access registers.
> 
> The call to pm_runtime_resume_and_get() is also problematic since the
> .adap_enable CEC hook is called both to enable and to disable the
> controller. That means that we'll now call pm_runtime_resume_and_get()
> at disable time as well, messing with the reference counting.
> 
> The behaviour we should have though would be to have
> pm_runtime_resume_and_get() called when the CEC controller is enabled,
> and pm_runtime_put when it's disabled.
> 
> We need to move things around a bit to behave that way, but it aligns
> stable with upstream.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: <stable@vger.kernel.org> # 5.15.x
> Cc: <stable@vger.kernel.org> # 5.16.x
> Reported-by: Michael Stapelberg <michael+drm@stapelberg.ch>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/vc4/vc4_hdmi.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> @@ -1738,18 +1738,18 @@ static int vc4_hdmi_cec_adap_enable(stru
>  	u32 val;
>  	int ret;
>  
> -	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> -	if (ret)
> -		return ret;
> +	if (enable) {
> +		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> +		if (ret)
> +			return ret;
>  
> -	val = HDMI_READ(HDMI_CEC_CNTRL_5);
> -	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> -		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> -		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> -	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> -	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> +		val = HDMI_READ(HDMI_CEC_CNTRL_5);
> +		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> +			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> +			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> +		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> +			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);

Unfortunately this is broken because it leaves the still existing
else path with

               if (!vc4_hdmi->variant->external_irq_controller)
                        HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
                HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
                           VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);

where 'val' is now uninitialized. I don't know how to fix this up properly,
so I won't even try.

Guenter
