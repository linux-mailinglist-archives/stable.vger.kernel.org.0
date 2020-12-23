Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7B2E20B6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 20:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgLWTNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 14:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbgLWTNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 14:13:15 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C32C061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 11:12:29 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id q137so137908iod.9
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 11:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qb0tc7BydwYkZNXccd9OZJoWvelQk+CP47NzXiB2qoM=;
        b=krLppYrJggRrdIffbbHEWXkW8VcHhFvGxZPH9PGQmhQtxckNSvhsxahbfh/LDcIuEi
         yAxOBPQVTuyhiFnU5zIRuPySMrwU6A889Qh9hAUs3F8YoqksmsA9+fTf0YIY26ppK8RL
         mJAj4KuTmWxGhTMxHzT0amyp+WYQahh7/M1t8MQY1cGVpCtCz2A2p0t9Im0ACNhZi8Do
         E78Js58M5RxDCaPlIt4yE//4aE33cDHdswhXj26VGoZg4KIv+j78rQ78/SfznD++KNeY
         jz7kzsa8CFWpelOuUaeXnDhjtcocQvQ3WOLdaJXxtfDiLjmf2fTduAB3ETpLZINGOtrf
         Da2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qb0tc7BydwYkZNXccd9OZJoWvelQk+CP47NzXiB2qoM=;
        b=WeNbxfbaqX9J05Q9b5GLRCpyQUcS+GIXSbMgYIVcbYkqMRodSmMg5TkJV+reepkIzn
         istDLRwfGJYGHuG64niRZvy+tGaRSu428DZ9ValZS3fegK0P8wdYTLBqL8Wo2dWP+hw1
         ishTbcjskk8G5KhsFpraXhx1ic9LR/ZhSYS4MgLel9Ucth0RvYos1zu/mlRp0jaV+aBi
         UcieoGv8+1bIag/V54bblj7/m6OrDYifYB1VIctNqFM3VrTgNRDXRyubiysxySnoVH1P
         iLFZO+SWrqueWJEzyhbb1/0rFJcA3G+LmyqqwQNAxqbUVAb9qnIgl0U8lBoKlq1CFYUb
         +CsQ==
X-Gm-Message-State: AOAM531NreY2VM5ilyExL2sCoYG4Wr1Zt6yfwPaV2IsAte8Ra0q8OUei
        J9C2eEgY6CsTtelu52gYNC14KQ==
X-Google-Smtp-Source: ABdhPJz4a7OAQWBdn1CvL/P+G+4K+Opqz0lz3LESf8QB0QmYgHycQGi2Lz8Hm+xezfah7HwtTKha4g==
X-Received: by 2002:a02:a498:: with SMTP id d24mr23961590jam.4.1608750748680;
        Wed, 23 Dec 2020 11:12:28 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id m8sm25523711ioh.16.2020.12.23.11.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 11:12:28 -0800 (PST)
Date:   Wed, 23 Dec 2020 12:12:23 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+OWl0C51/06C8WT@google.com>
References: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
 <CAHk-=wjNv1GQn+8stK419HAqK0ofkJ1vOR9YSWSNjbW3T5as9A@mail.gmail.com>
 <X+MWppLjiR7hLgg9@google.com>
 <20201223162416.GD6404@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223162416.GD6404@xz-x1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 11:24:16AM -0500, Peter Xu wrote:
> On Wed, Dec 23, 2020 at 03:06:30AM -0700, Yu Zhao wrote:
> > On Wed, Dec 23, 2020 at 01:44:42AM -0800, Linus Torvalds wrote:
> > > On Tue, Dec 22, 2020 at 4:01 PM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > The more I look at the mprotect code, the less I like it. We seem to
> > > > be much better about the TLB flushes in other places (looking at
> > > > mremap, for example). The mprotect code seems to be very laissez-faire
> > > > about the TLB flushing.
> > > 
> > > No, this doesn't help.
> > > 
> > > > Does adding a TLB flush to before that
> > > >
> > > >         pte_unmap_unlock(pte - 1, ptl);
> > > >
> > > > fix things for you?
> > > 
> > > It really doesn't fix it. Exactly because - as pointed out earlier -
> > > the actual page *copy* happens outside the pte lock.
> > 
> > I appreciate all the pointers. It seems to me it does.
> > 
> > > So what can happen is:
> > > 
> > >  - CPU 1 holds the page table lock, while doing the write protect. It
> > > has cleared the writable bit, but hasn't flushed the TLB's yet
> > > 
> > >  - CPU 2 did *not* have the TLB entry, sees the new read-only state,
> > > takes a COW page fault, and reads the PTE from memory (into
> > > vmf->orig_pte)
> > 
> > In handle_pte_fault(), we lock page table and check pte_write(), so
> > we either see a RW pte before CPU 1 runs or a RO one with no stale tlb
> > entries after CPU 1 runs, assume CPU 1 flushes tlb while holding the
> > same page table lock (not mmap_lock).
> 
> I think this is not against Linus's example - where cpu2 does not have tlb
> cached so it sees RO while cpu3 does have tlb cached so cpu3 can still modify
> it.  So IMHO there's no problem here.

