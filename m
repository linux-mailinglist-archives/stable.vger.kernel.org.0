Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116062F3D87
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437999AbhALVhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437039AbhALUu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 15:50:29 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A17C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 12:49:49 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id w18so7032621iot.0
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 12:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iz948zq6frbZj4yrO0gxVPBCgl3MtZVScrUscJeCONc=;
        b=mUfnl+ylyuef1eqF5Au0U+9hQqR6rirDJC+wgHZcgeX+Y10zfQZesA2JPpjOJfAwem
         vfs+NxTNB2oiy4I0ee8RoLt4IE+0c+o5nLK90UCmAQK7dhkSy3ls0KrVTtKWUgNXuXb5
         g7LHX6knzedxFCigXXZZGKIoxMKlKMXXixLEgghpQ58zLLUDEXh8bGqmg6m8EohhZXCq
         upbCvoy9vWALYnMM0dKDsIEVb0JfVESkH3xlqpVmKlzYCIgOoPTe0Gx0XYFA5K6aG9zs
         l/LGSWC7dnBdNRSZZSNZDH53xSE4hgYKK53yQCXD41+6n1eKibYkRL85GBD+3hwXkkkz
         Sc2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iz948zq6frbZj4yrO0gxVPBCgl3MtZVScrUscJeCONc=;
        b=juB15eBqMC6rJtLgpbdN9VMnK7+H6guXGv8fy7r2SNooYzmDylOWKOT/zCKqP0Frn2
         luFSaiyxs1P1KuWevv7e8egXTqPsIadPgMrDiGzBUkRR+bC8WIiwR1Hc/9VIhkiZUMoS
         pcElslRVfYv3+WlcBB3EgqCE7SvDVtBMEcqbI2rdY42dDhx5kSmpLvZgo0GnMXjhIjjt
         lMaRnTB2RztX8cIBkWycttaKa2X5LP7+AKZT45difXIJ8mNIKpPUXm0BiuxIoTX2hwb6
         vao6oKhiiNutVoIECsc6IVpsJ7Hmn1qjTot8XGJbVG6qRdN57qqN9ioveb+alV3ohjkx
         lz4A==
X-Gm-Message-State: AOAM531NZaNm6pS9E8xpp4vr+31xO/4lyC1Zyd4S6tCf/2Rxvv76WnA5
        2SPnR9j/9fd0Rjsn4GthLMkWRQ==
