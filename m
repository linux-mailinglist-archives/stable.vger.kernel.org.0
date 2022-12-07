Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F64646225
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 21:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLGUMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 15:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLGULu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 15:11:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3DB7B4D5
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 12:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670443852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=baWxWbCInGY7stkmdks81E7dLCHRp7Y+jb4EX+IK+hM=;
        b=TkcoF5FM4GICGWoO2dNK5uYUBFAN1Ge2fFeIN3AjFTtpaNhcnA7647KcfMSkwiqjxbCyFY
        Vti4kIjVAajub3lcpQw6rkH1x62Y9cgcDN8L3IIhoJSJ8m6nvTmI030EAqsuIBkh6/AI5f
        TrNEo0p5wCGjvJa4xh85uXOn72tPWtA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-48-FOkkf6QBMi6U9Y7KKrBcNQ-1; Wed, 07 Dec 2022 15:10:44 -0500
X-MC-Unique: FOkkf6QBMi6U9Y7KKrBcNQ-1
Received: by mail-wm1-f72.google.com with SMTP id r67-20020a1c4446000000b003d09b0fbf54so1258384wma.3
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 12:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=baWxWbCInGY7stkmdks81E7dLCHRp7Y+jb4EX+IK+hM=;
        b=UsnjiMAAw47Vj1uX/MoAnCg7JySdZk18oZRMcM9SEmDx08Reqi3uHWoVO7aRZkMmxt
         WrD97drmwTEi2OYzl5jHTklZrmaBQhtLwCEQQsi4vXgMDqgKy+WTgZe7LqYizhYWQHSj
         L14QHi3K/Ko+/4DXEFS0ZOPcSlbP6ONz+mdNlmbKwirCirpiGwy4x/HSlrfdTESVxv7/
         HzX1fe7rJSEwWxXwUh/LTJOaUIvP1t9qDJawC+ATUoP/xvX21XOpxKd7Us92l9j8w40l
         tSiwE2A+Lm0A+8nvJNeXEvuakaC/g66BxTPsLq5YbMFGbzGJghMHOzo4HZX3kVjl9gqL
         5YvA==
X-Gm-Message-State: ANoB5pkFWAnoE4GaOor1kFZndIvUBx6/9p9Of7CSDpBwE2D3lYAhPkkr
        fv7uQAMvzZ5iRVbtxEeCc/yUtV4XNQpkLYaGc4g/GlcAzJim9dmzsOP3ddglsPqFGnWAV+F6oEq
        u0np8p8tf6cfZ2qPW
X-Received: by 2002:a05:600c:3542:b0:3cf:6c2f:950c with SMTP id i2-20020a05600c354200b003cf6c2f950cmr60500607wmq.146.1670443843089;
        Wed, 07 Dec 2022 12:10:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4zwrELXMIzIpNeWlphS4Moyt8c60RN3m7bVg8O7emdf3WdIK9ut84KFLcMr5WMA28nsglkiA==
X-Received: by 2002:a05:600c:3542:b0:3cf:6c2f:950c with SMTP id i2-20020a05600c354200b003cf6c2f950cmr60500590wmq.146.1670443842851;
        Wed, 07 Dec 2022 12:10:42 -0800 (PST)
Received: from ?IPV6:2003:cb:c702:2500:fe2d:7534:ffa4:c1e5? (p200300cbc7022500fe2d7534ffa4c1e5.dip0.t-ipconnect.de. [2003:cb:c702:2500:fe2d:7534:ffa4:c1e5])
        by smtp.gmail.com with ESMTPSA id q10-20020a05600c46ca00b003c70191f267sm2912613wmo.39.2022.12.07.12.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 12:10:42 -0800 (PST)
Message-ID: <53e52007-e556-332d-ec4d-5fe48a90e9b0@redhat.com>
Date:   Wed, 7 Dec 2022 21:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20221202122748.113774-1-david@redhat.com> <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
 <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com> <Y45duzmGGUT0+u8t@x1n>
 <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com> <Y4+zw4JU7JMlDHbM@x1n>
 <5a626d30-ccc9-6be3-29f7-78f83afbe5c4@redhat.com> <Y5C4Zu9sDvZ7KiCk@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
