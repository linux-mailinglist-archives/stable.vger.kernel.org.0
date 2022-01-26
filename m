Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E534549D026
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 17:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiAZQ6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 11:58:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236816AbiAZQ6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 11:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643216325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwK+6dlb+joz6FreBSpGR4qwGRjjJX0iS2ErICzu918=;
        b=feaNRKpDopc8OlXZCiyCY/Pla2tQIeEktvHvfWABJ4fYVF2KIFuxN4zAoqgCHknVCSjBF3
        sTPaUebYFEHB4it/HQ16T1cEqm0gH63T6yD23I2BJdirB3ZFPYafSKQUJoglDrCNnQDquN
        9AaIJcIOFO2yy8wO5ZmF11XRTjQjHSU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-ZnfDWXS0MWmPFikaopiv1A-1; Wed, 26 Jan 2022 11:58:43 -0500
X-MC-Unique: ZnfDWXS0MWmPFikaopiv1A-1
Received: by mail-wr1-f71.google.com with SMTP id r27-20020adfb1db000000b001d7567e33baso21499wra.12
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 08:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=iwK+6dlb+joz6FreBSpGR4qwGRjjJX0iS2ErICzu918=;
        b=NZxTi52NlbHEwdoIW4RORMHnlrsoN8Ze24N09uysKW2+IZ77cjfKRZDicMgY5UyD7s
         SRs4kOOsT79l6iJel88NqvJ3oMNcqAflfOtQTvuPOMYVOrFJH/5BUKEDEPHJ2LjZVvZj
         RBUijVvVU62VNJyRJpfYDV/WZqhKTLDO/pGYMkMyfQZiiANmjmgHHlxGCyl+WQ9fqcuH
         EjiODm9qmejuIdYIZziqQ+WiPvq3gFB01G1VPqUZsQMAS67GW9IVELJCt8JI+AccFzuC
         z4lQzPftu78VbdOrn9ni+R2z/OYrtLl6YWhgtaHg4FfIcW0m6Qw7Uq9ZqJyRw8+0vxR1
         dHNQ==
X-Gm-Message-State: AOAM5337HUcMnNsnx09VkOuOR504awKsHq9K+Zsn2k7FYhR3qiRmxvkS
        S+RDZRZbxBNzBj/iMaRZzlXWV9mq4NwvVcJ5yTKTOAuEtHWVV5H14eaCaz3BDWgKH803N7PFL2/
        5yPyUyeyOlHvfZ7IQ
X-Received: by 2002:adf:e48c:: with SMTP id i12mr22533544wrm.43.1643216322628;
        Wed, 26 Jan 2022 08:58:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzE5Cse7NdwemLeauGToLxmGqUbxzhBHAuDgDEL3m6H11ecldT3oNelWmLpcvXYbUmZZoLrQ==
X-Received: by 2002:adf:e48c:: with SMTP id i12mr22533533wrm.43.1643216322381;
        Wed, 26 Jan 2022 08:58:42 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:2700:cdd8:dcb0:2a69:8783? (p200300cbc7092700cdd8dcb02a698783.dip0.t-ipconnect.de. [2003:cb:c709:2700:cdd8:dcb0:2a69:8783])
        by smtp.gmail.com with ESMTPSA id a9sm4002911wmm.32.2022.01.26.08.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 08:58:41 -0800 (PST)
Message-ID: <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com>
Date:   Wed, 26 Jan 2022 17:58:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
Content-Language: en-US
To:     Yang Shi <shy828301@gmail.com>
Cc:     Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20220120202805.3369-1-shy828301@gmail.com>
 <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com>
 <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
 <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com>
 <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.01.22 17:53, Yang Shi wrote:
