Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0165C69DA7D
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 06:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjBUFrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 00:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjBUFrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 00:47:10 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133D9234FE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 21:47:09 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id u5so1947936vkl.4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 21:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676958428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izZIdNC3oqCcDjjoV42j9HMelGZKUkI04FqEVyWoCmY=;
        b=z0y/ADi/bAys//DbnHAbukcnOpshX9E+Ty6O2BdReCuGag83Mq1Lsz7qkp3sucyTiZ
         n/fCnVlRCpbvdHhAW4XGkxvmEtXhuH5apEobAmAAj8L/5vvlYpvXZmcmIqcICD6EUR5p
         1B/TO1kZhz/Kqg9JxCvY0BZzXz0XZMEb6epIYwpA0Hryycy/ACGY/iNP8Ypb5Gv0/6W1
         y7jyvBrcS2yseS8QEpr44gwKz1fsfIjYrJMsPzvf8GJWR5hDFFsfPmn5/eI0as5b2zXD
         2bf+mcJ7/nl9tGn+2tePTZQp/cRo7isOJW8lJ+/cXCPz+m4PkOM9Z44S8uBxa0G17qLp
         uvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676958428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izZIdNC3oqCcDjjoV42j9HMelGZKUkI04FqEVyWoCmY=;
        b=GRO1OMz7kiHVcxCBf1bB3MQ1nvYhQMNBdyY9eloz2zcpk+BbF5e6HR6AvPoCRISUq3
         Rtjt1r42uEjob2HpBGSVvrM7DRwJKrPZFn23cJeo3uViurxQo604OCmXFDFoV5QBZFug
         WOrXu0KO5BVX4fpaJ9pG2WXO05hnFm7pORrrXoQrDsH3HSr6LLPKsYd4/OzAiiUdVdPQ
         vO+o0zBZYwTxyUf/4+FNdMV3wQ+TCsRuOSi4R6EevVfFg4OQqXMdVsnm8xDGEipMmbEA
         ISxOZdgTOHq4yleNICbc8AZJBf3guL5dn5zNvYC95EgGPazX9l5txQGFh6djf87BF6hk
         ixbQ==
X-Gm-Message-State: AO0yUKXEAsSpCEYfOga3PUlGyJzlWaBq71dc4i5tPaXRynNywphdx7Sl
        gT1deRaj7VfaJ3DFC7van9oPkJ/+0/qpoKjXxQXdLQ==
X-Google-Smtp-Source: AK7set/u3U4D8gdeGLsXb6Hi6rhMzFLbqN7ZkZLMZLT7RN2ROxu7BcWk2nTJPI/Rma8QvKYZrNXuNAT/xvWPNTCLpr4=
X-Received: by 2002:a1f:2305:0:b0:40e:eec8:6523 with SMTP id
 j5-20020a1f2305000000b0040eeec86523mr261620vkj.43.1676958427971; Mon, 20 Feb
 2023 21:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20230220133600.368809650@linuxfoundation.org>
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Feb 2023 11:16:57 +0530
Message-ID: <CA+G9fYtJHeGi+xsMf5Vf6Udo3Rp0Dnjn_X-O2OndWWLL2kUiDg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
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

On Mon, 20 Feb 2023 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.13-rc1.gz
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
* kernel: 6.1.13-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: fc84fcf24fda6858e5ca04afe4516846e5b1cd25
* git describe: v6.1.12-119-gfc84fcf24fda
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
2-119-gfc84fcf24fda

## Test Regressions (compared to v6.1.11-115-g9012d1ebd323)

## Metric Regressions (compared to v6.1.11-115-g9012d1ebd323)

## Test Fixes (compared to v6.1.11-115-g9012d1ebd323)

## Metric Fixes (compared to v6.1.11-115-g9012d1ebd323)

## Test result summary
total: 129915, pass: 115205, fail: 3736, skip: 10965, xfail: 9

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