In-Reply-To: <Y5C4Zu9sDvZ7KiCk@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> For example, libvhost-user.c in QEMU uses for ordinary postcopy:
>>
>>          /*
>>           * In postcopy we're using PROT_NONE here to catch anyone
>>           * accessing it before we userfault.
>>           */
>>          mmap_addr = mmap(0, dev_region->size + dev_region->mmap_offset,
>>                           PROT_NONE, MAP_SHARED | MAP_NORESERVE,
>>                           vmsg->fds[0], 0);
> 
> I assume this is for missing mode only.  More on wr-protect mode below.
> 
> Personally I don't see immediately on whether this is needed.  If the
> process itself is trusted then it should be under control of anyone who
> will be accessing the pages..  If the other threads are not trusted, then
> there's no way to stop anyone from mprotect(RW) after mprotect(NONE)
> anyway..

I think there is a difference between code that can read/write memory 
(e.g., rings/buffers in libvhost-user.c, where I think this was added to 
detect such early access) and code that can execute arbitrary mprotect() 
to voluntarily break the system. I think that's the whole reason 
libvhost-user.c went that direction.

> 
> So I may not really get the gut of it.
> 
> Another way to make sure no one access it is right after receiving the
> memory range from QEMU (VhostUserMemoryRegion), if VuDev.postcopy_listening
> is set, then we register the range with UFFD missing immediately.  After
> all if postcopy_listening is set it means we passed the advise phase
> already (VHOST_USER_POSTCOPY_ADVISE). Any potential access will be blocked
> until QEMU starts to read on that uffd.
> 
>>
>> I'd imagine, when using uffd-wp (VM snapshotting with shmem?) one might use
>> PROT_READ instead before the write-protection is properly set. Because read
>> access would be fine in the meantime.
> 
> It'll be different for wr-protect IIUC, because unlike missing protections,
> we don't worry about writes happening before UFFDIO_WRITEPROTECT.
> 
> IMHO the solo thing the vhost-user proc needs to do is one
> UFFDIO_WRITEPROTECT for each of the range when QEMU tells it to, then it'll
> be fine.  Pre-writes are fine.
> 
> Sorry I probably went a bit off-topic.  I just want to make sure I don't
> miss any real use case of having mprotect being useful for uffd-wp being
> there, because that used to be a grey area for me.
> 
>>
>> But I'm just pulling use cases out of my magic hat ;) Nothing stops user
>> space from doing things that are not clearly forbidden (well, even then
>> users might complain, but that's a different story).
> 
> Yes, I think those are always fine but the user just cannot assume it'll
> work as they assumed how it will work.
> 
> If "doing things that are not clearly forbidden" triggers a host warning or
> crash that's a bug, OTOH if the outcome is limited to the process itself
> then from kernel pov I think we're good.  I used to even thought about
> forbid mprotect() on uffd-wp but I'm not sure whether it's good idea either.
> 
> Let's see whether I missed something above, if so I'll rethink.

Let's not get distracted too much. As a reminder, I wrote that test case 
to showcase that other kernel code behaves just like the migration code 
does. It was the long hanging fruit to make a point, I'm happy to 
exclude it for now.


Now, my 2 cents on the whole topic regarding "supported", "not 
supported" etc:

(1) If something is not supported we should bail out or at least warn
     the user. I'm pretty sure there are other uffd-wp dummy users like
     me. Skimming over the man userfaultfd page nothing in particular
     regarding PROT_WRITE, mprotect(), ... maybe I looked at the wrong
     page.
(2) If something is easy to support, support it instead of having all
     these surprises for users and having to document them and warn the
     user. Makes all these discussions regarding what's supported, what's
     a valid use case, etc ... much easier.
(3) Inconsistency confuses users. If something used to work for anon,
     in an ideal world, we make shmem behave in a similar, non-surprising
     way.
(4) There are much smarter people like me with much more advanced
     magical hats. I'm pretty sure they will come up with use cases that
     I am not even able to anticipate right now.
(5) Users will make any imaginable mistake possible and point at the
     doc, that nothing speaks against it and that the system didn't bail
     out.

Again, just my 2 cents. Maybe the dos and don'ts of userfaultfd-wp are 
properly documented already and we just don't bail out.

-- 
Thanks,

David / dhildenb

