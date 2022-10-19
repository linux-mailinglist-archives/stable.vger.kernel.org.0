Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72696604EF9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 19:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJSRi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 13:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJSRiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 13:38:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162AE1D5873
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 10:37:44 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h13so17901307pfr.7
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 10:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QUeR0xJtQiT2FtLI52jrQbxV3zmFpDGxTjYeu2DOx8=;
        b=V/ZniAWglCRNerUtlTJMs4j1SfPZ1ajarI4h/dNAxQyEK2N36B2teXn8PZxt9kvn1f
         Xif8oSa5gYEVDVvg0XegTof5CeCWNSF62xVS+QfPKCSUslCcknu9BwKqRLjTVJYzQ+G/
         XbiXwKu14DCQBdyaY/YaWAK8KtZLc8RKq3Vt5aaTuLeHoMmPjRUnlUF2nqgNCCtM2uM+
         8noapyxj98cscd5ee2Cj6rYlT7SGJtOgYveyoELRYZq3FvNKBM/zAb2fHZea+pLml8sm
         3Yg/zWKcNMEnuBznDhTYhJqvapfUgOUMeK0ldzMaKpVYcPV3tAQcYjf9WdI2ATnszIgn
         SIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9QUeR0xJtQiT2FtLI52jrQbxV3zmFpDGxTjYeu2DOx8=;
        b=Rd8zFbAgxdYSfwTE9gX7IKLJ4MoaqtE/vEFDveLaM5+OWKeWL7+V1sG2zh/Ah7EM1i
         OwUUKxOg5F5oCnKPkAnkxACa35/lNVNAoyWekfKepUK+zDSiFkkqds4P/Wb69NOfjzHv
         UuliJbyMGE3Vc77jVNdDVAwKDEgJY9gFfxXWyo8/wav/S8tY5iJA3Ywq2jTIltcCJLkM
         0DWkq8JDii7r3ovM1ZZOG1lfdgPG+ucu27oqj/eAX8Wu0md+LqR6pPuQDavJq2l/n+k9
         +3vybOXytNUWfEx8fS9WT95SBBdO1ynRF5o7e5hjzdbvBymVDMSC0uztrKz6bwFNhM8O
         wn/A==
X-Gm-Message-State: ACrzQf0n8givfBZWl6NZtWi7xU3eLpukDB51fk7nITsNINXn243rqfIZ
        tDJMfzys5kwbO7U5Wd3Q4FjHJw==
X-Google-Smtp-Source: AMsMyM5G9dWv3EDnjrumdtvOc+yfH44DpoJFGQZ7mToz8a7AoyBb2s/kStIZ8q4RsGltAzv72jsCvA==
X-Received: by 2002:a65:6c08:0:b0:448:c216:fe9 with SMTP id y8-20020a656c08000000b00448c2160fe9mr7980809pgu.243.1666201055365;
        Wed, 19 Oct 2022 10:37:35 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id a188-20020a624dc5000000b005629d8a3204sm11892309pfb.99.2022.10.19.10.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 10:37:34 -0700 (PDT)
Message-ID: <fe5a50a8-25b8-91b2-3a84-e68efa1905bb@kernel.dk>
Date:   Wed, 19 Oct 2022 10:37:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 6.0 479/862] sbitmap: fix possible io hung due to lost
 wakeup
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083311.114449669@linuxfoundation.org>
 <174a196-5473-4e93-a52a-5e26eb37949@google.com> <Y1AzCuwWxEPoYGRr@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y1AzCuwWxEPoYGRr@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 10:25 AM, Greg Kroah-Hartman wrote:
> On Wed, Oct 19, 2022 at 08:06:26AM -0700, Hugh Dickins wrote:
>> On Wed, 19 Oct 2022, Greg Kroah-Hartman wrote:
>>
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> [ Upstream commit 040b83fcecfb86f3225d3a5de7fd9b3fbccf83b4 ]
>>>
>>> There are two problems can lead to lost wakeup:
>>>
>>> 1) invalid wakeup on the wrong waitqueue:
>>>
>>> For example, 2 * wake_batch tags are put, while only wake_batch threads
>>> are woken:
>>>
>>> __sbq_wake_up
>>>  atomic_cmpxchg -> reset wait_cnt
>>> 			__sbq_wake_up -> decrease wait_cnt
>>> 			...
>>> 			__sbq_wake_up -> wait_cnt is decreased to 0 again
>>> 			 atomic_cmpxchg
>>> 			 sbq_index_atomic_inc -> increase wake_index
>>> 			 wake_up_nr -> wake up and waitqueue might be empty
>>>  sbq_index_atomic_inc -> increase again, one waitqueue is skipped
>>>  wake_up_nr -> invalid wake up because old wakequeue might be empty
>>>
>>> To fix the problem, increasing 'wake_index' before resetting 'wait_cnt'.
>>>
>>> 2) 'wait_cnt' can be decreased while waitqueue is empty
>>>
>>> As pointed out by Jan Kara, following race is possible:
>>>
>>> CPU1				CPU2
>>> __sbq_wake_up			 __sbq_wake_up
>>>  sbq_wake_ptr()			 sbq_wake_ptr() -> the same
>>>  wait_cnt = atomic_dec_return()
>>>  /* decreased to 0 */
>>>  sbq_index_atomic_inc()
>>>  /* move to next waitqueue */
>>>  atomic_set()
>>>  /* reset wait_cnt */
>>>  wake_up_nr()
>>>  /* wake up on the old waitqueue */
>>> 				 wait_cnt = atomic_dec_return()
>>> 				 /*
>>> 				  * decrease wait_cnt in the old
>>> 				  * waitqueue, while it can be
>>> 				  * empty.
>>> 				  */
>>>
>>> Fix the problem by waking up before updating 'wake_index' and
>>> 'wait_cnt'.
>>>
>>> With this patch, noted that 'wait_cnt' is still decreased in the old
>>> empty waitqueue, however, the wakeup is redirected to a active waitqueue,
>>> and the extra decrement on the old empty waitqueue is not handled.
>>>
>>> Fixes: 88459642cba4 ("blk-mq: abstract tag allocation out into sbitmap library")
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>> Link: https://lore.kernel.org/r/20220803121504.212071-1-yukuai1@huaweicloud.com
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> I have no authority on linux-block, but I'll say NAK to this one
>> (and 517/862), and let Jens and Jan overrule me if they disagree.
>>
>> This was the first of several 6.1-rc1 commits which had given me lost
>> wakeups never suffered before; was not tagged Cc stable; and (unless I've
>> missed it on lore) never had AUTOSEL posted to linux-block or linux-kernel.
> 
> Ok, thanks for the review.  I'll drop both of the sbitmap.c changes and
> if people report issues and want them back, I'll be glad to revisit them
> then.

Sorry for being late, did see Hugh respond to the original auto-select
as well, and was surprised to see it moving forward after that. Let's
please drop them for now.

-- 
Jens Axboe


