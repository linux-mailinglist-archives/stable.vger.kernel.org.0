Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F4F306B7
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 04:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfEaCrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 22:47:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34176 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfEaCrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 22:47:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id w7so3355601plz.1;
        Thu, 30 May 2019 19:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=QWqfHsjUghbJuluGIm+n7TXYKiW/2yK5i56h8u43V+I=;
        b=fvANVSrmUwOPgCyDs9M4pQMPXj1nmCrBrGf6OcwYuhhggsgcHj9AI7MD1tR9LJ19GO
         +u6MIOnaSRlHMgrxmTdeX/OiVjNknq+oWQ8ItsyUENPDzukRL902M7mUfYHNreC51KAe
         XEwrqg6E0F3wxWtAGL5RcGMcTCUpv1Fbg2Or9BShZSzLT/TUx+aVo/EOOZTsFRxUcvDE
         J4t3FQdOiZEp3wNhQ778/mCelcBQEgkZ89p8ydIeoowVH6Npc/O/v7He3P17/Es1hxgj
         WI0a+Albz/8o3yEiGloSrsgsW0Y+GDdo9sK345FOAVQ7iT4DkCN8WrHOcP3tVd3kvoa1
         3t+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=QWqfHsjUghbJuluGIm+n7TXYKiW/2yK5i56h8u43V+I=;
        b=bhcpV+Tm1e+niDfJGzx/1EWOZc+PjBVJjx7QuBowYufGeZrdXAiW8WBYFJqg7+d6/V
         tFENYWDOUQOcBYK8VUGL1XcteTpca/juJJvzINdekLCrtcXQSbEmxStxo+d7gMZ/13JI
         JeBazHvdoBZRT0nObPFL2Kz2ygypFAOX/YEiVumq8Cq2RsLLofTm3B06xwPOhGquui2O
         jvq5A4NKp5cFCljewIFZeKj6JOSeOQBCI8rVZW/xbTRMCiTwITIyQqUuqGRhfn+X5+8r
         +aW1RiBza/HJbbDsIXSdmt4Cxbk7ZzcmnMXZhJhc4jsFFCu/2Qh2WkryqBaP7wJNIcDJ
         ypqw==
X-Gm-Message-State: APjAAAVvsnhcSyj8yU5VzSumVwpOcOlIYkob1zGwSSbW933Bbg0SjhHE
        u2GbhnxHUSLIvwPDQPNklMY=
X-Google-Smtp-Source: APXvYqy4DIi3vUHKmcNqksUZl2qvXGv9N3fdOekYdOznOsyhgJzy2mHA4RVsJMxqyNMolCb0JvuUFg==
X-Received: by 2002:a17:902:20eb:: with SMTP id v40mr6641002plg.239.1559270836028;
        Thu, 30 May 2019 19:47:16 -0700 (PDT)
Received: from localhost (193-116-81-133.tpgi.com.au. [193.116.81.133])
        by smtp.gmail.com with ESMTPSA id j20sm4450991pfi.138.2019.05.30.19.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 19:47:15 -0700 (PDT)
Date:   Fri, 31 May 2019 12:46:56 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     akpm@linux-foundation.org, jstancek@redhat.com, mgorman@suse.de,
        minchan@kernel.org, mm-commits@vger.kernel.org, namit@vmware.com,
        stable@vger.kernel.org, will.deacon@arm.com,
        yang.shi@linux.alibaba.com
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
        <20190527110158.GB2623@hirez.programming.kicks-ass.net>
        <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
        <20190527142552.GD2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190527142552.GD2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1559270298.wiy8c3d4zs.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Zijlstra's on May 28, 2019 12:25 am:
