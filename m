Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709AB35AC1D
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhDJJIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhDJJIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 05:08:17 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAF0C061763
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:08:02 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s15so9215362edd.4
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RdN7YkjdyQpf6iiNC2gA6eA2FYaZ/HS1hWiO5JvUgXw=;
        b=Wa34Zl0cDudHtlBvNmen3pJkdksvotUKFYRm7DuyNpdMU1gsyXYqO4FXkAuGq5v5H+
         4bL3R0mGOd0jwwUWiXTzvl0lCHOYZoJoPUAtKwbc89gkmLPTiLP6iagrfK5ryqqlSKwh
         333SReDTSzjDfagekCo4QxliRrfsxz2xXvkISXE0rWbp/SMRO0y1kqrl5WOgS6XthUa6
         ExlngeAn7VYvZHlu4B+935KYH4QedFqIIsyOIQWGzyaerqnM0DwUsiyoErxczfen2u6+
         bszMUJrh6eiqNRD59KFeowVv/fH7jiMADvg2c1Dnv5zVt/0Z0nQ9brT28NrrBtmiUT5y
         5RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RdN7YkjdyQpf6iiNC2gA6eA2FYaZ/HS1hWiO5JvUgXw=;
        b=S8XrtWzoygUmCfgbNnIiQ1qLUcb9KiZ91a1+64sgCpwyqY62NPOz7IkUt3rg5p1B+B
         JIi/2y3jAszxlT1HqLy6llQqAWwFNJj3KlSPabsUJ8JO8HlX4FGMGp3Xw44osMwmQNPt
         UxZYhyDLktJNwjCEeMglGx5z6W4kOKkZgteyk+I/0gDt694ZowLl8r9Pf14GAe0Lg3Ud
         Ta8KnMgT1w9lOumRok1T0/+zL7LsaaWcQ7wC4Ld8MGzg7XnS5DfqJuprCWBXquMUhume
         str50FXTapUqxnl5NtRYHAwxC9SWzU+77HBkKum/JT/NsHy2TJV8v6iJUHZZY/0FA//j
         mWbg==
X-Gm-Message-State: AOAM531YzlG78zhjwY1DWlPrz5dUBIB/pp3vGOYMpCefBb2ngLgXv3S3
        CYJjPDgDYfylBmyz39kpa2sR7qTBwM8/Q1v0c8nJGw==
X-Google-Smtp-Source: ABdhPJxUtrh9zQUuo+LYNfKjxSTA/5MyqWQwZH46l6Y4oAU7CJ0jIfauv2bWU74yPO0J3GRHMIqyYVbwk1SNAEiSSe4=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr21142662edf.23.1618045681491;
 Sat, 10 Apr 2021 02:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095301.525783608@linuxfoundation.org>
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 14:37:49 +0530
Message-ID: <CA+G9fYs3kDdR_3KwHQ7gaWAYXG5gRjsjBc9dZGWuvbciWdbC2w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/18] 4.19.186-rc1 review
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

On Fri, 9 Apr 2021 at 15:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.186 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.186-rc1.gz
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

## Build
* kernel: 4.19.186-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 6aba908ea95f2196c499c922cfae662412d5040a
* git describe: v4.19.185-19-g6aba908ea95f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.185-19-g6aba908ea95f

## No regressions (compared to v4.19.185)

## No fixes (compared to v4.19.185)

## Test result summary
 total: 67843, pass: 55043, fail: 1811, skip: 10773, xfail: 216,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 13 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 14 passed, 1 failed

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
