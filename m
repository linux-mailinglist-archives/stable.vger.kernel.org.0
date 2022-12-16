Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C759B64EA6C
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLPL37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiLPL36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:29:58 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EA25B5AA
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:29:57 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id 128so1951534vsz.12
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hshIBEO5BuJMMxhTO5nPRgbV6MtjaGSC1XWTlwofzlQ=;
        b=hRCHQBzYfAPjof8qyZ7LpH+ZxcjuKew4xm3kTaLQkzA6nCGqcHlLehPlJMDSndoVFL
         xuU6w05g9AnDpxzXNta/MeF8g/PPsxGIv1ASXyPhFJh29iqYtTvz4yw9lOrEyCC8/1FO
         +rJudARnDTCeB935/0P54q8kjceKZ90INGVGZd++jDXY9h/iU+V2JJe/b+d3yOV3F8Uo
         xwkPMx9MhWeLjhLxgYewUQIB0u0oYUPhcmh4Ul4eAAhN9nbnQIGwoVVWBUjN2bi7w4sm
         sPZ9eUy/GD8/GgFHQEkvdey72s4Do11qv89DJKoXwvTo7iLNTuX4Z6PtIviNCcMbO6FO
         o1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hshIBEO5BuJMMxhTO5nPRgbV6MtjaGSC1XWTlwofzlQ=;
        b=5y2KQ/dXuLtQy7F57vbZ/Cfy1rLYF8tVx/J8T6C5h8kmKTS/4cWUm2KrLHMGozinIp
         b7i8ZpC4lKKlvzpa7vAsyan90gb3hdeP00r14vmr1oAswn7a1Yd3zMVNPgdi8KrdemE2
         K32CPGu+vX0Ha/iH9UpNGtbpk2wQGGluk24FNCbwSxNsCYQa5xVqRHpOlvaHS6qtY7Ds
         RRXDzsB1tIbtJf9mmXG00kE5tLXkAGyB0KerJTzFyMs5jkcrFnLNrGEQjd/iJdOxZkmg
         SagoG/SQSMO30NROkBg64aWbUlEMZ/OS6i0FDO3Wx58ICBl9L4yQ0ov065t+hRoTuSSH
         69Fw==
X-Gm-Message-State: ANoB5pnZ8bZKikmsDP9a5Aurz9up5wOP+31t9kKHrzA8L52ORAtsvfkN
        IIv+0pyOiC9glqOdMwlANGeG5kCthQ51E/kjq5mBr581PnpLIDim
X-Google-Smtp-Source: AA0mqf5CblcmqOzxnaAelHLLb0E7zJ7XbpKeujmgCHGkstQ2halSCUqOY/KblEIwVEu5GOwEyVLHgw38hS0DTvc6Um4=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr2385835vsv.9.1671190196636; Fri, 16 Dec
 2022 03:29:56 -0800 (PST)
MIME-Version: 1.0
References: <20221215172905.468656378@linuxfoundation.org>
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Dec 2022 16:59:45 +0530
Message-ID: <CA+G9fYu=CvaCaVSnGjXO7TF-XcOYqzcetLARozCkHGsJveqCKA@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

On Thu, 15 Dec 2022 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.228-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.228-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: e538d4b64ed30c6b7248a14b4e8641db4db16736
* git describe: v5.4.227-10-ge538d4b64ed3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
27-10-ge538d4b64ed3

## Test Regressions (compared to v5.4.226-68-g8c05f5e0777d)

## Metric Regressions (compared to v5.4.226-68-g8c05f5e0777d)

## Test Fixes (compared to v5.4.226-68-g8c05f5e0777d)

## Metric Fixes (compared to v5.4.226-68-g8c05f5e0777d)

## Test result summary
total: 114869, pass: 99876, fail: 1964, skip: 12795, xfail: 234

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
* libgpiod
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
* ltp[
* network-basic-tests
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
