Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBC67A799
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 01:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjAYAYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 19:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbjAYAYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 19:24:53 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0A64DE15
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 16:24:21 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bk15so43436450ejb.9
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 16:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzQQeyRfF2HV87Fjpq/ubdYSdShKPB/6MX+ctSBVpyI=;
        b=eIEaa8PiCo3WUjR5xIgIkA1oj+ipnHw1vB8ibe6d8sQRY6nc9Nxl4UOMvhlPOY2i3I
         P1L7KF0OjyBKyULKUOEAIhLGk6fIrrsQDgwO9eS+okwYq2Vw1XnEEi0OlJc+mgTYkmcr
         KjHQFXPSFABxNU2XU5e3XKmUmKSNZoMmttwM6zSVdiiezS+QO3wEWOfbGw2KLAhiN/NV
         KYX6e9Az3R75e1IthzUAEfBYLuhI6ubzjDzKzZae4xAGNAJtgDZ7WL8ihlc7ZlYIsUzo
         1VrhW+fJnIPsnCbkD4p6uW5IlAwqoesVNqbW+dAjR1aAJUkM2Z/cXas9myCWvfOQ/JC2
         zrOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzQQeyRfF2HV87Fjpq/ubdYSdShKPB/6MX+ctSBVpyI=;
        b=JEwlDyQ1/sMYjTIn9P3b0PQw7+VeL5zGyIYl7qkYWLG5LhGnNqY7XHyZE00OEWKDi9
         AcWoMnoqcKWepR1uUCXvj0XZkEyhbvR3CyVO2JHEvq78coxLEIdG90GMktSwp1JMG0Z6
         4luqin2Z6h/ZBHj4oYxzUnXUC1TkWC6iY8Pqfdd+6lJ5vgyvcfmILZvGTbJo/l8DyYMd
         AOPobwmJJAXEWlfoB0Joa16xNMWQFiziyq6sXlAJb1mbE9AiIILotXY62TIx/wj3pcdK
         X3ZsOtsj8oKmZlRpFjQs6UFo49Uns1rHDQAtPiedzqj4NB3ruqWjmLMETp1Sxxu4R2Wk
         1qAg==
X-Gm-Message-State: AFqh2krSDKxtKZ7LazqB1dim6GTRA3fim6ldScTy2VJpD68+Y+NGuOCY
        +Tz/M+oPj2T/0+9gbo21am5Q4Oy/lq+Bjf7oesBI1Q==
X-Google-Smtp-Source: AMrXdXuG1Dspmth4tKgruP5/Bny5y4x0FAkx5NJl2FczoMQ1ufzc8vtp4vOxGR5ZyJOymp/MMcBmcnWDsTO6nAoJdDI=
X-Received: by 2002:a17:906:1946:b0:870:e329:5f3b with SMTP id
 b6-20020a170906194600b00870e3295f3bmr3545795eje.255.1674606251954; Tue, 24
 Jan 2023 16:24:11 -0800 (PST)
MIME-Version: 1.0
References: <20230123094914.748265495@linuxfoundation.org> <CA+G9fYvgEEOkatUJB1p_DQuL1BcDyk9mq-3d-iUjgxhP+pONTw@mail.gmail.com>
In-Reply-To: <CA+G9fYvgEEOkatUJB1p_DQuL1BcDyk9mq-3d-iUjgxhP+pONTw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 25 Jan 2023 05:53:59 +0530
Message-ID: <CA+G9fYvXfmrBMUULtDKyG4Z8aHSa10R=Oth9maJ-hCuJ+Xy51Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
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

+ qemu-devel

On Tue, 24 Jan 2023 at 15:22, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.165 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.165-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> Regressions found on arm64 for both 5.15.90-rc2 and 5.10.165-rc2.
>
> * qemu-arm64-mte, kselftest-arm64
>   - arm64_check_buffer_fill
>   - arm64_check_child_memory
>   - arm64_check_ksm_options
>   - arm64_check_mmap_options
>   - arm64_check_tags_inclusion
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> We are in a process to bisect this problem and there are updates coming
> from kselftest rootfs.

Here is a interesting findings,

The bisect process was not successful.

I have investigated the infrastructure changes and found qemu updated to 7.=
2
 1. qemu version 7.2 caused this regressions
 or we can put in this way,
 2. qemu version 7.2 has better coverage to find better regressions.

Old version of qemu 7.1 selftests/arm64 test passed.

lava-dispatcher, installed at version: 2022.11.1
qemu-system-arm, installed at version: 1:7.1+dfsg-2~bpo11+3, host
architecture: arm64


New version of qemu 7.2 selftests/arm64 test failed.

