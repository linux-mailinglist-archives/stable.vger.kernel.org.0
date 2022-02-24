Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B374C2758
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 10:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiBXJBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 04:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiBXJBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 04:01:22 -0500
X-Greylist: delayed 308 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 01:00:52 PST
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1886156C7F
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 01:00:52 -0800 (PST)
Received: from mail-wr1-f54.google.com ([209.85.221.54]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MyK1E-1oAjpL13zI-00yj9n; Thu, 24 Feb 2022 09:55:43 +0100
Received: by mail-wr1-f54.google.com with SMTP id s1so1817228wrg.10;
        Thu, 24 Feb 2022 00:55:43 -0800 (PST)
X-Gm-Message-State: AOAM5321tyNBm9si7/U2bh+owVFO3S3s7EY1xq1BIhtkM+T4O3XuKdus
        ulUcIWUNOFAhvHR94BJeMzS9bskE9DK3XTR+73c=
X-Google-Smtp-Source: ABdhPJzVx8NxhnRplqn7UOCa0h4W/Ep2FJpa492JuQvGufCpx+inyOvUlatvGWKDK96MHihZg0ncKPY6m8F54x2XjXI=
X-Received: by 2002:adf:a446:0:b0:1ed:c41b:cf13 with SMTP id
 e6-20020adfa446000000b001edc41bcf13mr1436356wra.407.1645692942849; Thu, 24
 Feb 2022 00:55:42 -0800 (PST)
MIME-Version: 1.0
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
 <20220223135820.2252470-2-anders.roxell@linaro.org> <1645670923.t0z533n7uu.astroid@bobo.none>
 <1645678884.dsm10mudmp.astroid@bobo.none>
In-Reply-To: <1645678884.dsm10mudmp.astroid@bobo.none>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 24 Feb 2022 09:55:26 +0100
X-Gmail-Original-Message-ID: <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
Message-ID: <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:T/CJqf+iu6c4Xf/EuExSSIm06x9aJ6WDKLfHNQtRXGxumPmu8z7
 EtaQl1Z0OVFx3hD9xVfSk3eRxxqK0eDOxVy8EUSuPcpQidkbZwG+8irxVhaM9vs6YM/o1Rs
 sB/rlEnbewRor2D65FUH5k7JNB6Tz/vp0LJE7ZJ8kaXHE7X7teQaks2/GOxm/Mvb7Yrs76F
 ZBF+9AU17HrltlODwbYaA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:o18Hyh38HcU=:eBCagCbc2qKOH02dfbgnxe
 a5cxtwNqXiN/Y2vt5QGIm+yVXazJ7fA1pfEW5rszHyoghx88h+nCyNvuRWvIGZBrawu6FlY9T
 wB4Bg5kYUe0fTuwKaZNvedR+J2JNANUgSZFr+3bOJhwkq6LssmevG/hSpFpWv3BE55NDDF942
 Ocuxn/3U764PJnyCDlralg47g8+N7nmW9jLF9h/SRk94RaT87ogJ1qxsNOkq4CRDGQCTuhlDi
 TNDvlfENm1zxcs1aJcFFB4jkMI5i1JtSe7QphDbtCkD0vYgWNqZ8kfyqcwG0ehOyFDvcQiihj
 b81hpap2moxeUe+fGAtuVBT7IVYPxerQwsBSD0c3nOQVIlEp0M/XBEL6ANS+pv8Hjz2nVy+Ji
 cjhS7q/Frg7i69XEWPGcFri6J9JD86I+91qDuRH1sEWLiiXEy0YEvVnASOiROo4+o+ArkpHBw
 Ps1Odlep/o+Fn4dkPTke3TMPTO17X6o+CYQ+cYCjAIBiUiVUFdtBwaD/nWz5A7TRxGBaXJNbj
 kDUGV02Q9qTLrng/NmJleajRjAGFItk5CLhQF98oVV4ev+2k3ZnYiu44Zx4NRwea79wEm3vMX
 ilAVpmThj7cYo=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 6:05 AM Nicholas Piggin <npiggin@gmail.com> wrote:
> Excerpts from Nicholas Piggin's message of February 24, 2022 12:54 pm:
> >
> > Not sure on the outlook for GCC fix. Either way unfortunately we have
> > toolchains in the wild now that will explode, so we might have to take
> > your patches for the time being.
>
> Perhaps not... Here's a hack that seems to work around the problem.
>
> The issue of removing -many from the kernel and replacing it with
> appropriate architecture versions is an orthogonal one (that we
> should do). Either way this hack should be able to allow us to do
> that as well, on these problem toolchains.
>
> But for now it just uses -many as the trivial regression fix to get
> back to previous behaviour.

I don't think the previous behavior is what you want to be honest.

We had the same thing on Arm a few years ago when binutils
started enforcing this more strictly, and it does catch actual
bugs. I think annotating individual inline asm statements is
the best choice here, as that documents what the intention is.

There is one more bug in this series that I looked at with Anders, but
he did not send a patch for that so far:

static void dummy_perf(struct pt_regs *regs)
{
#if defined(CONFIG_FSL_EMB_PERFMON)
        mtpmr(PMRN_PMGC0, mfpmr(PMRN_PMGC0) & ~PMGC0_PMIE);
#elif defined(CONFIG_PPC64) || defined(CONFIG_PPC_BOOK3S_32)
        if (cur_cpu_spec->pmc_type == PPC_PMC_IBM)
                mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~(MMCR0_PMXE|MMCR0_PMAO));
#else
        mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~MMCR0_PMXE);
#endif
}

Here, the assembler correctly flags the mtpmr/mfpmr as an invalid
instruction for a combined 6xx kernel: As far as I can tell, these are
only available on e300 but not the others, and instead of the compile-time
check for CONFIG_FSL_EMB_PERFMON, there needs to be some
runtime check to use the first method on 83xx but the #elif one on
the other 6xx machines.

       Arnd
