Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDC01EAD30
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgFASnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgFASmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 14:42:42 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE204C00863C
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 11:33:41 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q2so9358452ljm.10
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 11:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3sHbO80vtv9O/JxbnwXh4jR68cxMf3w81ROR6LwO9k=;
        b=SFrdLCiSEkNy2zyHi9SxtTE/RYuVRDPQ82lJVYyuc3MzgEwAMXFE0/Tr4FILI98o5P
         Dm2KigpAl1qPYOOqejUb69+1DG9goI6HiATNNALji11hL8oCzfxiwhHhUBAuDWbt1jzN
         8wQkacMcKusRXX+gXlPU7fA8CR4eJg3vFpQGaccZ6nMkwC3iXg1LAUShuv8taAkh9kB5
         /vV3L4W9Z9+LnzPFypzfXeKFp30H0TdJJl74M+Ju+lxmQt2sXLfxK3dNbeCJhMr0VARM
         BE4MyGcVGZkgJ3lgz4NpHpML2bSrld1hJEsB7l/dMENkaTDIdfqhlR0j44vKvztxqIeG
         fraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3sHbO80vtv9O/JxbnwXh4jR68cxMf3w81ROR6LwO9k=;
        b=ZV9d/Ccf43/tJtf7mIZgIwjYZl6c9hnFCBcXBfwrQz5VJs1DFyv0DgTaQKCtKFzGvs
         r49VLLeyLJiY+7OS14AU5y6orRcRzc7U6tQ1VOnrCIeql9kRA54dqS/vRjzqnRH7xWIK
         WLR3qHjh2utRewNsHZhIDX1BUxyBWRkJzftlL2I08+gKtlWpCsXj/DvV4FgAEeFR8hf5
         67nzIEWBOG2vRcuP8l3VghWU6qkmBT6t+0+N0gaVwXF1VPwXdh3KQuNen11XF9yLu4rY
         QG8ta+Xtb3kove/A7VaCqBU4k58Y8E0FXOqWFsyIDouY7HZ+VM3rLWgV1pnVQU8YPfXC
         06gA==
X-Gm-Message-State: AOAM531uPbRddvmKo1zQgTTBOq2RwvMo61GDyXFCJAuKS1Nak5MzcNf2
        sULshS7uMXznwxV41Y3qd8w1IwxTs7mk5BUobzLC7Q==
X-Google-Smtp-Source: ABdhPJweDrQrdGauRVsPgro6XfW2riI+P8mrmcDjGb5v9sRN28iDOf2IuIbsJHEd5LJxnAxVE+ionRILHpVzTo7lRPg=
X-Received: by 2002:a2e:9c91:: with SMTP id x17mr2848121lji.366.1591036420298;
 Mon, 01 Jun 2020 11:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com> <20200601170751.GO1551@shell.armlinux.org.uk>
 <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com> <20200601182605.GI1407771@sasha-vm>
In-Reply-To: <20200601182605.GI1407771@sasha-vm>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 00:03:28 +0530
Message-ID: <CA+G9fYv+BmykLK-gSaJSZBgFeFsU=bzEfcco4w8Pk+LA7r4cYQ@mail.gmail.com>
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
To:     Sasha Levin <sashal@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Jun 2020 at 23:56, Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Jun 01, 2020 at 11:01:19PM +0530, Naresh Kamboju wrote:
> >On Mon, 1 Jun 2020 at 22:37, Russell King - ARM Linux admin
> ><linux@armlinux.org.uk> wrote:
> >>
> >> On Mon, Jun 01, 2020 at 07:02:48PM +0200, Greg Kroah-Hartman wrote:
> >> > On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
> >> > > stable-rc 4.9 arm architecture build failed due to
> >> > > following errors,
> >> > >
> >> > > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> >> > > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> >> > > arm-linux-gnueabihf-gcc" O=build zImage
> >> > > #
> >> > > ../arch/arm/vfp/vfphw.S: Assembler messages:
> >> > > ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
> >> > > ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
> >> > > make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
> >> > > make[2]: Target '__build' not remade because of errors.
> >> > > make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
> >> > > ../arch/arm/lib/changebit.S: Assembler messages:
> >> > > ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
> >>
> >> It looks like Naresh's toolchain doesn't like the new format
> >> instructions.  Which toolchain (and versions of the individual
> >> tools) are you (Naresh) using?
> >
> >  toolchain version is gcc-9
>
> Do you see the same issue with upstream? I'd expect it to fail the sam
> way because of this patch.

This failure is only on stable-rc 4.9 branch arm architecture.
All other stable-rc branches and linux mainline builds successfully.

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/576020084

- Naresh

>
> --
> Thanks,
> Sasha
