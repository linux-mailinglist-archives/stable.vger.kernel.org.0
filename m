Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FAA49D217
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbiAZSzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:55:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244293AbiAZSzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643223298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhj664AgQt2KQtf7ayYCvSA5RqB+++2Rhwj5UZ7qWsg=;
        b=LbNbY/etdVE3pfl8mWPsWcOfqdoDZG4mMmE98xHVXkE6JDNpKLE5o6XtbH1DbW9G4O4Onc
        ygtHC88Y7ttVyhSUlejI7i+XrBfWoVFy2wgSqJe0iA6vmj+NVzmW+BB4+FsOV3fskr1/we
        BfA9N+tlcokxoSagUHe7Z42WX5YMMx4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-z0oVoXrzNmyvKJ7F3UqpJg-1; Wed, 26 Jan 2022 13:54:57 -0500
X-MC-Unique: z0oVoXrzNmyvKJ7F3UqpJg-1
Received: by mail-ed1-f71.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so170290eds.7
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 10:54:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=hhj664AgQt2KQtf7ayYCvSA5RqB+++2Rhwj5UZ7qWsg=;
        b=d9DcLqb079JoAujwF56RMOxu5rk5XFmlOFjcoOPj0oOc+QQTKbGde3jVdwfkrmJhVZ
         tAoXrQ/5em/q3z1WBZTc25WaAWNXD1YztTUoL+tDOCxyuifrN/JMpsvsk2tatWHYAxq9
         hohaS4YH9LLBWIWGBTBst9hNHPpjkuMfjXrRHF3LLPs4VzmDSdqL94xKjIdgR0WN73B2
         yb1U7KCwjltfdMaSdMwO5B5aj8qkhcuWkIhsDuD60RA1jSO5COZK5B0eOrD6JYU1dcgv
         tgNHwou4rETFtmakOXQDdu405ut6ReIJvdKM/LXFE0d3gFvXnmX8REKfoqD08/oX27ym
         9XEQ==
X-Gm-Message-State: AOAM532Rar8oVmiEi0F5oUcVbL82slg6KoHr/CTFYLuNX7OjGCdaodMh
        s4G1MKiWD8aWsUlr+P0NUYIeq+f6FE/PNGzjDhb8YUud4DZb1r5KDUPZShPm/fWIn/PljICDjC3
        hb2lLevoZMNe+HisE
X-Received: by 2002:a50:9fc6:: with SMTP id c64mr373299edf.5.1643223295980;
        Wed, 26 Jan 2022 10:54:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNVlUS4gG6iKHrXL4vEtlyLwR50PsiO1uMeg6vr7kFp887V1xsTCa2ukZkyA57E8IaC8YFEQ==
X-Received: by 2002:a50:9fc6:: with SMTP id c64mr373279edf.5.1643223295724;
        Wed, 26 Jan 2022 10:54:55 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:2700:cdd8:dcb0:2a69:8783? (p200300cbc7092700cdd8dcb02a698783.dip0.t-ipconnect.de. [2003:cb:c709:2700:cdd8:dcb0:2a69:8783])
        by smtp.gmail.com with ESMTPSA id h3sm10210165edq.83.2022.01.26.10.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 10:54:55 -0800 (PST)
Message-ID: <2a1c5bd2-cb8c-b93b-68af-de620438d19a@redhat.com>
Date:   Wed, 26 Jan 2022 19:54:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
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
 <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com>
 <CAHbLzkqXy-W9sD5HFOK_rm_TR8uSP29b+RjKjA5zOZ+0dkqMbQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
In-Reply-To: <CAHbLzkqXy-W9sD5HFOK_rm_TR8uSP29b+RjKjA5zOZ+0dkqMbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>> Just page lock or elevated page refcount could serialize against THP
>>> split AFAIK.
>>>
>>>>
>>>> But yeah, using the mapcount of a page that is not even mapped
>>>> (migration entry) is clearly wrong.
>>>>
>>>> To summarize: reading the mapcount on an unlocked page will easily
>>>> return a wrong result and the result should not be relied upon. reading
>>>> the mapcount of a migration entry is dangerous and certainly wrong.
>>>
>>> Depends on your usecase. Some just want to get a snapshot, just like
>>> smaps, they don't care.
>>
>> Right, but as discussed, even the snapshot might be slightly wrong. That
>> might be just fine for smaps (and I would have enjoyed a comment in the
>> code stating that :) ).
> 
> I think that is documented already, see Documentation/filesystems/proc.rst:
> 
> Note: reading /proc/PID/maps or /proc/PID/smaps is inherently racy (consistent
> output can be achieved only in the single read call).

Right, but I think there is a difference between

* Atomic values that change immediately afterwards ("this value used to
  be true at one point in time")
* Values that are unstable because we cannot read them atomically ("this
  value never used to be true")

I'd assume with the documented race we actually talk about the first
point, but I might be just wrong.

> 
> Of course, if the extra note is preferred in the code, I could try to
> add some in a separate patch.

When staring at the (original) code I would have hoped to find something
like:

/*
 * We use page_mapcount() to get a snapshot of the mapcount. Without
 * holding the page lock this snapshot can be slightly wrong as we
 * cannot always read the mapcount atomically. As long we hold the PT
 * lock, the page cannot get unmapped and it's at safe to call
 * page_mapcount().
 */

With the addition of

"... For unmapped pages (e.g., migration entries) we cannot guarantee
that, so treat the mapcount as being 1."

But this is just my personal preference ... :) I do think the patch does
the right thing in regard to migration entries.

-- 
Thanks,

David / dhildenb

