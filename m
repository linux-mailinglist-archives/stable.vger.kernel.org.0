Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF837F3C5
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 09:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhEMH6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 03:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhEMH6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 03:58:11 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40882C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 00:57:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id s20so33137876ejr.9
        for <stable@vger.kernel.org>; Thu, 13 May 2021 00:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SGspoSiWWeO05p0idByqkzj7gns1gkPL6aCjtxZXsfk=;
        b=TiFV3eyEi7qCXvQsNux0S3lu2EwnLCjVFD93KY5zOJepLCTKuUPdGjnKLzMOVL1Od/
         hBWBOPRn32DGdkKRtyIrxI9hTECZWu+BeMQ3XH3y7SXHjHX1GngZSUE0sGHk3Lo+C5UP
         kqxx/Q00P5vP1hEoMKLoMwU8txoXYHzoT8mTbeMLtmWaGfc8j91Lk42OHzy1CxdAirs6
         C7YN8/gD1LQkz0A3eua2yNb7HbatDFoUUI2KKXyHv4PYhdqCNDQ7VvUsYgPOfMv3Og2g
         3BmD3MLb9CaIrgl0GaZ2sK5BeIuZvJjS1iBDYEDd7lPQU+FyccMeF6Hvsnk9cOkW1gZ2
         8EhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SGspoSiWWeO05p0idByqkzj7gns1gkPL6aCjtxZXsfk=;
        b=OgnYlyPS+v7vy19ssLSd51vpnWIp3gGvOOoMKwnLmeKTtIu66b4j65awDDJLcuM1uG
         1IFNA2wrk8gJmQGOmLvBRKu3X6K3wKUZfSYRHQVhh+zrhV/tHad6KSSzb7nGnlEWHHeY
         YYNNhQJIB+z4D6wtXifAPCP7K72ZoLpoNX6FRQJ4HAC9wZ88fE+nOL8S5jttYII3Tw/v
         XXUZYn6HoJEokpEE9GaXU5+lhRKtTIR/W37owwmwrK2j2u6yNQD9XE+TwaJKsfoONMqt
         +GMhUR4n+v7ednHNBZsg+1m4Jf5m4olETBWLzR4U251/TelghPHIUm1471IXRZOoEFxJ
         rbCQ==
X-Gm-Message-State: AOAM531cXFzD45piMVRn2ORaa6mslCIqOdvdJv6L+n+YanNsm/+NvyGS
        6pPBNs1UZlG8legXGmF6xSv2AgMmz1w=
X-Google-Smtp-Source: ABdhPJy0pyb0ROfCLqDeYFGZ62bJEOpCeBY7EPqDa9mekMR2s9avY+9GSRzB0VAx8sXu40XRho5Djw==
X-Received: by 2002:a17:906:d978:: with SMTP id rp24mr42545397ejb.333.1620892619962;
        Thu, 13 May 2021 00:56:59 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:1e3f:7b0a:2eb9:c6dc? ([2a02:908:1252:fb60:1e3f:7b0a:2eb9:c6dc])
        by smtp.gmail.com with ESMTPSA id jt11sm1403774ejb.83.2021.05.13.00.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 00:56:59 -0700 (PDT)
Subject: Re: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
To:     Luben Tuikov <luben.tuikov@amd.com>, amd-gfx@lists.freedesktop.org
Cc:     Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org
References: <20210512170302.64951-1-luben.tuikov@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <9d7f82e8-6528-154f-9a23-bf78ff249505@gmail.com>
Date:   Thu, 13 May 2021 09:56:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512170302.64951-1-luben.tuikov@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 12.05.21 um 19:03 schrieb Luben Tuikov:
> On QUERY2 IOCTL don't query counts of correctable
> and uncorrectable errors, since when RAS is
> enabled and supported on Vega20 server boards,
> this takes insurmountably long time, in O(n^3),
> which slows the system down to the point of it
> being unusable when we have GUI up.
>
> Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to AMDGPU_CTX_OP_QUERY_STATE2")
> Cc: Alexander Deucher <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 26 ++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> index 01fe60fedcbe..d481a33f4eaf 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> @@ -363,19 +363,19 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
>   		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
>   
>   	/*query ue count*/
> -	ras_counter = amdgpu_ras_query_error_count(adev, false);
> -	/*ras counter is monotonic increasing*/
> -	if (ras_counter != ctx->ras_counter_ue) {
> -		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
> -		ctx->ras_counter_ue = ras_counter;
> -	}
> -
> -	/*query ce count*/
> -	ras_counter = amdgpu_ras_query_error_count(adev, true);
> -	if (ras_counter != ctx->ras_counter_ce) {
> -		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
> -		ctx->ras_counter_ce = ras_counter;
> -	}
> +	/* ras_counter = amdgpu_ras_query_error_count(adev, false); */
> +	/* /\*ras counter is monotonic increasing*\/ */
> +	/* if (ras_counter != ctx->ras_counter_ue) { */
> +	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE; */
> +	/* 	ctx->ras_counter_ue = ras_counter; */
> +	/* } */
> +
> +	/* /\*query ce count*\/ */
> +	/* ras_counter = amdgpu_ras_query_error_count(adev, true); */
> +	/* if (ras_counter != ctx->ras_counter_ce) { */
> +	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE; */
> +	/* 	ctx->ras_counter_ce = ras_counter; */
> +	/* } */

Please completely drop the code. We usually don't keep commented out 
code in the driver.

With that done the patch is Reviewed-by: Christian König 
<christian.koenig@amd.com>

Christian.

>   
>   	mutex_unlock(&mgr->lock);
>   	return 0;

