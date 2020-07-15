Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF92A22058A
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 08:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgGOGyy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Jul 2020 02:54:54 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60363 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgGOGyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 02:54:53 -0400
Received: from mail-qv1-f49.google.com ([209.85.219.49]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N0nSN-1kpvWY1EyT-00wqCG for <stable@vger.kernel.org>; Wed, 15 Jul 2020
 08:54:51 +0200
Received: by mail-qv1-f49.google.com with SMTP id m8so430614qvk.7
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:54:51 -0700 (PDT)
X-Gm-Message-State: AOAM533uf96aeVik7CXeQnk63ky/amOEoqq472YiKTubVh6yGDmLrVCt
        h/DCjc3YdpQXg6at2x8rmK+mmIBzLxX0rn4FSA4=
X-Google-Smtp-Source: ABdhPJzZwB4hO0/Tq7XSeeHTRZ2JeciAv8SwtuaXKme8mVm5kQesA4zAD6Wow/94RtIvHH9WQ4rqq/3HUe1X+w+y2QA=
X-Received: by 2002:a0c:f802:: with SMTP id r2mr8145700qvn.197.1594796090120;
 Tue, 14 Jul 2020 23:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsLBOVVjxO2DAUgjXskxEXyMpBxYG1PRKwe7BTHJfzfZw@mail.gmail.com>
 <20200714184013.GA2174489@kroah.com>
In-Reply-To: <20200714184013.GA2174489@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 15 Jul 2020 08:54:33 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2B6xO-PEOEsseajBvJCvF0d269XHvOzqzdfhyssZ6wrw@mail.gmail.com>
Message-ID: <CAK8P3a2B6xO-PEOEsseajBvJCvF0d269XHvOzqzdfhyssZ6wrw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_stable=2Drc_5=2E4=3A_arm64_build_failed_=2D_error=3A_=E2=80=98co?=
        =?UTF-8?Q?nst_struct_arch=5Ftimer=5Ferratum=5Fworkaround=E2=80=99_has_no_member_na?=
        =?UTF-8?Q?med_=E2=80=98disable=5Fcompat=5Fvdso=E2=80=99?=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:OEGVEXQWIRuXSiBTLgsme84uU7X/xFY2/e0DZJmWd7z67IJrddF
 37BVfIE4oBw52PyqWl53DNTe6rgxqzn6foymRfOjIASiDY5WEYO9pjDpZ9OxtshAb7aIbsh
 TuiZooKTlibIM84Q9Wx6WgNGgiXF6HIo1qpcuqnrl4YwHUOQej9I0MoUQb5c58wpOP7WAHj
 AqKd3AenpW8RS8pYh5bTg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5NlDjtSnfOI=:N79WHIEZ1hiW1qdgud3Fe2
 YaBkNPGNJatnESgmZ2B9d0itlphqnPbQ9XfZv3eOo/jYDugXLCBemLG0g1R5LbzCNTDI6APpY
 +p8QtpHU7FxaSfzT/4L9VZJOEccmpiMRVunvX9DnWGiivmicQqpm6AswaDeYuDEkQN7e/2uhV
 UZNUS63sdu6F9SZiKkI5XoY1zziEatuawvtWdAUK7t+lKodm2jo4hMIppjEOgHygTHfJIPtAe
 F1AU2cd/LV1idrKLZhbxuyiZBzGwV+na8Do9KO/9yYYvp5HvmeCSrHEnwerobon1x3BNU/Pkj
 w5EzFPJ+MEQDVYVDGgb0q/2ffBf4fvdnJcoY0sVA65EevU4N6EIkEbC/Z/y3MTO1TmfpjBe9N
 XEyNIREUWp12GdwgrkOIoVF+9cZqkuYcJ4p24ld+R18LDDt7PaO2x9+IyXzZzEulBVOViYpgw
 Y4M9AkRxv2lNybJhFv9mSRUgv1M9gi0rXKgZBBQabBT5FtxW6AtsCXfbVZm/IGg6XpIsWPud+
 Bos6X5N9/NjrsxEX1uggvwcUreWCdJs0l7ewBdmkIaNSzQI6nKrp8jGAtLSNF3mzvvx9TJsTU
 1aix3Ii67lulyRghPNPOrghzj4B15rU/3pMeBIRrqEGKnOhhpRJSuKo7PSBn9cq+dZ3b1kXkT
 CoTrFxcvEUm1CG1oT7cndddSGyMoRhwj57a/bpo6TIrzRXD0WR4XefWXyRng+s49YKBu89+WD
 v6PbrA9Yy6gVzCJVyLVBtGbSFhjx4b94yw6Vxk0qXaZL2bk7CzbSi5Ju1JjlEx250IH5PxAOP
 lWgfNExw/0iANqtdCK2sZdJ0Gqv1zjhzKUCHZP4yrXwHGu/Y+7HJNFSf9W317FYuaJU8RzrJr
 CMnRTo9QISdbnCQ78+XOAjHkF9ftQHB/eGVGhRFvQRw+dFvn7zczD/PF1m7L7zLqJfgyuSTA4
 YqFLtxEykML2R5yIR6C8NvXqmsRePEJAMGGiJYseI816ciCd5fhMa
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 8:40 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jul 14, 2020 at 10:48:14PM +0530, Naresh Kamboju wrote:
> > arm64 build failed on 5.4
> >
> > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> > aarch64-linux-gnu-gcc" O=build Image
> > #
> > ../drivers/clocksource/arm_arch_timer.c:484:4: error: ‘const struct
> > arch_timer_erratum_workaround’ has no member named
> > ‘disable_compat_vdso’
> >   484 |   .disable_compat_vdso = true,
> >       |    ^~~~~~~~~~~~~~~~~~~
> > ../drivers/clocksource/arm_arch_timer.c:484:26: warning:
> > initialization of ‘u32 (*)(void)’ {aka ‘unsigned int (*)(void)’} from
> > ‘int’ makes pointer from integer without a cast [-Wint-conversion]
> >   484 |   .disable_compat_vdso = true,
> >       |                          ^~~~
> > ../drivers/clocksource/arm_arch_timer.c:484:26: note: (near
> > initialization for ‘ool_workarounds[5].read_cntp_tval_el0’)
> >
> > Could be this patch,
> > arm64: arch_timer: Disable the compat vdso for cores affected by
> > ARM64_WORKAROUND_1418040
> > commit 4b661d6133c5d3a7c9aca0b4ee5a78c7766eff3f upstream.
> >
> > ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
> > the virtual counter register are trapped and emulated by the kernel.
> > This makes the vdso pretty pointless, and in some cases livelock
> > prone.
> >
> > Provide a workaround entry that limits the vdso to 64bit tasks.
> >
> > ref:
> > https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/638094006
>
> Thanks, I've now dropped this patch.

I think we do want to have it back eventually. It appears that the patch
upstream depends on the two immediately before it:

4b661d6133c5 arm64: arch_timer: Disable the compat vdso for cores
affected by ARM64_WORKAROUND_1418040
c1fbec4ac0d7 arm64: arch_timer: Allow an workaround descriptor to
disable compat vdso
97884ca8c292 arm64: Introduce a way to disable the 32bit vdso

AFAICT, the second one was missing, causing the build failure.
Do you know if that one needed a manual backport, or could you
try applying all three in sequence again?

      Arnd