> On Wed, Jan 26, 2022 at 3:57 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 26.01.22 12:48, Jann Horn wrote:
>>> On Wed, Jan 26, 2022 at 12:38 PM David Hildenbrand <david@redhat.com> wrote:
>>>> On 26.01.22 12:29, Jann Horn wrote:
>>>>> On Wed, Jan 26, 2022 at 11:51 AM David Hildenbrand <david@redhat.com> wrote:
>>>>>> On 20.01.22 21:28, Yang Shi wrote:
>>>>>>> The syzbot reported the below BUG:
>>>>>>>
>>>>>>> kernel BUG at include/linux/page-flags.h:785!
>>> [...]
>>>>>>> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
>>>>>>> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
>>> [...]
>>>>>> Does this point at the bigger issue that reading the mapcount without
>>>>>> having the page locked is completely unstable?
>>>>>
>>>>> (See also https://lore.kernel.org/all/CAG48ez0M=iwJu=Q8yUQHD-+eZDg6ZF8QCF86Sb=CN1petP=Y0Q@mail.gmail.com/
>>>>> for context.)
>>>>
>>>> Thanks for the pointer.
>>>>
>>>>>
>>>>> I'm not sure what you mean by "unstable". Do you mean "the result is
>>>>> not guaranteed to still be valid when the call returns", "the result
>>>>> might not have ever been valid", or "the call might crash because the
>>>>> page's state as a compound page is unstable"?
>>>>
>>>> A little bit of everything :)
>>> [...]
>>>>> In case you mean "the result might not have ever been valid":
>>>>> Yes, even with this patch applied, in theory concurrent THP splits
>>>>> could cause us to count some page mappings twice. Arguably that's not
>>>>> entirely correct.
>>>>
>>>> Yes, the snapshot is not atomic and, thereby, unreliable. That what I
>>>> mostly meant as "unstable".
>>>>
>>>>>
>>>>> In case you mean "the call might crash because the page's state as a
>>>>> compound page could concurrently change":
>>>>
>>>> I think that's just a side-product of the snapshot not being "correct",
>>>> right?
>>>
>>> I guess you could see it that way? The way I look at it is that
>>> page_mapcount() is designed to return a number that's at least as high
>>> as the number of mappings (rarely higher due to races), and using
>>> page_mapcount() on an unlocked page is legitimate if you're fine with
>>> the rare double-counting of references. In my view, the problem here
>>> is:
>>>
>>> There are different types of references to "struct page" - some of
>>> them allow you to call page_mapcount(), some don't. And in particular,
>>> get_page() doesn't give you a reference that can be used with
>>> page_mapcount(), but locking a (real, non-migration) PTE pointing to
>>> the page does give you such a reference.
>>
>> I assume the point is that as long as the page cannot be unmapped
>> because you block it from getting unmapped (PT lock), the compound page
>> cannot get split. As long as the page cannot get unmapped from that page
>> table you should have at least a mapcount of 1.
> 
> If you mean holding ptl could prevent THP from splitting, then it is
> not true since you may be in the middle of THP split just exactly like
> the race condition solved by this patch.

While you hold the PT lock and discover a mapped page, unmap_page()
cannot continue and unmap the page. That's what I meant "as long as the
page cannot be unmapped".

What doesn't work is if you hold the PT lock and discover a migration
entry, because then you're already past unmap_page(). That's the issue
you're fixing.

> 
> Just page lock or elevated page refcount could serialize against THP
> split AFAIK.
> 
>>
>> But yeah, using the mapcount of a page that is not even mapped
>> (migration entry) is clearly wrong.
>>
>> To summarize: reading the mapcount on an unlocked page will easily
>> return a wrong result and the result should not be relied upon. reading
>> the mapcount of a migration entry is dangerous and certainly wrong.
> 
> Depends on your usecase. Some just want to get a snapshot, just like
> smaps, they don't care.

Right, but as discussed, even the snapshot might be slightly wrong. That
might be just fine for smaps (and I would have enjoyed a comment in the
code stating that :) ).


-- 
Thanks,

David / dhildenb

