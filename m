Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91731EBF95
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 18:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFBQEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 12:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFBQEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 12:04:48 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A60C05BD1E
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 09:04:47 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a25so13285650ljp.3
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 09:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TdASVYRd1oNcB8z3lm3vXKwpIMfs10a1pt94BdFhokU=;
        b=AfaS5JbkkfQMHNCpjwv78O6KVcnyrd4QGShVbk4K/7pEB3PJCV+g5Vf2unfyLucHSb
         7VSl8SFQiW+BNM7k2dMWP2e4e639+dzM7/EYEhs4kfC+jH6oV9HvYtLgYbU/bd6i/8MF
         0wVLgi/YfesNh09a1h5XIZsRdR24kV13KsettgC19TXNVW02srl+iHkZIqbGLjkMBJKR
         dHWRpr0rtGOeKmDHU1Fuz9fJsHiBElviuiO1gsZK/BTPUfflKWsnxZSx1R7ZMxstlsy5
         ZzUn1aG8cQ08b33K2iZNceKw0uLh2wEaKF7Rjq6kTNTAOGsevXGHTyY0jVCRNH2Smcs5
         Ymkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TdASVYRd1oNcB8z3lm3vXKwpIMfs10a1pt94BdFhokU=;
        b=HM2y7BdLASHSilg70cnmrHg1zRR+I4hdSbkD8ylAgrpvARGHg9wOEbCJQdK7vZF/IP
         GunqtxRCM5Od/IKNcgtHbbfyDIU0ae55d254RTSeeeORhP0ouhvsJY0p8EFddeGfd0Yq
         KbJ/so/95d4wF9X8lNL8PqUWbeqre6g/I9NbTvjBtwQBLHe+aOhxg85ZASibCk4HK+m2
         wG9ee1X0n/wG+s5d76rv1T0gTduoixaKmRwTEqlCjhVkepJkoG9rL186025ySdQK4Sie
         vITi35IpJ7yTHAFI/62VWardp9QWV9djFG+KT9MJFy8Ut231BZap2i1sUW+wXurA4V2T
         k1/g==
X-Gm-Message-State: AOAM532HWcAXuA6eRIq9pEVKiRsdscl097hHQF4qYfa8BsAA4989IXdm
        P4RsqCa1UrZsU+xIZj/F+3FmfojDf2dDNV+qvCjT0GHsMI7dZA==
X-Google-Smtp-Source: ABdhPJz9tp/aYek/IMn73T2R1tTC8IqsxYdWZXPCqIjy6DkFciXG4xeSR4Wxrn03fkzWFSkjbZVhS2VyT6GY9/Hjwo8=
X-Received: by 2002:a2e:9a4f:: with SMTP id k15mr10127288ljj.55.1591113885989;
 Tue, 02 Jun 2020 09:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200602101841.662517961@linuxfoundation.org> <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
In-Reply-To: <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 21:34:34 +0530
Message-ID: <CA+G9fYuwg3s_-om4ojDQtMuWj10skoh568nPZVW7Ar-UVKD=2w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/59] 4.9.226-rc2 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Russell King

On Tue, 2 Jun 2020 at 21:07, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 6/2/20 3:23 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.226 release.
> > There are 59 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> > Anything received after that time might be too late.
> >
>
> Many arm builds still fail as attached. Is it really only me seeing this problem ?
>

We have noticed this problem.

> FWIW, if we need/want to use unified assembler in v4.9.y, shouldn't all unified
> assembler patches be applied ?

This is reported on stable mailing list
https://lore.kernel.org/stable/20200601203710.GR1551@shell.armlinux.org.uk/T/#t

>
> $ git log --oneline v4.9..c001899a5d6 arch/arm | grep unified
> c001899a5d6c ARM: 8843/1: use unified assembler in headers
> a216376add73 ARM: 8841/1: use unified assembler in macros
> eb7ff9023e4f ARM: 8829/1: spinlock: use unified assembler language syntax
> 32fdb046ac43 ARM: 8828/1: uaccess: use unified assembler language syntax
> 1293c2b5d790 ARM: dts: berlin2q: add "cache-unified" to l2 node
> 75fea300d73a ARM: 8723/2: always assume the "unified" syntax for assembly code
>
> I am quite concerned especially about missing commit 75fea300d73a,
> which removes the ARM_ASM_UNIFIED configuration option. That means it is
> still present in v4.9.y, but the failing builds don't enable it. Given that,
> the build failures don't seem to be surprising.
>
> Guenter
>
> ---
> Build reference: v4.9.225-60-g6915714f12d0
> gcc version: arm-linux-gnueabi-gcc (GCC) 9.3.0
>
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> arch/arm/vfp/vfphw.S: Assembler messages:
> arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],#32*4'
> arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#32*4'
> make[2]: *** [arch/arm/vfp/vfphw.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [arch/arm/vfp] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [sub-make] Error 2
> --------------
>
> Building arm:s3c2410_defconfig ... failed
> --------------
> Error log:
> arch/arm/lib/changebit.S: Assembler messages:
> arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
> make[2]: *** [arch/arm/lib/changebit.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> arch/arm/lib/clear_user.S: Assembler messages:
> arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#1'
> arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#1'
> arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#1'
> arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
> arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
> arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
> arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#1'
> arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#1'
> make[2]: *** [arch/arm/lib/clear_user.o] Error 1
> make[1]: *** [arch/arm/lib] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> Failed builds:
> arm:allmodconfig
> arm:s3c2410_defconfig
> arm:omap2plus_defconfig
> arm:imx_v6_v7_defconfig
> arm:ixp4xx_defconfig
> arm:u8500_defconfig
> arm:multi_v5_defconfig
> arm:omap1_defconfig
> arm:footbridge_defconfig
> arm:davinci_all_defconfig
> arm:mini2440_defconfig
> arm:axm55xx_defconfig
> arm:mxs_defconfig
> arm:keystone_defconfig
> arm:vexpress_defconfig
> arm:imx_v4_v5_defconfig
> arm:at91_dt_defconfig
> arm:s3c6400_defconfig
> arm:lpc32xx_defconfig
> arm:shmobile_defconfig
> arm:nhk8815_defconfig
> arm:bcm2835_defconfig
> arm:sama5_defconfig
> arm:orion5x_defconfig
> arm:exynos_defconfig
> arm:cm_x2xx_defconfig
> arm:s5pv210_defconfig
> arm:integrator_defconfig
> arm:pxa910_defconfig
> arm:clps711x_defconfig
