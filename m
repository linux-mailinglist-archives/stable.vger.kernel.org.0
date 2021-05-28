Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F65393C15
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 05:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhE1Dwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 23:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbhE1Dwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 23:52:33 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC226C061760
        for <stable@vger.kernel.org>; Thu, 27 May 2021 20:50:58 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so2260051otc.12
        for <stable@vger.kernel.org>; Thu, 27 May 2021 20:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=asRlje0goAhFcEJxLUA9BBxp84jlRep9Pz0YvxsytNw=;
        b=nfADAGzbgpY5NA6+jelsBMfutNd8ztua/oK7zSpFSidti7UyaUmCZFpCdpdqXgWCOP
         16YUZThLFJXDGxmY0e6aLtilolZ10AVYNb8xXgrHlsDJ9LCsEAGFGVP7dgh6z/PTAIaR
         G+tiLxz4Ba4ChEAbTbgQEQvarmbckCnZD9RF+0blclzFEhy+Q/4rEMpR25feVE+DvXyF
         MFCoZvcBmhfy3gx7dLfeUj2RrMhLP4+iUXMLlzySRSG3ZHsDIUsafqvstmoiIlloHRx1
         C9hX7NMiyqt55ra0fW6SxKL2tXUeiozrLeRUDKNAlrBNhSF107doS8x6CH5TsMVWyQy4
         Zl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=asRlje0goAhFcEJxLUA9BBxp84jlRep9Pz0YvxsytNw=;
        b=Ue4SIrNM2YajALTrLshquwabPKRSPAI+Q+xOdbNs8JiPxxmGBsN1Q9dfDKAO4CG0xY
         E6eELePU11XNC214MD0qhJ2nrMU4IGxzeUS1O6AC/o20KxTP+pMw2cyAVgiFpjB7YGFh
         1CmZPhs627lk7woqSJuID0nFJqlyXX/VMwUkJjElmhYVh2pPMCzyrXyfHh7ht/e3eaQ+
         vm4h+0XTkjhdYHL8iGEHWpbtRvC6TC0N5T4PCeMP6blGbzNx4gsbSAnJ5Kk3C4lDklVZ
         QXt0xYqATSjsRBFB1zJCAZz/hY/wQZB69H2WMgRTpqeJKuLKjSEeupgTRAuConV3/auE
         kVUQ==
X-Gm-Message-State: AOAM53370xB/OSfY+FkNdPi/xEHJZKK7SujR6Tag3y4y/IqUlEZ7zl3W
        DHxCmXVZpldOajwzt9B4Wzj6GA==
X-Google-Smtp-Source: ABdhPJxwBt+4tqhG35N+FAveVQMOtsF/8nAal7iWx1N0eQlYBcRpavgW1FadCaaLPuNq6iagLqNhNQ==
X-Received: by 2002:a05:6830:2143:: with SMTP id r3mr5545599otd.165.1622173857906;
        Thu, 27 May 2021 20:50:57 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id b19sm881138oib.46.2021.05.27.20.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 20:50:57 -0700 (PDT)
Date:   Thu, 27 May 2021 22:50:55 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     ohad@wizery.com, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] remoteproc: core: Cleanup device in case of failure
Message-ID: <YLBon0bBnzrizpDi@builder.lan>
References: <1621284349-22752-1-git-send-email-sidgup@codeaurora.org>
 <1621284349-22752-4-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621284349-22752-4-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 17 May 15:45 CDT 2021, Siddharth Gupta wrote:

> When a failure occurs in rproc_add() it returns an error, but does
> not cleanup after itself. This change adds the failure path in such
> cases.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> ---
>  drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 45d09bf..6f5fa81 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -2326,8 +2326,10 @@ int rproc_add(struct rproc *rproc)
>  		return ret;
>  
>  	ret = device_add(dev);
> -	if (ret < 0)
> -		return ret;
> +	if (ret < 0) {
> +		put_device(dev);
> +		goto rproc_remove_cdev;
> +	}
>  
>  	dev_info(dev, "%s is available\n", rproc->name);
>  
> @@ -2338,7 +2340,7 @@ int rproc_add(struct rproc *rproc)
>  	if (rproc->auto_boot) {
>  		ret = rproc_trigger_auto_boot(rproc);
>  		if (ret < 0)
> -			return ret;
> +			goto rproc_remove_dev;
>  	}
>  
>  	/* expose to rproc_get_by_phandle users */
> @@ -2347,6 +2349,13 @@ int rproc_add(struct rproc *rproc)
>  	mutex_unlock(&rproc_list_mutex);
>  
>  	return 0;
> +
> +rproc_remove_dev:
> +	rproc_delete_debug_dir(rproc);
> +	device_del(dev);
> +rproc_remove_cdev:
> +	rproc_char_device_remove(rproc);

I'm confused, shouldn't this function just do cdev_del()?
__unregister_chrdev() seems to do more than unroll what cdev_add()
did...

Apart from this, I think the patch looks good. Really nice to see you
tidy this up!

Regards,
Bjorn

> +	return ret;
>  }
>  EXPORT_SYMBOL(rproc_add);
>  
> -- 
> Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
