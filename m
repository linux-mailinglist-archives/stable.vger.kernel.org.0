Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232FF1585E4
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 00:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgBJXFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 18:05:54 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46285 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgBJXFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 18:05:53 -0500
Received: by mail-yw1-f67.google.com with SMTP id z141so4261531ywd.13
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 15:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q5PXlpwVvi6saWkvSQji3GnNIe//3e8V+lTRQXOS/Es=;
        b=wvXw1Ql4U47cssGBa5B+/tRZizPR+KTJga7oifGQfeIljgVqNyFRBbuBpAVgGDS+CV
         8dO//dTJGHC3H3VmbTbHA2AorvuL3a9L4zallLsIiTZEjjaozDaRePUr0f8jQi/QSoVB
         7Qz34RDyHKVOOoVDhDv3jV/yq1oYS4YGtMZDFBophPIJ34DLh+l0aV6Ri/0Wjca7GiWh
         UafavllHoDLnIuNbHVEMg1ruP4vleNWhgzT0vGfKsbsivu/Asx7u/BkZON0IOXt3hycN
         WIf8YfrhV8YRvHyqYX8Dqqbrfuw+EulslCzCVqBeNdEo4I+xe28LXGEuBBSJbXpgyHnI
         wibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q5PXlpwVvi6saWkvSQji3GnNIe//3e8V+lTRQXOS/Es=;
        b=WkRVfoeVuHOwD3aI87XKq7h6Y31vBVBjE2kC3WayFbkOwUV+O40PzILMyghUD9MxF7
         UnS8ePOnVDLXE+oh//rBH9NvzFgN1qhY+MDE5c0G6qSU3xUspNSnjS0jvdk86BMKZoFM
         fPs6fgwvc3C4IdLEp+OhecmggVapzhqi8PQFdQHGOgiH1hlfoChhP3D25daNCNzWTARo
         GFx1bUtcgQwLZ4jMoAbDNow945/jhCFRoPsscEqfE1gpA9m0rYmmifNE4GxsLfZ75HkU
         jn+J45Fd+yUKmGeEm42gisLdorejCIls++Wy8hBrUkBFYwTUZEwfpF6bz0gKgSw4El+z
         gw4A==
X-Gm-Message-State: APjAAAXDmJ+Q7FGrXRLKJ9u6kNLxDQiqV+IYyxSAm5lv2zgCIcYLq02f
        xN957daUXGoR4xE8OrhXW15MLw==
X-Google-Smtp-Source: APXvYqypoygAH8SSKndH7IUhnMK1woOlF1wvNP+ub43POcE2aD4Va7DiD4+547eOi1gEIopJzS7+UQ==
X-Received: by 2002:a0d:ed45:: with SMTP id w66mr3164581ywe.183.1581375951475;
        Mon, 10 Feb 2020 15:05:51 -0800 (PST)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id q16sm935897ywa.110.2020.02.10.15.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 15:05:51 -0800 (PST)
Date:   Mon, 10 Feb 2020 16:05:48 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sibi Sankar <sibis@codeaurora.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss
 region on shutdown
Message-ID: <20200210230548.GA20652@xps15>
References: <20200204062641.393949-1-bjorn.andersson@linaro.org>
 <20200204062641.393949-2-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204062641.393949-2-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On Mon, Feb 03, 2020 at 10:26:40PM -0800, Bjorn Andersson wrote:
> Trying to reclaim mpss memory while the mba is not running causes the
> system to crash on devices with security fuses blown, so leave it
> assigned to the remote on shutdown and recover it on a subsequent boot.
> 
> Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Changes since v2:
> - The assignment of mpss memory back to Linux is rejected in the coredump case
>   on production devices, so check the return value of q6v5_xfer_mem_ownership()
>   before attempting to memcpy() the data.
> 
>  drivers/remoteproc/qcom_q6v5_mss.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> index 471128a2e723..25c03a26bf88 100644
> --- a/drivers/remoteproc/qcom_q6v5_mss.c
> +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> @@ -887,11 +887,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
>  		writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
>  	}
>  
> -	ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> -				      false, qproc->mpss_phys,
> -				      qproc->mpss_size);
> -	WARN_ON(ret);
> -
>  	q6v5_reset_assert(qproc);
>  
>  	q6v5_clk_disable(qproc->dev, qproc->reset_clks,
> @@ -981,6 +976,10 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
>  			max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
>  	}
>  
> +	/* Try to reset ownership back to Linux */
> +	q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> +				qproc->mpss_phys, qproc->mpss_size);

Would you mind adding more chatter here, something like what is mentioned in the
changelog?  That way I anyone trying to review this code doesn't have to suffer
through the same mental gymnastic. 

> +
>  	mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
>  	qproc->mpss_reloc = mpss_reloc;
>  	/* Load firmware segments */
> @@ -1070,8 +1069,16 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
>  	void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
>  
>  	/* Unlock mba before copying segments */
> -	if (!qproc->dump_mba_loaded)
> +	if (!qproc->dump_mba_loaded) {
>  		ret = q6v5_mba_load(qproc);
> +		if (!ret) {
> +			/* Try to reset ownership back to Linux */
> +			ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> +						      false,
> +						      qproc->mpss_phys,
> +						      qproc->mpss_size);
> +		}

I'm a bit puzzled here as to why a different reclaim strategy is needed.  It is
clear to me that if q6v5_mba_load() returns 0 then the MBA is running and we can
safely reclaim ownership of the memory.  But is it absolutely needed when we
know that 1) the MCU has crashed and 2) said memory will be reclaimed in
q6v5_mpss_load()?

If so I think an explanation in the code is needed.

I also assume there is no way to know if the mba is running, hence not taking
any chance.  If that's the case it would be nice to add that to the comment in
q6v5_mpss_load().

Thanks,
Mathieu

> +	}
>  
>  	if (!ptr || ret)
>  		memset(dest, 0xff, segment->size);
> @@ -1123,10 +1130,6 @@ static int q6v5_start(struct rproc *rproc)
>  	return 0;
>  
>  reclaim_mpss:
> -	xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> -						false, qproc->mpss_phys,
> -						qproc->mpss_size);
> -	WARN_ON(xfermemop_ret);
>  	q6v5_mba_reclaim(qproc);
>  
>  	return ret;
> -- 
> 2.23.0
> 
