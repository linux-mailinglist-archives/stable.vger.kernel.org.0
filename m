Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324046B2056
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 10:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjCIJlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 04:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjCIJlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 04:41:23 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD91E841E
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 01:41:22 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id s23so706957uae.5
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 01:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678354881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jIOTc6rn175vyiFq5gHKJuBMS+ktp/ltYyWXUJXbuJ0=;
        b=snneBnAmpgUiHLd38p7vadzvY/UzVgShwTDe/tov/JkfdNK5XlTfaMix0bwM22zHSL
         h4eR9mlatZ+qXxORwLyvsRqsozXsecjYIEKNx+QN5TNWB/qgsqqESMpDFpcRfY6ys3OJ
         E1SETI9x0xOblR1YLtnr+ZYb9UsVdDMrboM33RW+TsIDQELxdiAUzuAe2Pm4ynuOG+/E
         qcN+pmWtwESko7WW3QKk9U07MogoModFMCuKwyUKNrFhioUvBIvC8oe8b+1OL8zWoVw6
         Zn5WBDww/3R/gQdHNIGmIU0HbO1K9qY7+jF93o3Nlz8Zsw5JL5tmRePpV5U32iJ8tG8W
         G+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678354881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jIOTc6rn175vyiFq5gHKJuBMS+ktp/ltYyWXUJXbuJ0=;
        b=MQGdgAayyl4Z09MLFizvY3NHiX8ulhbUYnKBv0yUFyqIm/ZDTJeigp3JFEXgVizY0u
         26B/ZvqmCvRZWsJYt8QmhGyQ+T92k2xduEJ8MseAODLguPQWs0wn1ks4463GOzKDHF4u
         x/+7flIeNVQEpY3cY+ZpnDFkglo8nmU942GrZJ5M350M5tkN9KCO7J5pfHBqUmMb1+Zt
         fN2qS9RXX7FLrI7leAr20/g3LcG1intmHtgWThlFK0YJX15nVsGUIF/nKxOMU95gFiB6
         Jmnfb8nhevYYaobcJeAB/PRcqo6pcGRnjWXlPo7wtQSEm3VwuqTlvwGcbzkvlw2zEMaQ
         RMrw==
X-Gm-Message-State: AO0yUKUlv0r9w/4bIyO9YrK+vuJuQ+TTyM2djGR9NYDzBimBAY6UlJCZ
        Sa1+qaXa692Rzf1E2CgLelxtpvTeuSfXARtcIbitbQ==
X-Google-Smtp-Source: AK7set9MA0HVOQztZi1vXV8nxaRwHuutfpyhuAGcdu+cDwH71E4Sieb/AVCvERDPvAxQA5myYctNNvM4Ets7TGOoSBQ=
X-Received: by 2002:a1f:cac3:0:b0:406:6b94:c4fe with SMTP id
 a186-20020a1fcac3000000b004066b94c4femr13560505vkg.0.1678354881180; Thu, 09
 Mar 2023 01:41:21 -0800 (PST)
MIME-Version: 1.0
References: <20230308091912.362228731@linuxfoundation.org>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 9 Mar 2023 15:11:10 +0530
Message-ID: <CA+G9fYvb+59kmM=LXucEEG0Ys4-ad9EBdC_p_A3E7SXadGS0Kw@mail.gmail.com>
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
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

On Wed, 8 Mar 2023 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.3-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 69fee44387164fb4c017b1a9fbdc04a66aee75aa
* git describe: v6.2.2-1001-g69fee4438716
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.2=
-1001-g69fee4438716

## Test Regressions (compared to v6.2.2)

## Metric Regressions (compared to v6.2.2)

## Test Fixes (compared to v6.2.2)

## Metric Fixes (compared to v6.2.2)

## Test result summary
total: 197247, pass: 168778, fail: 5013, skip: 23456, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 140 total, 139 passed, 1 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 36 total, 35 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-exec
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
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
