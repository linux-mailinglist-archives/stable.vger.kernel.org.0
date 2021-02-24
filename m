Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E903323B33
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 12:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhBXLUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 06:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbhBXLUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 06:20:04 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22876C06174A
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 03:19:19 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t15so1481630wrx.13
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 03:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=y1amc0xUUDXKyMkYpBNAZwR5P9bhKoCJSS4XEZ56VYA=;
        b=OdI1Nh16csmUafIBo4cGakR3MV48vT6+emCMcit7JQ8pv8fbf09Pzu4qgDmXBRrxVP
         MqrSktI0jUbZV58GN5mmyAj/Nk9wJDerYysxbJ90AUNx+lniy7sBZP6sd9ZtgkblWGGd
         6GW7SnoT0vMzndPTdWB2Pt8+OgVixRhhdjf9D+cUDSdvp2D4lwctvN7XRC2LzJVR07Lx
         m8BViKyEJyo+5D3AbO01NLWbGPXdJupsDFQSd7MSA53huqr5wP+5IgWN4psSl88Wb72e
         aLjiAtfM1ws8K/9zMSjXGtA6/VPWMl3bySW8fsX+O/gQCudq6jdUeNuvetls6aSPKG9M
         wSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y1amc0xUUDXKyMkYpBNAZwR5P9bhKoCJSS4XEZ56VYA=;
        b=LQhbp+DxCROq1fTjOaWXF48Vqs1XE5VaicpoJq+QszNFT6oY5tOP+2RTI1qc6Wjfq3
         EVQF/8TssJ6TW3Tev7IyAGyEmHPgeG8adQyR4Z2znU56VmBdbgC1DKQCA/2ugimXYP4z
         srAXljZd6IMSpba6CReeiKs+0UMKMtqVJ+lHtudyBCiVU56GynthJ5054NEZuQRwIW77
         TKOzEisYhZAnbk5euaNvjaYAe7v2KhcQZYjf6/BOtIl+vTTPW9x5BiL/a2MgwrN7saI+
         kLyFIFs4j7sKsKPuoaoqu028NrArkNVnZ27JOaADGsUk7VdckflgkXb8UUj5kCdKXxo9
         L06A==
X-Gm-Message-State: AOAM531/gKLESJnuHd9NEf0+ZCur3jShyFjQ0DV+KwWcAe7qw6ouELSO
        zENfq4TR85Iv4KmMYctF4fYHMQ==
X-Google-Smtp-Source: ABdhPJzOx+OdbNolIfDYzohxY1RMg4sxN9tprKAWEdVYqQSYcIphGwY5yi8s5yDexEpWOJeed1ePhg==
X-Received: by 2002:a5d:6808:: with SMTP id w8mr28828323wru.290.1614165557793;
        Wed, 24 Feb 2021 03:19:17 -0800 (PST)
Received: from dell ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id e17sm3583648wro.36.2021.02.24.03.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:19:17 -0800 (PST)
Date:   Wed, 24 Feb 2021 11:19:15 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com
Subject: Re: [PATCH 4.9.y 1/1] futex: Fix OWNER_DEAD fixup
Message-ID: <20210224111915.GA641347@dell>
References: <20210223144151.916675-1-zhengyejian1@huawei.com>
 <20210223144151.916675-2-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210223144151.916675-2-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Feb 2021, Zheng Yejian wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
> 
> Both Geert and DaveJ reported that the recent futex commit:
> 
>   c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> 
> introduced a problem with setting OWNER_DEAD. We set the bit on an
> uninitialized variable and then entirely optimize it away as a
> dead-store.
> 
> Move the setting of the bit to where it is more useful.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@us.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>

Why have you dropped my Reviewed-by?

> ---
>  kernel/futex.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index b65dbb5d60bb..604d1cb9839d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2424,9 +2424,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  	int err = 0;
>  
>  	oldowner = pi_state->owner;
> -	/* Owner died? */
> -	if (!pi_state->owner)
> -		newtid |= FUTEX_OWNER_DIED;
>  
>  	/*
>  	 * We are here because either:
> @@ -2484,6 +2481,9 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  	}
>  
>  	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
> +	/* Owner died? */
> +	if (!pi_state->owner)
> +		newtid |= FUTEX_OWNER_DIED;
>  
>  	if (get_futex_value_locked(&uval, uaddr))
>  		goto handle_fault;

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
