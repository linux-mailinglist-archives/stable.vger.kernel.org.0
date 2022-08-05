Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21BD58AFB4
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbiHESZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240758AbiHESZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 14:25:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34C3427172
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659723944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gbZS7QF09rE8ScpjrsJlHIn7pEqxX+BCCZXbzG+bY8=;
        b=alNUN1cL/CYaBOD0DfgtZuUVWm+WVHflso/o90Ogpx0GJj4QYwwEqL5me2V5yVr1Yx/teu
        xOm2N1Q7TqPf6p3uf3B1IdHtXHS+L0InRkWIwC0uoxNrFQLRpsW9zNqY4KSvDpEVFla+J1
        r2D0GDa16qSx4gWuQI8vsywtaH9OrWY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-2LSkcPlxOGqNci64df0GBQ-1; Fri, 05 Aug 2022 14:25:40 -0400
X-MC-Unique: 2LSkcPlxOGqNci64df0GBQ-1
Received: by mail-wr1-f71.google.com with SMTP id j20-20020adfb314000000b00220d9957623so658202wrd.0
        for <stable@vger.kernel.org>; Fri, 05 Aug 2022 11:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=5gbZS7QF09rE8ScpjrsJlHIn7pEqxX+BCCZXbzG+bY8=;
        b=yVJWe/ELXEU2aiPMsbf6d2KOBN32RDOf13DMzgXcro9raOnI9u7tZ+XU6nDluKJu6F
         XnTJyPp9fHGk+EUy38mkVKMockvH/pf3QqrWEMuo0TQvnj0i758eHBEY+sn7Ee3eSwig
         LnSN1wU7oXYWq2u7Bsh0c1R/d4kerDUbXtQ8hVOOb+48wTn8BBbRblESSBtmYWRuur7o
         GzPWgD3a63dF6jQTSz/2C7zhSOOrZ2UtzsNFaL+MLVB832/t3xteRmN6YzT1FyWKfG3l
         lFott4UVvZ1tEhp/xrw+/s1lle1oBerOYQXCszi7cz3LtgBp/Ww6X3YG8NlJxh3OulwK
         xA2A==
X-Gm-Message-State: ACgBeo2jH3Lqi/SkJ29PvQxTZnDUmzMHYedoYjjoMLs5iOJAwwBNxUkT
        HE8eIo9sahriEMX4PsnORrwX6ndBsS8AUGW6VAzLsRhSg8GrnHbyltjAkSvONAz8ye9eG0kkP6y
        RVotbTnDoOwtpCV5x
X-Received: by 2002:a5d:595f:0:b0:220:619d:da07 with SMTP id e31-20020a5d595f000000b00220619dda07mr5039736wri.10.1659723939388;
        Fri, 05 Aug 2022 11:25:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7LHyYXq3T7uBDEmcodrtgkrkt4qPFOx+H0sFCOo3qbsgD8PcEUXT31a6r/ZIVw1aJCZtgxIQ==
X-Received: by 2002:a5d:595f:0:b0:220:619d:da07 with SMTP id e31-20020a5d595f000000b00220619dda07mr5039725wri.10.1659723939149;
        Fri, 05 Aug 2022 11:25:39 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:fb00:f5c3:24b2:3d03:9d52? (p200300cbc706fb00f5c324b23d039d52.dip0.t-ipconnect.de. [2003:cb:c706:fb00:f5c3:24b2:3d03:9d52])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d58e5000000b0021eed2414c9sm4409875wrd.40.2022.08.05.11.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 11:25:38 -0700 (PDT)
Message-ID: <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
Date:   Fri, 5 Aug 2022 20:25:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com> <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yu1gHnpKRZBhSTZB@monkey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.08.22 20:23, Mike Kravetz wrote:
> On 08/05/22 14:14, Peter Xu wrote:
>> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>> index 61e6135c54ef..462a6b0344ac 100644
>>> --- a/mm/mmap.c
>>> +++ b/mm/mmap.c
>>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>>>  		return 0;
>>>  
>>> +	/*
>>> +	 * Hugetlb does not require/support writenotify; especially, it does not
>>> +	 * support softdirty tracking.
>>> +	 */
>>> +	if (is_vm_hugetlb_page(vma))
>>> +		return 0;
>>
>> I'm kind of confused here..  you seems to be fixing up soft-dirty for
>> hugetlb but here it's explicitly forbidden.
>>
>> Could you explain a bit more on why this patch is needed if (assume
>> there'll be a working) patch 2 being provided?
>>
> 
> No comments on the patch, but ...
> 
> Since it required little thought, I ran the test program on next-20220802 and
> was surprised that the issue did not recreate.  Even added a simple printk
> to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
> We were.


... does your config have CONFIG_MEM_SOFT_DIRTY enabled?


-- 
Thanks,

David / dhildenb

