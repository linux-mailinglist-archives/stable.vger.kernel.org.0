Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31B452D05
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 09:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhKPIm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 03:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhKPImx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 03:42:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7163C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 00:39:56 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so24406294edd.3
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 00:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29oqjmL46qhcPK7GumgLq+DG8d/OcnmM7sBa267LNJc=;
        b=HONPxPc4fpua+nyA5KACQL975ArZH3/eBZ5dZY+p2HgPVPrzmmke+3HJWO2fCuuPVf
         l6f/AdcurSlwQitjA8g/mqh5lMP6Ad7Y2yKDZ3KPIDSx/M9xUBEV1QmMbD9uzAlXdMnm
         2Pq6zA92NLyZGraUjpKEnUeaXM8JEomRJRcxIk3CjGNzoDdCiIAeukpjfz5e9+dKV+1c
         y0luK2d9szpkwic7PL+e/BbeLQ3eEvF2IkQeSyDfW6u4WlVuDTNraMytYMqlRCrUgZwX
         LHmEkcCL8WrLlzzguwmU1M1g+DuVFytZ6yvWZ9Fyz1Mm+5z2F+fz+/KOCsQkakBVfK4r
         /1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29oqjmL46qhcPK7GumgLq+DG8d/OcnmM7sBa267LNJc=;
        b=B1KsoQG/DckR6XSN2rwJcABqTJwpvDlRDcO9XaxypfuCOHpzIM++B119Lvh+Qu29Y6
         XDeRsRZBZaa/N4flJ2b680Bcyvwd113LWaRidT32hWf0Fi/r0WR53jD2S5wJmv4EyK2C
         AWPU3J+kNgrXMmTON77K3UhuRbTO4rssSJbsSab+5jV51yshOyQ+shm5REJEUPqeZ28x
         w0uHa96qTbHyMM1tP4/Hn2WUuncx68gKNi9mOTdm/CrEZwzaK8nSMkVlRFD9ghnyB3hg
         /76yMl+yuM4ayzzh9DKdIHwKKsnjycRq5QrCvCg+KX79vfKkwaUb2h2qUfsXXT9DZ0Hf
         IfJg==
X-Gm-Message-State: AOAM530Lbe7bkJHoaU9nKa9hA3EEzUAYTTO/sllD0cKDqDOoDFX+ZU3i
        K4bBEvgrrD/uO7sCMN2eCNGdAh9jTsw+d2lVEUiC3A==
X-Google-Smtp-Source: ABdhPJzw2cpdURyncHf4l37gZdIW9qTyoDRpERcWbGarQ+ldN+Qh5JZMa2Mv6dpFTys9HHv83+R10ncImdIENaH1IUM=
X-Received: by 2002:a17:906:7955:: with SMTP id l21mr8006801ejo.6.1637051995253;
 Tue, 16 Nov 2021 00:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
In-Reply-To: <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Nov 2021 14:09:44 +0530
Message-ID: <CA+G9fYuF1F-9TAwgR9ik_qjFqQvp324FJwFJbYForA_iRexZjg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Anders Roxell <anders.roxell@linaro.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 at 12:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 16 Nov 2021 at 00:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.3 release.
> > There are 917 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>

Regression found on arm64 juno-r2 / qemu.
Following kernel crash reported on stable-rc 5.15.

Anders bisected this kernel crash and found the first bad commit,

Herbert Xu <herbert@gondor.apana.org.au>
   crypto: api - Fix built-in testing dependency failures


>
> metadata:
>   git branch: linux-5.15.y
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git commit: ff5232812521d01d1ddfd8f36559a9cf83fea928
>   git describe: v5.15.2-918-gff5232812521
>   make_kernelversion: 5.15.3-rc1
>   kernel-config: https://builds.tuxbuild.com/20yUV5tYmCSzjklEffg3Dhkbdzi/config
>
> Kernel crash log:
> -----------------
> [    1.178361] kvm [1]: Hyp mode initialized successfully
> [    1.184780] Unable to handle kernel NULL pointer dereference at
> virtual address 000000000000019b
> [    1.193599] Mem abort info:
> [    1.196394]   ESR = 0x96000044
> [    1.199458]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    1.204786]   SET = 0, FnV = 0
> [    1.207848]   EA = 0, S1PTW = 0
> [    1.210998]   FSC = 0x04: level 0 translation fault
> [    1.215889] Data abort info:
> [    1.218777]   ISV = 0, ISS = 0x00000044
> [    1.222623]   CM = 0, WnR = 1
> [    1.225605] [000000000000019b] user address but active_mm is swapper
> [    1.231979] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [    1.237559] Modules linked in:
> [    1.240617] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.3-rc1 #1
> [    1.246894] Hardware name: ARM Juno development board (r2) (DT)
> [    1.252820] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    1.259793] pc : crypto_register_alg+0x88/0xe4
> [    1.264246] lr : crypto_register_alg+0x78/0xe4
> [    1.268694] sp : ffff800012b9bce0
> [    1.272008] x29: ffff800012b9bce0 x28: 0000000000000000 x27: ffff800012644c80
> [    1.279162] x26: ffff000820d95480 x25: ffff000820d96000 x24: ffff800012644d3a
> [    1.286313] x23: ffff800012644cba x22: 0000000000000000 x21: ffff800012742518
> [    1.293463] x20: 0000000000000000 x19: ffffffffffffffef x18: ffffffffffffffff
> [    1.300614] x17: 000000000000003f x16: 0000000000000010 x15: ffff000800844a1c
> [    1.307765] x14: 0000000000000001 x13: 293635326168732c x12: 2973656128636263
> [    1.314916] x11: 0000000000000010 x10: 0101010101010101 x9 : ffff80001054b5a8
> [    1.322066] x8 : 7f7f7f7f7f7f7f7f x7 : fefefefefeff6462 x6 : 0000808080808080
> [    1.329217] x5 : 0000000000000000 x4 : 8080808080800000 x3 : 0000000000000000
> [    1.336367] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff800012742518
> [    1.343517] Call trace:
> [    1.345962]  crypto_register_alg+0x88/0xe4
> [    1.350062]  crypto_register_skcipher+0x80/0x9c
> [    1.354600]  simd_skcipher_create_compat+0x19c/0x1d0
> [    1.359572]  cpu_feature_match_AES_init+0x9c/0xdc
> [    1.364284]  do_one_initcall+0x50/0x2b0
> [    1.368125]  kernel_init_freeable+0x250/0x2d8
> [    1.372488]  kernel_init+0x30/0x140
> [    1.375981]  ret_from_fork+0x10/0x20
> [    1.379562] Code: 2a0003f6 710002df aa1503e0 1a9fd7e1 (3906b261)
> [    1.385667] ---[ end trace a032e96fc9ec202d ]---
> [    1.390350] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> [    1.398018] SMP: stopping secondary CPUs
> [    1.401947] Kernel Offset: disabled
> [    1.405434] CPU features: 0x10001871,00000846
> [    1.409794] Memory Limit: none
> [    1.412849] ---[ end Kernel panic - not syncing: Attempted to kill
> init! exitcode=0x0000000b ]---
>
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> build link:
> -----------
> https://builds.tuxbuild.com/20yUV5tYmCSzjklEffg3Dhkbdzi/build.log
>
> build config:
> -------------
> https://builds.tuxbuild.com/20yUV5tYmCSzjklEffg3Dhkbdzi/config

- Naresh
