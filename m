Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CCA34D1E1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhC2NyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhC2Nxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 09:53:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B21EC061756
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 06:53:48 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u5so19603138ejn.8
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRDNxOKqgMTRliUmrUZqC4bBoTo2G0CXnwLhIBoHBgQ=;
        b=lV/ix2kywBpsOJiijM/WDFtwKZh+quRH1NlZdU/cB6BOr54qZHEckSENplCl/KquXC
         gN9U81nnoQ2RYxXAqxIHc8B0711uMXP+CyPpeOFNhBuDEr6JPOtiODuewDHGtmo0gCbE
         hX2QVbfD+TDgozhIZtbZ7wOS84erifIMalyN7rqOn5ML/fSyhjfMg73IoAjYpWkJpuAD
         mmdWVH2wHATaY3vfv9RibREUTrmdc9EWprBIBmV/oMPo8zthPlscnSPl5Imxf8TdXtzr
         HYBbrI3ZI8201l2ZXOsRFMiG+muYmMuMEsysbyOX09JZDEzCx74nkuPChT4rU4gAWVke
         1Snw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRDNxOKqgMTRliUmrUZqC4bBoTo2G0CXnwLhIBoHBgQ=;
        b=H6BfzBeBOYFbnirZbFHGULLy6Hma8OMkJy4QFsLJv+ZXP8evZFmYYsI+oaMW84/YFs
         rqh4piLQCvoPkcmjrY2hUpAuYEZKhjkRph5QUSTV8EzS3+Cf/ka2Ng9ayHK5iPqksKu6
         N8zoQNbKfQwR1otjsUL6SSAZ+COs502o2mjOy4loCIFAfDT3r24zwLFn4pFVlDbk3blZ
         Zs6FWcRnamafaB+FkuE71y/PDanZ/mNwRYUMqYwbghL301t+jZH5H+z0AWOw5tT8CYnP
         7cOQnxmX09v41IM910GHcRK0zxAMWtgw0O1P8DhSfppgCZlLdXMNb89J2Qpn/ZdZRD95
         EsTg==
X-Gm-Message-State: AOAM5303chXnSPepZ6fiwqM7wME4wV/BO3UDtg5aMLvOKIhEtwOruETV
        3nmcrjCy4+qOn35vCqM6lUvn8yq3mprKAr0Y32XyrCXbmAU=
X-Google-Smtp-Source: ABdhPJyPot+DS1608lIJgrkfz6R2AOz71ovrgOCJBMt3U5z3OuE0pbEebY1yKj+z4oQQygBbwuGVti/2aTqx1YjW8M0=
X-Received: by 2002:a17:906:3409:: with SMTP id c9mr28359752ejb.314.1617026026828;
 Mon, 29 Mar 2021 06:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075633.135869143@linuxfoundation.org> <20210329075640.480623043@linuxfoundation.org>
 <CA+G9fYvHsa0TAqPBvHwPhhe_0qt8syEWkGV_GPjOyEOAO9q5Sw@mail.gmail.com>
 <YGGoHdprUT/AscHa@kroah.com> <CAMj1kXEwMSbS1LC7sPSjSifLF8jYVyGcHvvkf9nfrf-fwo4d9w@mail.gmail.com>
 <YGHZRHgNJkFH+Eiq@kroah.com> <CAMj1kXFERgODEEmK-ohSErV5At6SJGKU1a6=9ZfeBnFE0ZJ-AA@mail.gmail.com>
 <YGHbcXMlWAwAjteN@kroah.com>
