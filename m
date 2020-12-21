Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547052E017A
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 21:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgLUUVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 15:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgLUUVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 15:21:52 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBB5C0613D6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:21:11 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id t9so10045939ilf.2
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=39yturDQFY/cvVTZmJmushizui4zmBufjTYAX1ZRVr4=;
        b=AsNW8sxxEEVT9w5tme1yJxKp9Dl95DhTmg+u63fBnsSTtdk9NJRMhf4ZW9FyvNXDNF
         c6zk+d9yjb29quTJe78WAH/vR4vrgewSuHtG6UVuM2bTAO57IcV7hqwAw/WelEzPTK9p
         EWrI8JVYWH33S5IpvS72BL7JfexOp1pLjHVso/vJQVec9ExiDjskynoTD2sxPPTryjh+
         ht+NtbaQNP7/qs2QmR0PEysPS/FtEEJnqhFm+GxGLmVXSe07QP9WEzIP4B8YKgW/lhP/
         srzgWHOhT/1PLIvn1fnLAmkNaa66fIVZtMM8TNOrWynt2AN+6uKiySazdlRptjObqMCh
         nXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=39yturDQFY/cvVTZmJmushizui4zmBufjTYAX1ZRVr4=;
        b=sKuyfBOCxY2n8/tlcRaeMFEOm9dwt2muVBrsJGcN7lNYCb1LgJ9F/X8WoojtcdV/t2
         pTEcEpxA0VX/X4weJed5R+cSm/5S+Uxi8s3GGv/PQu70opFm65ZFo8XjH0txyKU2ed96
         J00okyDgDhHpDDGojO0ymzZjL/AboYfA6ZqWAbp5V+vYugsObvb7g6V07Cze26zgNbts
         Y7BbqnJ9Y5bDSHUQFJMTDB9YINvJ6dU20iRtp/27i0WBnlNk6LdpP9PObjvtpcVwP4M3
         bEGnYI50dMKHwegJuneYit8U5tpEyDw2dUXGMNaTMyWl3GVwliBCdad/31U+BsH7Tb4U
         lQag==
X-Gm-Message-State: AOAM532jIsXZJvDZqqGW3vB3eaf2Tmx3FAV/UNmXAz3pJ0gxdCecCoaw
        vYBojTO664WX1OhAXPgTqFyN9g==
X-Google-Smtp-Source: ABdhPJxcCE/izSGRkZZ/8WMAn5Fu6c2zGo1sMI3bumbFrTE9aeKshhtCCKIglCHfJBwjFsrgImvP1w==
X-Received: by 2002:a92:c26c:: with SMTP id h12mr17219261ild.165.1608582070907;
        Mon, 21 Dec 2020 12:21:10 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id m7sm21272065iow.46.2020.12.21.12.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 12:21:10 -0800 (PST)
Date:   Mon, 21 Dec 2020 13:21:06 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+EDslLVp9yRRru6@google.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 11:55:02AM -0800, Linus Torvalds wrote:
> On Mon, Dec 21, 2020 at 11:16 AM Yu Zhao <yuzhao@google.com> wrote:
> >
> > Nadav Amit found memory corruptions when running userfaultfd test above.
> > It seems to me the problem is related to commit 09854ba94c6a ("mm:
> > do_wp_page() simplification"). Can you please take a look? Thanks.
> >
> > TL;DR: it may not safe to make copies of singly mapped (non-COW) pages
> > when it's locked or has additional ref count because concurrent
> > clear_soft_dirty or change_pte_range may have removed pte_write but yet
> > to flush tlb.
> 
> Hmm. The TLB flush shouldn't actually matter, because anything that
> changes the writable bit had better be serialized by the page table
> lock.

Well, unfortunately we have places that use optimizations like

  inc_tlb_flush_pending()
    lock page table
      pte_wrprotect
  flush_tlb_range()
  dec_tlb_flush_pending()

which complicate things. And usually checking mm_tlb_flush_pending()
in addition to pte_write() (while holding page table lock) would fix
the similar problems. But for this one, doing so apparently isn't as
straightforward or the best solution.

> Yes, we often load the page table value without holding the page table
> lock (in order to know what we are going to do), but then before we
> finalize the operation, we then re-check - undet the page table lock -
> that the value we loaded still matches.
> 
> But I think I see what *MAY* be going on.  The userfaultfd
> mwriteprotect_range() code takes the mm lock for _reading_. Which
> means that you can have
> 
> Thread A     Thread B
> 
>  - fault starts. Sees write-protected pte, allocates memory, copies data
> 
>                    - userfaultfd makes the regions writable
> 
>                    - usefaultfd case writes to the region
> 
>                    - userfaultfd makes region non-writable
> 
>  - fault continues, gets the page table lock, sees that the pte is the
> same, uses old copied data
> 
> But if this is what's happening, I think it's a userfaultfd bug. I
> think the mmap_read_lock(dst_mm) in mwriteprotect_range() needs to be
> a mmap_write_lock().
> 
> mprotect() does this right, it looks like userfaultfd does not. You
> cannot just change the writability of a page willy-nilly without the
> correct locking.
> 
> Maybe there are other causes, but this one stands out to me as one
> possible cause.
> 
> Comments?
> 
>               Linus
