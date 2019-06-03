Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973E9331C3
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfFCOKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:10:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45335 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfFCOKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:10:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id s11so10679009pfm.12;
        Mon, 03 Jun 2019 07:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=VKqpqAFaCBGCDN4rU6pWhi0CyqoEKXjeqNPt6iWhCpI=;
        b=bKQAO2zERGpvGjCFziWoIAO/+QmYU5btmareALnnQGSUK2lxpsYvIheMeTQw0dSUl6
         Cml5PhojgRlpvHdXLTDPu3lR7MaYe6tFcGn8QCtcbZVjz35XMQqVsDcTVv/7Um8k0Zsj
         EmxI/h1Jb8WVdImyMP2zepDpAYoxaL0wrdnDSkUxuwZtakRxaUosBUfYKfx/+h/RP1J8
         OGjW4XUfi6IjZu3Fivowrf6hTaSpI6cbYgEnucuCBJI5sX7PSjLJ8Zd/pT5sFd0Ficjl
         SNdVTVXcus1J5OxrSjgMcc2T6lqQKMXKj70yyIvDXZeKVw6Qxo77B0MeBqsyeEq0r+nb
         uI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=VKqpqAFaCBGCDN4rU6pWhi0CyqoEKXjeqNPt6iWhCpI=;
        b=oQnBwdyTA7gS8h1+ffFtre3nT3nxOa3NyTKhQZtzyTSWbGANZZP5/q0IBG/c5O3OLU
         C/yQ3RiCoD2t0abNefnHqEPIL4o6kHWCaMA7xRrcdcLcaORndWCoV8u7n7DmRtt8ewJY
         zDw+5EibvhMsdRhzUhnsjpTtvOIr+EOXeKy/3WH9TIvJIm9cCJ820ESnG6TEJCrOO0h9
         6BLe+23ocElouibSx6F2aLbaHJP8tPeyA1yc/i5xq3U6Bu2WTNra2MhH0ORkaUdJG72A
         ojbe0b0DsCVO39S+uKPYhaeMpwRF1Aca0RgBtrkDQAmv95QNI1jTKe8q0GJe3a8pM78O
         MH4Q==
X-Gm-Message-State: APjAAAV2+JeipPwMMNiujlQJ9qWH07MJ3vg0dkeViydC3T+7XCECJAHz
        UTNXdWYhb75HL7wNWynfIhI=
X-Google-Smtp-Source: APXvYqzgEPlr4hYf6RHJukHoJftOw4dWUmUGHHp/fttfqzwHHtjMNJTaE5ERxMLe0khShB+fJhQnVQ==
X-Received: by 2002:a17:90a:c503:: with SMTP id k3mr30727376pjt.46.1559571047873;
        Mon, 03 Jun 2019 07:10:47 -0700 (PDT)
Received: from localhost (60-240-187-127.tpgi.com.au. [60.240.187.127])
        by smtp.gmail.com with ESMTPSA id k2sm15053724pje.16.2019.06.03.07.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 07:10:43 -0700 (PDT)
Date:   Tue, 04 Jun 2019 00:10:37 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
To:     Will Deacon <will.deacon@arm.com>
Cc:     akpm@linux-foundation.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        jstancek@redhat.com, mgorman@suse.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, namit@vmware.com,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        yang.shi@linux.alibaba.com
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
        <20190527110158.GB2623@hirez.programming.kicks-ass.net>
        <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
        <20190527142552.GD2623@hirez.programming.kicks-ass.net>
        <1559270298.wiy8c3d4zs.astroid@bobo.none>
        <20190531094931.GM2623@hirez.programming.kicks-ass.net>
        <1559527383.76rykleqz1.astroid@bobo.none>
        <20190603103009.GB27507@fuggles.cambridge.arm.com>