In-Reply-To: <YGHbcXMlWAwAjteN@kroah.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Mon, 29 Mar 2021 09:53:10 -0400
Message-ID: <CA+CK2bCqf7Bw13ibUbUfEtsGikv3Vhye-UTmNo4JgLZ=uAqbmA@mail.gmail.com>
Subject: Re: [PATCH 5.11 225/254] arm64/mm: define arch_get_mappable_range()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 9:51 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 29, 2021 at 03:49:19PM +0200, Ard Biesheuvel wrote:
> > (+ Pavel)
> >
> > On Mon, 29 Mar 2021 at 15:42, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Mar 29, 2021 at 03:08:52PM +0200, Ard Biesheuvel wrote:
> > > > On Mon, 29 Mar 2021 at 12:12, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Mon, Mar 29, 2021 at 03:05:25PM +0530, Naresh Kamboju wrote:
> > > > > > On Mon, 29 Mar 2021 at 14:10, Greg Kroah-Hartman
> > > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > > > >
> > > > > > > [ Upstream commit 03aaf83fba6e5af08b5dd174c72edee9b7d9ed9b ]
> > > > > > >
> > > > > > > This overrides arch_get_mappable_range() on arm64 platform which will be
> > > > > > > used with recently added generic framework.  It drops
> > > > > > > inside_linear_region() and subsequent check in arch_add_memory() which are
> > > > > > > no longer required.  It also adds a VM_BUG_ON() check that would ensure
> > > > > > > that mhp_range_allowed() has already been called.
> > > > > > >
> > > > > > > Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
> > > > > > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > > > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > > > > Cc: Heiko Carstens <hca@linux.ibm.com>
> > > > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > > > > Cc: Michal Hocko <mhocko@kernel.org>
> > > > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > > > Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > > > > > > Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > > > > > Cc: teawater <teawaterz@linux.alibaba.com>
> > > > > > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > > > > > Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> > > > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > > > ---
> > > > > > >  arch/arm64/mm/mmu.c | 15 +++++++--------
> > > > > > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > > > > > index 6f0648777d34..92b3be127796 100644
> > > > > > > --- a/arch/arm64/mm/mmu.c
> > > > > > > +++ b/arch/arm64/mm/mmu.c
> > > > > > > @@ -1443,16 +1443,19 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
> > > > > > >         free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
> > > > > > >  }
> > > > > > >
> > > > > > > -static bool inside_linear_region(u64 start, u64 size)
> > > > > > > +struct range arch_get_mappable_range(void)
> > > > > > >  {
> > > > > > > +       struct range mhp_range;
> > > > > > > +
> > > > > > >         /*
> > > > > > >          * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
> > > > > > >          * accommodating both its ends but excluding PAGE_END. Max physical
> > > > > > >          * range which can be mapped inside this linear mapping range, must
> > > > > > >          * also be derived from its end points.
> > > > > > >          */
> > > > > > > -       return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
> > > > > > > -              (start + size - 1) <= __pa(PAGE_END - 1);
> > > > > > > +       mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
> > > > > > > +       mhp_range.end =  __pa(PAGE_END - 1);
> > > > > > > +       return mhp_range;
> > > > > > >  }
> > > > > > >
> > > > > > >  int arch_add_memory(int nid, u64 start, u64 size,
> > > > > > > @@ -1460,11 +1463,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
> > > > > > >  {
> > > > > > >         int ret, flags = 0;
> > > > > > >
> > > > > > > -       if (!inside_linear_region(start, size)) {
> > > > > > > -               pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
> > > > > > > -               return -EINVAL;
> > > > > > > -       }
> > > > > > > -
> > > > > > > +       VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > > > > >         if (rodata_full || debug_pagealloc_enabled())
> > > > > > >                 flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
> > > > > >
> > > > > > The stable rc 5.10 and 5.11 builds failed for arm64 architecture
> > > > > > due to below warnings / errors,
> > > > > >
> > > > > > > Anshuman Khandual <anshuman.khandual@arm.com>
> > > > > > >     arm64/mm: define arch_get_mappable_range()
> > > > > >
> > > > > >
> > > > > >   arch/arm64/mm/mmu.c: In function 'arch_add_memory':
> > > > > >   arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
> > > > > > 'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
> > > > > > [-Werror=implicit-function-declaration]
> > > > > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > > > >                ^
> > > > > >   include/linux/build_bug.h:30:63: note: in definition of macro
> > > > > > 'BUILD_BUG_ON_INVALID'
> > > > > >    #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
> > > > > >                                                                  ^
> > > > > >   arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
> > > > > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > > > >     ^~~~~~~~~
> > > > > >
> > > > > > Build link,
> > > > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
> > > > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull
> > > > >
> > > > > thanks, will go drop this, and the patch that was after it in the
> > > > > series, from both trees and will push out a -rc2.
> > > > >
> > > >
> > > > Why were these picked up in the first place? I don't see any fixes or
> > > > cc:stable tags, and the commit log clearly describes that the change
> > > > is preparatory work for enabling arm64 support into a recently
> > > > introduced generic framework.
> > >
> > > This was needed for a follow-on patch in the series that fixed an issue.
> > > Specifically it was commit ee7febce0519 ("arm64: mm: correct the inside
> > > linear map range during hotplug check")
> > >
> >
> > Yeah, but during the discussion of that patch [0], we pointed out that
> > it needed to be rebased because of these new changes. So trying to
> > backport this rebased version is obviously not the right approach:
> > Pavel's original patch would be much more suitable for that.
> >
> > Could we have annotated this patch in a better way to make this more obvious?
>
> Yes, given that there was no annotation on the patch at all to let us
> know this :)
>
> You can say things like "do not apply to stable trees" or "needs total
> rework for older kernels" or other fun such things that when we read
> them, we know to ask for help.  As it is, the patch provided nothing so
> we guessed and got it wrong...

I will send the patch for stable trees with the commit id included as requested.

Pasha

>
> thanks,
>
> greg k-h
