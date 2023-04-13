Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A04D6E0A45
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 11:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjDMJaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 05:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMJad (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 05:30:33 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A2D977E
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 02:30:14 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id ba16so9844490uab.4
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 02:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681378213; x=1683970213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ojk98C2P2738VliLRVk9E7Fs2BzwlSkZpm6Xrm321Yc=;
        b=QtJqlC9LOkPPOEpo/w2pdMzX+H860RBxG0Q+p/WHjdcROwn4+1e1tPUju+B39bDSaG
         DoXsITmQgQ0fzr5MyB5eiGYGAlVvbENxW7fQIqICDzLyke0eHy+S9druBsAVfsqMHgWq
         HFAlkQY5rhzIK3Kn8pf0Pyr7XUenSP6OZt57z7pgPNSoyBayIaf6c/1ZMxDG4Wl6wKkx
         PLcUzwscTy1nne3MC7R4Rn/EQhYkA9Np3Tr37EJVIf62Cxw9zELuRTFDZchoydC3yoRs
         c7DezEqRcQhFlxPI/0Yv+DMaxShcqFb3VLXGx3Mq0ZR+Oy9oPOsBPAwCX8upn3SuB77R
         zyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681378213; x=1683970213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ojk98C2P2738VliLRVk9E7Fs2BzwlSkZpm6Xrm321Yc=;
        b=Glh+CvSQXrBcKCGvB+jdrA5584/NBzk4uR62OTSrmCh9i0VQApKmDW+8KDUm3R9WFz
         /Z2sfoBb7gKtQPrb3Z8ymKPYdc1SOt91TcVzCYiYUiWTDwkDVrAW4RpQ/gkmhdeI9A7m
         ky1bpPQrvp/3gTAt63G8p20ONRmL5E0l34sYVV0tSjwxzfDrnnq4YeIEulTqyrjwMa7N
         ZbpLqntzih5GDNzCyggDsy49Kaw2mRDsFjXQZ8G/DDSP+pkHCdn6td84xEc/caNKMrNl
         KPLU51r9OLe/9nYk88SmFunD8e/F3Aup65ZGQ7i54P3tax94ipMIoqIofZDsO9E5e7+N
         p0pQ==
X-Gm-Message-State: AAQBX9dFxQ1qdjTybBr4HP5dOEj2n5Em+DVhwA2L8Ml1QoYMx9v+cVJH
        fiIvbHJG6IcPWbXJ0jAOFpnr11AnORX80zaBWac4tA==
X-Google-Smtp-Source: AKy350a3aoVp2K2USsb8M5VGKcmDbrINPT8BRK1Y4L/VFXI/l1ATe0okX2x9OziPyE5EeyrEAMIB2EekMorde0h+KBM=
X-Received: by 2002:ab0:4ad6:0:b0:687:afc8:ffb9 with SMTP id
 t22-20020ab04ad6000000b00687afc8ffb9mr781660uae.2.1681378212428; Thu, 13 Apr
 2023 02:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230412082836.695875037@linuxfoundation.org>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 Apr 2023 15:00:01 +0530
Message-ID: <CA+G9fYs7nPmYU9-w0zdSTcs_mGWJTwKxj2_YOkoTTH_Y2-eL0w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Apr 2023 at 14:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.24-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 3ffd355e5e57467adbc1a65ccc871125bb75c36e
* git describe: v6.1.22-344-g3ffd355e5e57
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-344-g3ffd355e5e57

## Test Regressions (compared to v6.1.22)

## Metric Regressions (compared to v6.1.22)

## Test Fixes (compared to v6.1.22)

## Metric Fixes (compared to v6.1.22)

## Test result summary
total: 153669, pass: 135435, fail: 4189, skip: 13710, xfail: 335

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
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
* kselftest-net-mptcp
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
