Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1218B2E1AC1
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 11:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgLWKHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 05:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgLWKHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 05:07:16 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7394C0613D3
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 02:06:35 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id n4so14597978iow.12
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 02:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TsZfeXRM1ReVd7eBjQcIMfaYnF6JpJXqu5pz2p0wGEQ=;
        b=CNmoLodAEpv7gOwb8VpGyiCO30xoo2vCseCl7Eji3i9ZVItKzd5J+ZHmP4Q90yW9SF
         v9/P4uSVz7jVdIkY/Q7aJORA3LOHdltQkbnFMryoxugSt3lIs3VvpBheK+VoEHaroXxq
         GrILcIEPhED0FYieTZbeY6px2c/7Y+7nHdeWGGqdoSpqu0F+ojsemeGhHiIY8iO5KauO
         vYeFCrHb+nlpRHSDYs+V3QZIxHwep2HohggzXgELErQKjWM2g8p/N9RjYIY+sOMCzknf
         W/tq16osSog5ItcqmtldMo0KTddd4OEAdZzG2SgrPWKfdkqAfUfij21WlwmTwR4h8ro5
         yNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TsZfeXRM1ReVd7eBjQcIMfaYnF6JpJXqu5pz2p0wGEQ=;
        b=Wkv+d68U70kf6bILZmX2RJGJ/q7AgmpgdF/Cz3Sao4o3SZ3H0K4pXE9I1yReRGAVjf
         yaUJ1iZASKZmDBTzhXbR2+3gjSVxvko5pi7HGujkvMozObsa5/sPJbGkWwErWXW0ZlvI
         TLXiRB0LExIR859DnMzJ33vpTSWtqWpC/OsPoqtfVX3Wz+lRgqUHifRUiWqMNh/19W2B
         tFR83ZXUhLVtXF1cqO+bGfLG0vDGbR3ykBbv1MQ2vziJQM/wlcVRckp+IzYq7xybIAXr
         eJfuySeSWLKyZGyXpPeMola9iL4XwgOzRqM7XbwhporQB4R+MPepsJlu66kV7Ky1miZ9
         XHsw==
X-Gm-Message-State: AOAM532Zn1gKRww7mCYBR9RMbQzgBm7GjsQm1yD7GPcatimjU+muUo71
        w6ZXt7AwphyfrChVgqacrLhxEA==
X-Google-Smtp-Source: ABdhPJzBINtZwYQUDT2fyB7vaQAbu2xabNp/ZkzWZgkh5VIkMKAYi1A0wfAjRz9FwcP8I8BS4yHZEQ==
X-Received: by 2002:a05:6602:387:: with SMTP id f7mr21085021iov.209.1608717994800;
        Wed, 23 Dec 2020 02:06:34 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id 12sm17304825ily.42.2020.12.23.02.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 02:06:34 -0800 (PST)
Date:   Wed, 23 Dec 2020 03:06:30 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
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
Message-ID: <X+MWppLjiR7hLgg9@google.com>
References: <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
 <CAHk-=wjNv1GQn+8stK419HAqK0ofkJ1vOR9YSWSNjbW3T5as9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjNv1GQn+8stK419HAqK0ofkJ1vOR9YSWSNjbW3T5as9A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 01:44:42AM -0800, Linus Torvalds wrote:
> On Tue, Dec 22, 2020 at 4:01 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The more I look at the mprotect code, the less I like it. We seem to
> > be much better about the TLB flushes in other places (looking at
> > mremap, for example). The mprotect code seems to be very laissez-faire
> > about the TLB flushing.
> 
> No, this doesn't help.
> 
> > Does adding a TLB flush to before that
> >
> >         pte_unmap_unlock(pte - 1, ptl);
> >
> > fix things for you?
> 
> It really doesn't fix it. Exactly because - as pointed out earlier -
> the actual page *copy* happens outside the pte lock.

I appreciate all the pointers. It seems to me it does.

> So what can happen is:
> 
>  - CPU 1 holds the page table lock, while doing the write protect. It
> has cleared the writable bit, but hasn't flushed the TLB's yet
> 
>  - CPU 2 did *not* have the TLB entry, sees the new read-only state,
> takes a COW page fault, and reads the PTE from memory (into
> vmf->orig_pte)

In handle_pte_fault(), we lock page table and check pte_write(), so
we either see a RW pte before CPU 1 runs or a RO one with no stale tlb
entries after CPU 1 runs, assume CPU 1 flushes tlb while holding the
same page table lock (not mmap_lock).

>  - CPU 2 correctly decides it needs to be a COW, and copies the page contents
> 
>  - CPU 3 *does* have a stale TLB (because TLB invalidation hasn't
> happened yet), and writes to that page in users apce
> 
>  - CPU 1 now does the TLB invalidate, and releases the page table lock
> 
>  - CPU 2 gets the page table lock, sees that its PTE matches
> vmf->orig_pte, and switches it to be that writable copy of the page.
> 
> where the copy happened before CPU 3 had stopped writing to the page.
> 
> So the pte lock doesn't actually matter, unless we actually do the
> page copy inside of it (on CPU2), in addition to doing the TLB flush
> inside of it (on CPU1).
> 
> mprotect() is actually safe for two independent reasons: (a) it does
> the mmap_sem for writing (so mprotect can't race with the COW logic at
> all), and (b) it changes the vma permissions so turning something
> read-only actually disables COW anyway, since it won't be a COW, it
> will be a SIGSEGV.
> 
> So mprotect() is irrelevant, other than the fact that it shares some
> code with that "turn it read-only in the page tables".
> 
> fork() is a much closer operation, in that it actually triggers that
> COW behavior, but fork() takes the mmap_sem for writing, so it avoids
> this too.
> 
> So it's really just userfaultfd and that kind of ilk that is relevant
> here, I think. But that "you need to flush the TLB before releasing
> the page table lock" was not true (well, it's true in other
> circumstances - just not *here*), and is not part of the solution.
> 
> Or rather, if it's part of the solution here, it would have to be
> matched with that "page copy needs to be done under the page table
> lock too".
> 
>               Linus
> 
