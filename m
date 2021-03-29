Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8634D233
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhC2ONv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhC2ONd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:13:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24A3C061756
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 07:13:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r12so19703187ejr.5
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 07:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86TeMxQ89yb3/ndTsuX1OXubFkK/BuTbuolAbXSLSik=;
        b=IFcI9jEg+O3A4eONHkvWRe1r0Ehi05s9eFnLPDMXl/ML+/aAId2nVpJOovAvSVhp0O
         MKMhZp59G47NRct/PMdnLWMJcSO6VSuAnLdR2uJCk3Olr0LJBEXI5SZ4tItb91xw2B4j
         0qNUyYfaicfLW8GsBq5DS8xqEJ2oFVQNijZ+fwgCxGLP2LQyZ4UrvN/00obi7n26wrMs
         9QYvqQIB2ZtzoQjt42Da3LSG2/hNFTKaqA/1hCWag7hmglxvXR6hWxM+vS28ie1xKolK
         QxCIev16OgLnqY0SP8Q5QDrsFZwX0NY/A11zoxT8W3uyKKkzfEl52U7lNSZ9PzZ7uf7m
         FrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86TeMxQ89yb3/ndTsuX1OXubFkK/BuTbuolAbXSLSik=;
        b=WMP8k4ciO8PcJzwxM6Y8568uW9T2H7QCBRAVj0LqAEdVruxFFVKqUqovE/KGRI2qT2
         rxd70HG1uFSAldAxv2PgDDzv//sp3fPOzfmOe2mj6AoMYLrz3gU8pFtVXSI9T0Kpyv2L
         84rpcNbK7g/cGmGm78pfbVP9YaYcOrwdTHVTpGrkF495Dmh4NDU1SNgzJqT/s8wboDPC
         H2qN+EEmTCCkq9vtggWRVomYHOagMmF8/s1Ve07c1cYi4tOHXWhdzn6Fw71V0HBBtF48
         YKt9qjDw/oWoCWL4xzqLwZMilNN7fUK4uNAcKmQVPKliYVXC//aeCPFhpDf2ro4kpqY6
         sI7Q==
X-Gm-Message-State: AOAM53138oXPw9+mBCHV8xzBCQkSDuYv5bbQwMunZnsqPfgab3YiMkv2
        g1cbCj2OrPOITwAjTuJ4k2/jvvmDHgW+hKrnlHf9Qg==
X-Google-Smtp-Source: ABdhPJwHlCSU+a2hL0/WMfvHzMD/fGVmeeFv/HnoEbiKZWgsmdcvNRudPSIVstBfAPD6a6CCb9LpRXyXZed2Y0Se0B0=
X-Received: by 2002:a17:907:9482:: with SMTP id dm2mr2503093ejc.303.1617027211640;
 Mon, 29 Mar 2021 07:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075633.135869143@linuxfoundation.org> <20210329075640.480623043@linuxfoundation.org>
 <CA+G9fYvHsa0TAqPBvHwPhhe_0qt8syEWkGV_GPjOyEOAO9q5Sw@mail.gmail.com>
 <YGGoHdprUT/AscHa@kroah.com> <CADYN=9K-rV+efCDBoF4a_rKbg77d1o-uWH1oTgjZ+v-4MUjo5Q@mail.gmail.com>
 <YGG7hTYP2gGwuBCJ@kroah.com>
In-Reply-To: <YGG7hTYP2gGwuBCJ@kroah.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Mon, 29 Mar 2021 16:13:20 +0200
Message-ID: <CADYN=9+kQwBUbq_Na-Y1Cz4Y7w16Quh+utMtVuDOsBjZk_jJYA@mail.gmail.com>
Subject: Re: [PATCH 5.11 225/254] arm64/mm: define arch_get_mappable_range()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
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