* qemu-arm64-mte, kselftest-arm64 failed tests,
  - arm64_check_buffer_fill
  - arm64_check_child_memory
  - arm64_check_ksm_options
  - arm64_check_mmap_options
  - arm64_check_tags_inclusion

lava-dispatcher, installed at version: 2023.01
qemu-system-arm, installed at version: 1:7.2+dfsg-1~bpo11+2, host
architecture: arm64

With reference to my previous emails,
This is not a kernel regression on stable-rc 6.1, 5.15, and 5.10.

--=20
Looking into 7.2 release blog post i have found following highlights,

QEMU version 7.2.0 released
14 DEC 2022
We=E2=80=99d like to announce the availability of the QEMU 7.2.0 release. T=
his
release contains 1800+ commits from 205 authors.

You can grab the tarball from our download page. The full list of
changes are available in the Wiki.

Highlights include:

* ARM: emulation support for the following CPU features: Enhanced
Translation Synchronization, PMU Extensions v3.5, Guest Translation
Granule size, Hardware management of access flag/dirty bit state, and
Preventing EL0 access to halves of address maps
* ARM: emulation support for Cortex-A35 CPUs
* LoongArch: support for fw_cfg DMA functionality, memory hotplug, and
TPM device emulation
* OpenRISC: support for multi-threaded TCG, stability improvements,
and new =E2=80=98virt=E2=80=99 machine type for CI/device testing.
* RISC-V: =E2=80=98virt=E2=80=99 machine support for booting S-mode firmwar=
e from
pflash, and general device tree improvements
* s390x: support for Message-Security-Assist Extension 5 (RNG via PRNO
instruction), SHA-512 via KIMD/KLMD instructions, and enhanced zPCI
interpretation support for KVM guests
* x86: TCG performance improvements, including SSE
* x86: TCG support for AVX, AVX2, F16C, FMA3, and VAES instructions
* x86: KVM support for =E2=80=9Cnotify vmexit=E2=80=9D mechanism to prevent=
 processor
bugs from hanging whole system
* LUKS block device headers are validated more strictly, creating LUKS
images is supported on macOS
* Memory backends now support NUMA-awareness when preallocating memory
and lots more=E2=80=A6
 - https://www.qemu.org/blog/




>
> Test logs,
> # selftests: arm64: check_buffer_fill
> # 1..20
> # ok 1 Check buffer correctness by byte with sync err mode and mmap memor=
y
> # ok 2 Check buffer correctness by byte with async err mode and mmap memo=
ry
> # ok 3 Check buffer correctness by byte with sync err mode and
> mmap/mprotect memory
> # ok 4 Check buffer correctness by byte with async err mode and
> mmap/mprotect memory
> # not ok 5 Check buffer write underflow by byte with sync mode and mmap m=
emory
> # not ok 6 Check buffer write underflow by byte with async mode and mmap =
memory
> # ok 7 Check buffer write underflow by byte with tag check fault
> ignore and mmap memory
> # ok 8 Check buffer write underflow by byte with sync mode and mmap memor=
y
> # ok 9 Check buffer write underflow by byte with async mode and mmap memo=
ry
> # ok 10 Check buffer write underflow by byte with tag check fault
> ignore and mmap memory
> # not ok 11 Check buffer write overflow by byte with sync mode and mmap m=
emory
> # not ok 12 Check buffer write overflow by byte with async mode and mmap =
memory
> # ok 13 Check buffer write overflow by byte with tag fault ignore mode
> and mmap memory
> # not ok 14 Check buffer write correctness by block with sync mode and
> mmap memory
> # not ok 15 Check buffer write correctness by block with async mode
> and mmap memory
> # ok 16 Check buffer write correctness by block with tag fault ignore
> and mmap memory
> # ok 17 Check initial tags with private mapping, sync error mode and mmap=
 memory