> On Mon, May 27, 2019 at 06:59:08PM +0530, Aneesh Kumar K.V wrote:
>> On 5/27/19 4:31 PM, Peter Zijlstra wrote:
>> > On Tue, May 21, 2019 at 04:18:33PM -0700, akpm@linux-foundation.org wr=
ote:
>> > > --- a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-for=
ce-flush
>> > > +++ a/mm/mmu_gather.c
>> > > @@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
>> > >   {
>> > >   	/*
>> > >   	 * If there are parallel threads are doing PTE changes on same ra=
nge
>> > > -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TL=
B
>> > > -	 * flush by batching, a thread has stable TLB entry can fail to fl=
ush
>> > > -	 * the TLB by observing pte_none|!pte_dirty, for example so flush =
TLB
>> > > -	 * forcefully if we detect parallel PTE batching threads.
>> > > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer T=
LB
>> > > +	 * flush by batching, one thread may end up seeing inconsistent PT=
Es
>> > > +	 * and result in having stale TLB entries.  So flush TLB forcefull=
y
>> > > +	 * if we detect parallel PTE batching threads.
>> > > +	 *
>> > > +	 * However, some syscalls, e.g. munmap(), may free page tables, th=
is
>> > > +	 * needs force flush everything in the given range. Otherwise this
>> > > +	 * may result in having stale TLB entries for some architectures,
>> > > +	 * e.g. aarch64, that could specify flush what level TLB.
>> > >   	 */
>> > >   	if (mm_tlb_flush_nested(tlb->mm)) {
>> > > +		/*
>> > > +		 * The aarch64 yields better performance with fullmm by
>> > > +		 * avoiding multiple CPUs spamming TLBI messages at the
>> > > +		 * same time.
>> > > +		 *
>> > > +		 * On x86 non-fullmm doesn't yield significant difference
>> > > +		 * against fullmm.
>> > > +		 */
>> > > +		tlb->fullmm =3D 1;
>> > >   		__tlb_reset_range(tlb);
>> > > -		__tlb_adjust_range(tlb, start, end - start);
>> > > +		tlb->freed_tables =3D 1;
>> > >   	}
>> > >   	tlb_flush_mmu(tlb);
>> >=20
>> > Nick, Aneesh, can we now do this?

Sorry I meant to get to that but forgot.

>> >=20
>> > ---
>> >=20
>> > diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/bo=
ok3s64/radix_tlb.c
>> > index 4d841369399f..8d28b83914cb 100644
>> > --- a/arch/powerpc/mm/book3s64/radix_tlb.c
>> > +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
>> > @@ -881,39 +881,6 @@ void radix__tlb_flush(struct mmu_gather *tlb)
>> >   	 */
>> >   	if (tlb->fullmm) {
>> >   		__flush_all_mm(mm, true);
>> > -#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PA=
GE)
>> > -	} else if (mm_tlb_flush_nested(mm)) {
>> > -		/*
>> > -		 * If there is a concurrent invalidation that is clearing ptes,
>> > -		 * then it's possible this invalidation will miss one of those
>> > -		 * cleared ptes and miss flushing the TLB. If this invalidate
>> > -		 * returns before the other one flushes TLBs, that can result
>> > -		 * in it returning while there are still valid TLBs inside the
>> > -		 * range to be invalidated.
>> > -		 *
>> > -		 * See mm/memory.c:tlb_finish_mmu() for more details.
>> > -		 *
>> > -		 * The solution to this is ensure the entire range is always
>> > -		 * flushed here. The problem for powerpc is that the flushes
>> > -		 * are page size specific, so this "forced flush" would not
>> > -		 * do the right thing if there are a mix of page sizes in
>> > -		 * the range to be invalidated. So use __flush_tlb_range
>> > -		 * which invalidates all possible page sizes in the range.
>> > -		 *
>> > -		 * PWC flush probably is not be required because the core code
>> > -		 * shouldn't free page tables in this path, but accounting
>> > -		 * for the possibility makes us a bit more robust.
>> > -		 *
>> > -		 * need_flush_all is an uncommon case because page table
>> > -		 * teardown should be done with exclusive locks held (but
>> > -		 * after locks are dropped another invalidate could come
>> > -		 * in), it could be optimized further if necessary.
>> > -		 */
>> > -		if (!tlb->need_flush_all)
>> > -			__radix__flush_tlb_range(mm, start, end, true);
>> > -		else
>> > -			radix__flush_all_mm(mm);
>> > -#endif
>> >   	} else if ( (psize =3D radix_get_mmu_psize(page_size)) =3D=3D -1) {
>> >   		if (!tlb->need_flush_all)
>> >   			radix__flush_tlb_mm(mm);
>> >=20
>>=20
>>=20
>> I guess we can revert most of the commit
>> 02390f66bd2362df114a0a0770d80ec33061f6d1. That is the only place we flus=
h
>> multiple page sizes? . But should we evaluate the performance impact of =
that
>> fullmm flush on ppc64?
>=20
> Maybe, but given the patch that went into -mm, PPC will never hit that
> branch I killed anymore -- and that really shouldn't be in architecture
> code anyway.

Yeah well if mm/ does this then sure it's dead and can go.

I don't think it's very nice to set fullmm and freed_tables for this=20
case though. Is this concurrent zapping an important fast path? It
must have been, in order to justify all this complexity to the mm, so
we don't want to tie this boat anchor to it AFAIKS?

Is the problem just that the freed page tables flags get cleared by
__tlb_reset_range()? Why not just remove that then, so the bits are
set properly for the munmap?

> Also; as I noted last time: __radix___flush_tlb_range() and
> __radix__flush_tlb_range_psize() look similar enough that they might
> want to be a single function (and instead of @flush_all_sizes, have it
> take @gflush, @hflush, @flush and @pwc).

Yeah, it could possibly use a cleanup pass. I have a few patches
sitting around to make a few more optimisations around the place,
was going to look at some refactoring after that.

Thanks,
Nick
=
