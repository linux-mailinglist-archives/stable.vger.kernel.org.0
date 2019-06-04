Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC05341A1
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfFDISq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:18:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32793 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfFDISp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:18:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id h17so9924026pgv.0;
        Tue, 04 Jun 2019 01:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=Xm8mCKi6Z2e2khhtE7E2JprRNLeGb7NHPoqrIWlf6DA=;
        b=F87Ss6ZD1aKac/ozAijPEyOxTUg8xgrEQmB0aqQIFq5oITFg7AkYOAdWtkj0YZKCdL
         JAKY6YElEuxab1rzok1UbAk2PTPRnF6RLdKA/6ItByUxZyZHHaC2DbpY/GS7qboSKmKU
         nILS4by2sno2rv4s7su4znsARl2vTrvbjL/+vqPlst35UrhxIT1hqzYzCrRXieAHLSda
         PRnr7zUF5txgoENK2JYCgSaD9Xtq294ZVAskdC0kOiD+XzpnOjrKV7KHA8e1kNl9cKxZ
         AZd/lb6Mk/Anjak52b/aCsy/Q4rBh8/dJ/6LhbwMSfSDVPHkbQNQeXecs1z0gHwz9oft
         cHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=Xm8mCKi6Z2e2khhtE7E2JprRNLeGb7NHPoqrIWlf6DA=;
        b=ERJUQUlxPZMfvaeRQwyC1TqYlv0GnKigwc6Ax6FGksUWlckSqBu1tUZrcb2CfKzmy9
         ntE6mSYlE/gQ+DPolow4EmGS3UnZquP1SmPUB1oLTlZpXbf6jxESsFkzCODjTOsFhH9n
         roS/F/VZFKU+DDT725vZQoXtzUVn/JyVICv75R9fCdbfrxkL+HPIfHRr+dyGfBofYmGE
         6savMocCpPQ6001JYhpruzuS3gXq9p97RvHe+yi4RVVgdqXlVQG7dwg212HM6iI8/XYZ
         lnVbECwopVnD59y1ji8UflNDjGxU35uB82C7FCh7mrKkW3XK9HRxpjBJSGJg75oHz9PW
         g+bw==
X-Gm-Message-State: APjAAAWu04KxfgyyffpFq0ZSrMHU9E/tgfaLx9BpJquJlQpi9ap0Rc1B
        VHdxATE4pAPPohBIivgo27w=
X-Google-Smtp-Source: APXvYqzuRh4PTFk2JsV9rrAeM9esxOg81BuDNUQ9Kk4TwhfrA7ZeRx2Y/KSHhgiUXJgP9QbzCUPdXA==
X-Received: by 2002:a17:90b:904:: with SMTP id bo4mr8269927pjb.60.1559636324943;
        Tue, 04 Jun 2019 01:18:44 -0700 (PDT)
Received: from localhost (60-240-187-127.tpgi.com.au. [60.240.187.127])
        by smtp.gmail.com with ESMTPSA id c127sm26491000pfb.107.2019.06.04.01.18.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 01:18:44 -0700 (PDT)
Date:   Tue, 04 Jun 2019 18:18:24 +1000
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
        <1559569861.n3f6bbdn43.astroid@bobo.none>
        <20190603175719.GA13018@fuggles.cambridge.arm.com>
In-Reply-To: <20190603175719.GA13018@fuggles.cambridge.arm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1559634902.anlflf5fmr.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Will Deacon's on June 4, 2019 3:57 am:
> Hi Nick,
>=20
> On Tue, Jun 04, 2019 at 12:10:37AM +1000, Nicholas Piggin wrote:
>> Will Deacon's on June 3, 2019 8:30 pm:
>> > On Mon, Jun 03, 2019 at 12:11:38PM +1000, Nicholas Piggin wrote:
>> >> Peter Zijlstra's on May 31, 2019 7:49 pm:
>> >> > On Fri, May 31, 2019 at 12:46:56PM +1000, Nicholas Piggin wrote:
>> >> >> I don't think it's very nice to set fullmm and freed_tables for th=
is=20
>> >> >> case though. Is this concurrent zapping an important fast path? It
>> >> >> must have been, in order to justify all this complexity to the mm,=
 so
