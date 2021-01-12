Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B3E2F3B53
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406917AbhALT5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406913AbhALT5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 14:57:12 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08520C061795
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 11:56:31 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id w18so6684664iot.0
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 11:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m+OlJPIb+Y7HL3mVvnn3aPJy9H6Uy5divcbzK7j1Vac=;
        b=ijpBBn3/eYfeKjIklKWS1c5NBUUWU/glzhzuVqSiYrNeGFj/33i6sMGT6ABu6v8y30
         6ClaiIxIJqZhO4gWRmAEMM8ki53XQp0vzKenQLOwDafAPdfAUk+Vbnq4B3TNJENciWDT
         MmDQ7CXTXbXr2Um9vBiU+rIbTYtlacGzKba6j2rW5bJsOWWQ2hs8mBkgg7y72tigagm/
         Bm2iym+5uqEeisSbob3R540G7m4/iv7PmuZahZWdNM49malb01s1pvyViEfA+RFHZsW3
         GsxZJQUp46Ei8tm92rtxLpIVxvAEsDXGuDmPDaYhrBj7dyFy+1+i7IyWsnz3R56nGBGS
         Uj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m+OlJPIb+Y7HL3mVvnn3aPJy9H6Uy5divcbzK7j1Vac=;
        b=TVirkEj6T1USt5OfgenWoplZG+vPU3osoIZuRZH7vy1quCecWH6UJqBWJsOpiHtDCX
         uxvxrvvhK7BwxLrQwVdhSv26klC1F7P1ZGswuATGZMxsaaHtrFaoZstcYulnI+oqZ/kc
         Yf/2yF7+WdDl928eTzopizk1JiweJyEP7ONqTDKZ9wcNKW2/2kkBZR6jzTZq11XuBvvU
         AEEIn/mkhTBaeGU3cNSBPScIL0MoXpIyUqNcADalkFHpM1kWfw6t3HXqUwuw65Ry/1Wq
         qiX2ekIsBmtOkBVmydsxrFRcPpw6eqq75ermEpK9IpW8MhFAesOTV3F3F4iXfjCxZofE
         wdag==
X-Gm-Message-State: AOAM533p78k6W1nYwJnT5/Fvj+pbJT/MRqs45wLBJykTdsqim+GXJGTk
        mvZNB7V5slX42nWdvJVpeeiwyg==
X-Google-Smtp-Source: ABdhPJygreYDj1N+TwKoFXkVp0vrevIYk6hR5C4174Z/QpvC//lcr0AVJTHPs8etujNQwBZ4aOmn3A==
X-Received: by 2002:a92:dc8e:: with SMTP id c14mr757390iln.54.1610481391209;
        Tue, 12 Jan 2021 11:56:31 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id n16sm3147956ilj.19.2021.01.12.11.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 11:56:30 -0800 (PST)