> # ok 18 Check initial tags with private mapping, sync error mode and
> mmap/mprotect memory
> # ok 19 Check initial tags with shared mapping, sync error mode and mmap =
memory
> # ok 20 Check initial tags with shared mapping, sync error mode and
> mmap/mprotect memory
> # # Totals: pass:14 fail:6 xfail:0 xpass:0 skip:0 error:0
> not ok 34 selftests: arm64: check_buffer_fill # exit=3D1
>
>
> # selftests: arm64: check_child_memory
> # 1..12
> # not ok 1 Check child anonymous memory with private mapping, precise
> mode and mmap memory
> # not ok 2 Check child anonymous memory with shared mapping, precise
> mode and mmap memory
> # not ok 3 Check child anonymous memory with private mapping,
> imprecise mode and mmap memory
> # not ok 4 Check child anonymous memory with shared mapping, imprecise
> mode and mmap memory
> # not ok 5 Check child anonymous memory with private mapping, precise
> mode and mmap/mprotect memory
> # not ok 6 Check child anonymous memory with shared mapping, precise
> mode and mmap/mprotect memory
> # not ok 7 Check child file memory with private mapping, precise mode
> and mmap memory
> # not ok 8 Check child file memory with shared mapping, precise mode
> and mmap memory
> # not ok 9 Check child file memory with private mapping, imprecise
> mode and mmap memory
> # not ok 10 Check child file memory with shared mapping, imprecise
> mode and mmap memory
> # not ok 11 Check child file memory with private mapping, precise mode
> and mmap/mprotect memory
> # not ok 12 Check child file memory with shared mapping, precise mode
> and mmap/mprotect memory
> # # Totals: pass:0 fail:12 xfail:0 xpass:0 skip:0 error:0
> not ok 35 selftests: arm64: check_child_memory # exit=3D1
>
> # selftests: arm64: check_ksm_options
> # 1..4
> # # Invalid MTE synchronous exception caught!
> not ok 37 selftests: arm64: check_ksm_options # exit=3D1
>
>
> # selftests: arm64: check_mmap_options
> # 1..22
> # ok 1 Check anonymous memory with private mapping, sync error mode,
> mmap memory and tag check off
> # ok 2 Check file memory with private mapping, sync error mode,
> mmap/mprotect memory and tag check off
> # ok 3 Check anonymous memory with private mapping, no error mode,
> mmap memory and tag check off
> # ok 4 Check file memory with private mapping, no error mode,
> mmap/mprotect memory and tag check off
> # not ok 5 Check anonymous memory with private mapping, sync error
> mode, mmap memory and tag check on
> # not ok 6 Check anonymous memory with private mapping, sync error
> mode, mmap/mprotect memory and tag check on
> # not ok 7 Check anonymous memory with shared mapping, sync error
> mode, mmap memory and tag check on
> # not ok 8 Check anonymous memory with shared mapping, sync error
> mode, mmap/mprotect memory and tag check on
> # not ok 9 Check anonymous memory with private mapping, async error
> mode, mmap memory and tag check on
> # not ok 10 Check anonymous memory with private mapping, async error
> mode, mmap/mprotect memory and tag check on
> # not ok 11 Check anonymous memory with shared mapping, async error
> mode, mmap memory and tag check on
> # not ok 12 Check anonymous memory with shared mapping, async error
> mode, mmap/mprotect memory and tag check on
> # not ok 13 Check file memory with private mapping, sync error mode,
> mmap memory and tag check on
> # not ok 14 Check file memory with private mapping, sync error mode,
> mmap/mprotect memory and tag check on
> # not ok 15 Check file memory with shared mapping, sync error mode,
> mmap memory and tag check on
> # not ok 16 Check file memory with shared mapping, sync error mode,
> mmap/mprotect memory and tag check on
> # not ok 17 Check file memory with private mapping, async error mode,
> mmap memory and tag check on
> # not ok 18 Check file memory with private mapping, async error mode,
> mmap/mprotect memory and tag check on
> # not ok 19 Check file memory with shared mapping, async error mode,
> mmap memory and tag check on
> # not ok 20 Check file memory with shared mapping, async error mode,
> mmap/mprotect memory and tag check on
> # not ok 21 Check clear PROT_MTE flags with private mapping, sync
> error mode and mmap memory
> # not ok 22 Check clear PROT_MTE flags with private mapping and sync
> error mode and mmap/mprotect memory
> # # Totals: pass:4 fail:18 xfail:0 xpass:0 skip:0 error:0
> not ok 38 selftests: arm64: check_mmap_options # exit=3D1
>
>
> # selftests: arm64: check_tags_inclusion
> # 1..4
> # # No valid fault recorded for 0x500ffffb8b27000 in mode 1
> # not ok 1 Check an included tag value with sync mode
> # # No valid fault recorded for 0x400ffffb8b27000 in mode 1
> # not ok 2 Check different included tags value with sync mode
> # ok 3 Check none included tags value with sync mode
> # # No valid fault recorded for 0xa00ffffb8b27000 in mode 1
> # not ok 4 Check all included tags value with sync mode
> # # Totals: pass:1 fail:3 xfail:0 xpass:0 skip:0 error:0
> not ok 40 selftests: arm64: check_tags_inclusion # exit=3D1
>
> Test logs,
> https://lkft.validation.linaro.org/scheduler/job/6087664#L4865
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.=
10.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/test/arm64_=
check_tags_inclusion/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.=
10.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/tests/
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.=
15.87-219-g60931c95bb6d/testrun/14329656/suite/kselftest-arm64/tests/
>
> --
> Linaro LKFT
> https://lkft.linaro.org
