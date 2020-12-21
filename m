Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B448C2DF85B
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 05:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgLUEpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 23:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgLUEpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 23:45:05 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B452C061282
        for <stable@vger.kernel.org>; Sun, 20 Dec 2020 20:44:25 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id g1so7775535ilk.7
        for <stable@vger.kernel.org>; Sun, 20 Dec 2020 20:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=p8JksJ1UE+8rqp4HYul0mL9E6FM1BsI4Tkdvg3Hw2OY=;
        b=R1h03FujlY+KgN5boGgDxp45kSuW98V/MCScMBkzOiKe02XkYO8H8H0Ilp0WctVBsN
         v+dpxuv17skD1Ux1jEuCx+2nPsM7GHd3Hl2pvGl5BRe0zRfmxpd24I7ra4FIcqTiQJZV
         5cFk+m/AgBYi8V8K1lLtFX2G0143VugwnvFmAWxWHIiZKRqkFsrnZjE/kDSjrkVoVwiU
         1rSTz40MZ4E4lspUpO+A4egnLtrkg/QtaT6FPikQLR7MGSAkB7GCkaDO4p+tVE8exRTD
         KulBRNcUBr+GtUVnC/7y/ZhdK/bROJdDFPRpIq5I0TXofzfBlKUvcHNIx/YHzl6ACNuE
         tj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=p8JksJ1UE+8rqp4HYul0mL9E6FM1BsI4Tkdvg3Hw2OY=;
        b=jVdbkTaqFm9aGJ7sa1JHMokZNlD+T5oQvDQ9/5bdUPl7Q5eesNvjPzkxdTwoQv0MUc
         NpzQVF7tQYvFz8r/TMnaPwwERZ77r/WARMKkaFupgTlDifi0kx57OpbEh1gGZJEGaf0u
         7QPoWpNhYGJMWUvG6OWAkpHfs6oo/JPJh44k40voeCk+78I/jrJ8GI2INmOYhBJqrA2/
         lvsVN25sGepLku24XasBupa/EuOrXwS2/u7LgYXyUcroag71u7nqCd+Gc+Ti5PeltMeV
         93oUVMMksI8mPYpZicrwsYtJI/v8scCgTlm09BDWBP5u1sdZ6aJR2+dtQTvf55+DhLM3
         ufpQ==
X-Gm-Message-State: AOAM530WSrM0NWWqbfp/6B+PhB2KTf7f7MLyEx7TIH/ZELRNI8v5aP/O
        kJAxgBlVcASogeENkMenss7o+g==
X-Google-Smtp-Source: ABdhPJwrDHPeqcY3HZhvnXxaX4FDb199mgH0soAhXc71NIMSD+41+jSEqh4vkN90QyGaFMwqWa9P9g==
X-Received: by 2002:a92:ce47:: with SMTP id a7mr15272146ilr.261.1608525864712;
        Sun, 20 Dec 2020 20:44:24 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id q5sm12155640ile.48.2020.12.20.20.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 20:44:23 -0800 (PST)
Date:   Sun, 20 Dec 2020 21:44:19 -0700
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
Message-ID: <X+AoIwSqkKMo7Oxg@google.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <X98fZOiLNmnDQKhN@google.com>
 <3680387D-65F1-4078-A19D-F77DE8544B96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3680387D-65F1-4078-A19D-F77DE8544B96@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 20, 2020 at 07:33:09PM -0800, Nadav Amit wrote:
