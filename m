Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2991EA873
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFARil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgFARik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 13:38:40 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1BDC05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 10:38:39 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id c11so9196726ljn.2
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 10:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9/y5VUZFG1Qp9Nxo0dmlo33MWKMYC1RROrHOs3ljwX4=;
        b=ZgYE5PmvGsuu2mmvWzJkcyWqhunNgIy5OfEFSXhe6AB1RcwJTJLatdaGpzM5rcLueq
         Z0O1PpRTrYC9q326asGTqvTXe/8llpyVQOlwDC/FIT38yCZ43tEPYlGfzEM9qWNa2TQs
         ki20l0KfLCxqKv7eFbHKgNjQzipYqQZwgCwA2iJ3rxpMwKuvXKPGRM1hhcKC0480uX8n
         13wHWdAqV8pc0g7YJwOPA30asldqTC7MBoFD/whI/0XTBIf85+B3uxXOqgFlVy18F9D0
         Dd05tGNzyqmgTCEys2hjqn/5U7qWYT2YGIDnEuwlQOeZ/ufxlh8FLs6TpEEjn4a2pbHp
         TDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9/y5VUZFG1Qp9Nxo0dmlo33MWKMYC1RROrHOs3ljwX4=;
        b=XOKG6rcJ6L6XTVkzZjiJbn99c+htHQkNgRcMgizFuF6lresy6fM05M2QpsNgxKm+ks
         q847CVI/prtbISqi/8MESngpuHO9C8i1U/On8safgRWGxhQFz5tH1uygwrztgBzzOcAX
         VnETIja6fwd2b6jzcJ06i456O7S48QuV83mrq9Jxf0Q8ygin2+44aY5yy49ZfY3AG32h
         IK/Ni84jKp36eZM5nRMIRSk3gEmLfXAFqWLpuiDxEf6XQt/oAt6JDUmnIaZOmNc0UB+9
         IdstdA317dhJC2krs2rgFxkSeWSuEaJ7oiuSFy7QLJOWqZtB2FFsZM0lws18IoodaONn
         QDyw==
X-Gm-Message-State: AOAM530V9tlGLr1ra9dnaDFUSTRthM01+iwH/YESa84R3Lg4/WYMy8zj
        4gjR1uRMm/MTszc4RrI3aJxR+qoPb/epRetdxUn5cA==
X-Google-Smtp-Source: ABdhPJynv9GzbxVA0ydLm4o7PI1kgrhxakbBU2+8ALiD7B3VODVoJTR17Jun0lCQIFy00O6PNF3gagLWHUXoL2tvOPM=
X-Received: by 2002:a2e:574e:: with SMTP id r14mr11653712ljd.411.1591033117209;
 Mon, 01 Jun 2020 10:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com> <20200601170751.GO1551@shell.armlinux.org.uk>
 <20200601172135.GA1236358@kroah.com> <20200601173510.GA1262785@kroah.com>
In-Reply-To: <20200601173510.GA1262785@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Jun 2020 23:08:25 +0530
Message-ID: <CA+G9fYu9x0YeQmdb7fCF1doTGUwii6LVOJyDdo3v+yZsxpkuWA@mail.gmail.com>
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Jun 2020 at 23:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 01, 2020 at 07:21:35PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 01, 2020 at 06:07:51PM +0100, Russell King - ARM Linux admin wrote:
> > > On Mon, Jun 01, 2020 at 07:02:48PM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
> > > > > stable-rc 4.9 arm architecture build failed due to
> > > > > following errors,
> > > > >
> > > > > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> > > > > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> > > > > arm-linux-gnueabihf-gcc" O=build zImage
> > > > > #
> > > > > ../arch/arm/vfp/vfphw.S: Assembler messages:
> > > > > ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
> > > > > ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
> > > > > make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
> > > > > make[2]: Target '__build' not remade because of errors.
> > > > > make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
> > > > > ../arch/arm/lib/changebit.S: Assembler messages:
> > > > > ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
> > >
> > > It looks like Naresh's toolchain doesn't like the new format
> > > instructions.  Which toolchain (and versions of the individual
> > > tools) are you (Naresh) using?
> > >
> > > > Odd, I'll drop it from 4.9, but it's also in the 4.14 and 4.19 queues as
> > > > well, is it causing issues there too?
> > >
> > > What if it turns out that Naresh is using an ancient toolchain
> > > that isn't supported by these kernels?  Does that still count as
> > > a reason to drop the patch?
> >
> > Depends on if anyone actually wants to use the newer toolchain on the
> > really-old 4.9 release :)
>
> Ok, looks like other patches in the queue depended on this one, so I've
> added it back, and we can figure out what Naresh's toolchain is here...

gcc version 9.3.0

>
> thanks,
>
> greg k-h
