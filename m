Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E3522B91
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 07:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiEKFQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 01:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiEKFQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 01:16:55 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B7752E6F
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:16:53 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2fb9a85a124so4901647b3.13
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K7vluCZEPRmcKgiJXvMD7fUmvJ/aH53x/09ad+GgHBE=;
        b=gLLOvMo/RuPEjsE+pHY40C1Y8GNlNEN/5IT2ix3jhWDY5XordkvFaFtJLdtkJAkP19
         k1VlMpycA5ecu9CqXR/R/xCdNyJ6X8PlXhgtk59cCkUADS9+6oBCS6/0NXnWEqKJ5Wb5
         wNA3ns01G0P1WwQEOXVqpdGRv4ixxRpIx4B+A2zTxypQaHp9HVVTsqX170Ds40kCEVao
         eB33lILpSpAUgG8007snqrX5nbuidcvST69cE5iSZdmfcr6zt3suwuCbybNLMwUnuiul
         HszgLVp2G8inhV3+zlfgPl6eeDiASgELm/BBbpvXIX2B71cnnk7Ux9XrVKNmM2jlnutk
         0c0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K7vluCZEPRmcKgiJXvMD7fUmvJ/aH53x/09ad+GgHBE=;
        b=URc+K4NCZEaDSFJTtUCnfXDVUqXHQVT7L5E3v3VCMyxAH3KyIj//QeGVt0ZPjkPZH3
         zTNy04wGdScBZFgcfWXK5jNXzM9RUtUd/FcczIvXG9dgfTK24VFbAOa0PdsW4UEilW7c
         zseZzn6X4C3FlJ7Pnnnf8/3AWX6AItKfMqd5hugjwjbieR9D+C1TIpRSFWBS7793onDc
         qwIKpAGc9qVsIfafLJjDXHBXKn4BUc+yiswDKij/LN46ypRsosVrV7SA+d2DgYB1cDEy
         jUmdIjgQDG+F8WO+nV2j5Sf4pK57MvlP8zmFt38QPba76a/YZa9hjkBQetX++kG5cGa5
         Xbng==
X-Gm-Message-State: AOAM532vc/KJxC6p5pyr3ti6rvGwmQxfSb+mIsxBo1Kb6i1Dmf7OLmK/
        9c/9JnN1ObkiDtQwWuU5R5N6DFZwzjot/x0d8Rhe/Q==
X-Google-Smtp-Source: ABdhPJy64xOdrMNxugRq3EWe7akbLXc+bIB7h7uYmhW2YbTvkv+HCuR3JKsn7DyqPB9G5pGT82lSQCVWglUj9nvTmwE=
X-Received: by 2002:a0d:ffc3:0:b0:2eb:2327:3361 with SMTP id
 p186-20020a0dffc3000000b002eb23273361mr23097388ywf.36.1652246213044; Tue, 10
 May 2022 22:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130740.392653815@linuxfoundation.org>
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 10:46:41 +0530
Message-ID: <CA+G9fYvgoK6PVm495QjQ004WszeNdt+zkw-hYfArE_p1mNmmkw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 at 19:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.39-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.39-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 60041d0985244b5cda37d857a7807f2d572b3762
* git describe: v5.15.37-314-g60041d098524
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.37-314-g60041d098524

## Test Regressions (compared to v5.15.37-259-gab77581473a3)
No test regressions found.

## Metric Regressions (compared to v5.15.37-259-gab77581473a3)
No metric regressions found.

## Test Fixes (compared to v5.15.37-259-gab77581473a3)
No test fixes found.

## Metric Fixes (compared to v5.15.37-259-gab77581473a3)
No metric fixes found.

## Test result summary
total: 103063, pass: 87539, fail: 626, skip: 13925, xfail: 973

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* timesync-off
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