> > On Dec 20, 2020, at 1:54 AM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Sun, Dec 20, 2020 at 12:06:38AM -0800, Nadav Amit wrote:
> >>> On Dec 19, 2020, at 10:05 PM, Yu Zhao <yuzhao@google.com> wrote:
> >>> 
> >>> On Sat, Dec 19, 2020 at 01:34:29PM -0800, Nadav Amit wrote:
> >>>> [ cc’ing some more people who have experience with similar problems ]
> >>>> 
> >>>>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >>>>> 
> >>>>> Hello,
> >>>>> 
> >>>>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> >>>>>> Analyzing this problem indicates that there is a real bug since
> >>>>>> mmap_lock is only taken for read in mwriteprotect_range(). This might
> >>>>> 
> >>>>> Never having to take the mmap_sem for writing, and in turn never
> >>>>> blocking, in order to modify the pagetables is quite an important
> >>>>> feature in uffd that justifies uffd instead of mprotect. It's not the
> >>>>> most important reason to use uffd, but it'd be nice if that guarantee
> >>>>> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> >>>>> other pgtable manipulations.
> >>>>> 
> >>>>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> >>>>>> 
> >>>>>> cpu0				cpu1
> >>>>>> ----				----
> >>>>>> userfaultfd_writeprotect()
> >>>>>> [ write-protecting ]
> >>>>>> mwriteprotect_range()
> >>>>>> mmap_read_lock()
> >>>>>> change_protection()
> >>>>>> change_protection_range()
> >>>>>> ...
> >>>>>> change_pte_range()
> >>>>>> [ defer TLB flushes]
> >>>>>> 				userfaultfd_writeprotect()
> >>>>>> 				 mmap_read_lock()
> >>>>>> 				 change_protection()
> >>>>>> 				 [ write-unprotect ]
> >>>>>> 				 ...
> >>>>>> 				  [ unprotect PTE logically ]
> >>>>>> 				...
> >>>>>> 				[ page-fault]
> >>>>>> 				...
> >>>>>> 				wp_page_copy()
> >>>>>> 				[ set new writable page in PTE]
> >>> 
> >>> I don't see any problem in this example -- wp_page_copy() calls
> >>> ptep_clear_flush_notify(), which should take care of the stale entry
> >>> left by cpu0.
> >>> 
> >>> That being said, I suspect the memory corruption you observed is
> >>> related this example, with cpu1 running something else that flushes
> >>> conditionally depending on pte_write().
> >>> 
> >>> Do you know which type of pages were corrupted? file, anon, etc.
> >> 
> >> First, Yu, you are correct. My analysis is incorrect, but let me have
> >> another try (below). To answer your (and Andrea’s) question - this happens
> >> with upstream without any changes, excluding a small fix to the selftest,
> >> since it failed (got stuck) due to missing wake events. [1]
> >> 
> >> We are talking about anon memory.
> >> 
> >> So to correct myself, I think that what I really encountered was actually
> >> during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). The
> >> problem was that in this case the “write”-bit was removed during unprotect.
> > 
> > Thanks. You are right about when the problem happens: UFD write-
> > UNprotecting. But it's not UFD write-UNprotecting that removes the
> > writable bit -- the bit can only be removed during COW or UFD
> > write-protecting. So your original example was almost correct, except
> > the last line describing cpu1.
> 
> The scenario is a bit confusing, so stay with me. The idea behind uffd
> unprotect is indeed only to mark the PTE logically as uffd-unprotected, and
> not to *set* the writable bit, allowing the #PF handler to do COW or
> whatever correctly upon #PF.

Right.

> However, the problem that we have is that if a page is already writable,
> write-unprotect *clears* the writable bit, making it write-protected (at
> least for anonymous pages). This is not good from performance point-of-view,
> but also a correctness issue, as I pointed out.
> 
> In some more detail: mwriteprotect_range() uses vm_get_page_prot() to
> compute the new protection. For anonymous private memory, at least on x86,
> this means the write-bit in the protection is clear. So later,
> change_pte_range() *clears* the write-bit during *unprotection*.

Agreed.

> That’s the reason the second part of my patch - the change to preserve_write
> - fixes the problem.

Yes, it fixes a part of the problem.

But what if there is no writable bit there for you to preserve? If the
bit was cleared by COW, e.g., KSM, fork, etc., no problem, because they
guarantee the flush. If it was cleared by a priory UFD write-protecting,
you still would run into the same problem because of the deterred flush.
And you are trying to fix this part of the problem by grabbing
mmap_write_lock. I think I understand your patch correctly.

Both parts of the problem were introduced by the commits I listed, and
your patch does fix the problem. I'm just saying it's not an optimal fix
because for the second part of the problem:
1) there is no need to grab mmap_write_lock
2) there is no need to make a copy in do_wp_page() if the write bit was
cleared by UFD write-protecting (non-COW case).

The fix should be done in do_wp_page(), i.e., to handle non-COW pages
correctly. Preserving the write bit can be considered separately as an
optimization, not a fix. (It eliminates unnecessary page faults.)

> > The problem is how do_wp_page() handles non-COW pages. (For COW pages,
> > do_wp_page() works correctly by either reusing an existing page or
> > make a new copy out of it.) In UFD case, the existing page may not
> > have been properly write-protected. As you pointed out, the tlb flush
> > may not be done yet. Making a copy can potentially race with the
> > writer on cpu2.
> 
> Just to clarify the difference - You regard a scenario of UFFD
> write-protect, while I am pretty sure the problem I encountered is during
> write-unprotect.
> 
> I am not sure we are on the same page (but we may be). The problem I have is
> with cow_user_page() that is called by do_wp_page() before any TLB flush
> took place (either by change_protection_range() or by do_wp_page() which
> does flush, but after the copy).
> 
> Let me know if you regard a different scenario.
> 
> > Should we fix the problem by ensuring integrity of the copy? IMO, no,
> > because do_wp_page() shouldn't copy at all in this case. It seems it
> > was recently broken by
> > 
> >  be068f29034f mm: fix misplaced unlock_page in do_wp_page()
> >  09854ba94c6a mm: do_wp_page() simplification
> > 
> > I haven't study them carefully. But if you could just revert them and
> > run the test again, we'd know where exactly to look at next.
> 
> These patches regard the wp_page_reuse() case, which makes me think we
> are not on the same page. I do not see a problem with wp_page_reuse()
> since it does not make a copy of the page. If you can explain what I
> am missing, it would be great.
> 
