Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC064D97E1
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346779AbiCOJnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346620AbiCOJmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:42:53 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5F04EF50
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 02:41:41 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2db2add4516so194974617b3.1
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 02:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XSQQR6oOJbSZhoFKqF6hj+IKioXVuBCA6nvzAYTEE4Y=;
        b=BMznJ8MEXB6qf+XEFAjAstoXhAH9PMsaaoGM6dThhWcw0HSqJI4ozUjZWv7qZmym8V
         lHsGAR9O6EqCtu6U9BCw0jmtxptvPiA9bvRxAA++1NSwbs1032FXd2EHOPE/p3kvCvxA
         YjUopuGGsRpmLjrCivcjwJOxO6J/3CpZNJ3J3oMAfvWl/VNtAaXChzFQu3qcO3y+3UPF
         8DLyvyF57fZaypAsyF1W8Q0t2eSmQMI11t3w7AlFhcpGoS5LdR1kbtsPDMX/O71Gf8Ym
         7HRuOi4MYr/rOlXz9rSE5jiRYjdimzOC6O3B4fT73S5id148Hav7zD8bx3MhtopOg9tc
         CeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XSQQR6oOJbSZhoFKqF6hj+IKioXVuBCA6nvzAYTEE4Y=;
        b=sYOTcBlqJ6Fz7aJ6S6c/3OEeTJhPIhffruVL6hoIRYyp0tFqECGw6MqunvYF01jBxR
         MaYZSqhKdKc0I3C8KcTHaqa0h93jISzCuiYtOAK8OTZuBc19Thstir8Y2YDUKHCJaQhO
         xYmgX7blaFXNS8/4Wvu8g32VOtd0awrL1TkyQnyDhuXp4EWm30e61n9LiTk84wDRTF9T
         atDYbnzDKSZmanWugjjkJp1shvFgOiDKpwwjeEzmlAJNqgKBQTVDt1mrL4yx4V+qHOvn
         kBI5C/y+nOelOGLwtdFdk8nr9MXZh8MaWovR1yUS0B1HwHLOxMFT6Tw9RDDa9tDKh/cI
         FMJw==
X-Gm-Message-State: AOAM530Z4qvy//W6UKEdVP43Zr7zY34yig4yQcEL6XRS9fVJZnoGiDhn
        YogqrlsuBFarYDw2/SQ+wcH1D80UQ1CeVy48FbAzKg==
X-Google-Smtp-Source: ABdhPJz7rmPM5hJ1bFKP+cVfII3U9NMG3L6xYJ48W5DadaOZb4VIr9SVFGyUNdVspLwNV0IF4E3fMiJSv1x1LtwXMTQ=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr24013644ywm.60.1647337300477; Tue, 15
 Mar 2022 02:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220314112734.415677317@linuxfoundation.org>
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 15:11:29 +0530
Message-ID: <CA+G9fYs6xdfUV36zptfuP3OvWt9f7Kaqn5s97kD-h5-RSyd+mg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/43] 5.4.185-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 at 17:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.185 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.185-rc1.gz
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
* kernel: 5.4.185-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: cb0af18075f051a9c4e242e027f1c6d08ac573a8
* git describe: v5.4.184-44-gcb0af18075f0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
84-44-gcb0af18075f0

## Test Regressions (compared to v5.4.184)
No test regressions found.

## Metric Regressions (compared to v5.4.184)
No metric regressions found.

## Test Fixes (compared to v5.4.184)
No test fixes found.

## Metric Fixes (compared to v5.4.184)
No metric fixes found.

## Test result summary
total: 85257, pass: 71966, fail: 508, skip: 11477, xfail: 1306

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 25 total, 24 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 36 passed, 1 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
