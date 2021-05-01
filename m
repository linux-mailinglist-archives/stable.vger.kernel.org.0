Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1640A37064F
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 10:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhEAIFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 04:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhEAIFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 04:05:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41524C06138B
        for <stable@vger.kernel.org>; Sat,  1 May 2021 01:04:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h10so641220edt.13
        for <stable@vger.kernel.org>; Sat, 01 May 2021 01:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KphVoY6iRBngHJ58FUeup3laOMQ2ppe8Ha1yo1uPRr0=;
        b=kjvfkC+eacdhaT4tlPTOB/Jg80PGKMqsis0j4CihpG1Q2joJdoJB9x4Z2KD78dkoAA
         abK20dtHL+k0Wl10q8AhHZ7apZD3kgEGKinIIOlpgSFod5lDedQeKjiaOsyluRP8WAm0
         BZn2vOTBw9fJjJbOYCzUV/icD+sQUFFgzUA4UiDrP/Wg7k3b88OEQZDOkzZGzzcveTyf
         rlCwaBnCHtyn+MZ6HqXMfv2kmUIpP4vy9blSFaM4e1otcitQEjn1qR/7WKMkz73YmtuC
         N7EpStcFXJ1tLALnkyq13rB8u1QlUvKkX0YYdGjCeDoQ5S3s+QDkPdFYrAB/OEgmqoye
         LReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KphVoY6iRBngHJ58FUeup3laOMQ2ppe8Ha1yo1uPRr0=;
        b=ZcNc4JEzb+cIcGsjvtVXvONojbLQMEmqiJziYbOGkvZTUXw2py+qQiD+8UqzfA7dzE
         7NEN9g7CgvrfGKcUfttd2zqWhxNA30BkVcqcHiHJDsaswZTY3v9F21p/g9skE1fGVe8G
         TwEidrkDDLXRs6ATPVgjkihpSGSvXmyLkuExuPhuB7gmsSyLqwJBYWq7BYngvLPDnjzt
         TnFQw/fGYsIVVL2JLb3AzlN1l/f0zsGGy7znv4rqIFGBzZVxUeRGFkoagILZquf11Kld
         pSjH5HvvAz8grxPRTslsga+ZCYJWCRmZDQEOS7Xz8Y/hc4ygvGjLUZk3eNu8R3opEwDl
         CmPg==
X-Gm-Message-State: AOAM530cBtH3Ikd5cjcjuRY2acprmJNiNrtZSpH3t0bOsMEwCVzOYAzU
        xVVWpi9/frlww21Gv3MwyRfm5k1Y/3rzeg6MQENbOw==
X-Google-Smtp-Source: ABdhPJyFmSS1HHsJyxNa7qmco84ZwOpMGGYOwtRrQR2pmeVTR0tFf47OZ+3goOl4aqjNRThUPYw2Rfou9m7orSATJZg=
X-Received: by 2002:aa7:c349:: with SMTP id j9mr10228113edr.230.1619856254615;
 Sat, 01 May 2021 01:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210430141911.137473863@linuxfoundation.org>
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 1 May 2021 13:34:03 +0530
Message-ID: <CA+G9fYsgCNTgeMFjM_nbu+hU4tSnG7MZO36hZWCiHrD200LufA@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/8] 5.4.116-rc1 review
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

On Fri, 30 Apr 2021 at 19:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.116 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.116-rc1.gz
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
* kernel: 5.4.116-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 4f9e765c943d89435e58094c616a044b84fb55ef
* git describe: v5.4.115-9-g4f9e765c943d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
15-9-g4f9e765c943d

## No regressions (compared to v5.4.115)

## No fixes (compared to v5.4.115)

## Test result summary
 total: 71664, pass: 57763, fail: 2316, skip: 11326, xfail: 259,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 25 passed, 1 failed

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
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
