Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD6742A106
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 11:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhJLJak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 05:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhJLJak (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 05:30:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E16360F92;
        Tue, 12 Oct 2021 09:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634030919;
        bh=w6tJ0j7GZyF9EA8+IbdyJH2ct/ziottLxIdQqKTGRqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Af/9zwXNiRPkvFTna55wceL8kexV3DRj4NlW8pN/pyovPyCs5nA2v/56fiiRDIU+c
         HM3Yu00NmTQF5P/KOHjXwMKD/VP0O/X3b0SCsoNdDpQFnkr/DDBxo1KFcNTaVuCVAK
         CleWg31dMcxiLmuLVt6pU/08nVbn/1ukk2C4m0v8=
Date:   Tue, 12 Oct 2021 11:28:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        bpf <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 5.4 00/52] 5.4.153-rc2 review
Message-ID: <YWVVRDEDdaIQYKlX@kroah.com>
References: <20211012064436.577746139@linuxfoundation.org>
 <CA+G9fYt3vmhvuoFJ6p49DHiFE60oBeWUwuSLrh7vXwr=8_rpfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt3vmhvuoFJ6p49DHiFE60oBeWUwuSLrh7vXwr=8_rpfg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 01:04:54PM +0530, Naresh Kamboju wrote:
> On Tue, 12 Oct 2021 at 12:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.153 release.
> > There are 52 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 14 Oct 2021 06:44:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> stable rc 5.4.153-rc2 Powerpc build failed.
> 
> In file included from arch/powerpc/net/bpf_jit64.h:11,
>                  from arch/powerpc/net/bpf_jit_comp64.c:19:
> arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
> arch/powerpc/net/bpf_jit.h:32:9: error: expected expression before 'do'
>    32 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
>       |         ^~
> arch/powerpc/net/bpf_jit.h:33:33: note: in expansion of macro 'PLANT_INSTR'
>    33 | #define EMIT(instr)             PLANT_INSTR(image, ctx->idx, instr)
>       |                                 ^~~~~~~~~~~
> arch/powerpc/net/bpf_jit_comp64.c:415:41: note: in expansion of macro 'EMIT'
>   415 |                                         EMIT(PPC_LI(dst_reg, 0));
>       |                                         ^~~~
> arch/powerpc/net/bpf_jit.h:33:33: note: in expansion of macro 'PLANT_INSTR'
>    33 | #define EMIT(instr)             PLANT_INSTR(image, ctx->idx, instr)
>       |                                 ^~~~~~~~~~~
> arch/powerpc/net/bpf_jit.h:41:33: note: in expansion of macro 'EMIT'
>    41 | #define PPC_ADDI(d, a, i)       EMIT(PPC_INST_ADDI |
> ___PPC_RT(d) |           \
>       |                                 ^~~~
> arch/powerpc/net/bpf_jit.h:44:33: note: in expansion of macro 'PPC_ADDI'
>    44 | #define PPC_LI(r, i)            PPC_ADDI(r, 0, i)
>       |                                 ^~~~~~~~
> arch/powerpc/net/bpf_jit_comp64.c:415:46: note: in expansion of macro 'PPC_LI'
>   415 |                                         EMIT(PPC_LI(dst_reg, 0));
>       |                                              ^~~~~~
> make[3]: *** [scripts/Makefile.build:262:
> arch/powerpc/net/bpf_jit_comp64.o] Error 1
> make[3]: Target '__build' not remade because of errors.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Ok, I'm just going to go delete this patch from the queue now...

Thanks for the quick report.

greg k-h
