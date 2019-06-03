Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA7C3266D
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 04:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFCCLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jun 2019 22:11:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34165 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfFCCLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Jun 2019 22:11:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id c85so863964pfc.1;
        Sun, 02 Jun 2019 19:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=70ySUXfZoJO6NGjc1E/FmmTs4bYAgjLgidrG3Ztqgro=;
        b=N0tPlhFS7EVIX0TmCmv3wtEGkv0GRdDQm9Mkd1iFCIhw0myxgTcujzr8uIsAswNqUu
         1tSsfFGqW5UFld1Rn5X/vM9f2Q7veliZaQoOmphthpjhTtWrFTtdEgGY/Kn9ulwCiuBN
         jUybSGR3DK843gMnNSjHw0AGxhWqDE7BjGlnzah2zzRg9SJdWt7jfgAHMhe+nwGr6sCz
         gKWaUN7xFeXwNJytNXX3ryCXvwF680blTWzI5VvyO037t3774Gn8Fa2y6JTj1gvwL+7k
         AQ30p11tZd2TY7yLrfV9WMNxNRJdScmJPwzz5nA8hzPl596txfj8lHqBfSs7turSBjug
         GHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=70ySUXfZoJO6NGjc1E/FmmTs4bYAgjLgidrG3Ztqgro=;
        b=nZwvL8AAH6SJkp576xz5xZnVWcwQOP3tuwNp9dxl/8tTXl7mOYSbxn8S4IFa6aBfmW
         8z3yYC68SCFAItM9Asc5Z8n34+aqng0npq+Q9nxGnfj/blyUxn5yAkdAk3jIVWtCqWar
         J7PjZ/XLPM62mfxZO4UciHptRAaiodr3GWxIR/chlP3lbMdartBDCmn+ktlFFh6aew7z
         cqlmxjJdOIYBKt6C0addXdjEN5TV5CNeMnsi1cpQdgo6GYo8WKCOtrJ5/9xlz7bqm4d9
         zqhTZBKQzDsg8aTBpD1ju5XVN30K6dDk65YwjrmKx20AuQUvY1UE1PhzFWf9Tfa2NMFw
         X39w==
X-Gm-Message-State: APjAAAXdjd3Eu3hvv56u1kcV6/2B6kAEHGOVUKs3Gb0D7/1gTfi/pK5L
        r0kOYQq4UoBpqdALYgxfo6o=
X-Google-Smtp-Source: APXvYqwl+QUMQbJKuqvWCqD/I3daFukmo+iJAwxSbBy2KoZGXbkZmLJoXdYt0vdo2IqjUbkW3ETjnA==
X-Received: by 2002:aa7:9212:: with SMTP id 18mr28384804pfo.120.1559527889129;
        Sun, 02 Jun 2019 19:11:29 -0700 (PDT)
Received: from localhost ([203.111.179.138])
        by smtp.gmail.com with ESMTPSA id y185sm3831872pfy.110.2019.06.02.19.11.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Jun 2019 19:11:28 -0700 (PDT)
Date:   Mon, 03 Jun 2019 12:11:38 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     akpm@linux-foundation.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        jstancek@redhat.com, mgorman@suse.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, namit@vmware.com,
        stable@vger.kernel.org, will.deacon@arm.com,
        yang.shi@linux.alibaba.com
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
        <20190527110158.GB2623@hirez.programming.kicks-ass.net>
        <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
        <20190527142552.GD2623@hirez.programming.kicks-ass.net>
        <1559270298.wiy8c3d4zs.astroid@bobo.none>
        <20190531094931.GM2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190531094931.GM2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1559527383.76rykleqz1.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Zijlstra's on May 31, 2019 7:49 pm:
> On Fri, May 31, 2019 at 12:46:56PM +1000, Nicholas Piggin wrote:
>> Peter Zijlstra's on May 28, 2019 12:25 am:
>> > On Mon, May 27, 2019 at 06:59:08PM +0530, Aneesh Kumar K.V wrote:
>> >> On 5/27/19 4:31 PM, Peter Zijlstra wrote:
>> >> > On Tue, May 21, 2019 at 04:18:33PM -0700, akpm@linux-foundation.org=
 wrote:
