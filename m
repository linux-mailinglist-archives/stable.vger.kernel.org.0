Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E386206F8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 03:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiKHCsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 21:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiKHCsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 21:48:06 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2ED2ED7A
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 18:48:05 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so12172774pjk.1
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 18:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cb+qNTf4zZw7M49/6HjMGiu6w5l1+cn6hrjaUdr0DHU=;
        b=3hhW4zT1sCYAOPA96ae3wbs82Byb/dVx1bVdVIfMX6vZCuBfxtEJQu9+4MfFDDLc6O
         4/xG4ynRn8sMpO5Kho4YSJ7IhrrPYEDAF2Ccm/mY3H3wU+nD04ZPFKRa9VKJr5xU+hke
         qn0d/TwtZQ8GcT8eGv/ob/7xcGTQC+u/8OrqGaY6ZixXcqj13v1GMJ6leMG3qH1Us+I+
         +eTJMMetsZv5/S0aHE1PJyzU+4bo3LsHV1KxPxbN+CSEidENJCNA5beDEJkP1jXxKLRo
         wPpkHa6m9oGoQcBCxkEW2K7asp5ctT+jKl0+rlyjVKj/WVOYgOmKKlCYcL4EWjxJ8R9y
         Fe+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cb+qNTf4zZw7M49/6HjMGiu6w5l1+cn6hrjaUdr0DHU=;
        b=uygz9PjkKlv5kJs3727DW/uT8h3BCVFHsvTn1GBdymp7WlXrjwTqBvuPfBafgRDw9j
         mgyTscKSJf3cE3tSXOmFLm2GZnLxZTX9fTv/AYWyaf1lDl+7fifnjB6Jltl1eQ0iMAwd
         +2p5bjPetdwpnrYP8wtB7jAFzUn9IZ3pTBMMZkyFRgk/mc32nVUGBKWPYosZADCWm5KC
         3Yfe/0zSLfgO/wy/DZQ5M9iJmfnPymR2PpxC+Q4jM5A4lAZOtKFauZNbDeHm6mTCCqSF
         1tMXnnN2C/UE1hcFTX0/HfBAA8tGV9SLN4/z+XG4WgVgvF+jeAo3KfDIkD/clUqoFm04
         yS9g==
X-Gm-Message-State: ACrzQf0Zo6i04pUNDhvlT/4H/5RU5vVYv+DN1cjOq0NsC+jzxDwRJVtl
        g3WSSjRozXZDCIPW+XX8GqsJIQ==
X-Google-Smtp-Source: AMsMyM7BbG3pWsplO2ijPGakSOF6da3rpSXH6xgjk9w0ZQAiCfSjkEhQDkKZzWadc75CnndQoDi2Dw==
X-Received: by 2002:a17:903:284:b0:186:bb2c:b041 with SMTP id j4-20020a170903028400b00186bb2cb041mr53044475plr.36.1667875684569;
        Mon, 07 Nov 2022 18:48:04 -0800 (PST)
Received: from [10.255.93.192] ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id v6-20020aa799c6000000b0056ee49d6e95sm3837717pfi.86.2022.11.07.18.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 18:48:04 -0800 (PST)
Message-ID: <0fd0c72d-badc-ad75-f0fe-91bc148820f2@bytedance.com>
Date:   Tue, 8 Nov 2022 10:47:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     dvyukov@google.com, willy@infradead.org, akinobu.mita@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <CACT4Y+Zc21Aj+5KjeTEsvOysJGHRYDSKgu_+_xN1LUYfG_H0sg@mail.gmail.com>
 <20221107033109.59709-1-zhengqi.arch@bytedance.com>
 <Y2j9Q/yMmqgPPUoO@nvidia.com>
 <4736d199-7e70-6bc3-30e6-0f644c81a10c@bytedance.com>
 <Y2kxrerISWIxQsFO@nvidia.com>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <Y2kxrerISWIxQsFO@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/11/8 00:26, Jason Gunthorpe wrote:
> On Mon, Nov 07, 2022 at 11:05:42PM +0800, Qi Zheng wrote:
>>
>>
>> On 2022/11/7 20:42, Jason Gunthorpe wrote:
>>> On Mon, Nov 07, 2022 at 11:31:09AM +0800, Qi Zheng wrote:
>>>
>>>> @@ -31,9 +33,9 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
>>>>    		return false;
>>>>    	if (gfpflags & __GFP_NOWARN)
>>>> -		failslab.attr.no_warn = true;
>>>> +		flags |= FAULT_NOWARN;
>>>
>>> You should add a comment here about why this is required, to avoid
>>> deadlocking printk
>>
>> I think this comment should be placed where __GFP_NOWARN is specified
>> instead of here. What do you think? :)
> 
> NOWARN is clear what it does, it is this specifically that is very
> subtle about avoiding deadlock aginst allocations triggered by
> printk/etc code.

Oh, maybe I understand your concern. Some people may think that this
is just a print of fault injection information, not a warning. I'll
add a comment explaining why in some cases there must be no printing.

Thanks,
Qi

> 
> Jason

-- 
Thanks,
Qi
