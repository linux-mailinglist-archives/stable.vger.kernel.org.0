Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531F92DF88B
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 06:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgLUFNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 00:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLUFNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 00:13:22 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E98C0613D3
        for <stable@vger.kernel.org>; Sun, 20 Dec 2020 21:12:41 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id v3so7817207ilo.5
        for <stable@vger.kernel.org>; Sun, 20 Dec 2020 21:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vswCukahHI84DC0lcMezNvVlWnF1S1S3+uLVpnYj1r4=;
        b=HE7XS3E//8ycSGXzh/6H9wdve7qwxdJnIX0qC9Nq/ALqPuwX+9S+FoblZ4cSaIGpU9
         w+xfm0NHcWJ5fYhrcK1TNQijEJwhfCsrCFRg18Vn0J3H1hteYiDr9HKw4DrFSpsZmNp3
         Zqfm+XrdIUynL5Sqq4wZZ7sb+URJAmTM15lnZgpIKVdwLm7eMvGdOxjHxcFwZ8YydWBc
         yOeMc+8u+HyB70bg/nSRAQtp9elax1o7QVDMhnJz/IqX8AFNrojW6uEWtbCYHvP/jLsS
         S0ShJikwivPRoSml0mrF9lCpWbXWCFamtvwHXB8j+ISPGlf3ztqWRfgtFs6zJC7nLsPx
         0UyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vswCukahHI84DC0lcMezNvVlWnF1S1S3+uLVpnYj1r4=;
        b=CtihsarwSXwYGMoAhM5GkaWR97RtoxgNYUZBMFcxMzyyGV3GOUg4ggPa7jzVpunOCE
         O2sXohZZtvk0YI/BHhiILZS+6E2bhKSSGoGXVk2XwZUNJEX7hcBoOZX+8Yvw5qly/NjZ
         cohlJ+V2Iug9lPkfGjhEBQa7fg1wuRaDpZnCh+yoHhuOWUL3ZAjjl8sMxxj5fI0rTT5W
         Ixu9OOG4Rz65d0V3fi+NPwR2HaQxp+mriazeWYZgJynje+7+b8fpHIAbqL3e/7xqalr7
         NaHx+Cl+iYkVNAmTnvOahlQXTcda1hjH4bqliarzhdQsjos9QKO1LSD/J9jAFC2s4Cu/
         rtCg==
X-Gm-Message-State: AOAM532wkS54ZJj3XirLC+frxeTf9NU/kYiWGgWJorDwyiFwgs+ZpQER
        KOFn7SAR7AgNiVuFCLqhfw/+OA==
X-Google-Smtp-Source: ABdhPJy/28dluEI2zZ26w5IG4pu144SzvEEQhZSVKHNJeLBhF12fU9+UXV21cI4kTSy4bJMamlVOsQ==
X-Received: by 2002:a05:6e02:f93:: with SMTP id v19mr14874422ilo.154.1608527560929;
        Sun, 20 Dec 2020 21:12:40 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id a9sm21528543ion.53.2020.12.20.21.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 21:12:40 -0800 (PST)
Date:   Sun, 20 Dec 2020 22:12:36 -0700
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
Message-ID: <X+AuxIkwmyo/9TD/@google.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
 <X961C3heiGSJ5qVL@redhat.com>
 <729A8C1E-FC5B-4F46-AE01-85E00C66DFFF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <729A8C1E-FC5B-4F46-AE01-85E00C66DFFF@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 20, 2020 at 08:36:15PM -0800, Nadav Amit wrote:
