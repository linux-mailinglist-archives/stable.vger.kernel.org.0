Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4689535AB52
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 08:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhDJG1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 02:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhDJG1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 02:27:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA13C061763
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 23:26:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m3so8972182edv.5
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 23:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VYQgXA4JFzHDk4viq07HuvZNY7v6sV4QclOQl2M4hJ4=;
        b=qcH4wxIKFlGWqwulCIsFTdVwfFB7gQRKvnLCxqAstLjPU9CvZJ0zZ21PhmY6Evsa70
         J8XwlPvBpgRAwsE0T4yNCF2he+wafCKKNE1Fi6HpeHhrrTb16Yucdq0dbhcp0vDcA/Yr
         4l0iXobIgTBnmUlbaAyTvKS+/QcLLKEEjK2lW1e6z4O0ECHzWAr/GnYtDBlXKyWIdYKv
         BujpdK+3d2wRAms8hqboQXwbET6iGYwSiplkZc1xY563u4hbmz1Ui/u7OwX9BhSoiSai
         /NWanFqpSNKNXEavDTDb03b+S7Mz5Jez30kmlJ5qq76wrXwYhUdn0EC/fwTvqEVIsjgu
         B47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VYQgXA4JFzHDk4viq07HuvZNY7v6sV4QclOQl2M4hJ4=;
        b=pjcTjn6wnd20stPldHBqASUVxeV/fM1jo4yxb8Gd3J9BE5QZU8XdIHLFxgmfuFNzFM
         rt+4Ozwkk7P5Y850DXuYFhpgrFcCArtlUUtfB4CyjU2ibEB5zuRtgKhqtsbeTAnN3pmq
         0Z70yTzFHqE118N7JR8xt5hB4HguHIVKPIpXiHVfte5M/CNcOKQDW/EDtm89G4n79nPR
         RYeu6i5zGCPUv0PjUhaQvMlaC3WydD+MwnblvGk7Xng8sZBuPy02ppgVMWHvJVsnb6DB
         gX36MJWsPC4lv94hckf0jzvjoghUburV39R5zqLoZkGsDNRplNicsEPnAYTndus0hSxI
         0JKg==
X-Gm-Message-State: AOAM533tS5BpX2VHRKWFXchsgHftcyMZWx/yYTWte6Q3Gen3cjggmPCe
        L50/8CcL6LCPatcyYN2mlJMkrxjnU12eRE6kdSCs7Q==
X-Google-Smtp-Source: ABdhPJyZc09whnLQOKOPu9DdP/CsG9zoNdsm/kuSHfd2Obk2KrHGgwtvq/xwYn8iT4NuHNKxlKWk+TxNTtgDBWpJWQ0=
X-Received: by 2002:a50:eb92:: with SMTP id y18mr12700486edr.230.1618036009612;
 Fri, 09 Apr 2021 23:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095305.397149021@linuxfoundation.org>
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 11:56:38 +0530
Message-ID: <CA+G9fYtfsjqkbH-fOiS5UX4U+7oeOk0sMDSke79GgUVVTfVNWw@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/45] 5.11.13-rc1 review
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

On Fri, 9 Apr 2021 at 15:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.13 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.11.13-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.11.y
* git commit: ab8c60637a48fbff98e2c93fd1cba93172937f29
* git describe: v5.11.12-46-gab8c60637a48
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.12-46-gab8c60637a48

## No regressions (compared to v5.11.12)

## No fixes (compared to v5.11.12)

## Test result summary
 total: 71163, pass: 59648, fail: 1495, skip: 9771, xfail: 249,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-lkdtm
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
