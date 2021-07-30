Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6779B3DB7D3
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 13:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbhG3L1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 07:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238576AbhG3L1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 07:27:39 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96783C0613C1
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 04:27:34 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id x15so12707424oic.9
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 04:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=baSZDbp/TLfSVx/yL2xSQkCjVpnpVUlEm4g8HBHorpU=;
        b=mZIoDrxU50xRM6Wn8vF50yMhNsSCSqFSWAIfiFQNia0CmRRxIrF8yFwwl08NCpd+IB
         ERw5ETkaoxfiiB5OC7RQhMz/P3lQ3Wl8Pc3QAq7cObIUlYi/SEOXpEFHI7i4P7RI9OIV
         1izPkYB4ZA45XjNrHHNWBa1dYGjTmLNq2Mm4Y59BtJTffGOblCiZ2mjL+cFrlydj2erh
         hCMlmLcut9dSUpHRsi+MVOQ9mlP1bgttTDeToVyIz+1DV16O5X9FVcsiVEqJVfoJdkqC
         9nQc3XZ+MLmQvwFuoMGvZc//5/YQSPipwI9uFzp04GQXxBL4zXXhvjGhcSjctcnqZTZg
         49ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=baSZDbp/TLfSVx/yL2xSQkCjVpnpVUlEm4g8HBHorpU=;
        b=j3pkPmb1rV4kI+8HrjAn5Y/P3K+zFAywGRxAuxD8uozCc3D5DzIwHJM8w/Fyebi9g/
         8SIlskFKSTbYmzKo88ZnMImpm3VM4l13a2EmEzegWdDcjnuyCaIG4w66uB+zz6A2Bk6S
         e+/tthAmWg96EHZDPMOLYGWW4pSGb+IvSoRGjiY5AqKuPTVyONsn+gpCKzwDBzfZutk4
         b64H5UKJp3bRrhGCHtQD3tHQcdj9SGvR3cd7PhjHBGSzGzUUwvRGwMjGiSm9qKoMz71E
         5SYyrajH4dXhJQhI2/9AWakSyUdNh0MKTOTRL18cRTskg2/c+zE9HakK1jvLdhheML5L
         qZ2w==
X-Gm-Message-State: AOAM532x0vyPHL/Mp21FYQln8SSwpkpLQu5EqK7U1nSWuvig+YJiy/Ng
        x1hp5HRQnWuIo0WW2Opd6ZXXgNULOvMJ2UrtVwIKvg==
X-Google-Smtp-Source: ABdhPJzRJCBt0UBigVVSxKV2WvYCH1JKioBiGRJDS74Vx3uHlUqc1DSJWIt1/zsvRy3o0CDJ/fx4HHiOlJHfcl+qtWY=
X-Received: by 2002:aca:abd4:: with SMTP id u203mr1444918oie.13.1627644453703;
 Fri, 30 Jul 2021 04:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210729135137.260993951@linuxfoundation.org>
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 30 Jul 2021 16:57:22 +0530
Message-ID: <CA+G9fYspx_fMweJFMevdL84q6-FNp8DqMA-ng--iLGboLgMpAg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/17] 4.19.200-rc1 review
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

On Thu, 29 Jul 2021 at 19:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.200 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.200-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.200-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 3b0f6d777e8545324198eca00a5758c7b287aee7
* git describe: v4.19.199-18-g3b0f6d777e85
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.199-18-g3b0f6d777e85

## No regressions (compared to v4.19.198-120-gb72fc3c0016d)

## No fixes (compared to v4.19.198-120-gb72fc3c0016d)

## Test result summary
 total: 74142, pass: 57856, fail: 1674, skip: 12842, xfail: 1770,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 13 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* ltp[
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
