Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A883D00FE
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 19:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhGTRM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 13:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhGTRMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 13:12:52 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1093C061574
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:53:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gb6so35564111ejc.5
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kkVa9gzCIySm8E5xjowRQ3dsQcjUh9dPvc+KNu/VY8M=;
        b=Fp7toN3fMQhPk15C9ae375VyUJH+L+cMObBy4sWVLdAHgnePD+IolgQWW9eSlsDz35
         jwSqV+BAmPmT7t4c+DFgtxHN2j2hjlCJj8aZLuBIv1GwNLickoARNfOisDKyNhgiAuqv
         +AKuUjgvlLJeyM6iRelLQEkAaotZwoq96MjGB4XUXil1+RSBnOAvKdDa8/vti6e6/cFR
         D7w3+nQNIKPaty5uyJNNUrGu/4X79IZ0TBFk34fLpOyNFpy+60TpEBQDHlimAAVJ+wvj
         66Q19yN/J29f6WaE5BnQDvhWEah3Qx+wv38qfdGdhx2XeC8rGOkof8CD9YBR/cIoaJdw
         2yYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kkVa9gzCIySm8E5xjowRQ3dsQcjUh9dPvc+KNu/VY8M=;
        b=EQH8yqmd62YbpLq87RIU8SIjD7AiAjfHl3cI5tlS6AW2Yz0PrweewEZAi64Mj1kiP9
         qyAwYdLmU4n/8w24kW7pX255X2wBoVZ8Km9YnQnw0LItJWecat8adydItxOCsqE688xW
         mtCXsV3/l1qRb7er0QuUKkavWstRAgLQfeznbPNhDe1qFJkgSTngqudGlrt+gGqH33K+
         ELlU4oCZZoQ2yAvpR9mkwX60lvmvSGWpseUvf78eb2VPiOicm+Thu986+kjv/Ch7ABbV
         ktF/yd+bagYBIBbCYvXKw/qjFGqXpQpsgqA5A2n07EyrZiVMuxOtih3BEK7tm8ezWL88
         movg==
X-Gm-Message-State: AOAM530HR4n4MDgPLTfH5sGAJlvO7hSuUWMCI1d5tMCDLi9FwurOef/c
        CLDL7ShXs6HV19ckYNON0tdDdT4Wy8N5I7X3oC7KJw==
X-Google-Smtp-Source: ABdhPJyI+/WSe9Qr2WczZtcqLUSwAez5JjRteiN4jGxzjtE2ui55mBIuimc7a1SHFyC9a+Rw9fZi2KQVS5VBd1BZfSQ=
X-Received: by 2002:a17:907:76b8:: with SMTP id jw24mr33490243ejc.375.1626803608362;
 Tue, 20 Jul 2021 10:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210719184320.888029606@linuxfoundation.org>
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Jul 2021 23:23:17 +0530
Message-ID: <CA+G9fYu0J32Xjv9bdaoiXEyjhRtLce=GMLfE8xzogsB4mR4eEA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/239] 5.10.52-rc2 review
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

On Tue, 20 Jul 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.52-rc2.gz
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
* kernel: 5.10.52-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: cf38e62a0dbb761f5733ccb0906c619421631e57
* git describe: v5.10.51-239-gcf38e62a0dbb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.51-239-gcf38e62a0dbb

## No regressions (compared to v5.10.51-244-g36694d0b92d3)

## No fixes (compared to v5.10.51-244-g36694d0b92d3)

## Test result summary
 total: 76296, pass: 63258, fail: 1503, skip: 10390, xfail: 1145,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
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
