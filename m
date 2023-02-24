Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137CD6A1CF8
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBXN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 08:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBXN1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 08:27:54 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BCCA5FB
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 05:27:52 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id d7so15961176vsj.2
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 05:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht3Zl3ZeZf9aYs1rAv0eBFAKdSyPCi8FHnQJB2PH7a4=;
        b=q42TEXf32WjxpQYaZ+P2B/m7xXg3PhNpsXDHqqRDBJVt4oLOScq4Mq0mWbSErQAvOY
         ZN2eBQUbcKaIvX8p0Pcn63o/WTCMIFSCxfNigG+qtncT+KwLVEs6BpBdsFdFuphJB1Pf
         92N9M67hUUXGLbEGW0tWoRLNJ+H/ZWI/CiONWjTVQEQl/0lNL8AcStZsx9AhAaQWVuOl
         f7Pul1kjFp5lJ2Sy1YCNdy+BKmZQBx3GLgGGwBwVLVAcwiVmMSXl08xp+5vhbcXBy101
         gjShESLdUz+z+gOlFkKCQIrJX85ZfTtU11E8NLOXP0KxqQV3QMgW4R3q6j/pK9MZBVDo
         KhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ht3Zl3ZeZf9aYs1rAv0eBFAKdSyPCi8FHnQJB2PH7a4=;
        b=2gMfaIdVZLa3Iyf3SmbUht4t+HazuJJ+nc15G1XwrI8GRxfIN1GRJ4LClrYkCz5XKe
         xGOq9/d1CE6Zg/RgFNzpbBorTMlSR53aEUxF/oBML5yjABtOpEtUWmHkoxH24+6fcbh8
         9fYeztQ2ue5AMZqtUP1/NoYKNcML198xaVoYzYWUmDQfJIhrz8eaJk96X1LLMCLRyeci
         3OL4acnvX2zMfxb98j9iQGkIrXcTojMKStl+X5XjrJHJ6VAkAEm6D7pNe5xSBwmMjdLj
         LBiQAYOQ7PTuuZSJpfypSvGEEbnQimQ7zXRxT4EtwRQ5dcA9jXzRCMzNvWVfnp5uRysC
         ez0Q==
X-Gm-Message-State: AO0yUKWxthTjXDvBbKN9Cw3NvZciKznnhlE1kulbG4+wgogKPCqW4E/q
        vAdinZQZwn9e3gTdMHvplRDQ/CULpau2yF4PMMe1Qg==
X-Google-Smtp-Source: AK7set+RvhMqiPUTtmN09JfHxAMoVYk1d0TWTJi3iZrKtWsN1At8RhCFG3vW/3R5ioz49sQafvf7WJy7UxAH0kpg7Sc=
X-Received: by 2002:a05:6122:e17:b0:401:8898:ea44 with SMTP id
 bk23-20020a0561220e1700b004018898ea44mr2344915vkb.3.1677245271310; Fri, 24
 Feb 2023 05:27:51 -0800 (PST)
MIME-Version: 1.0
References: <20230223130423.369876969@linuxfoundation.org>
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 Feb 2023 18:57:40 +0530
Message-ID: <CA+G9fYsOV3vqKEkVKy-2FCzhM4S1d1HMHByHO_1kTSgsopy=gA@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/7] 4.14.307-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Feb 2023 at 18:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.307 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.307-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.307-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 43b3a61e4368a7abc906689e505cbb1e198bd1cf
* git describe: v4.14.306-8-g43b3a61e4368
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.306-8-g43b3a61e4368

## Test Regressions (compared to v4.14.306)

## Metric Regressions (compared to v4.14.306)

## Test Fixes (compared to v4.14.306)

## Metric Fixes (compared to v4.14.306)

## Test result summary
total: 92685, pass: 79026, fail: 3518, skip: 9809, xfail: 332

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 228 total, 225 passed, 3 failed
* arm64: 42 total, 39 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 38 total, 37 passed, 1 failed

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
