Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA6132F953
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 11:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCFKLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 05:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhCFKLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 05:11:01 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE14C06175F
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 02:11:00 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b7so6425923edz.8
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 02:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GXftPex8UROwldlSTjWO5JLsjQS15Ns56NL5ObCiNC8=;
        b=SvTld0M92Q7MHnM8nc+QVQ9+53zDdnZjT4F4K3hBoiK6ve6lDzObjamJVgtT5VHrLd
         PlKYGGpZ6W3klwBv4vBzGA4S60/LetARTzomStSg9lBIMrIbBmT5tSlSCGOzd068FwUh
         2MkUVAKf1221+QWszhj4j3plqioawRmjHBmJq1WXnnQqITzSBX3PB7f5l20C/BDaRsJr
         a3Np06nvpt6fOecM3g2OfLHskTlbSXbrjZIG6t8DcQtjqEyOaBvGFGTIOV9tY6X0wxOl
         5/KaPcOGH347dEsR2e2NbSUZcGtDx3BIXVUAqclfl72EdXQ58MvaRJq1FyQ4P0oxd9FP
         t0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GXftPex8UROwldlSTjWO5JLsjQS15Ns56NL5ObCiNC8=;
        b=tRTtjmJdwe3zg0SgSZYXLqjwag2ogdY68HbVGMKkUmX86Jo4LB8X2yDx/wfRzacrtD
         maymUpZci+VEi3J65GintSn9sRZrc1j6hiOFpLQBgVw9c3dm3daAnLa9LNjeswNavfeb
         kQcYTI1BZRzPzfQojY4jeYH2UwP/kb/ejTpAStslta0Vq1yXD3HmDdWyZsl3CttrPMfD
         qxQd2csLHSAuSmVlE0UjDLc3ptt7A3Tn9a1P0X9awlszqY9moUsv/RTvY4LL+McomeaY
         zfcOxOHAW1Gj0muacXi+V3UdVtLuyTLEhjSFJP2vNOO069tS0z4JrzrtHjmPrOj5P9UL
         1dcg==
X-Gm-Message-State: AOAM532BLLVO14+5W7h2lNxesfO5e63DBfnyEddVvsGPRF7TfWVkISns
        ISX+qVRquQxAnY59zWm+DH7Z+ukO6WiVna2yVPHR+w==
X-Google-Smtp-Source: ABdhPJzeRiubDbm7Vo97ceRb6fzrxmXMHM5Wh1tMsgI2VlVxRDHPvzrE/6btAj39FrCgSfSqYufJb7uVcB/zMS+R7EQ=
X-Received: by 2002:aa7:d287:: with SMTP id w7mr2681187edq.23.1615025459208;
 Sat, 06 Mar 2021 02:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20210305120853.659441428@linuxfoundation.org>
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Mar 2021 15:40:47 +0530
Message-ID: <CA+G9fYs6VQaLwKJXVpiRdAm7mAwFfTqL1zZxWg1L+AR1TQfnMg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/52] 4.19.179-rc1 review
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

On Fri, 5 Mar 2021 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.179 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.179-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.179-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 1112456421caf2562801d760aef4da53915246c0
git describe: v4.19.178-53-g1112456421ca
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.178-53-g1112456421ca

No regressions (compared to build v4.19.178)

No fixes (compared to build v4.19.178)

Ran 59275 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
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
* kselftest-lib
* kselftest-livepatch
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
* libhugetlbfs
* ltp-controllers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* kselftest-kexec
* kselftest-kvm
* kselftest-vm
* kselftest-x86
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* ltp-sched-tests
* kvm-unit-tests
* rcutorture
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
