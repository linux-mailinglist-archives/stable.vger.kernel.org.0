Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF92DE1DE
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 04:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfJUCG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 22:06:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39021 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfJUCG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 22:06:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id p12so6761682pgn.6
        for <stable@vger.kernel.org>; Sun, 20 Oct 2019 19:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+yWlFQ3j7MPCBznXsMHQtwJpyH73frvubd7zQPjGqcQ=;
        b=b6jF/1TCbvWbam16ICWlejQoSAC8+hg+CuxDEnF4riYF5Sq4SSUC+vktJEEOp4GwaL
         R+MVDsuCHRmEkMhueRjh3U4t/xHsfmYAd5Yomv9TltCGadViASJLNsaikB20jqDJxi8n
         dWVfgkI6OxuV8SrTlzu1UxF84Waqf0ymzK7EjZVebV+jJvqaIuMIp0TTrl4wcLkRQ1cg
         JRDHJR3HLRAy4g02+T82IvW12A/CAQAGYnqhqse9BnW+Z7pg+VV47mmjQ77JfilZzDiA
         +4QoCJLF0pzaHnplp75PudT0JDggsOSIJ3OGCzqSRGkdb8VVyWjD0Hk6gS3A5uCtXRqZ
         bMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+yWlFQ3j7MPCBznXsMHQtwJpyH73frvubd7zQPjGqcQ=;
        b=T9tCVPI4F4AeTUP1tQ/5jCUCoXdaMU+hz8u7U83HDpDRaVdDg1o5JPykal7/+WMPHZ
         xsSdVJcSw9WmLZtYaGY0HXZ9NtDIx9bg9NpA7/v/m1ewgnjUCZLQvrZFgZEtlKSHqBXb
         FYJy3icMilnxgCRYEQXdZrTLaP4sLODKee0hPhKHyACDTJMpdiWCcnrlvZuBC95MlzjN
         ZqF0c80naZTdtSm1dTPdoOcT++HCrH2b+No2pGiGNSvwFqhfnMQ4sXpICUlD0eYPrPyC
         JdF7sp4Zdd9444lbom7CrJ7v26039jK9UbBvCFV/Lr/HQFg16P9EkRGM4dnUiOAgU/fb
         6z0g==
X-Gm-Message-State: APjAAAVtULGi60BoNVQ4ok1c8Yr/26nnlE3yQidGAO2EYLVNch+IMcpO
        drbc9wLge00ReBQuVJfgCN7RgA==
X-Google-Smtp-Source: APXvYqx+O4q4hmJUC+1LMJIMJc8cEyhGSOZvO9jUQMs0EyVIEpjKc4vVl0VNeQL6Dp2g1H3xO8GA+g==
X-Received: by 2002:a63:b644:: with SMTP id v4mr7468971pgt.249.1571623588138;
        Sun, 20 Oct 2019 19:06:28 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id k23sm12553705pgi.49.2019.10.20.19.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 19:06:26 -0700 (PDT)
Date:   Sun, 20 Oct 2019 19:06:24 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: reserved_mem: add missing of_node_put() for proper
 ref-counting
Message-ID: <20191021020624.GE4500@tuxbook-pro>
References: <1571536644-13840-1-git-send-email-cgoldswo@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571536644-13840-1-git-send-email-cgoldswo@codeaurora.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 19 Oct 18:57 PDT 2019, Chris Goldsworthy wrote:

> Commit d698a388146c ("of: reserved-memory: ignore disabled memory-region
> nodes") added an early return in of_reserved_mem_device_init_by_idx(), but
> didn't call of_node_put() on a device_node whose ref-count was incremented
> in the call to of_parse_phandle() preceding the early exit.
> 
> Fixes: d698a388146c ("of: reserved-memory: ignore disabled memory-region nodes")
> Signed-off-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
> To: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org

Cc stable@ is used to assist in making sure your patch is backported to
stable kernels, other than that the purpose Cc here is to indicate that
specific people have been requested to comment on your patch.

So please skip these from the commit message in the future (for this
one, wait and see if Rob is willing to trim them as he applies the
patch).


Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/of/of_reserved_mem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 7989703..6bd610e 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -324,8 +324,10 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
>  	if (!target)
>  		return -ENODEV;
>  
> -	if (!of_device_is_available(target))
> +	if (!of_device_is_available(target)) {
> +		of_node_put(target);
>  		return 0;
> +	}
>  
>  	rmem = __find_rmem(target);
>  	of_node_put(target);
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
