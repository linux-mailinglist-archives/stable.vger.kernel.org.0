Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D347B423851
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 08:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhJFGtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 02:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhJFGtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 02:49:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86593C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 23:47:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dj4so5835078edb.5
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 23:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/RY0JnlX5/n503ZfUQl/lXYTDbDxPGWgSX/+M+PX6zg=;
        b=ND/qn5EN6ZOX+kj9T4HjQnPgvD5vp2Tzd88EL4LNGrE3epRb/wAvkVPYGm2vagumIh
         5y8C1J22S1jwKEhs2zhtCelhllowp+WwxxNgeVEMKR8iVS33bYsRXgkDxwBoGcmNnFjT
         nb69wIInWgZDzDW3Qq6h93cEbPP2GMc7wZ7pKuwECq1pvrPI9ej8wsv9AQAbpy7P0ato
         rFd+3YfC7de2ad4KJXDV/B4E/wyaaSs9pvz2bhMG3pjZf//CxeYn8IYgilEDPzM5UEu4
         AzXYNn9EE+ylf3qRAO+YfUh8vhNXN7NGi3asoV6HFQbVrtq5Gc9z12tSRv2Ivk4eY94O
         +v7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/RY0JnlX5/n503ZfUQl/lXYTDbDxPGWgSX/+M+PX6zg=;
        b=5fiLqaZGqA+g6cbJfUjrBffN5X/CZw6h9wTGap6fbPACkNb+wZDa8Q0K5k8xpNJaNY
         t59BYPiM3Dul4+j9fub8exa3LxnRnq6yAULaWghlE1aueAPGvWLN8zWudQVXw6cxO8Jb
         9zUUfs9ieuUNbzJZhIg9n25oTD+n/ZFc0o5qBzoBNIyIPx0xgvtjZbVi8dXR4B27smxr
         bY8O5B9kstiMvDGexHB6L1JuLW0lDC45lPynUi0m8yyE8z3ArzOoADguphr+MHmtrA+N
         Aq7LtGJu8l5OChr/N6v+SnHqiKTFZ/w3Nd7gq4MzZkSRBCirsnh/+Vuc9Lgr7XtGvtVa
         sfSQ==
X-Gm-Message-State: AOAM532PXzYRM4cMbLOVAMbtcPp0vfFmTeZ7m8DLF3UBPOOHAeqwWaIE
        tBszU2KnbfhCkig7MbEexCCVsfb8KUhbLec9/LS5xA==
X-Google-Smtp-Source: ABdhPJyLOOUJk/+zZ4hD4di+KTSZCiPPUtohb5zRN8TuFo8uu1LUCBYECUD6PevDWEBXIUyFDFLkaBqBGVz1BoUPrfo=
X-Received: by 2002:a50:e184:: with SMTP id k4mr32628757edl.217.1633502875888;
 Tue, 05 Oct 2021 23:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211005083301.812942169@linuxfoundation.org>
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Oct 2021 12:17:44 +0530
Message-ID: <CA+G9fYsjbuOwiSF7q=dm2EMP6JrURJ1-4+YB4-g6otoWBoPceg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/92] 5.10.71-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Oct 2021 at 14:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.71-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.71-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 76aee5dfd7ee7d3a9f3ba6c98ad0e8526191cd87
* git describe: v5.10.70-93-g76aee5dfd7ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.70-93-g76aee5dfd7ee

## No regressions (compared to v5.10.70-94-g02a774174b52)

## No fixes (compared to v5.10.70-94-g02a774174b52)

## Test result summary
total: 84250, pass: 70535, fail: 516, skip: 12276, xfail: 923

## Build Summary
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 1 total, 1 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed

## Test suites summary
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
