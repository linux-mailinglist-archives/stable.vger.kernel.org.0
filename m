Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280CF4F7601
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiDGG3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241077AbiDGG3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:29:06 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AC023140
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 23:27:06 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id o62so7926226ybo.2
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 23:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5mKuLfEu/XgxaX2jy+hBrSqJETshC2bp0HB62gqa9as=;
        b=ijWyXBIU2gTvhFS1E8a8eFBl4dLddumMhFj95hUgEpPnrsAdxvDOez3JKjfVLmCDC8
         pT5X4PU16JZNf1Xwn8+1qSFdC/anxn+LfFM/2SAb9FV1OKsWDT5C1qJYNGu3U+H9ZbXh
         pRzSN5chWjRGaG+91pr+97QccPnWzoGd1/GdcaeRTIT3LmKGnzaZNgmwE4Ub3gqFLJ6/
         VtJ4UQID0YojRhupDZ9D2ryu9KP16I43NCK+obhrag6lWUfUR87hyvRz/OCVa+YZUxXQ
         ZGTKdlkgVx7ZEmgEOyV5bX/FMrms9wD2hol7mbseJ84CoLvQZKsEYjCasGQbYTYpEpmR
         3+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5mKuLfEu/XgxaX2jy+hBrSqJETshC2bp0HB62gqa9as=;
        b=8BaMHvPCnXPUw3vM1yi09uKf28y00JzpSc1mGLDxkWzzYWjgkviVcnx8e5lUCDrspy
         3AQJsK5KNqWVuVkrz4hWifGTUpEFt9wouN5MYBGBxPkYuDwnirymtgFD78X5dINE3y0n
         +HkVuiesfT076WNQtYaFCabPOyv5dVFOuLG/hXHR6opABearvBp/SYFYtKD/3fAgxkrs
         fMO9JK0YVjo5OU72U6+7dtp0HcR++5LJvLHXDJ93fMMaSG38NgL019lsH9hqKGX2S6a2
         TlMm9Z0yBFX5jdaop78jviRtOQxEDzycEZc4GYbAJpvnhroczmqjl9J+zkQ4kr2QY5vh
         brTw==
X-Gm-Message-State: AOAM532USFYJOgGbxyh8qpB2A6CLy/YFXMl4MBJ/A3/VbNO3lcF6OCyd
        g4PTd05j4wc2uErhQTh6JlskS5ZhQ7YlmJZBPRTZBw==
X-Google-Smtp-Source: ABdhPJyROADdkMq9pW7+A1qoOWOj6ZUsJeKyNaQKPXuuR9mtzSUEzntyZ/5alX+/W3USXgYeX9zTgHL2suqfY9ixmtw=
X-Received: by 2002:a25:dfc4:0:b0:63d:b28e:93ec with SMTP id
 w187-20020a25dfc4000000b0063db28e93ecmr9426015ybg.474.1649312826038; Wed, 06
 Apr 2022 23:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220406133109.570377390@linuxfoundation.org>
In-Reply-To: <20220406133109.570377390@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Apr 2022 11:56:54 +0530
Message-ID: <CA+G9fYv+-ZGGkX288PzupW9c5CnWTK8d_=2j=0zJNd3=A5oy4g@mail.gmail.com>
Subject: Re: [PATCH 5.16 0000/1014] 5.16.19-rc2 review
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

On Wed, 6 Apr 2022 at 19:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1014 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.19-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.19-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 18299e64680a0cbdf745fd73c5345d9a029928b9
* git describe: v5.16.18-1015-g18299e64680a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.18-1015-g18299e64680a

## Test Regressions (compared to v5.16.18-959-gef4d007f65de)
No test regressions found.

## Metric Regressions (compared to v5.16.18-959-gef4d007f65de)
No metric regressions found.

## Test Fixes (compared to v5.16.18-959-gef4d007f65de)
No test regressions found.

## Metric Fixes (compared to v5.16.18-959-gef4d007f65de)
No metric fixes found.

## Test result summary
total: 104242, pass: 87607, fail: 1089, skip: 14348, xfail: 1198

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kself[
* kselftest-
* kselftest-android
* kselftest-arm64
* kselftest-bpf
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
