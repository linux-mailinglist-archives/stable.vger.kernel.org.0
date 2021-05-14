Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7002538044B
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 09:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhENHcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 03:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbhENHce (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 03:32:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D206EC061756
        for <stable@vger.kernel.org>; Fri, 14 May 2021 00:31:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id m12so43389954eja.2
        for <stable@vger.kernel.org>; Fri, 14 May 2021 00:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MeWJn1lwkxmYF65NxG4LtJkp+p22LS33JHgIImsUXpE=;
        b=eAMMv9yTHNgm7dAJqLpDUz305VUqf3cXaecKNjOjZ17lbj6BrB+GxhXVpkdA6wVtMQ
         m1D0zwn/u3O9mkmOOkuft7E6HTDfPOCQ/XratpwmkWum7wuE+JkXgPClFqUuRbvgQ8CA
         rfGYTudoS/HQocrejIYSlIzl+DfSuAad2JwmQP2H0vdDOUGTX+yRsZY42ViyehWMsJtB
         94LzEdVsMxUdDMkHo+/pwiQn8GPZp5eJKFa8upUWBqpUK9Xvbk91ZGjRxE0Kao5bc2iV
         7bj7AR6c2/sWPt6psVSUTpwUE51kWoC/ZMsuAkAIxq50jzzu59SNRbD40XeenlE/0Fly
         qKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MeWJn1lwkxmYF65NxG4LtJkp+p22LS33JHgIImsUXpE=;
        b=NmkXG7AUgcoiMHaSvv8pRFZoLqwOzg65333NMB72TtYpX0rIwGYmTz2q7r9WrQodiq
         BQ0wV3Zeo3vS9vN4oFDTtemQa1e9QpS1k3AnItCKLTfck4/0bWoML+LN3+4eFAbuMtYh
         695QQyfFV9zwHinlxzz3F6BmjESNiU4Ccy6mjLfIv05vi4pZJM39B9v0IB560ocGK5ue
         eiOLlubgmUWMthugHZH+O0VHGtNUJsQx61YyL38woBQbUozH1b98dwiXpk7uwX92l/l3
         Gal6bdIiHn2DvmsrK23u0ROjb+NyaCJeentz2qIixhmhZfpCZZB6whQ1tX1KtGoY7T81
         KGhw==
X-Gm-Message-State: AOAM532r2FVxC3sf9gePndoBz8ejVub2oSjy1ycMF6nBJiUcK2PkPcDU
        Sm4euT5LHgTH7dseRnUpgNNujgf9U/4=
X-Google-Smtp-Source: ABdhPJwrNtqFS9rXsOXwEQOwk1zWCpjPwDnD+DmCADTTUPTIoDfSqB4U3s42bWhiZUf1mbi5Kp2M5Q==
X-Received: by 2002:a17:906:2ed0:: with SMTP id s16mr22020058eji.543.1620977479574;
        Fri, 14 May 2021 00:31:19 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:cf70:a0fd:8c48:efd4? ([2a02:908:1252:fb60:cf70:a0fd:8c48:efd4])
        by smtp.gmail.com with ESMTPSA id z12sm3898825edr.17.2021.05.14.00.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 00:31:19 -0700 (PDT)
Subject: Re: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
To:     Luben Tuikov <luben.tuikov@amd.com>, amd-gfx@lists.freedesktop.org
Cc:     Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org
References: <20210512170302.64951-1-luben.tuikov@amd.com>
 <9d7f82e8-6528-154f-9a23-bf78ff249505@gmail.com>
 <1d54c92e-1448-7aaf-9738-3a22e6799356@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <4bebeded-99b7-9b60-b761-7a4d04415424@gmail.com>
Date:   Fri, 14 May 2021 09:31:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1d54c92e-1448-7aaf-9738-3a22e6799356@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 13.05.21 um 21:37 schrieb Luben Tuikov:
> On 2021-05-13 3:56 a.m., Christian König wrote:
>> Am 12.05.21 um 19:03 schrieb Luben Tuikov:
>>> On QUERY2 IOCTL don't query counts of correctable
>>> and uncorrectable errors, since when RAS is
>>> enabled and supported on Vega20 server boards,
>>> this takes insurmountably long time, in O(n^3),
>>> which slows the system down to the point of it
>>> being unusable when we have GUI up.
>>>
>>> Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to AMDGPU_CTX_OP_QUERY_STATE2")
>>> Cc: Alexander Deucher <Alexander.Deucher@amd.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
>>> ---
>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 26 ++++++++++++-------------
>>>    1 file changed, 13 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
>>> index 01fe60fedcbe..d481a33f4eaf 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
>>> @@ -363,19 +363,19 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
>>>    		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
>>>    
>>>    	/*query ue count*/
>>> -	ras_counter = amdgpu_ras_query_error_count(adev, false);
>>> -	/*ras counter is monotonic increasing*/
>>> -	if (ras_counter != ctx->ras_counter_ue) {
>>> -		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
>>> -		ctx->ras_counter_ue = ras_counter;
>>> -	}
>>> -
>>> -	/*query ce count*/
>>> -	ras_counter = amdgpu_ras_query_error_count(adev, true);
>>> -	if (ras_counter != ctx->ras_counter_ce) {
>>> -		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
>>> -		ctx->ras_counter_ce = ras_counter;
>>> -	}
>>> +	/* ras_counter = amdgpu_ras_query_error_count(adev, false); */
>>> +	/* /\*ras counter is monotonic increasing*\/ */
>>> +	/* if (ras_counter != ctx->ras_counter_ue) { */
>>> +	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE; */
>>> +	/* 	ctx->ras_counter_ue = ras_counter; */
>>> +	/* } */
>>> +
>>> +	/* /\*query ce count*\/ */
>>> +	/* ras_counter = amdgpu_ras_query_error_count(adev, true); */
>>> +	/* if (ras_counter != ctx->ras_counter_ce) { */
>>> +	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE; */
>>> +	/* 	ctx->ras_counter_ce = ras_counter; */
>>> +	/* } */
>> Please completely drop the code. We usually don't keep commented out
>> code in the driver.
> 1. Alex suggested this when we chatted--this is why it is commented.

Sounds like a misunderstanding to me, usually it is Alex who insists on 
dropping the code.

> 2. He suggested the same thing last night and 2.5 hours before your email,
>      I posted a patch in which the code is commented out--did you not see it?
>      It's threaded, it appears above, 2.5 hours before your email.

Sorry for the redundancy, didn't had seen that in my inbox yet when I 
wrote the reply.

Regards,
Christian.

>
> Regards,
> Luben
>
>> With that done the patch is Reviewed-by: Christian König
>> <christian.koenig@amd.com>
>>
>> Christian.
>>
>>>    
>>>    	mutex_unlock(&mgr->lock);
>>>    	return 0;