> > On Dec 19, 2020, at 6:20 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > 
> > On Sat, Dec 19, 2020 at 02:06:02PM -0800, Nadav Amit wrote:
> >>> On Dec 19, 2020, at 1:34 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> 
> >>> [ cc’ing some more people who have experience with similar problems ]
> >>> 
> >>>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >>>> 
> >>>> Hello,
> >>>> 
> >>>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> >>>>> Analyzing this problem indicates that there is a real bug since
> >>>>> mmap_lock is only taken for read in mwriteprotect_range(). This might
> >>>> 
> >>>> Never having to take the mmap_sem for writing, and in turn never
> >>>> blocking, in order to modify the pagetables is quite an important
> >>>> feature in uffd that justifies uffd instead of mprotect. It's not the
> >>>> most important reason to use uffd, but it'd be nice if that guarantee
> >>>> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> >>>> other pgtable manipulations.
> >>>> 
> >>>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> >>>>> 
> >>>>> cpu0				cpu1
> >>>>> ----				----
> >>>>> userfaultfd_writeprotect()
> >>>>> [ write-protecting ]
> >>>>> mwriteprotect_range()
> >>>>> mmap_read_lock()
> >>>>> change_protection()
> >>>>> change_protection_range()
> >>>>> ...
> >>>>> change_pte_range()
> >>>>> [ defer TLB flushes]
> >>>>> 				userfaultfd_writeprotect()
> >>>>> 				 mmap_read_lock()
> >>>>> 				 change_protection()
> >>>>> 				 [ write-unprotect ]
> >>>>> 				 ...
> >>>>> 				  [ unprotect PTE logically ]
> > 
> > Is the uffd selftest failing with upstream or after your kernel
> > modification that removes the tlb flush from unprotect?
> 
> Please see my reply to Yu. I was wrong in this analysis, and I sent a
> correction to my analysis. The problem actually happens when
> userfaultfd_writeprotect() unprotects the memory.
> 
> > 			} else if (uffd_wp_resolve) {
> > 				/*
> > 				 * Leave the write bit to be handled
> > 				 * by PF interrupt handler, then
> > 				 * things like COW could be properly
> > 				 * handled.
> > 				 */
> > 				ptent = pte_clear_uffd_wp(ptent);
> > 			}
> > 
> > Upstraem this will still do pages++, there's a tlb flush before
> > change_protection can return here, so I'm confused.
> > 
> 
> You are correct. The problem I encountered with userfaultfd_writeprotect()
> is during unprotecting path.
> 
> Having said that, I think that there are additional scenarios that are
> problematic. Consider for instance madvise_dontneed_free() that is racing
> with userfaultfd_writeprotect(). If madvise_dontneed_free() completed
> removing the PTEs, but still did not flush, change_pte_range() will see
> non-present PTEs, say a flush is not needed, and then
> change_protection_range() will not do a flush, and return while
> the memory is still not protected.
> 
> > I don't share your concern. What matters is the PT lock, so it
> > wouldn't be one per pte, but a least an order 9 higher, but let's
> > assume one flush per pte.
> > 
> > It's either huge mapping and then it's likely running without other
> > tlb flushing in background (postcopy snapshotting), or it's a granular
> > protect with distributed shared memory in which case the number of
> > changd ptes or huge_pmds tends to be always 1 anyway. So it doesn't
> > matter if it's deferred.
> > 
> > I agree it may require a larger tlb flush review not just mprotect
> > though, but it didn't sound particularly complex. Note the
> > UFFDIO_WRITEPROTECT is still relatively recent so backports won't
> > risk to reject so heavy as to require a band-aid.
> > 
> > My second thought is, I don't see exactly the bug and it's not clear
> > if it's upstream reproducing this, but assuming this happens on
> > upstream, even ignoring everything else happening in the tlb flush
> > code, this sounds like purely introduced by userfaultfd_writeprotect()
> > vs userfaultfd_writeprotect() (since it's the only place changing
> > protection with mmap_sem for reading and note we already unmap and
> > flush tlb with mmap_sem for reading in MADV_DONTNEED/MADV_FREE clears
> > the dirty bit etc..). Flushing tlbs with mmap_sem for reading is
> > nothing new, the only new thing is the flush after wrprotect.
> > 
> > So instead of altering any tlb flush code, would it be possible to
> > just stick to mmap_lock for reading and then serialize
> > userfaultfd_writeprotect() against itself with an additional
> > mm->mmap_wprotect_lock mutex? That'd be a very local change to
> > userfaultfd too.
> > 
> > Can you look if the rule mmap_sem for reading plus a new
> > mm->mmap_wprotect_lock mutex or the mmap_sem for writing, whenever
> > wrprotecting ptes, is enough to comply with the current tlb flushing
> > code, so not to require any change non local to uffd (modulo the
> > additional mutex).
> 
> So I did not fully understand your solution, but I took your point and
> looked again on similar cases. To be fair, despite my experience with these
> deferred TLB flushes as well as Peter Zijlstra’s great documentation, I keep
> getting confused (e.g., can’t we somehow combine tlb_flush_batched and
> tlb_flush_pending ?)
> 
> As I said before, my initial scenario was wrong, and the problem is not
> userfaultfd_writeprotect() racing against itself. This one seems actually
> benign to me.
> 
> Nevertheless, I do think there is a problem in change_protection_range().
> Specifically, see the aforementioned scenario of a race between
> madvise_dontneed_free() and userfaultfd_writeprotect().
> 
> So an immediate solution for such a case can be resolve without holding
> mmap_lock for write, by just adding a test for mm_tlb_flush_nested() in
> change_protection_range():
> 
>         /*
> 	 * Only flush the TLB if we actually modified any entries
> 	 * or if there are pending TLB flushes.
> 	 */
>         if (pages || mm_tlb_flush_nested(mm))
>                 flush_tlb_range(vma, start, end);
>  
> To be fair, I am not confident I did not miss other problematic cases.
> 
> But for now, this change, with the preserve_write change should address the
> immediate issues. Let me know if you agree.
> 
> Let me know whether you agree.

The problem starts in UFD, and is related to tlb flush. But its focal
point is in do_wp_page(). I'd suggest you look at function and see
what it does before and after the commits I listed, with the following
conditions

PageAnon(), !PageKsm(), !PageSwapCache(), !pte_write(),
page_mapcount() = 1, page_count() > 1 or PageLocked()

when it runs against the two UFD examples you listed.
