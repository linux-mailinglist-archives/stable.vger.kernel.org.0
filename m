Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9CA393C0B
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 05:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbhE1DqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 23:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbhE1DqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 23:46:10 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608AC06174A
        for <stable@vger.kernel.org>; Thu, 27 May 2021 20:44:35 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id t24so2990232oiw.3
        for <stable@vger.kernel.org>; Thu, 27 May 2021 20:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWWrXtqxypaG6W94Jcb7Nqjb7DgWl7Dvm/E9oGzGZbY=;
        b=gGsvGbKh9TFq4frPlNvRb4UTOPbO3ODdYCRS/termttaL9wBaX/aVYbXiCVDAI8hMc
         3hw0s9WwmHoxF5hjnKKreRK1hjcX9JzboDsyo7opzQPjDFWZVP8iw+2c0sqs/ON4FFwq
         ImwSfnInJr0JrFAx0pjBIbHg6GInSbC1WafQCc839WqhLqCgjavP+XkM9C1sC6MGLX1e
         M0WOF9n4SVU8oysKjHTA2DG9+Jd724cUJmCY9msOZq3HfTYBLOtSukYgWZBPsXUNgyU7
         nYcg/hPNrJG/MQtTWJZgZM1e69rf1/cdg8h4oi/Rj5NbZbIInlSHb66TEJ/EXVISbVVN
         pfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWWrXtqxypaG6W94Jcb7Nqjb7DgWl7Dvm/E9oGzGZbY=;
        b=QsD7dviDSCnBPLx1RMvqjFZDhJGLwGb4jUK//a5eciA3mgdvu5f9ikyYH3AOaR1VjY
         51ULoj2+8+74pZiuRqdkwgQn7zwE6IdG80liCHwuwFW17VkzK/V9lhg2WWNvwf8u28Xy
         JX5Xu79GmOb/DP5IKbFK1UXPlQldla2AOk0PCadmVhnMvTMBdAalK1zkhsE4CK+9MXyF
         E186ANdZbRDH0h7s74197AJgUbMlrxF48AYP9MMSkUmlmM9Kg9BKKLNjAulJPNqwSfja
         gYkNtI4Sqr1OvU+tQAC2OpEUw8dgsZu2BqUC2BCOn1z6DIFzYLAOXEC715kk54n60od5
         mRxQ==
X-Gm-Message-State: AOAM533hJq+qYPgvmLEV/WcVEaLhsRHKvI7/3ZwcKnrDYK4PlymefPrs
        D0upePyA872RB+9USAKa+k78vA==
X-Google-Smtp-Source: ABdhPJzIHO4BdhieqQHBdFlwXeo4p1xzGRxy0ToJKelI3up3VqCBFqUI2lIb1e3HK958Nnpfw7QwNw==
X-Received: by 2002:a05:6808:1149:: with SMTP id u9mr4467883oiu.61.1622173474368;
        Thu, 27 May 2021 20:44:34 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id p22sm846364oop.7.2021.05.27.20.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 20:44:33 -0700 (PDT)
Date:   Thu, 27 May 2021 22:44:32 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     ohad@wizery.com, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] remoteproc: core: Move validate before device add
Message-ID: <YLBnIDrNVVePv3gZ@builder.lan>
References: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
 <1621284349-22752-3-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621284349-22752-3-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 17 May 15:45 CDT 2021, Siddharth Gupta wrote:

> We can validate whether the remoteproc is correctly setup before
> calling making the cdev_add and device_add calls. This saves us
> the trouble of cleaning up later on.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> ---
>  drivers/remoteproc/remoteproc_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 562355a..45d09bf 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -2316,16 +2316,16 @@ int rproc_add(struct rproc *rproc)
>  	struct device *dev = &rproc->dev;
>  	int ret;
>  
> -	/* add char device for this remoteproc */
> -	ret = rproc_char_device_add(rproc);
> +	ret = rproc_validate(rproc);
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = device_add(dev);
> +	/* add char device for this remoteproc */
> +	ret = rproc_char_device_add(rproc);
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = rproc_validate(rproc);
> +	ret = device_add(dev);
>  	if (ret < 0)
>  		return ret;
>  
> -- 
> Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
