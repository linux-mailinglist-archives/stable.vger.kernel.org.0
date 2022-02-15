Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2C4B787F
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbiBOUCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 15:02:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbiBOUCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 15:02:09 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC41723DD
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 12:01:56 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id i62so25350224ioa.1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 12:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mgRhZesJswJ3/ynhybWZOU8hr/RyxGXmljZMpkuuJW4=;
        b=odYILHCrnwbsOfpGCV+JaE2s3lvJ3Ht1HPQsg+dukRqGJ/nMmvPjXfhbODV+KhXzpB
         xjmbl7pccnIdeQmlVLdeYqk9GuyKYCcpVtJgyTA6rsJwxfCPUd/gXe15VgFoS7srSIXt
         HVqhAI66OnEg7f+9b6qs5KCandGkCGCU/oR906pGI4RTidBsmDIaqTSDsBplwgH3gLtR
         KgMTes4ezt7G/su7DY0xhgyBGgPtx0AFlwn9ngUv10uh0/YD+LhqgLS06qzKuCFW63Vo
         IqzDclXOZmCuX/JNhcVi0wqCotAOVGYMHgEBqrWcApVORpe8fdDk3YVOuG5EIMzDsKVd
         Cl2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mgRhZesJswJ3/ynhybWZOU8hr/RyxGXmljZMpkuuJW4=;
        b=j04MxfQfVPGoGKgY/RnSGQs1AW7Y4atca9MAgkcbEW49ZFvnKMdyaq0dqL464XwoDJ
         uJp9Az5RR1mrX4Bke7TxC4xiuv//jJy4trDXZY3GliNz8D+9RCXPjv8VNK1tKajRuYFF
         HJO9LIux9SQ7yAGrryj/b2NzvyszsSumXhBFQFVRDoRzZG0wCXWt6WDGSvk8eSOfF9AO
         obZEYdKIKW97rX9lWIodglP4GBZeUmHOET99DUStOo1ifQ7tD/ZjOVN5tKc4L0cX90VH
         wDYvFXvsGvA8v48XjH+j+irji50L5fLPDApz+zzZ1Xi7AnK1ckoetSKber2AbvkNkxSe
         7E3A==
X-Gm-Message-State: AOAM530DYgo92dz1JVvNpi+0GoRupOjI12YunYh4QYYWjxc8PnJ6VLzt
        z9NPtOknm5iMGfTu1CdFY/je0g==
X-Google-Smtp-Source: ABdhPJwcV/GbLd9CikXqISjwI58+VzhQaVZtbO/QUToPhsnUL3EHQ2SawA9MRgvrzJCVD3rmpAdjkA==
X-Received: by 2002:a6b:e60d:: with SMTP id g13mr323488ioh.39.1644955315941;
        Tue, 15 Feb 2022 12:01:55 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id p11sm25923177iov.38.2022.02.15.12.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 12:01:55 -0800 (PST)
Message-ID: <0c95c9a5-cf66-dcec-bfde-0ca201206c8b@linaro.org>
Date:   Tue, 15 Feb 2022 14:01:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 01/25] bus: mhi: Fix pm_state conversion to string
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        quic_jhugo@quicinc.com, vinod.koul@linaro.org,
        bjorn.andersson@linaro.org, dmitry.baryshkov@linaro.org,
        quic_vbadigan@quicinc.com, quic_cang@quicinc.com,
        quic_skananth@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
References: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
 <20220212182117.49438-2-manivannan.sadhasivam@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220212182117.49438-2-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/12/22 12:20 PM, Manivannan Sadhasivam wrote:
> From: Paul Davey <paul.davey@alliedtelesis.co.nz>
> 
> On big endian architectures the mhi debugfs files which report pm state
> give "Invalid State" for all states.  This is caused by using
> find_last_bit which takes an unsigned long* while the state is passed in
> as an enum mhi_pm_state which will be of int size.

I think this would have fixed it too, but your fix is better.

	int index = find_last_bit(&(unsigned long)state, 32);

> Fix by using __fls to pass the value of state instead of find_last_bit.
> 
> Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
> Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/bus/mhi/core/init.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> index 046f407dc5d6..af484b03558a 100644
> --- a/drivers/bus/mhi/core/init.c
> +++ b/drivers/bus/mhi/core/init.c
> @@ -79,10 +79,12 @@ static const char * const mhi_pm_state_str[] = {
>   
>   const char *to_mhi_pm_state_str(enum mhi_pm_state state)

The mhi_pm_state enumerated type is an enumerated sequence, not
a bit mask.  So knowing what the last (most significant) set bit
is not meaningful.  Or normally it shouldn't be.

If mhi_pm_state really were a bit mask, then its values should
be defined that way, i.e.,

	MHI_PM_STATE_DISABLE	= 1 << 0,
	MHI_PM_STATE_DISABLE	= 1 << 1,
	. . .

What's really going on is that the state value passed here
*is* a bitmask, whose bit positions are those mhi_pm_state
values.  So the state argument should have type u32.

This is a *separate* bug/issue.  It could be fixed separately
(before this patch), but I'd be OK with just explaining why
this change would occur as part of this modified patch.

>   {
> -	unsigned long pm_state = state;
> -	int index = find_last_bit(&pm_state, 32);
> +	int index;
>   
> -	if (index >= ARRAY_SIZE(mhi_pm_state_str))
> +	if (state)
> +		index = __fls(state);
> +
> +	if (!state || index >= ARRAY_SIZE(mhi_pm_state_str))
>   		return "Invalid State";

Do this test and return first, and skip the additional
check for "if (state)".

					-Alex

>   	return mhi_pm_state_str[index];

