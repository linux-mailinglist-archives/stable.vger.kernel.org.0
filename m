Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E7E2DF429
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 07:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgLTGGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 01:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgLTGGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 01:06:13 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9751DC0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 22:05:33 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id v3so6045033ilo.5
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 22:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3PPLg+PyRHcRYpZXYU0/asVVIWhX7CVrUOdST+JsHR0=;
        b=e9wxcQKAFmPoEefwuZbY4XDYd4tBIR1mNJrmj/KVWvI/UZUztU7+L4iHz+Ve9enOI+
         E2lrFuoODyJXy71rDvSN4jQw1/jWVkaHsoHX8wOHb2M0vig7rxn0n3iT9Jr5ij4N+5Op
         FUID7+AbzTYOVJ1KMLZsFkggc51AVCic7CrJd31xeO34IKxcmQQD7SjEAOT2tSv3WueV
         jrWSVojFo//oZQnc8LOGMxJxPVxHA/Sp9paANaQEYBlp2RZkxJ0I38bCB8jI1OG+VxtS
         Zwddmly0CxNmChMl8rVCN5c2w1PqfAOk35/xeloRR92oDb42Hcy1egNuuW3yeIWjVB6G
         qFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3PPLg+PyRHcRYpZXYU0/asVVIWhX7CVrUOdST+JsHR0=;
        b=DFbEz1JHnJkRlmW29eo9MH0r9QV+unEpzLEgberm/dQpmkhQbdiV/9bOf3yAm59GvA
         LKASTQaRYcvPoDLqu5sRstRXoYYpuEv3W4dYGLmfzQEyZraW0j+7UBThz3D4u5uJcSyK
         qGNI8xVVHwP60gbie6LmlHciC7LxkC7UGQ+xIOgxJjs8wwm5NAWKgTMvHdmU08uZM92Z
         ORJFhg+Fr+G8rZUozn9K8FfrtT/Gjl1PRutvuXlGhCtU6YYLjdz5j9NZs9vpm6xryiqh
         ViF7FbW81ZMztqVABaQHryGXw02n/9mPMdLlMh9TmSznRR4OWESP5gYkgNoF5udMvcTg
         w94Q==
X-Gm-Message-State: AOAM530JAaulzo0v753hJcnQsB4ffXsNJiP+9g1LJbQV+VNpPf4i9/r3
        A1VNq4xGt17Bq+D/Bvc32/ih9A==
X-Google-Smtp-Source: ABdhPJyy9yVMnwfNic7VftM2KcUqOrVxMDy8+CIcb0HITMOOPzzKatb6Pr6CA9cJOtnPTOc4U8HISA==
X-Received: by 2002:a92:d7d2:: with SMTP id g18mr11631723ilq.2.1608444331660;
        Sat, 19 Dec 2020 22:05:31 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id f13sm12714253iog.18.2020.12.19.22.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 22:05:30 -0800 (PST)
Date:   Sat, 19 Dec 2020 23:05:26 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X97pprdcRXusLGnq@google.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 01:34:29PM -0800, Nadav Amit wrote:
> [ cc’ing some more people who have experience with similar problems ]
> 
> > On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > 
> > Hello,
> > 
> > On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> >> Analyzing this problem indicates that there is a real bug since
> >> mmap_lock is only taken for read in mwriteprotect_range(). This might
> > 
> > Never having to take the mmap_sem for writing, and in turn never
> > blocking, in order to modify the pagetables is quite an important
> > feature in uffd that justifies uffd instead of mprotect. It's not the
> > most important reason to use uffd, but it'd be nice if that guarantee
> > would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> > other pgtable manipulations.
> > 
> >> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> >> 
> >> cpu0				cpu1
> >> ----				----
> >> userfaultfd_writeprotect()
> >> [ write-protecting ]
> >> mwriteprotect_range()
> >> mmap_read_lock()
> >> change_protection()
> >>  change_protection_range()
> >>   ...
> >>   change_pte_range()
> >>   [ defer TLB flushes]
> >> 				userfaultfd_writeprotect()
> >> 				 mmap_read_lock()
> >> 				 change_protection()
> >> 				 [ write-unprotect ]
> >> 				 ...
> >> 				  [ unprotect PTE logically ]
> >> 				...
> >> 				[ page-fault]
> >> 				...
> >> 				wp_page_copy()
> >> 				[ set new writable page in PTE]

I don't see any problem in this example -- wp_page_copy() calls
ptep_clear_flush_notify(), which should take care of the stale entry
left by cpu0.

That being said, I suspect the memory corruption you observed is
related this example, with cpu1 running something else that flushes
conditionally depending on pte_write().

Do you know which type of pages were corrupted? file, anon, etc.

> > Can't we check mm_tlb_flush_pending(vma->vm_mm) if MM_CP_UFFD_WP_ALL
> > is set and do an explicit (potentially spurious) tlb flush before
> > write-unprotect?
> 
> There is a concrete scenario that I actually encountered and then there is a
> general problem.
> 
> In general, the kernel code assumes that PTEs that are read from the
> page-tables are coherent across all the TLBs, excluding permission promotion
> (i.e., the PTE may have higher permissions in the page-tables than those
> that are cached in the TLBs).
> 
> We therefore need to both: (a) protect change_protection_range() from the
> changes of others who might defer TLB flushes without taking mmap_sem for
> write (e.g., try_to_unmap_one()); and (b) to protect others (e.g.,
> page-fault handlers) from concurrent changes of change_protection().
> 
> We have already encountered several similar bugs, and debugging such issues
> s time consuming and these bugs impact is substantial (memory corruption,
> security). So I think we should only stick to general solutions.
> 
> So perhaps your the approach of your proposed solution is feasible, but it
> would have to be applied all over the place: we will need to add a check for
> mm_tlb_flush_pending() and conditionally flush the TLB in every case in
> which PTEs are read and there might be an assumption that the
> access-permission reflect what the TLBs hold. This includes page-fault
> handlers, but also NUMA migration code in change_protection(), softdirty
> cleanup in clear_refs_write() and maybe others.
> 
> [ I have in mind another solution, such as keeping in each page-table a 
> “table-generation” which is the mm-generation at the time of the change,
> and only flush if “table-generation”==“mm-generation”, but it requires
> some thought on how to avoid adding new memory barriers. ]
> 
> IOW: I think the change that you suggest is insufficient, and a proper
> solution is too intrusive for “stable".
> 
> As for performance, I can add another patch later to remove the TLB flush
> that is unnecessarily performed during change_protection_range() that does
> permission promotion. I know that your concern is about the “protect” case
> but I cannot think of a good immediate solution that avoids taking mmap_lock
> for write.
> 
> Thoughts?
> 
