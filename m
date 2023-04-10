Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2456DC864
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDJPXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDJPXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:23:40 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29474ED3;
        Mon, 10 Apr 2023 08:23:39 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q15-20020a17090a2dcf00b0023efab0e3bfso7678621pjm.3;
        Mon, 10 Apr 2023 08:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681140219;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAAiwiCB/IlxZ+tW1NN/jAR3nnAR8DHWWAB+OfEwJvg=;
        b=cn89rkUSvkBY31gPcK0r5LJ4lI1IntvjKgLNJrWjW3NrJEYqnRJpRqjjHNivrSHdNR
         1rZxnELiSfFupOW/KUrbHI8OJOHs+IPhW/bCnV5M7uTD3JysegGmLsSu86AdTjnYN3ZO
         Dxr/dTtNsaEprPkNGyAWEYuQW//lXNyQwuBeNfXp62c8EL3LiExAXW03Nmp1t5oMpMxe
         tiezxkNK/RK5+L+GfXw6Dd9T+7fTzGD+ETVND+9G74kfWIRba4R2It0AGh1dPyhNbij7
         YKhQItjAWnuJLGyv6D4fZ88X8x5Y37Yc31qPqxptXOY81Qky+Gn3IA07XECppV2l2RGD
         0+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681140219;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gAAiwiCB/IlxZ+tW1NN/jAR3nnAR8DHWWAB+OfEwJvg=;
        b=hI51jj3Jp0jBhgvXO1wzq43b45U5NMPtcKUbna/ynsXK74RRDNw25CvZNEZ3IsXFtI
         t2uEf5TFuLvOxhiyOHN2cii7l2pQZ5Vi73DZ/6PggNavcys18Al+0F5P5hiMnyIHwUcv
         CSIsjcaJnIiMoVZI8EUpM7pgx2vLE3GqC952ncQgirdwTuY/HfPGdOPxizdRXKDwKinX
         3Jd5qAmU8I8omT21sYpQfSpI5KNHzTh7L7DPllTylIN5ZWHhCaOwYs02afsEVmH+0qha
         KxeSXhm+GHg9CUOC2tmqQ5fX5z/HwqwrXKPKlbm3VKz5odjPYjWGbeZcu/EfxfADOVfM
         duIQ==
X-Gm-Message-State: AAQBX9fjzKlwJC1wxiug4dtS6wRyx+Jf4LnjHVBvSW0V1sz0EGrRf6nL
        4hA8RfGoZV6wh6nNb7S/zeE=
X-Google-Smtp-Source: AKy350ZeXaTDh0K7PEBWGBjrhAE6TpuqOt7vs7YwXQMRhRZKwopQRczZw7AEZXwUNqx5n6jU5Kkc4w==
X-Received: by 2002:a17:90a:840a:b0:23f:7176:df32 with SMTP id j10-20020a17090a840a00b0023f7176df32mr13169233pjn.40.1681140219268;
        Mon, 10 Apr 2023 08:23:39 -0700 (PDT)
Received: from [10.200.10.217] ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090a318700b002468e374d28sm3109841pjb.7.2023.04.10.08.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 08:23:38 -0700 (PDT)
Message-ID: <16b7b4e1-f6aa-5ee4-a70f-9c07febaee89@gmail.com>
Date:   Mon, 10 Apr 2023 23:23:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 2/2] maple_tree: Fix a potential memory leak, OOB access,
 or other unpredictable bug
To:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        stable@vger.kernel.org
References: <20230407040718.99064-1-zhangpeng.00@bytedance.com>
 <20230407040718.99064-2-zhangpeng.00@bytedance.com>
 <20230410124331.kijufkik2qlxoxjz@revolver>
 <84c50299-5b5b-867e-1e96-2d3a0c6ade2a@gmail.com>
 <20230410131258.txkiqa5eudgsrmht@revolver>
 <c9a5bcce-7e1b-81cd-b85f-0e9128024d6b@gmail.com>
 <20230410150054.nfmrlqfjdgqvehcn@revolver>
