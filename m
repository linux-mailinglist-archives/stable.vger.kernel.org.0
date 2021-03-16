Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4B033CD4D
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 06:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhCPF2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 01:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhCPF2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 01:28:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40BDC061756
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:28:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e7so19985249edu.10
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W8cno2jI/q1a7Mp+m2I4l1zQLuFb746zaAM3fMhbI38=;
        b=LtIQg+e0Y9DlqGto+4IPnaOFvLMkZyX4VP8cj8K4xIETjgZ+3afnXfpGIIuxRbGSU5
         rGPTz1IhRm4jJeyNezL7FlmdQnGUWdGTFfSFjErOxJQPkSnIVR499589axeDe6WkKCiR
         g+hCAZmxnJtPt6pd+XLHRhbuSqa3CsZr4TAioE8tkumGmXG/PzHutejfbALnYz320OP2
         PusP80tnrVbkqNfxhWnVG5LBNdt4y0l6pg9IaUkXvcJ4OK7DOLq2Lja/0syRmogImG+m
         P5OSMm/r9vcCeAuUI3u2Lz0h6K6HY4aH9SaNrmBIYVHs/uXn/JnRtNWc1WU+J9QURhIg
         csjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W8cno2jI/q1a7Mp+m2I4l1zQLuFb746zaAM3fMhbI38=;
        b=MoO/ItItJmfe4diE7VzOeiZGVcVid8qq1ydYu1VMa0gtt1fCAbPDDx4ghtqgoFiv3A
         S6aT8kxmQAuvBi9j/M53CFGhiXUTKnsByVNu6rchyr9rDe30yj9Z0dHy/zqAUDzBQ88r
         XYcY+9nYYKSj44GbDmzlAiNm3skmZlRBwqit/BixHV/wU/0+4HCRfeCAK1MaEsZl5pHB
         dpCXHmQAHNiEcIA5sExxowEzxjyMcS4bXoui0jMazxx9hMuNtxiihQ6xTFljasaNF/6S
         qnP+9bIM14sQ1GzAlT4F0KF56hsJld9taXNJ/WrkOXa0WKj3aI9kBag8WDOcVZCEK6uZ
         /d8A==
X-Gm-Message-State: AOAM533EWnIWvkrdr2892F/DqgGVrt5IQDAlorF8iUMU/O2aiOA6LrBK
        dhLMIpmglSQVQvaxpPX629q5ERm+09YC6AoAP35fZg==
X-Google-Smtp-Source: ABdhPJyM14fi89CH30Ia06fF4KyQ0KbVSHA0Ml943Ta/ZexwvPgQDXfPzqM9t3bRGYLz2PUP/NMHHehK+N3WTtw8lEw=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr33958112edx.365.1615872484610;
 Mon, 15 Mar 2021 22:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135550.333963635@linuxfoundation.org>
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Mar 2021 10:57:53 +0530
Message-ID: <CA+G9fYu7ZwgN-c6sNpdwv2qYjjEdu2h-18FgGQhSumDfimB2mg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/168] 5.4.106-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 at 19:35, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.4.106 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Mar 2021 13:55:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.106-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.106-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 26ba2df2641dff3b9583fc4d1fbdc668bd346f00
git describe: v5.4.105-169-g26ba2df2641d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.105-169-g26ba2df2641d

No regressions (compared to build v5.4.105)

No fixes (compared to build v5.4.105)

Ran 50881 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-cap_bounds-test[
* ltp-open-posix-tests
* ltp-syscalls-tests
* rcutorture
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