Date:   Tue, 12 Jan 2021 12:56:25 -0700
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
Message-ID: <X/3+6ZnRCNOwhjGT@google.com>
References: <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
> > On Jan 12, 2021, at 11:02 AM, Laurent Dufour <ldufour@linux.vnet.ibm.com> wrote:
> > 
> > Le 12/01/2021 à 17:57, Peter Zijlstra a écrit :
> >> On Tue, Jan 12, 2021 at 04:47:17PM +0100, Laurent Dufour wrote:
> >>> Le 12/01/2021 à 12:43, Vinayak Menon a écrit :
> >>>> Possibility of race against other PTE modifiers
> >>>> 
> >>>> 1) Fork - We have seen a case of SPF racing with fork marking PTEs RO and that
> >>>> is described and fixed here https://lore.kernel.org/patchwork/patch/1062672/
> >> Right, that's exactly the kind of thing I was worried about.
> >>>> 2) mprotect - change_protection in mprotect which does the deferred flush is
> >>>> marked under vm_write_begin/vm_write_end, thus SPF bails out on faults
> >>>> on those VMAs.
> >> Sure, mprotect also changes vm_flags, so it really needs that anyway.
> >>>> 3) userfaultfd - mwriteprotect_range is not protected unlike in (2) above.
> >>>> But SPF does not take UFFD faults.
> >>>> 4) hugetlb - hugetlb_change_protection - called from mprotect and covered by
> >>>> (2) above.
> >>>> 5) Concurrent faults - SPF does not handle all faults. Only anon page faults.
> >> What happened to shared/file-backed stuff? ISTR I had that working.
> > 
> > File-backed mappings are not processed in a speculative way, there were options to manage some of them depending on the underlying file system but that's still not done.
> > 
> > Shared anonymous mapping, are also not yet handled in a speculative way (vm_ops is not null).
> > 
> >>>> Of which do_anonymous_page and do_swap_page are NONE/NON-PRESENT->PRESENT
> >>>> transitions without tlb flush. And I hope do_wp_page with RO->RW is fine as well.
> >> The tricky one is demotion, specifically write to non-write.
> >>>> I could not see a case where speculative path cannot see a PTE update done via
> >>>> a fault on another CPU.
> >> One you didn't mention is the NUMA balancing scanning crud; although I
> >> think that's fine, loosing a PTE update there is harmless. But I've not
> >> thought overly hard on it.
> > 
> > That's a good point, I need to double check on that side.
> > 
> >>> You explained it fine. Indeed SPF is handling deferred TLB invalidation by
> >>> marking the VMA through vm_write_begin/end(), as for the fork case you
> >>> mentioned. Once the PTL is held, and the VMA's seqcount is checked, the PTE
> >>> values read are valid.
> >> That should indeed work, but are we really sure we covered them all?
> >> Should we invest in better TLBI APIs to make sure we can't get this
> >> wrong?
> > 
> > That may be a good option to identify deferred TLB invalidation but I've no clue on what this API would look like.
> 
> I will send an RFC soon for per-table deferred TLB flushes tracking.
> The basic idea is to save a generation in the page-struct that tracks
> when deferred PTE change took place, and track whenever a TLB flush
> completed. In addition, other users - such as mprotect - would use
> the tlb_gather interface.
> 
> Unfortunately, due to limited space in page-struct this would only
> be possible for 64-bit (and my implementation is only for x86-64).

I don't want to discourage you but I don't think this would end up
well. PPC doesn't necessarily follow one-page-struct-per-table rule,
and I've run into problems with this before while trying to do
something similar.

I'd recommend per-vma and per-category (unmapping, clearing writable
and clearing dirty) tracking, which only rely on arch-independent data
structures, i.e., vm_area_struct and mm_struct.

> It would still require to do the copying while holding the PTL though.

IMO, this is unacceptable. Most archs don't support per-table PTL, and
even x86_64 can be configured to use per-mm PTL. What if we want to
support a larger page size in the feature?

It seems to me the only way to solve the problem with self-explanatory
code and without performance impact is to check mm_tlb_flush_pending
and the writable bit (and two other cases I mentioned above) at the
same time. Of course, this requires a lot of effort to audit the
existing uses, clean them up and properly wrap them up with new
primitives, BUG_ON all invalid cases and document the exact workflow
to prevent misuses.

I've mentioned the following before -- it only demonstrates the rough
idea.

diff --git a/mm/memory.c b/mm/memory.c
index 5e9ca612d7d7..af38c5ee327e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4403,8 +4403,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		goto unlock;
 	}
 	if (vmf->flags & FAULT_FLAG_WRITE) {
-		if (!pte_write(entry))
+		if (!pte_write(entry)) {
+			if (mm_tlb_flush_pending(vmf->vma->vm_mm))
+				flush_tlb_page(vmf->vma, vmf->address);
 			return do_wp_page(vmf);
+		}
 		entry = pte_mkdirty(entry);
 	}
 	entry = pte_mkyoung(entry);