>> >> > > --- a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-=
force-flush
>> >> > > +++ a/mm/mmu_gather.c
>> >> > > @@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
>> >> > >   {
>> >> > >   	/*
>> >> > >   	 * If there are parallel threads are doing PTE changes on same=
 range
>> >> > > -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer=
 TLB
>> >> > > -	 * flush by batching, a thread has stable TLB entry can fail to=
 flush
>> >> > > -	 * the TLB by observing pte_none|!pte_dirty, for example so flu=
sh TLB
>> >> > > -	 * forcefully if we detect parallel PTE batching threads.
>> >> > > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defe=
r TLB
>> >> > > +	 * flush by batching, one thread may end up seeing inconsistent=
 PTEs
>> >> > > +	 * and result in having stale TLB entries.  So flush TLB forcef=
ully
>> >> > > +	 * if we detect parallel PTE batching threads.
>> >> > > +	 *
>> >> > > +	 * However, some syscalls, e.g. munmap(), may free page tables,=
 this
>> >> > > +	 * needs force flush everything in the given range. Otherwise t=
his
>> >> > > +	 * may result in having stale TLB entries for some architecture=
s,
>> >> > > +	 * e.g. aarch64, that could specify flush what level TLB.
>> >> > >   	 */
>> >> > >   	if (mm_tlb_flush_nested(tlb->mm)) {
>> >> > > +		/*
>> >> > > +		 * The aarch64 yields better performance with fullmm by
>> >> > > +		 * avoiding multiple CPUs spamming TLBI messages at the
>> >> > > +		 * same time.
>> >> > > +		 *
>> >> > > +		 * On x86 non-fullmm doesn't yield significant difference
>> >> > > +		 * against fullmm.
>> >> > > +		 */
>> >> > > +		tlb->fullmm =3D 1;
>> >> > >   		__tlb_reset_range(tlb);
>> >> > > -		__tlb_adjust_range(tlb, start, end - start);
>> >> > > +		tlb->freed_tables =3D 1;
>> >> > >   	}
>> >> > >   	tlb_flush_mmu(tlb);
>=20
>> > Maybe, but given the patch that went into -mm, PPC will never hit that
>> > branch I killed anymore -- and that really shouldn't be in architectur=
e
>> > code anyway.
>>=20
>> Yeah well if mm/ does this then sure it's dead and can go.
>>=20
>> I don't think it's very nice to set fullmm and freed_tables for this=20
>> case though. Is this concurrent zapping an important fast path? It
>> must have been, in order to justify all this complexity to the mm, so
>> we don't want to tie this boat anchor to it AFAIKS?
>=20
> I'm not convinced its an important fast path, afaict it is an
> unfortunate correctness issue caused by allowing concurrenct frees.

I mean -- concurrent freeing was an important fastpath, right?
And concurrent freeing means that you hit this case. So this
case itself should be important too.

>=20
>> Is the problem just that the freed page tables flags get cleared by
>> __tlb_reset_range()? Why not just remove that then, so the bits are
>> set properly for the munmap?
>=20
> That's insufficient; as argued in my initial suggestion:
>=20
>   https://lkml.kernel.org/r/20190509103813.GP2589@hirez.programming.kicks=
-ass.net
>=20
> Since we don't know what was flushed by the concorrent flushes, we must
> flush all state (page sizes, tables etc..).

Page tables should not be concurrently freed I think. Just don't clear
those page table free flags and it should be okay. Page sizes yes,
but we accommodated for that in the arch code. I could see reason to
add a flag to the gather struct like "concurrent_free" and set that
from the generic code, which the arch has to take care of.

> But it looks like benchmarks (for the one test-case we have) seem to
> favour flushing the world over flushing a smaller range.

Testing on 16MB unmap is possibly not a good benchmark, I didn't run
it exactly but it looks likely to go beyond the range flush threshold
and flush the entire PID anyway.

Thanks,
Nick

=
