Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE75427757
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 06:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhJIEhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 00:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhJIEhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 00:37:37 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A80C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 21:35:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v18so44178199edc.11
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 21:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nGvUYvbmK0K5Ldg7vRbKHacSlMzqBKNjyJWApImR3yg=;
        b=WlVDYqNW/Ch7MBfrrhDWNKf1VGGe4MUo6pYqqSe7/aDzZf+I1Jjgn6sOrC9TXCioRw
         DNhBhT25m5uIAbpVtd3e1NDiNp5zVxQRWW42T8TQBCageHAloYEoZDVt22YP5R5AGcNk
         CfCcWert2uTBW/mJFlKIAEL0ATdHqHQ/j+zNGyfyHdTpn5gBPaOAzMlakJa+iYGJzKAC
         baSMIHznGNNjg043PGT0GB4lZt+Z7X9e1IlvGkM8wGCVE1dmORt0qKOxM+vLD1XM8Do6
         qucvgVFK8btS8yVxJ6woXequfFtYPSnbkayjInsOaG5NdrHsTvGt6rxckYJBqSrqTu5h
         0ZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nGvUYvbmK0K5Ldg7vRbKHacSlMzqBKNjyJWApImR3yg=;
        b=D0Zz0cVjQ0AYTLqb0BiN72h9hovVuhMJMAqN0ZFcX7XFsZUAMCTHRb6Uf+RoEn2kwL
         jtQkxEFnGZa5KAAd0O+gXl8YIHIS4UpHvRhv3g/zXuE+s010NEpDsZBIt/TAk+m7sCQC
         eAHcNr4GgK6IkqB7/hX+r7MMizOx5NVTQ0tPTmobjZlyZ47nC4YkLl8XPD+HZunEpkTA
         9emss74XTUFCFjF4Kfwn1qs3dkmu50L0oQ5qmkrOc79siFRyG0ngQZNNNGorIzvOQchr
         FRvNdHKJWPQH0Vg22FfMLoezVM1CF2ykSBPesNoDet5NhpJa2LuXJcJPgtEgtDFsBpdo
         9fsw==
X-Gm-Message-State: AOAM5335poXmpyVGNJnky7z/as8yoPwu6LuG4f/yWn2kepLvI+8PX77O
        VwgYgLZsBfg8IVnrvt0E26T6BNY6fMcYD9nqkXWtWg==
X-Google-Smtp-Source: ABdhPJybdjXOrnJxYGywpVwFJ9wR5rOXxImb5yLnv54kZvhAAUaus8FDEzaXnAO5dtkfXUXwgHBddYZU3eNILz91ZAs=
X-Received: by 2002:a17:906:82c8:: with SMTP id a8mr9329583ejy.384.1633754139245;
 Fri, 08 Oct 2021 21:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211008112715.444305067@linuxfoundation.org>
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Oct 2021 10:05:27 +0530
Message-ID: <CA+G9fYv_xOaLYQCkSBhBRUXaJ0oEVy9NzKq+wvS1n13K+V2UgA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/16] 5.4.152-rc1 review
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

On Fri, 8 Oct 2021 at 17:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.152 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.152-rc1.gz
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
* kernel: 5.4.152-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 0a25e1455412122583bd9796e6f05bc146458fde
* git describe: v5.4.151-17-g0a25e1455412
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
51-17-g0a25e1455412

## No regressions (compared to v5.4.151-17-gb1d2e2889dcd)

## No fixes (compared to v5.4.151-17-gb1d2e2889dcd)

## Test result summary
total: 85242, pass: 70848, fail: 633, skip: 12366, xfail: 1395

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 576 total, 576 passed, 0 failed
* arm64: 76 total, 76 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 37 total, 37 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 78 total, 78 passed, 0 failed
* parisc: 24 total, 24 passed, 0 failed
* powerpc: 72 total, 72 passed, 0 failed
* riscv: 60 total, 60 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 48 total, 48 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 76 total, 76 passed, 0 failed

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