On Mon, 29 Mar 2021 at 13:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 29, 2021 at 01:06:47PM +0200, Anders Roxell wrote:
> > On Mon, 29 Mar 2021 at 12:13, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Mar 29, 2021 at 03:05:25PM +0530, Naresh Kamboju wrote:
> > > > On Mon, 29 Mar 2021 at 14:10, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > >
> > > > > [ Upstream commit 03aaf83fba6e5af08b5dd174c72edee9b7d9ed9b ]
> > > > >
> > > > > This overrides arch_get_mappable_range() on arm64 platform which will be
> > > > > used with recently added generic framework.  It drops
> > > > > inside_linear_region() and subsequent check in arch_add_memory() which are
> > > > > no longer required.  It also adds a VM_BUG_ON() check that would ensure
> > > > > that mhp_range_allowed() has already been called.
> > > > >
> > > > > Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
> > > > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > Cc: Will Deacon <will@kernel.org>
> > > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > > Cc: Heiko Carstens <hca@linux.ibm.com>
> > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > > Cc: Michal Hocko <mhocko@kernel.org>
> > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > > > > Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > > > Cc: teawater <teawaterz@linux.alibaba.com>
> > > > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > > > Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  arch/arm64/mm/mmu.c | 15 +++++++--------
> > > > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > > > index 6f0648777d34..92b3be127796 100644
> > > > > --- a/arch/arm64/mm/mmu.c
> > > > > +++ b/arch/arm64/mm/mmu.c
> > > > > @@ -1443,16 +1443,19 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
> > > > >         free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
> > > > >  }
> > > > >
> > > > > -static bool inside_linear_region(u64 start, u64 size)
> > > > > +struct range arch_get_mappable_range(void)
> > > > >  {
> > > > > +       struct range mhp_range;
> > > > > +
> > > > >         /*
> > > > >          * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
> > > > >          * accommodating both its ends but excluding PAGE_END. Max physical
> > > > >          * range which can be mapped inside this linear mapping range, must
> > > > >          * also be derived from its end points.
> > > > >          */
> > > > > -       return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
> > > > > -              (start + size - 1) <= __pa(PAGE_END - 1);
> > > > > +       mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
> > > > > +       mhp_range.end =  __pa(PAGE_END - 1);
> > > > > +       return mhp_range;
> > > > >  }
> > > > >
> > > > >  int arch_add_memory(int nid, u64 start, u64 size,
> > > > > @@ -1460,11 +1463,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
> > > > >  {
> > > > >         int ret, flags = 0;
> > > > >
> > > > > -       if (!inside_linear_region(start, size)) {
> > > > > -               pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
> > > > > -               return -EINVAL;
> > > > > -       }
> > > > > -
> > > > > +       VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > > >         if (rodata_full || debug_pagealloc_enabled())
> > > > >                 flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
> > > >
> > > > The stable rc 5.10 and 5.11 builds failed for arm64 architecture
> > > > due to below warnings / errors,
> > > >
> > > > > Anshuman Khandual <anshuman.khandual@arm.com>
> > > > >     arm64/mm: define arch_get_mappable_range()
> > > >
> > > >
> > > >   arch/arm64/mm/mmu.c: In function 'arch_add_memory':
> > > >   arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
> > > > 'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
> > > > [-Werror=implicit-function-declaration]
> > > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > >                ^
> > > >   include/linux/build_bug.h:30:63: note: in definition of macro
> > > > 'BUILD_BUG_ON_INVALID'
> > > >    #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
> > > >                                                                  ^
> > > >   arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
> > > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > >     ^~~~~~~~~
> > > >
> > > > Build link,
> > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
> > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull
> > >
> > > thanks, will go drop this, and the patch that was after it in the
> > > series, from both trees and will push out a -rc2.
> > >
> > > Note, I used tuxbuild before doing this release, and it does not show
> > > this error in the arm64 defconfigs. What config did you use to trigger
> > > this?
> >
> > We have a build with CONFIG_MEMORY_HOTPLUG=y enabled too.
> >
> > This is a way to reproduce it locally:
> > tuxmake --runtime podman --target-arch arm64 --toolchain gcc --kconfig
> > defconfig --kconfig-add CONFIG_MEMORY_HOTPLUG=y
>
> Ah, that wasn't expected, but makes sense, thanks.
>
> Does 'allmodconfig' also trigger that?

Yes that would trigger it. I tried this:
tuxmake --runtime docker --target-arch arm64 --toolchain gcc --kconfig
allmodconfig --build-dir=$(pwd)/obj/test-allmod-arm64

>  Maybe I'll go add that to my
> build tests for arm64...

It will take a few minutes to build an allmodconfig kernel on tuxsuite.

Cheers,
Anders
