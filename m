Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2463766D9F9
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbjAQJbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 04:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbjAQJaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 04:30:24 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B371814D
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 01:29:19 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id q125so19821769vsb.0
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 01:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlEPnwSHAjZr4NXcVpqzSG2AW1hG4W7rPTERaEZE/P8=;
        b=rJFfuSn8QWqsY1C/Cs3RGIp1ElNdVoXaCEe7apJpvEsCvzA0o2G6fa7bSRiX3cy9Em
         RAoiy1jQxGKKcOimAavu29f7AiPA94DEp/fehPo16O6fpJs56NDpf5RfcvgvTl3aYezw
         T5dARuIzB+7iCPpcBE9AfrYRhxHKoOPk8CHMPb9Ix7RbqamsnLPU+H94l/ufz1pVC2He
         abCWUJR7F8puA2qhoSseFXcLUV5ZrSJ0esF0rtLOXosHvnfQcOyiY/dDfrh681S0dX0t
         Vl9egqV0jQgnFDJ5OF0XH6sxdHJKWtB3e7yHdPG1xptDYWOTuNaI1RuEONlluwcvCKX+
         7GCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlEPnwSHAjZr4NXcVpqzSG2AW1hG4W7rPTERaEZE/P8=;
        b=Ag+CldAkdtkIk2VvYF39FvkIPQATO3B8Imc2HCK7bpm2ot2BEN+bToHm/+0w4qNGNB
         tGAc9ECftGAratqrE2SL/OHzvS99/dFZz96sDsYYQyRtUKT/lENIezDmRfH40kl59QMC
         fZ5mAqGzWI1ECNdr6jjO+O5MjLt5nJXi0jNRrFjcTX6zkDk8H26cct1w56jRZghrKHTf
         iHiupI7wMZSFr5VoZMM9n8EJ47zVpYVlghUaI1RlrXj1gVWf7j6tsVMp0CrvKz3+L03+
         KBjj8I/tqHDcCuzhMxtqlbbq3/H9mrbd6U0SlHemb0pexV7zeTEqjBGpNH6cNXZtx9EK
         osiw==
X-Gm-Message-State: AFqh2kpg/WM43Atlfzv4rmTLlw6oVZGVpx2gfKoFA6gfzJSodiPasOaP
        rA1dhHzJcpR0esspQpD/6tgQkKsHoWl1Y2JRjLEhbw==
X-Google-Smtp-Source: AMrXdXuD/vWSIHrO86e7jvneaPF9xijTE2czSJFhJSQIV8crGRsjdhOyrbDG9UHVrxcGQotByo5ZQNweJ3w6ywDP/Cw=
X-Received: by 2002:a05:6102:5587:b0:3b5:32d0:edcc with SMTP id
 dc7-20020a056102558700b003b532d0edccmr267127vsb.24.1673947758901; Tue, 17 Jan
 2023 01:29:18 -0800 (PST)
MIME-Version: 1.0
References: <20230116154909.645460653@linuxfoundation.org> <20230116202025.GA3397667@roeck-us.net>
In-Reply-To: <20230116202025.GA3397667@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Jan 2023 14:59:08 +0530
Message-ID: <CA+G9fYswDKDVtmSNw7VhYCYynY3m8+taBcKN3-XRBa+BKDuMnQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/658] 5.4.229-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Chen Huang <chenhuang5@huawei.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Jan 2023 at 01:50, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Jan 16, 2023 at 04:41:28PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.229 release.
> > There are 658 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> >
>
> Note: Exactly the same failures are seen in v4.19.269-522-gc75d2b5524ab,
> so I won't bother sending test results for that branch.
>
> ---
>
> Build results:
>         total: 159 pass: 153 fail: 6
> Failed builds:
>         i386:tools/perf
>         riscv:defconfig
>         s390:allnoconfig
>         s390:tinyconfig
>         um:defconfig
>         x86_64:tools/perf
> Qemu test results:
>         total: 449 pass: 413 fail: 36
> Failed tests:
>         <all ppc64:pseries>
>         <all riscv>
>
> Details follow.
>
> Guenter
>
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Building i386:tools/perf ... failed
> Building x86_64:tools/perf ... failed
> --------------
> Error log:
> util/debug.c: In function =E2=80=98perf_quiet_option=E2=80=99:
> util/debug.c:237:2: error: =E2=80=98debug_peo_args=E2=80=99 undeclared
>
> Building riscv:defconfig ... failed
> --------------
> Error log:
> arch/riscv/kernel/stacktrace.c: In function 'walk_stackframe':
> arch/riscv/kernel/stacktrace.c:58:36: error: 'struct pt_regs' has no memb=
er named 'epc'

The above build error is caused due to,
riscv/stacktrace: Fix stack output without ra on the stack top


>
> Building s390:allnoconfig ... failed
> Building s390:tinyconfig ... failed
> --------------
> Error log:
> s390-linux-ld: drivers/base/platform.o: in function `devm_platform_get_an=
d_ioremap_resource':
> platform.c:(.text+0x594): undefined reference to `devm_ioremap_resource'
> s390-linux-ld: platform.c:(.text+0x5c2): undefined reference to `devm_ior=
emap_resource'
>
> Building um:defconfig ... failed
> --------------
> Error log:
> ld: drivers/base/platform.o: in function `devm_platform_get_and_ioremap_r=
esource':
> drivers/base/platform.c:82: undefined reference to `devm_ioremap_resource=
'

Linaro test farm also noticed above listed build errors
+ x86_64 clang-nightly deconfig, allnoconfig and tinyconfig.

arch/x86/kernel/fpu/init.c:181:2: error: 'struct (unnamed at
arch/x86/kernel/fpu/init.c:181:2)' cannot be defined in
'__builtin_offsetof'
        CHECK_MEMBER_AT_END_OF(struct fpu, state);
        ^

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
28-659-gb3b34c474ec7/testrun/14188759/suite/build/test/clang-nightly-x86_64=
_defconfig/log

--
Linaro LKFT
https://lkft.linaro.org