In-Reply-To: <20190603103009.GB27507@fuggles.cambridge.arm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1559569861.n3f6bbdn43.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Will Deacon's on June 3, 2019 8:30 pm:
> Hi Nick,
>=20
> On Mon, Jun 03, 2019 at 12:11:38PM +1000, Nicholas Piggin wrote:
>> Peter Zijlstra's on May 31, 2019 7:49 pm:
>> > On Fri, May 31, 2019 at 12:46:56PM +1000, Nicholas Piggin wrote:
>> >> I don't think it's very nice to set fullmm and freed_tables for this=20
>> >> case though. Is this concurrent zapping an important fast path? It
>> >> must have been, in order to justify all this complexity to the mm, so
>> >> we don't want to tie this boat anchor to it AFAIKS?
>> >=20
>> > I'm not convinced its an important fast path, afaict it is an
>> > unfortunate correctness issue caused by allowing concurrenct frees.
>>=20
>> I mean -- concurrent freeing was an important fastpath, right?
>> And concurrent freeing means that you hit this case. So this
>> case itself should be important too.
>=20
> I honestly don't think we (Peter and I) know. Our first involvement with
> this was because TLBs were found to contain stale user entries:
>=20
> https://lore.kernel.org/linux-arm-kernel/1817839533.20996552.155706544523=
3.JavaMail.zimbra@redhat.com/
>=20
> so the initial work to support the concurrent freeing was done separately
> and, I assume, motivated by some real workloads. I would also very much
> like to know more about that, since nothing remotely realistic has surfac=
ed
> in this discussion, other than some historical glibc thing which has long
> since been fixed.

Well, it seems like it is important. While the complexity is carried
in the mm, we should not skimp on this last small piece.

>> >> Is the problem just that the freed page tables flags get cleared by
>> >> __tlb_reset_range()? Why not just remove that then, so the bits are
>> >> set properly for the munmap?
>> >=20
>> > That's insufficient; as argued in my initial suggestion:
>> >=20
>> >   https://lkml.kernel.org/r/20190509103813.GP2589@hirez.programming.ki=
cks-ass.net
>> >=20
>> > Since we don't know what was flushed by the concorrent flushes, we mus=
t
>> > flush all state (page sizes, tables etc..).
>>=20
>> Page tables should not be concurrently freed I think. Just don't clear
>> those page table free flags and it should be okay. Page sizes yes,
>> but we accommodated for that in the arch code. I could see reason to
>> add a flag to the gather struct like "concurrent_free" and set that
>> from the generic code, which the arch has to take care of.
>=20
> I think you're correct that two CPUs cannot free the page tables
> concurrently (I misunderstood this initially), although I also think
> there may be some subtle issues if tlb->freed_tables is not set,
> depending on the architecture. Roughly speaking, if one CPU is clearing
> a PMD as part of munmap() and another CPU in madvise() does only last-lev=
el
> TLB invalidation, then I think there's the potential for the invalidation
> to be ineffective if observing a cleared PMD doesn't imply that the last
> level has been unmapped from the perspective of the page-table walker.

That should not be the case because the last level table should have
had all entries cleared before the pointer to it has been cleared.

So the page table walker could begin from the now-freed page table,
but it would never instantiate a valid TLB entry from there. So a
TLB invalidation would behave properly despite not flushing page
tables.

Powerpc at least would want to avoid over flushing here, AFAIKS.

>> > But it looks like benchmarks (for the one test-case we have) seem to
>> > favour flushing the world over flushing a smaller range.
>>=20
>> Testing on 16MB unmap is possibly not a good benchmark, I didn't run
>> it exactly but it looks likely to go beyond the range flush threshold
>> and flush the entire PID anyway.
>=20
> If we can get a better idea of what a "good benchmark" might look like (i=
.e.
> something that is representative of the cases in which real workloads are
> likely to trigger this path) then we can definitely try to optimise aroun=
d
> that.

Hard to say unfortunately. A smaller unmap range to start with, but
even then when you have a TLB over-flushing case, then an unmap micro
benchmark is not a great test because you'd like to see more impact of
other useful entries being flushed (e.g., you need an actual working
set).

> In the meantime, I would really like to see this patch land in mainline
> since it fixes a regression.

Sorry I didn't provide input earlier. I would like to improve the fix or=20
at least make an option for archs to provide an optimised way to flush=20
this case, so it would be nice not to fix archs this way and then have=20
to change the fix significantly right away.

But the bug does need to be fixed of course, if there needs to be more
thought about it maybe it's best to take this fix for next release.

Thanks,
Nick

=
