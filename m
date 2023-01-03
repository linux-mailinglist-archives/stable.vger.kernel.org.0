Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C362F65BC49
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbjACIeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjACIeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:34:11 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14399DF85
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:34:10 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id p30so25425281vsr.1
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 00:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0LRzaF4/eAHl8TOiwxl4NBIKM++7t47+klDG5YxwLE=;
        b=fnT59MiryMAYp0O8jmgcwbPbaobGE32AFR+KpPHkGFbsJ8FkMuDJsg/AFohviUbq9+
         8TsUmScZMvFqdccMQI+A7HIiPyl4o+wyvBbAgxq2s37iJZRVNLPHjc4LMoAixKDnlEYA
         2Qo8Z9uXG0lJiGQ1GEw10CcYpzcSRtSEBnbx8qJIjLYz46wTYIneUUHBCSCbSKdO9Cyx
         /yzqXlLP+kdE0lF4/zfiYQxyHsPQ87APfo2vKxQJ3jSCGWzVjwkcIN6xlcVeokmCyPOc
         JE3SvNH2+jiCaY1XiKiEDolPadoIkrz/LX7bW6rlL2SjptuAf5GJdvfkheFFLVibR/Xl
         MPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0LRzaF4/eAHl8TOiwxl4NBIKM++7t47+klDG5YxwLE=;
        b=RYi/eZxd+UAIWi0BN/q7k/CRPbASVl472Z3ZnEjwUH4R+i0OS+Xx5KBG58OExoPZQX
         ftJACWwwj6sZ+GQ6w5HX7eWtKG8tZsSiB1XDG29wBpfr1xNeQYg5k1M4JQBIoG7lO1RV
         YzNKVjja62c6X8kNKtZR67VygcRhdf3K4gcO9wBg8rH1hLt7y8BFqd3e2MazmeVMWJ8C
         qNAncdTkRIdzTTM0EbQqOXEqJnUgGiZKnrkwan9Q/kMOv7EPJiET3TGqyXD3Sb/aWIoo
         EFIIF7Spz4pcOoFXOkRKFzbj/Yt1qVqV1aRxg3FjqaxLbgIIkLS8wVChR4OCVUty8Z94
         yQcg==
X-Gm-Message-State: AFqh2kpXu42rmRnDaqMhQ259Ss1U+VAa2cajQQmEiMHuBHsYYUV8d2rm
        v+CF+s2yUphxdfKEYTN3kK2DDqSJik+LF+D6bDJgQA==
X-Google-Smtp-Source: AMrXdXuciQboi6XVi++eNEEmorcFjhwmSXVig2GCgBHpcRFA34Dd6NWZp0egXm/aJE33u2Po7Mh+CoF5UHCKLKTcXzA=
X-Received: by 2002:a67:ec94:0:b0:3b5:32d0:edcc with SMTP id
 h20-20020a67ec94000000b003b532d0edccmr4702598vsp.24.1672734848954; Tue, 03
 Jan 2023 00:34:08 -0800 (PST)
MIME-Version: 1.0
References: <20230102110552.061937047@linuxfoundation.org>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Jan 2023 14:03:57 +0530
Message-ID: <CA+G9fYvEOcOrPROaDWXpuuyNFh1apk_-hiRZpZbFQJYXR4Hu4Q@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
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

On Mon, 2 Jan 2023 at 16:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.17-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.0.y
* git commit: 9c0ac88985a8f62726941213c92ff8eddf500f72
* git describe: v6.0.16-75-g9c0ac88985a8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
6-75-g9c0ac88985a8

## Test Regressions (compared to v6.0.15-1067-gf54b936f8ec7)

## Metric Regressions (compared to v6.0.15-1067-gf54b936f8ec7)

## Test Fixes (compared to v6.0.15-1067-gf54b936f8ec7)

## Metric Fixes (compared to v6.0.15-1067-gf54b936f8ec7)

## Test result summary
total: 143234, pass: 127347, fail: 2737, skip: 12854, xfail: 296

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

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
