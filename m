Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8683F454D85
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 19:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhKQTAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 14:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhKQTAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 14:00:15 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11750C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 10:57:16 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so6430742otg.4
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 10:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J0Ee9uS/yNgK0Q38kRm9WiYIRO1wJYHsfH9qjA2K+7w=;
        b=kzHn6zBkFHRDLpiKcjHC6wdwdCAsiEWlU1A5ga8fIQG/NkKrfuEM8UZ3GubHSyljZi
         dlmvBmBNnQT9teK9HvVXlqZvz+6UVAeg1BFSrCcJUtplhufu5Op8acDCURafV1GBgdfU
         z1u1DnUZ8YuocgW5tefkx3WD5X6RKKxK4xOsVED+2Lzq87RbE6PuwJONo8w2o6CS+WxH
         Zlo2jgIXcZRhHnYTxS3GURFTCVj5NmhUGUAd3ZaCaDItviXTrhJSz34JvZj0aP2CYB4o
         sxtCxhNc/0Lnv3GnEHGqPMy42lbkh/09Dx+kOwc6UKyIoGh0FDOH8Le4th2dj5XVWYVf
         dZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J0Ee9uS/yNgK0Q38kRm9WiYIRO1wJYHsfH9qjA2K+7w=;
        b=MW9QIZmh/ufWhVTqw/5Pe7aVFGmYkRwd3P10meV4cS0hzudp4dvMfhkiklVdyK0ksw
         xUHspF/XJcUOGQieY9ZRveY1dj/LVxDTE8EMWKW4n5XVW7cKP4/sUB7uo4zwMiNgxebo
         NSFxO7CH/nBVCIL1poE1UmdwZah7KvQBnnFgYLiOHiKvy+2xlvADeoEARd2UwV9+ZWF5
         cBOIdMAEydS1d1wwiHJDbs+fNf2YgaKWY5ovJo30lItqe3+8OMpcrtqCCDnpIAekizei
         +zgAMWhsMDOmOaMAOdVz4/tfZWNkHJKthnW+MWTwubFHU0+x8ZX21Vl856QwMca5fsc7
         /Upg==
X-Gm-Message-State: AOAM531azWiEJb+4PQXavYmY2YFObId0WHQyUyya14otShL7lki0DDQi
        nQij9X+rqGOjCQ23wCDYhZb+iA==
X-Google-Smtp-Source: ABdhPJynSXjZcC1ekGOZbGSEKHkQCV4LlmAj0G8v/H9dQsgtSOa6o3k4RrWaDEeFL6ED7RfR1PFFkA==
X-Received: by 2002:a9d:7dca:: with SMTP id k10mr15971598otn.274.1637175435285;
        Wed, 17 Nov 2021 10:57:15 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a13sm150174oiy.9.2021.11.17.10.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 10:57:14 -0800 (PST)
Date:   Wed, 17 Nov 2021 12:57:12 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     vkoul@kernel.org, agross@kernel.org, ohad@wizery.com,
        mathieu.poirier@linaro.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] remoteproc: qcom: pas: Add missing power-domain "mxc"
 for CDSP
Message-ID: <YZVQiG5ChGFHwquA@builder.lan>
References: <1624559605-29847-1-git-send-email-sibis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624559605-29847-1-git-send-email-sibis@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 24 Jun 13:33 CDT 2021, Sibi Sankar wrote:

> Add missing power-domain "mxc" required by CDSP PAS remoteproc on SM8350
> SoC.
> 
> Fixes: e8b4e9a21af7 ("remoteproc: qcom: pas: Add SM8350 PAS remoteprocs")
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> Cc: stable@vger.kernel.org
> ---
> 
> The device tree and pas documentation lists mcx as a required pd for cdsp.
> Looks like it was missed while adding the proxy pds in the pas driver.
> Bjorn/Vinod you'll need to test this patch before picking it up.
> 

At least on the HDK mxc seems to be optional given the current system
state, but I don't see any regressions so let's land this before we put
the system in a state where it would matter.

Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

>  drivers/remoteproc/qcom_q6v5_pas.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
> index b921fc26cd04..ad20065dbdea 100644
> --- a/drivers/remoteproc/qcom_q6v5_pas.c
> +++ b/drivers/remoteproc/qcom_q6v5_pas.c
> @@ -661,6 +661,7 @@ static const struct adsp_data sm8350_cdsp_resource = {
>  	},
>  	.proxy_pd_names = (char*[]){
>  		"cx",
> +		"mxc",
>  		NULL
>  	},
>  	.ssr_name = "cdsp",
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
