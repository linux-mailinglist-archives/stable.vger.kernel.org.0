Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B0644934
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiLFQ3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbiLFQ3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:29:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569ACC10
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 08:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670344093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ftN5vrqIh393VC3x0YgzupFdfd4d2nuxsXC4NEbHZHY=;
        b=ZEUmDt3I5gUn4rmdiy4Qi2VPPOezWcs+Q6IRHOTplGMj4PENdj7octN/kWSGWbUUolTigX
        VRFNTPLjaB/DGE63md4CXCDQb/aR07V8TNbth3q3X4kKO9MZ64WDA7YCOdGQR4qTF+uOFa
        smS+nqYECQPWIebuPeCRj3v89Q0F0mc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-ozXcxljHNaen8wS3ZYS1Sg-1; Tue, 06 Dec 2022 11:28:10 -0500
X-MC-Unique: ozXcxljHNaen8wS3ZYS1Sg-1
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso8641665wms.8
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 08:28:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ftN5vrqIh393VC3x0YgzupFdfd4d2nuxsXC4NEbHZHY=;
        b=y1gedcVnRnZAzYVK1NbnULi859GdIeRxrDhC9qijB6JwszUNT5XHcPXpd8DokFrcTo
         btZ3QdPRrky4zHt+FkXWFYfrEhshSBC/DgndzsVrVjIPzR+IMl13402Tm5An0O9GdOu9
         BzlvhbsnOUzEOIbaJMLOk36qo9Ts5YwaElnXjyYIxP887V+GvsMtlzIlsNbcszATEsgJ
         eMeAJgtMJ5W9Atweah+1y+u5VweEj8lhEFBofaoUz+USv0tK+/ZnM+ypH+5sAZOYSM9E
         nmVOJrp+eA20aRE4Qs//ae5JZjEuo53kn321sg2lpKFf5EM9xtgBY/1SeBZX+PfUx7sU
         vFYg==
X-Gm-Message-State: ANoB5pnBqIxmPCa4CdegL8YdYzYiHKjsMtk55nJBZMOoKdWPsYp+wVjp
        bvrSjx5aUNbOD38Nh1crBUqfr/P++o8WTE35Z9K2pl6O3qJlvgJMvmWtMiM2tp13QgWp2lhtW8d
        6ZxpY1XD/Lnc0/Y0m
X-Received: by 2002:a5d:4985:0:b0:242:4c61:271f with SMTP id r5-20020a5d4985000000b002424c61271fmr9501083wrq.236.1670344089232;
        Tue, 06 Dec 2022 08:28:09 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6mAynUXcJWsU/JNusmmJwUTrMSf2IyMZvYSKNpAtRwo369qelwFXVeHHxbMyWQON65Dpyqdw==
X-Received: by 2002:a5d:4985:0:b0:242:4c61:271f with SMTP id r5-20020a5d4985000000b002424c61271fmr9501065wrq.236.1670344088866;
        Tue, 06 Dec 2022 08:28:08 -0800 (PST)
Received: from ?IPV6:2003:cb:c705:4f00:41f1:185d:4f9f:d1c2? (p200300cbc7054f0041f1185d4f9fd1c2.dip0.t-ipconnect.de. [2003:cb:c705:4f00:41f1:185d:4f9f:d1c2])
        by smtp.gmail.com with ESMTPSA id i21-20020a1c5415000000b003d1f2c3e571sm125988wmb.33.2022.12.06.08.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 08:28:08 -0800 (PST)
Message-ID: <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com>
Date:   Tue, 6 Dec 2022 17:28:07 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
In-Reply-To: <Y45duzmGGUT0+u8t@x1n>
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

>>>> I think fundamentally the core is uffd-wp is pte-based, so the information
>>>> resides in pte not vma.  I'm not strongly objecting this patch, especially
>>>> you mentioned auto-numa so I need to have a closer look later there.
>>>> However I do think uffd-wp is slightly special because we always need to
>>>> consider pte information anyway, so a per-vma information doesn't hugely
>>>> help, IMHO.
>>>
>>> That's the same as softdirty tracking, IMHO.
> 
> Soft-dirty doesn't have a bit in the pte showing whether the page is
> protected.

If the page is already softdirty (PTE bit), we don't need write faults 
and consequently can map the page writable. If the page is not 
softdirty, we need !write as default. But let's talk in detail about 
vma->vm_page_prot and interaction with other wrprotect features below.