None of the CPUs has stale entries when CPU 2 sees a RO PTE. We are
assuming that TLB flush will be done on CPU 1 while it's still holding
page table lock.

CPU 2 (re)locks page table and (re)checks the PTE under question when
it decides if copy is necessary. If it sees a RO PTE, it means the
flush has been done on all CPUs, therefore it fixes the problem.

> But I do think in step 2 here we overlooked _PAGE_UFFD_WP bit.  Note that if
> it's uffd-wp wr-protection it's always applied along with removing of the write
> bit in change_pte_range():
> 
>         if (uffd_wp) {
>                 ptent = pte_wrprotect(ptent);
>                 ptent = pte_mkuffd_wp(ptent);
>         }
> 
> So instead of being handled as COW page do_wp_page() will always trap
> userfaultfd-wp first, hence no chance to race with COW.
> 
> COW could only trigger after another uffd-wp-resolve ioctl which could remove
> the _PAGE_UFFD_WP bit, but with Andrea's theory unprotect will only happen
> after all wr-protect completes, which guarantees that when reaching the COW
> path the tlb must has been flushed anyways.  Then no one should be modifying
> the page anymore even without pgtable lock in COW path.
> 
> So IIUC what Linus proposed on "flushing tlb within pgtable lock" seems to
> work, but it just may cause more tlb flush than Andrea's proposal especially
> when the protection range is large (it's common to have a huge protection range
> for e.g. VM live snapshotting, where we'll protect all guest rw ram).
> 
> My understanding of current issue is that either we can take Andrea's proposal
> (although I think the group rwsem may not be extremely better than a per-mm
> rwsem, which I don't know... at least not worst than that?), or we can also go
> the other way (also as Andrea mentioned) so that when wr-protect:
> 
>   - for <=2M range (pmd or less), we take read rwsem, but flush tlb within
>     pgtable lock
> 
>   - for >2M range, we take write rwsem directly but flush tlb once
>   
> Thanks,
> 
> > 
> > >  - CPU 2 correctly decides it needs to be a COW, and copies the page contents
> > > 
> > >  - CPU 3 *does* have a stale TLB (because TLB invalidation hasn't
> > > happened yet), and writes to that page in users apce
> > > 
> > >  - CPU 1 now does the TLB invalidate, and releases the page table lock
> > > 
> > >  - CPU 2 gets the page table lock, sees that its PTE matches
> > > vmf->orig_pte, and switches it to be that writable copy of the page.
> > > 
> > > where the copy happened before CPU 3 had stopped writing to the page.
> > > 
> > > So the pte lock doesn't actually matter, unless we actually do the
> > > page copy inside of it (on CPU2), in addition to doing the TLB flush
> > > inside of it (on CPU1).
> > > 
> > > mprotect() is actually safe for two independent reasons: (a) it does
> > > the mmap_sem for writing (so mprotect can't race with the COW logic at
> > > all), and (b) it changes the vma permissions so turning something
> > > read-only actually disables COW anyway, since it won't be a COW, it
> > > will be a SIGSEGV.
> > > 
> > > So mprotect() is irrelevant, other than the fact that it shares some
> > > code with that "turn it read-only in the page tables".
> > > 
> > > fork() is a much closer operation, in that it actually triggers that
> > > COW behavior, but fork() takes the mmap_sem for writing, so it avoids
> > > this too.
> > > 
> > > So it's really just userfaultfd and that kind of ilk that is relevant
> > > here, I think. But that "you need to flush the TLB before releasing
> > > the page table lock" was not true (well, it's true in other
> > > circumstances - just not *here*), and is not part of the solution.
> > > 
> > > Or rather, if it's part of the solution here, it would have to be
> > > matched with that "page copy needs to be done under the page table
> > > lock too".
> > > 
> > >               Linus
> > > 
> > 
> 
> -- 
> Peter Xu
> 
