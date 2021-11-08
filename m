Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1316449843
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 16:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhKHP3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 10:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhKHP3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 10:29:38 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D0EC061570;
        Mon,  8 Nov 2021 07:26:54 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id o15-20020a9d410f000000b0055c942cc7a0so3368811ote.8;
        Mon, 08 Nov 2021 07:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=chC3YbDWYzniOxK3WtaulowJ3UlKNSrFvxxb8N8ry0w=;
        b=JxAFOgbVnHLwfMIQIECNqVQSIEcoAgACmUt5826itb3T19FXbfVsqi6R8OHrxR6Pi/
         a3fKmxc9lYKcvMCR+G/vJOWKMYwYpyIXVyVrPZbz6eYkMlyM4lVnixHHKlX3KQvQ4csZ
         dhgKnqbASbzPXqa5kxmcdMnb8bUnIgE2DxHEeRR+CABmKJEr9jnhQvavvAVu+yK1A2Il
         ZJS2fy4SEhOVhDHSF2XdjyB3ZQj+yuOuKXQnca4wZznE2KcsTlEo6XuaWOEe1P9FWpbV
         L6KelWpZhRfIIL1UzRbg2aZdaMQwH1zST7aFFyFtRUNfb5fcv3hche3SdjjNpo6K+4Vj
         UmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=chC3YbDWYzniOxK3WtaulowJ3UlKNSrFvxxb8N8ry0w=;
        b=yj88Rb94cAGGbbT83zOfOEWIEjkdF2Y8EoUBWFu0aZRJbSCWzkGt9XiQwY8vJlY1LS
         7/XCk/wK8lZkkVOUCsUbx6scuQQ/7gqD+IVJa9m44BUJqzB7AWxRykgjJYoPKniZvXN7
         iZB9qWK/2ZEPseRHmMxzpKzFd8vo4PvlmEKFnlHTehMDi0cUyZMa2r1weK6WeKBnZHL/
         +lkJUkm1q2Uol6mMVUl/KHvPkm4dl3YtU4DmUIamXJToY+rkrlR1KUVbgiQxkaLeo48z
         K5zNAlMIJkYg05mZVopwPKGdVLHjjOSJdi3kWKZjjfrKuhdGpEHnIKdgyr8pQm2OXhXq
         tznw==
X-Gm-Message-State: AOAM530izV3ymCa8eNXxzNytdAPTuXyEtu4R9THDN8okvRU5l46lhYmp
        VYhprwpufdNLerNTg4FyVrk=
X-Google-Smtp-Source: ABdhPJxwcgDuYyz0EEyHfI3TSX7yBhwpJtM+JFS4OEO2EZ7En6LRbidEU30chVhLMO9MP31+OK13tg==
X-Received: by 2002:a9d:590e:: with SMTP id t14mr530975oth.34.1636385213881;
        Mon, 08 Nov 2021 07:26:53 -0800 (PST)
Received: from [192.168.1.103] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id 97sm480880otv.80.2021.11.08.07.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:26:53 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <0d24888e-0132-4a9a-f8cb-4f5a3d4b10c6@lwfinger.net>
Date:   Mon, 8 Nov 2021 09:26:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2] staging: r8188eu: Fix breakage introduced when 5G code
 was removed
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "phil@philpotter.co.uk" <phil@philpotter.co.uk>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zameer Manji <zmanji@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Stable <stable@vger.kernel.org>
References: <20211107173543.7486-1-Larry.Finger@lwfinger.net>
 <8e4dd863ae894c8488a3d3d0f6a11f66@AcuMS.aculab.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <8e4dd863ae894c8488a3d3d0f6a11f66@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/21 04:55, David Laight wrote:
> From: Larry Finger
>> Sent: 07 November 2021 17:36
>>
>> In commit 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions
>> and code"), two entries were removed from RTW_ChannelPlanMap[], but not replaced
>> with zeros. The position within this table is important, thus the patch broke
>> systems operating in regulatory domains osted later than entry 0x13 in the table.
>> Unfortunately, the FCC entry comes before that point and most testers did not see
>> this problem.
> ...
>>   drivers/staging/r8188eu/core/rtw_mlme_ext.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
>> index 55c3d4a6faeb..5b60e6df5f87 100644
>> --- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
>> +++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
>> @@ -107,6 +107,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
>>   	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
>>   	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
>>   	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
>> +	{0x00}, /* 0x13 */
>>   	{0x02},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
>>   	{0x00},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
>>   	{0x00},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
>> @@ -118,6 +119,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
>>   	{0x00},	/* 0x1C, */
>>   	{0x00},	/* 0x1D, */
>>   	{0x00},	/* 0x1E, */
>> +	{0x00},	/* 0x1F, */
>>   	/*  0x20 ~ 0x7F , New Define ===== */
>>   	{0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
>>   	{0x01},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */
> 
> Is it worth changing that to use designated array initialisers?
> so:
> 	[0x21] = {0x01} /* RT_CHANNEL_DOMAIN_ETS11_NULL */
> 
> Then the {0x00} entries can be missed out (or just commented as not used).

Yes, we could save a few bytes but risk getting into trouble aligning with some 
other array that I have not located. I think it should be left the way it is.

Larry