> 
> One wr-protects in soft-dirty with either ALL or NONE.  That's per-vma.
> 
> One wr-protects in uffd-wp by wr-protect specific page or range of pages.
> That's per-page.
> 

Let me try to explain clearer what the issue with uffd-wp on shmem is 
right now and how to proceed from here. maybe that makes it clearer what 
the vma->vm_page_prot semantics are.

vma->vm_page_prot defines the default PTE/PMD/... protection. This 
protection is always *safe*, meaning, if you blindly use that protection 
when (re)mapping a page, there won't be correctness issues. No need to 
manually wrprotect afterwards.

That's why migration, mprotect(), NUMA faults that all rely on 
vma->vm_page_prot work as expected for now.


When calculating vma->vm_page_prot, we considers three things:

(1) VMA protection. For example, no VM_WRITE? then it won't include
     write permissions.
(2) Private vs. shared: If the mapping is private, we will never have
     write permissions in vma->vm_page_prot, because we might have to
     COW individual PTEs. We really want write faults as default.
(3) Write-notify: Some mechanism (softdirty tracking, file system, uffd-
     wp) *might* require default write-protection, such that we always
     properly trigger a write fault instead where we can handle these.
     This only applies to shared mappings, because private mappings
     always default to !write (2).

As vma->vm_page_prot is safe, it is always valid to apply them when 
mapping a PTE/PMD/ ... *in addition* we can use other information, to 
detect if we still can map the PTE writable (if they were removed due to 
(2) or (3)).

In migration code, we use the migration type (writable migration 
entries). In NUMA-hinting code we used the stored savedwrite value. 
Absence of these bits does not imply that we have to map the page 
wrprotected.


We never had to remove write permissions so far from the 
vma->vm_page_prot default. We always only added permissions.


Now, uffd-wp on shmem as of now violates these semantics. 
vma->vm_page_prot cannot always be used as a safe default, because we 
might have to wrprotect individual PTEs. Note that for uffd-wp on 
anonymous memory this was not an issue, because we default to !write in 
vma->vm_page_prot.


The two possible ways to approach this for uffd-wp on shmem are:

(1) Obey existing vma->vm_page_prot semantics. Default to !write and
     optimize the relevant cases to *add* the write bit. This is
     essentially what this patch does, minus
     can_change_pte_writable() optimizations on relevant code paths where
     we'd want to maintain the write bit. For example, when removing
     uffd-wp protection we might want to restore the write bit directly.

(2) Default to write permissions and check each and every code location
     where we remap for uffd-wp ptes, to manuall wrprotect -- *remove*
     the write bit. Alternatively, as you said, always wrprotect when
     setting the PTE bit, which might work as well.


My claim is that (1) is less error prone, because in the worst case we 
forget to optimize one code location -- instead to resulting in a BUG if 
we forget to wrprotect (what we have now). But I am not going to fight 
for it, because I can see that (2) can be made to work as well, as you 
outline in your patch.

You seem to have decided on (2). Fair enough, you know uffd-wp best. We 
just have to fix it properly and make the logic consistent whenever we 
remap a page.


Is anything I said fundamentally wrong?

>>>
>>> [...]
>>>
>>>>> Running the mprotect() reproducer [1] without this commit:
>>>>>      $ ./uffd-wp-mprotect
>>>>>      FAIL: uffd-wp did not fire
>>>>> Running the mprotect() reproducer with this commit:
>>>>>      $ ./uffd-wp-mprotect
>>>>>      PASS: uffd-wp fired
>>>>>
>>>>> [1] https://lore.kernel.org/all/222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com/T/#u
>>>>
>>>> I still hope for a formal patch (non-rfc) we can have a reproducer outside
>>>> mprotect().  IMHO mprotect() is really ambiguously here being used with
>>>> uffd-wp, so not a good example IMO as I explained in the other thread [1].
>>>
>>> I took the low hanging fruit to showcase that this is a more generic problem.
>>> The reproducer is IMHO nice because it's simple and race-free.
> 
> If no one is using mprotect() with uffd-wp like that, then the reproducer
> may not be valid - the reproducer is defining how it should work, but does
> that really stand?  That's why I said it's ambiguous, because the
> definition in this case is unclear.

There are interesting variations like:

mmap(PROT_READ, MAP_POPULATE|MAP_SHARED)
uffd_wp()
mprotect(PROT_READ|PROT_WRITE)

Where we start out with all-write permissions before we enable selective 
write permissions.

But I'm not going to argue about whats valid and whats not as long as 
it's documented ;). I primarily wanted to showcase that the same logic 
based on vma->vm_page_prot is used elsewhere, and that migration PTE 
restoration is not particularly special.

> 
> I think numa has the problem too which I agree with you.  If you attach a
> numa reproducer it'll be nicer.  But again I'm not convinced uffd-wp is a
> per-vma thing, which seems to be what this patch is based upon.

I might be able to give NUMA hinting a shot later this week, but I have 
other stuff to focus on.

> 
> Now I really wonder whether I should just simply wr-protect pte for
> pte_mkuffd_wp() always, attached.  I didn't do that from the start because
> I wanted to keep the helpers operate on one bit only.  But I found that
> it's actually common technique to use in pgtable arch code, and it really
> doesn't make sense to not wr-protect a pte if uffd-wp is set on a present
> entry.  It's much safer.

Indeed, that would be much safer.

> 
>>>
>>>>
>>>> I'll need to off-work most of the rest of today, but maybe I can also have
>>>> a look in the weekend or Monday more on the numa paths.  Before that, can
>>>> we first reach a consensus that we have the mm/migrate patch there to be
>>>> merged first?  These are two issues, IMHO.
>>>>
>>>> I know you're against me for some reason, but until now I sincerely don't
>>>> know why.  That patch sololy recovers write bit status (by removing it for
>>>> read-only) for a migration entry and that definitely makes sense to me.  As
>>>> I also mentioned in the old version of that thread, we can rework migration
>>>> entries and merge READ|WRITE entries into a GENERIC entry one day if you
>>>> think proper, but that's for later.
>>>
>>> I'm not against you. I'm against changing well-working, common code
>>> when it doesn't make any sense to me to change it.
> 
> This goes back to the original question of whether we should remove the
> write bit for read migration entry.  Well, let's just focus on others;
> we're all tired of this one.

I hope my lengthy explanation above was helpful and correct.

> 
>>> And now we have proof that
>>> mprotect() just behaves exactly the same way, using the basic rules of vma->vm_page_prot.
>>>
>>> Yes, there is broken sparc64 (below), but that shouldn't dictate our implementation.
> 
> I doubt whether sparc64 is broken if it has been like that anyway, because
> I know little on sparc64 so I guess I'd not speak on that.
> 

I'd wish some of the sparc64 maintainers would speak up finally. Anyhow, 
most probably I'll write a reproducer for some broken case and send it 
to the sparc64 list. Yeah, I need to get Linux for sparc64 running 
inside a VM ... :/

[...]

> 
> Yes, but now I'm prone to the patch I attached which should just cover all
> pte_mkuffd_wp().

We should probably do the same for the pmd variants, and clean up the 
existing wrprotect like:
	pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));

But that's of course, not a fix.


> 
> Side note: since looking at the numa code, I found that after the recent
> rework of removing savedwrite for numa, cdb205f9e220 ("mm/autonuma: use
> can_change_(pte|pmd)_writable() to replace savedwrite"), I think it can
> happen that after numa balancing one pte under uffd-wp vma (but not
> wr-protected) can have its write bit lost if the migration failed during
> recovering, because vma_wants_manual_pte_write_upgrade() will return false
> for such case.  Is it true?

Yes, you are correct. I added that to the patch description:

"
Note that we don't optimize for the actual migration case:
     (1) When migration succeeds the new PTE will not be writable because
         the source PTE was not writable (protnone); in the future we
         might just optimize that case similarly by reusing
         can_change_pte_writable()/can_change_pmd_writable() when
         removing migration PTEs.
     (2) When migration fails, we'd have to recalculate the "writable"
         flag because we temporarily dropped the PT lock; for now keep it
         simple and set "writable=false".
"

Case (1) would, with your current patch, always lose the write bit 
during migration, even if vma->vm_page_prot included it. We most might 
want to optimize that in the future.

Case (2) is rather a corner case, and unless people complain about it 
being a real performance issue, it felt cleaner (less code) to not 
optimize for that now.



Again Peter, I am not against you, not at all. Sorry if I gave you the 
impression. I highly appreciate your work and this discussion.

-- 
Thanks,

David / dhildenb

