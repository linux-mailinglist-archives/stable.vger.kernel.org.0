Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967A6324CA9
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhBYJUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhBYJSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:18:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98743C06178A
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 01:17:41 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e10so4250808wro.12
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 01:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xYVgNKYZnkO3UBX4MMId4voMW/i/bKSPJY8pF+VUUbY=;
        b=KuQP4Fdaew84KHfFyUTOZk66h0js+ph9/KOKdQCGQI834+m+MvDykdPOReRUuPvwfa
         FtWMwGCK2oD2QF67WL61he5z1eS6qNEU2DZogaRPy6QfGNUQaxTs018fVMDJSGyAoBdX
         Gav7attvyjihADlTxWK+x7Pffn/KFyRnJ2RXk9QrxOJS3r30Yb0nyNOOnoRHbClFR82b
         Ul1ZaJKSFgFK32poc0xqTFjyqgFBSPKBsjDNLbGheAH2I1RRo+OAnoRyQU9H+Or/2N80
         aJF1Q3ZmEVbJ3NslR+bxPcEfzAyVKGLk+e2h2CtkDVGsbJ7iIh3MoVxjBCWiIPWrSFPR
         zIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xYVgNKYZnkO3UBX4MMId4voMW/i/bKSPJY8pF+VUUbY=;
        b=BAif6JC51+hO00bhWokduSw6YP9MnQBNKWbuIpgIx2VW9TYnP1hG2beyc0u5BZQQFU
         zrjJaMg9HvBnWMz3z3OWVKJv96UKJTM6sC4Dz1HPcoM99YbNUDYN+TFuqF17/qXgpz1h
         kDk5KZkSI1t1tRMF9ADGMILlIzlF7LTK6diYW4cbQJJ8KJzEh/x1XCWEpyblmOhVzA19
         sud0j391k6bG99AAbE6u8iBgCxCTBkugiT/sAojxksREEMF7+gbis/yaHRfK9Q01babT
         1KDr4QLWD6W/deAjHmFga8DTbN6wD2VukJBunoL+bNBeTdLy84Tv37fLGSA35AK3630D
         a6vA==
X-Gm-Message-State: AOAM531xuQe+s7/Q78Pm4//5KvrxUNXJyFT0fetGIphLvR0IVmHUQ41A
        s4dmUXWlpW34NQYtO8a0/HQCMQ==
X-Google-Smtp-Source: ABdhPJx2/tTcgEFEDtUcpa1kS7N+8ZyLq4ix+srxq4T5kIK7+KPGURnKL2wk6Lff9ucshfSJ+fiycw==
X-Received: by 2002:adf:f6d0:: with SMTP id y16mr2415352wrp.351.1614244660343;
        Thu, 25 Feb 2021 01:17:40 -0800 (PST)
Received: from dell ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f7sm7365822wre.78.2021.02.25.01.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 01:17:39 -0800 (PST)
Date:   Thu, 25 Feb 2021 09:17:38 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org, tglx@linutronix.de,
        wangle6@huawei.com, zhengyejian1@huawei.com
Subject: Re: [PATCH 4.9.258] futex: fix dead code in attach_to_pi_owner()
Message-ID: <20210225091738.GC641347@dell>
References: <20210224100923.51315-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210224100923.51315-1-nixiaoming@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Feb 2021, Xiaoming Ni wrote:

> The handle_exit_race() function is defined in commit 9c3f39860367
>  ("futex: Cure exit race"), which never returns -EBUSY. This results
> in a small piece of dead code in the attach_to_pi_owner() function:
> 
> 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> 	...
> 	if (ret == -EBUSY)
> 		*exiting = p; /* dead code */
> 
> The return value -EBUSY is added to handle_exit_race() in upsteam
> commit ac31c7ff8624409 ("futex: Provide distinct return value when
> owner is exiting"). This commit was incorporated into v4.9.255, before
> the function handle_exit_race() was introduced, whitout Modify
> handle_exit_race().
> 
> To fix dead code, extract the change of handle_exit_race() from
> commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
>  is exiting"), re-incorporated.
> 
> Fixes: 9c3f39860367 ("futex: Cure exit race")
> Cc: stable@vger.kernel.org # v4.9.258
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> ---
>  kernel/futex.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

To clarify, this is not a wholesale back-port from Mainline.

It takes the remaining functional snippet of:

 ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")

... and is the correct fix for this issue.

Reviewed-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/kernel/futex.c b/kernel/futex.c
> index b65dbb5d60bb..0fd785410150 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1207,11 +1207,11 @@ static int handle_exit_race(u32 __user *uaddr, u32 uval,
>  	u32 uval2;
>  
>  	/*
> -	 * If the futex exit state is not yet FUTEX_STATE_DEAD, wait
> -	 * for it to finish.
> +	 * If the futex exit state is not yet FUTEX_STATE_DEAD, tell the
> +	 * caller that the alleged owner is busy.
>  	 */
>  	if (tsk && tsk->futex_state != FUTEX_STATE_DEAD)
> -		return -EAGAIN;
> +		return -EBUSY;
>  
>  	/*
>  	 * Reread the user space value to handle the following situation:

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