From:   Peng Zhang <perlyzhang@gmail.com>
In-Reply-To: <20230410150054.nfmrlqfjdgqvehcn@revolver>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2023/4/10 23:00, Liam R. Howlett 写道:
> * Peng Zhang <perlyzhang@gmail.com> [230410 09:28]:
>> 在 2023/4/10 21:12, Liam R. Howlett 写道:
>>> * Peng Zhang <perlyzhang@gmail.com> [230410 08:58]:
>>>> 在 2023/4/10 20:43, Liam R. Howlett 写道:
>>>>> * Peng Zhang <zhangpeng.00@bytedance.com> [230407 00:10]:
>>>>>> In mas_alloc_nodes(), there is such a piece of code:
>>>>>> while (requested) {
>>>>>> 	...
>>>>>> 	node->node_count = 0;
>>>>>> 	...
>>>>>> }
>>>>> You don't need to quote code in your commit message since it is
>>>>> available in the change log or in the file itself.
>>>> Ok, I will change it in the next version.
>>>>>> "node->node_count = 0" means to initialize the node_count field of the
>>>>>> new node, but the node may not be a new node. It may be a node that
>>>>>> existed before and node_count has a value, setting it to 0 will cause a
>>>>>> memory leak. At this time, mas->alloc->total will be greater than the
>>>>>> actual number of nodes in the linked list, which may cause many other
>>>>>> errors. For example, out-of-bounds access in mas_pop_node(), and
>>>>>> mas_pop_node() may return addresses that should not be used.
>>>>>> Fix it by initializing node_count only for new nodes.
>>>>>>
>>>>>> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
>>>>>> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>> ---
>>>>>>     lib/maple_tree.c | 16 ++++------------
>>>>>>     1 file changed, 4 insertions(+), 12 deletions(-)
>>>>>>
>>>>>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>>>>>> index 65fd861b30e1..9e25b3215803 100644
>>>>>> --- a/lib/maple_tree.c
>>>>>> +++ b/lib/maple_tree.c
>>>>>> @@ -1249,26 +1249,18 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>>>>>>     	node = mas->alloc;
>>>>>>     	node->request_count = 0;
>>>>>>     	while (requested) {
>>>>>> -		max_req = MAPLE_ALLOC_SLOTS;
>>>>>> -		if (node->node_count) {
>>>>>> -			unsigned int offset = node->node_count;
>>>>>> -
>>>>>> -			slots = (void **)&node->slot[offset];
>>>>>> -			max_req -= offset;
>>>>>> -		} else {
>>>>>> -			slots = (void **)&node->slot;
>>>>>> -		}
>>>>>> -
>>>>>> +		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
>>>>>> +		slots = (void **)&node->slot[node->node_count];
>>>>> Thanks, this is much cleaner.
>>>>>
>>>>>>     		max_req = min(requested, max_req);
>>>>>>     		count = mt_alloc_bulk(gfp, max_req, slots);
>>>>>>     		if (!count)
>>>>>>     			goto nomem_bulk;
>>>>>> +		if (node->node_count == 0)
>>>>>> +			node->slot[0]->node_count = 0;
>>>>>>     		node->node_count += count;
>>>>>>     		allocated += count;
>>>>>>     		node = node->slot[0];
>>>>>> -		node->node_count = 0;
>>>>>> -		node->request_count = 0;
>>>>> Why are we not clearing request_count anymore?
>>>> Because the node pointed to by the variable "node"
>>>> must not be the head node of the linked list at
>>>> this time, we only need to maintain the information
>>>> of the head node.
>>> Right, at this time it is not the head node, but could it become the
>>> head node with invalid data?  I think it can, because we don't
>>> explicitly set it in mas_pop_node()?
>> 1. Actually in mas_pop_node(), when a node becomes the head node,
>>     we initialize its total field and request_count field.
> Only if there is a request_count to begin with, right?
>
>> 2. The total field and request_count field of any non-head node,
>>     even if we initialize it, cannot be considered a valid value.
>>     Imagine if the request_count of the head node is changed, then
>>     we don't actually change the request_count of the non-head nodes,
>>     so it is an invalid value anyway.
> When we pop a node, we record the requested value and only initialize it
> to the recorded value + 1 if it wasn't zero.  So if there are no
> requests, we don't initialize it.

Yes, you are right.
I neglected that if request_count is equal to 0,
the request_count field of the new head node will not be set.
There are many implementation details of maple_tree,
which is quite error-prone.
I will modify it in the next version.

Thanks.

>
> This works because of the zeroing of that request_count that you removed
> here.  But it was, as you pointed out, not always using the right node.
> I think this needs to be moved to your new 'if' statement.
>
>>> In any case, be sure to mention that you make a change like this in the
>>> change log, like "Drop setting the resquest_count as it is unnecessary
>>> because.." in a new paragraph, so that it is not missed.
>> I thought it was a small change that wasn't written in the changelog.
>> In the next version and any future patches, I will write down the
>> details of any changes.
>>
>> Thanks.
>>
>>>
>>>>>>     		requested -= count;
>>>>>>     	}
>>>>>>     	mas->alloc->total = allocated;
>>>>>> -- 
>>>>>> 2.20.1
>>>>>>