X-Google-Smtp-Source: ABdhPJxA3ncb6sVXiU6rEnsOvA2T2v/R2etdfaiCr1nJnYQmxuLz2uwDw9LnJAyOGuJmsZNIrdy1uw==
X-Received: by 2002:a5e:8202:: with SMTP id l2mr724009iom.106.1610484588372;
        Tue, 12 Jan 2021 12:49:48 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id n11sm2412446ioh.37.2021.01.12.12.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 12:49:47 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:49:43 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>, surenb@google.com
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X/4LZ5NpCwYLgW1s@google.com>
References: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
> > On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
> >>> On Jan 12, 2021, at 11:02 AM, Laurent Dufour <ldufour@linux.vnet.ibm.com> wrote:
> >>> 
> >>> Le 12/01/2021 à 17:57, Peter Zijlstra a écrit :
> >>>> On Tue, Jan 12, 2021 at 04:47:17PM +0100, Laurent Dufour wrote:
> >>>>> Le 12/01/2021 à 12:43, Vinayak Menon a écrit :
> >>>>>> Possibility of race against other PTE modifiers
> >>>>>> 
> >>>>>> 1) Fork - We have seen a case of SPF racing with fork marking PTEs RO and that
> >>>>>> is described and fixed here https://lore.kernel.org/patchwork/patch/1062672/
> >>>> Right, that's exactly the kind of thing I was worried about.
> >>>>>> 2) mprotect - change_protection in mprotect which does the deferred flush is
> >>>>>> marked under vm_write_begin/vm_write_end, thus SPF bails out on faults
> >>>>>> on those VMAs.
> >>>> Sure, mprotect also changes vm_flags, so it really needs that anyway.
> >>>>>> 3) userfaultfd - mwriteprotect_range is not protected unlike in (2) above.
> >>>>>> But SPF does not take UFFD faults.
> >>>>>> 4) hugetlb - hugetlb_change_protection - called from mprotect and covered by
> >>>>>> (2) above.
> >>>>>> 5) Concurrent faults - SPF does not handle all faults. Only anon page faults.
> >>>> What happened to shared/file-backed stuff? ISTR I had that working.
> >>> 
> >>> File-backed mappings are not processed in a speculative way, there were options to manage some of them depending on the underlying file system but that's still not done.
> >>> 
> >>> Shared anonymous mapping, are also not yet handled in a speculative way (vm_ops is not null).
> >>> 
> >>>>>> Of which do_anonymous_page and do_swap_page are NONE/NON-PRESENT->PRESENT
> >>>>>> transitions without tlb flush. And I hope do_wp_page with RO->RW is fine as well.
> >>>> The tricky one is demotion, specifically write to non-write.
> >>>>>> I could not see a case where speculative path cannot see a PTE update done via
> >>>>>> a fault on another CPU.
> >>>> One you didn't mention is the NUMA balancing scanning crud; although I
> >>>> think that's fine, loosing a PTE update there is harmless. But I've not
> >>>> thought overly hard on it.
> >>> 
> >>> That's a good point, I need to double check on that side.
> >>> 
> >>>>> You explained it fine. Indeed SPF is handling deferred TLB invalidation by
> >>>>> marking the VMA through vm_write_begin/end(), as for the fork case you
> >>>>> mentioned. Once the PTL is held, and the VMA's seqcount is checked, the PTE
> >>>>> values read are valid.
> >>>> That should indeed work, but are we really sure we covered them all?
> >>>> Should we invest in better TLBI APIs to make sure we can't get this
> >>>> wrong?
> >>> 
> >>> That may be a good option to identify deferred TLB invalidation but I've no clue on what this API would look like.
> >> 
> >> I will send an RFC soon for per-table deferred TLB flushes tracking.
> >> The basic idea is to save a generation in the page-struct that tracks
> >> when deferred PTE change took place, and track whenever a TLB flush
> >> completed. In addition, other users - such as mprotect - would use
> >> the tlb_gather interface.
> >> 
> >> Unfortunately, due to limited space in page-struct this would only
> >> be possible for 64-bit (and my implementation is only for x86-64).
> > 
> > I don't want to discourage you but I don't think this would end up
> > well. PPC doesn't necessarily follow one-page-struct-per-table rule,
> > and I've run into problems with this before while trying to do
> > something similar.
> 
> Discourage, discourage. Better now than later.
> 
> It will be relatively easy to extend the scheme to be per-VMA instead of
> per-table for architectures that prefer it this way. It does require
> TLB-generation tracking though, which Andy only implemented for x86, so I
> will focus on x86-64 right now.
> 
> [ For per-VMA it would require an additional cmpxchg, I presume to save the
> last deferred generation though. ]
> 
> > I'd recommend per-vma and per-category (unmapping, clearing writable
> > and clearing dirty) tracking, which only rely on arch-independent data
> > structures, i.e., vm_area_struct and mm_struct.
> 
> I think that tracking changes on “what was changed” granularity is harder
> and more fragile.
> 
> Let me finish trying the clean up the mess first, since fullmm and
> need_flush_all semantics were mixed; there are 3 different flushing schemes
> for mprotect(), munmap() and try_to_unmap(); there are missing memory
> barriers; mprotect() performs TLB flushes even when permissions are
> promoted; etc.
> 
> There are also some optimizations that we discussed before, such on x86 - 
> RW->RO does not require a TLB flush if a PTE is not dirty, etc.
> 
> I am trying to finish something so you can say how terrible it is, so I will
> not waste too much time. ;-)
> 
> >> It would still require to do the copying while holding the PTL though.
> > 
> > IMO, this is unacceptable. Most archs don't support per-table PTL, and
> > even x86_64 can be configured to use per-mm PTL. What if we want to
> > support a larger page size in the feature?
> > 
> > It seems to me the only way to solve the problem with self-explanatory
> > code and without performance impact is to check mm_tlb_flush_pending
> > and the writable bit (and two other cases I mentioned above) at the
> > same time. Of course, this requires a lot of effort to audit the
> > existing uses, clean them up and properly wrap them up with new
> > primitives, BUG_ON all invalid cases and document the exact workflow
> > to prevent misuses.
> > 
> > I've mentioned the following before -- it only demonstrates the rough
> > idea.
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 5e9ca612d7d7..af38c5ee327e 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4403,8 +4403,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> > 		goto unlock;
> > 	}
> > 	if (vmf->flags & FAULT_FLAG_WRITE) {
> > -		if (!pte_write(entry))
> > +		if (!pte_write(entry)) {
> > +			if (mm_tlb_flush_pending(vmf->vma->vm_mm))
> > +				flush_tlb_page(vmf->vma, vmf->address);
> > 			return do_wp_page(vmf);
> > +		}
> > 		entry = pte_mkdirty(entry);
> > 	}
> > 	entry = pte_mkyoung(entry);
> 
> I understand. This might be required, regardless of the deferred flushes
> detection scheme. If we assume that no write-unprotect requires a COW (which
> should be true in this case, since we take a reference on the page), your
> proposal should be sufficient.
> 
> Still, I think that there are many unnecessary TLB flushes right now,
> and others that might be missed due to the overly complicated invalidation
> schemes. 
> 
> Regardless, as Andrea pointed, this requires first to figure out the
> semantics of mprotect() and friends when pages are pinned.

Thanks, I appreciate your effort. I'd be glad to review whatever you
come up with.
