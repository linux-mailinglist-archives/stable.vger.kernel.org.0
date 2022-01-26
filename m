Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3949C92A
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiAZL52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:57:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233931AbiAZL50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643198246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w6RnHqBRXKKY9foSrt7oGpZU3YcqPco8hnhwfG4iwHA=;
        b=i4G4WZ0tirLMAHvFJriEFdW6HM+JgVi0y//VVEaYaDrCO3UfeZ0NbkT1BKGn5voFL0j5UA
        lcv9VIEGcApAKREO4KhqQub4zjO8RWavIparQcd6EOXjHh5xE1AZ+RHoiAXvNwobgq1XlR
        Ss+ggWc4Ev+4cQoZOpvYFOul5n5zPlg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-omcrOVkPP5OwIzEhlik6cg-1; Wed, 26 Jan 2022 06:57:25 -0500
X-MC-Unique: omcrOVkPP5OwIzEhlik6cg-1
Received: by mail-wm1-f69.google.com with SMTP id bg32-20020a05600c3ca000b00349f2aca1beso3161460wmb.9
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:57:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=w6RnHqBRXKKY9foSrt7oGpZU3YcqPco8hnhwfG4iwHA=;
        b=dY+n7tkqBBJDhxSzvx68gdyZm0omO43NyV8aCpMAYSUV7vVi+Jgboxl4Vi0zVfga+b
         Ambc6BT+vOvqyVYGjtJtjwol1lBl0Wfe8fRtHx3i68Ic1OgmQVHHcW8wKFSb8/oGhXqF
         dAPtywzwh29wus3QU8D7ZO01TJan2hmC41cgZn5ElmpboBbU/+AAXUeY+s2JvO6Lw97/
         XGIQW+85J4xYRNgzN2Oe9Y5vH7Y8ierX2UMI2ILYcLWWcWIJ2ZcAELgcZUAN9XsyO3cA
         htm1zk53txWwKeEopWld6U28iHybPZRcoLMQT+CmAaGzc/CWc6+50ZiWK8vXMIQbtVu0
         1xtw==
X-Gm-Message-State: AOAM533gdX01QpqmtdRvCTPDj+zv5QdX5xhT0FtLH6kk+L86EIrjK2YR
        dXh15WTePONR9Uhl/wzOt4GlEapbj7SfQSZCiha/DB5jZibdZJtZ3c19wQTTWhW5RmF91wkiaEN
        9hVvI6JR5+E6hGJnr
X-Received: by 2002:a1c:4d1a:: with SMTP id o26mr6951710wmh.147.1643198243813;
        Wed, 26 Jan 2022 03:57:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFqWDLyjsg3RrLRRoSoX6kG2G3W4KJXWCYT79Oj2x6eCRVWsW/D6F8N8lsymC4hoPPnF9nLw==
X-Received: by 2002:a1c:4d1a:: with SMTP id o26mr6951692wmh.147.1643198243564;
        Wed, 26 Jan 2022 03:57:23 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:2700:cdd8:dcb0:2a69:8783? (p200300cbc7092700cdd8dcb02a698783.dip0.t-ipconnect.de. [2003:cb:c709:2700:cdd8:dcb0:2a69:8783])
        by smtp.gmail.com with ESMTPSA id g7sm3923134wmq.28.2022.01.26.03.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 03:57:23 -0800 (PST)
Message-ID: <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com>
Date:   Wed, 26 Jan 2022 12:57:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Jann Horn <jannh@google.com>
Cc:     Yang Shi <shy828301@gmail.com>, kirill.shutemov@linux.intel.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220120202805.3369-1-shy828301@gmail.com>
 <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com>
 <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
In-Reply-To: <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.01.22 12:48, Jann Horn wrote:
> On Wed, Jan 26, 2022 at 12:38 PM David Hildenbrand <david@redhat.com> wrote:
>> On 26.01.22 12:29, Jann Horn wrote:
>>> On Wed, Jan 26, 2022 at 11:51 AM David Hildenbrand <david@redhat.com> wrote:
>>>> On 20.01.22 21:28, Yang Shi wrote:
>>>>> The syzbot reported the below BUG:
>>>>>
>>>>> kernel BUG at include/linux/page-flags.h:785!
> [...]
>>>>> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
>>>>> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> [...]
>>>> Does this point at the bigger issue that reading the mapcount without
>>>> having the page locked is completely unstable?
>>>
>>> (See also https://lore.kernel.org/all/CAG48ez0M=iwJu=Q8yUQHD-+eZDg6ZF8QCF86Sb=CN1petP=Y0Q@mail.gmail.com/
>>> for context.)
>>
>> Thanks for the pointer.
>>
>>>
>>> I'm not sure what you mean by "unstable". Do you mean "the result is
>>> not guaranteed to still be valid when the call returns", "the result
>>> might not have ever been valid", or "the call might crash because the
>>> page's state as a compound page is unstable"?
>>
>> A little bit of everything :)
> [...]
>>> In case you mean "the result might not have ever been valid":
>>> Yes, even with this patch applied, in theory concurrent THP splits
>>> could cause us to count some page mappings twice. Arguably that's not
>>> entirely correct.
>>
>> Yes, the snapshot is not atomic and, thereby, unreliable. That what I
>> mostly meant as "unstable".
>>
>>>
>>> In case you mean "the call might crash because the page's state as a
>>> compound page could concurrently change":
>>
>> I think that's just a side-product of the snapshot not being "correct",
>> right?
> 
> I guess you could see it that way? The way I look at it is that
> page_mapcount() is designed to return a number that's at least as high
> as the number of mappings (rarely higher due to races), and using
> page_mapcount() on an unlocked page is legitimate if you're fine with
> the rare double-counting of references. In my view, the problem here
> is:
> 
> There are different types of references to "struct page" - some of
> them allow you to call page_mapcount(), some don't. And in particular,
> get_page() doesn't give you a reference that can be used with
> page_mapcount(), but locking a (real, non-migration) PTE pointing to
> the page does give you such a reference.

I assume the point is that as long as the page cannot be unmapped
because you block it from getting unmapped (PT lock), the compound page
cannot get split. As long as the page cannot get unmapped from that page
table you should have at least a mapcount of 1.

But yeah, using the mapcount of a page that is not even mapped
(migration entry) is clearly wrong.

To summarize: reading the mapcount on an unlocked page will easily
return a wrong result and the result should not be relied upon. reading
the mapcount of a migration entry is dangerous and certainly wrong.

-- 
Thanks,

David / dhildenb

