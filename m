Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8048C64B483
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 12:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiLMLyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 06:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiLMLyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 06:54:02 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2AC308
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 03:54:01 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id a66so5788827vsa.6
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 03:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZFILLndz4cbgf9FVCwj+Fm/jHKQQUcFiCQJTBVvxN0=;
        b=Z877fi9PfiVzISRKpYzAq7+/YI+HSo3SiIvlTgEhi03SCiiG69kGeaYeRrK60FeMVr
         t8azdZlIJ+dj+KViXHJRtLFWKQ0nOV3zEdPicE8crKP5iZvyD5V+1WAW/0WdtTQQRK2k
         jgzWa19eGLmHqJ8nlyRCvO23fxusjVZzAOAS++PGnNMFRjI8ckZmftOXWNhekVPyc1h6
         xkPCEGctubC0Vn9DJGGccs7yR/6mg+E90RrkKKv63snz5FcPZJNBDQ7mOv9N/jAaYqhY
         jL5xLtDnDFqCI7QQdR4BIl6qho3y7tIN9QEatLKnyH2zwADzeYOWfVys8BWqTRMTUdoB
         nP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZFILLndz4cbgf9FVCwj+Fm/jHKQQUcFiCQJTBVvxN0=;
        b=Ai/N17TLWxqvw1TWdoYCXivbH9dzowKHcK4QPSIoCX1EY+CT3VXzdGb1tTFWg4a4xz
         MRZgdhhvXPWJ//ekzF12onilGSK1Sl3vLJ4vk8ENaQd84TKeb4amXp/Isd8ug9/C5ABq
         KlGF5Jkd7fgSUomXBD+MCthGyWhwFaCp4Akma244t5jNZNfZzzJDiwdyRGzOnaREaXod
         zBp3egcQXmqyFu234C9a31roh6aqZaJ2IyyEeDkMRh7dL8kLECo1LtwDRwdB7IpeEoG5
         fdCs05A4RKYS6zPqkNGLSn6sFHlNiIfzWfb/XDQF9bjCNQn1LTmQPzxcB5pzPbV7VWe5
         vWTg==
X-Gm-Message-State: ANoB5plYGdRBIdHSCoP3lHwUcHGDYhckeD9NKVzvlOL0HICSsOw4uBVA
        RpoBwbCI4WHa5zkue3C/ySDA/rkFNZlkFzemcrLd8w==
X-Google-Smtp-Source: AA0mqf7mPKsCAWs/++OsyxwN/lViTpODKmwQHcuZDmUaD2s7CG6XjSxnxG8W6XNZgJ0GhRYbGpaSpH8K1TLt20RPPco=
X-Received: by 2002:a05:6102:dd1:b0:3b0:fd1d:3ded with SMTP id
 e17-20020a0561020dd100b003b0fd1d3dedmr17259317vst.3.1670932440266; Tue, 13
 Dec 2022 03:54:00 -0800 (PST)
MIME-Version: 1.0
References: <20221212130913.666185567@linuxfoundation.org>
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 17:23:48 +0530
Message-ID: <CA+G9fYtCTQHiW_pr+M8AVrLn-93Gf2gyP+ccx7Vr9FtUMungdg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Dec 2022 at 19:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.269-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
arm clang-nightly allnoconfig builds failed due to these warnings / errors.
for clang-nightly warning showing as error and for gcc-12 it is just a warn=
ing.

make --silent --keep-going --jobs=3D8
O=3D/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=3D1 LLVM_IAS=3D0
ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dclang CC=3Dclang
arch/arm/mm/nommu.c:163:12: error: incompatible integer to pointer
conversion assigning to 'void *' from 'phys_addr_t' (aka 'unsigned
int') [-Wint-conversion]
        zero_page =3D memblock_alloc(PAGE_SIZE, PAGE_SIZE);
                  ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.
make[2]: *** [/builds/linux/scripts/Makefile.build:303:
arch/arm/mm/nommu.o] Error 1

commit causing this build failures,
  ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation
  [ Upstream commit 340a982825f76f1cff0daa605970fe47321b5ee7 ]


## Build
* kernel: 4.19.269-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: bf741d1d7e6db2cb2fb6ba4634aaabad00089b40
* git describe: v4.19.268-50-gbf741d1d7e6d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.268-50-gbf741d1d7e6d

## Test Regressions (compared to v4.19.268)

## Metric Regressions (compared to v4.19.268)

## Test Fixes (compared to v4.19.268)

## Metric Fixes (compared to v4.19.268)

## Test result summary
total: 95070, pass: 81469, fail: 1691, skip: 10892, xfail: 1018

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 316 passed, 7 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