>> >> >> we don't want to tie this boat anchor to it AFAIKS?
>> >> >=20
>> >> > I'm not convinced its an important fast path, afaict it is an
>> >> > unfortunate correctness issue caused by allowing concurrenct frees.
>> >>=20
>> >> I mean -- concurrent freeing was an important fastpath, right?
>> >> And concurrent freeing means that you hit this case. So this
>> >> case itself should be important too.
>> >=20
>> > I honestly don't think we (Peter and I) know. Our first involvement wi=
th
>> > this was because TLBs were found to contain stale user entries:
>> >=20
>> > https://lore.kernel.org/linux-arm-kernel/1817839533.20996552.155706544=
5233.JavaMail.zimbra@redhat.com/
>> >=20
>> > so the initial work to support the concurrent freeing was done separat=
ely
>> > and, I assume, motivated by some real workloads. I would also very muc=
h
>> > like to know more about that, since nothing remotely realistic has sur=
faced
>> > in this discussion, other than some historical glibc thing which has l=
ong
>> > since been fixed.
>>=20
>> Well, it seems like it is important. While the complexity is carried
>> in the mm, we should not skimp on this last small piece.
>=20
> As I say, I really don't know. But yes, if we can do something better we
> should.
>=20
>> >> >> Is the problem just that the freed page tables flags get cleared b=
y
>> >> >> __tlb_reset_range()? Why not just remove that then, so the bits ar=
e
>> >> >> set properly for the munmap?
>> >> >=20
>> >> > That's insufficient; as argued in my initial suggestion:
>> >> >=20
>> >> >   https://lkml.kernel.org/r/20190509103813.GP2589@hirez.programming=
.kicks-ass.net
>> >> >=20
>> >> > Since we don't know what was flushed by the concorrent flushes, we =
must
>> >> > flush all state (page sizes, tables etc..).
>> >>=20
>> >> Page tables should not be concurrently freed I think. Just don't clea=
r
>> >> those page table free flags and it should be okay. Page sizes yes,
>> >> but we accommodated for that in the arch code. I could see reason to
>> >> add a flag to the gather struct like "concurrent_free" and set that
>> >> from the generic code, which the arch has to take care of.
>> >=20
>> > I think you're correct that two CPUs cannot free the page tables
>> > concurrently (I misunderstood this initially), although I also think
>> > there may be some subtle issues if tlb->freed_tables is not set,
>> > depending on the architecture. Roughly speaking, if one CPU is clearin=
g
>> > a PMD as part of munmap() and another CPU in madvise() does only last-=
level
>> > TLB invalidation, then I think there's the potential for the invalidat=
ion
>> > to be ineffective if observing a cleared PMD doesn't imply that the la=
st
>> > level has been unmapped from the perspective of the page-table walker.
>>=20
>> That should not be the case because the last level table should have
>> had all entries cleared before the pointer to it has been cleared.
>=20
> The devil is in the detail here, and I think specifically it depends
> what you mean by "before". Does that mean memory barrier, or special
> page-table walker barrier, or TLB invalidation or ...?

I don't know that matters. It is a complicating factor, but would
not be a new one to page table freeing. The issue really is the
TLB entries (not page walk entry) which need to be flushed by the
concurrent unmaps. Even without any page table freeing activity (so you=20
would still have the page table connected), the ordering and flushing=20
needs to be right such that it can not re-instantiate a new TLB from the
page table with the old PTEs.

If that is solved, then the subsequent step of freeing the page table
page doesn't introduce a new window where old PTEs could be read
from the same table via page walk cache after it is disconnected.

>=20
>> So the page table walker could begin from the now-freed page table,
>> but it would never instantiate a valid TLB entry from there. So a
>> TLB invalidation would behave properly despite not flushing page
>> tables.
>>=20
>> Powerpc at least would want to avoid over flushing here, AFAIKS.
>=20
> For arm64 it really depends how often this hits. Simply not setting
> tlb->freed_tables would also break things for us, because we have an
> optimisation where we elide invalidation in the fullmm && !freed_tables
> case, since this is indicative of the mm going away and so we simply
> avoid reallocating its ASID.

It wouldn't be not setting it, but rather not clearing it.

Not sure you have to worry about concurrent unmaps in the fullmm case
either.

>=20
>> >> > But it looks like benchmarks (for the one test-case we have) seem t=
o
>> >> > favour flushing the world over flushing a smaller range.
>> >>=20
>> >> Testing on 16MB unmap is possibly not a good benchmark, I didn't run
>> >> it exactly but it looks likely to go beyond the range flush threshold
>> >> and flush the entire PID anyway.
>> >=20
>> > If we can get a better idea of what a "good benchmark" might look like=
 (i.e.
>> > something that is representative of the cases in which real workloads =
are
>> > likely to trigger this path) then we can definitely try to optimise ar=
ound
>> > that.
>>=20
>> Hard to say unfortunately. A smaller unmap range to start with, but
>> even then when you have a TLB over-flushing case, then an unmap micro
>> benchmark is not a great test because you'd like to see more impact of
>> other useful entries being flushed (e.g., you need an actual working
>> set).
>=20
> Right, sounds like somebody needs to do some better analysis than what's
> been done so far.
>=20
>> > In the meantime, I would really like to see this patch land in mainlin=
e
>> > since it fixes a regression.
>>=20
>> Sorry I didn't provide input earlier. I would like to improve the fix or=
=20
>> at least make an option for archs to provide an optimised way to flush=20
>> this case, so it would be nice not to fix archs this way and then have=20
>> to change the fix significantly right away.
>=20
> Please send patches ;)

I have a few things lying around I put on hold until after all the
recent nice refactoring and improvements. I will rebase and try to
look at this issue as well and see if there is any ways to improve.
Likely to need help with arch code and analysis of races.

>> But the bug does need to be fixed of course, if there needs to be more
>> thought about it maybe it's best to take this fix for next release.
>=20
> Agreed.

Well I can't argue against in anymore then.

Thanks,
Nick

=
