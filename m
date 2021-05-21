Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A86A38BEBC
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 07:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhEUF5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 01:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbhEUF5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 01:57:34 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842BAC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:56:10 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a25so21944070edr.12
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TnbgULocZzNUVdlq8Rf9e1lWbujlXBlBHINrOtXv0b0=;
        b=HU451tR2rKQ1YJ2oTUugYhCaeZeWn0T3aqzgQ/EmfwB4jjdYBsUK84GoGDHxhf7JDF
         4CcrOcnkf41He6LbNvCChu4vPBmnJ9MXqS+FZCzsHt9C+8a/pTJFsEmeSHknpfZPFmTI
         y+2WkZDjHwSXbj9Nn9Sre6AfkOgUB9ft+JLedkz/VF/87X98Rkl2UEk+Zq9NETl94e4n
         Dza82TU+2f72ydw4lRekzIuBodOGaHjW9hzJH2P6GCHceK8BlQHFMUz3Xgwb7THRUJBz
         nJMvcmWCnsXZNir4NIM7oC4drgE/4X4Yf0+DHRNsZupfviVar2o3jn/IHqM2cDjlZUI5
         AVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TnbgULocZzNUVdlq8Rf9e1lWbujlXBlBHINrOtXv0b0=;
        b=ka1ISvuEyTQwWsNgCy8V8HH/B2D/jLg5rgCFz5n0fQDhZvCqClYGevR0FIKeSsSJMP
         WLoySNzzMV2Yc12YvXNtjFJZpvVQD2xY7OzSetM6bn1mK0IEpqddXRKyx4PW7mvY94Dd
         PyZS7EP0p9qU5JKwxfBY0KYJo+JZCghibIW/2pvRLoQkJ6KWs0nyGW6CWNdWIN9SGhXN
         9Z1NUls3T1RqnoKNEMc8CgIWtXgzi/DZNffREzZaEfbv3yayEF8wS1w+vLLJXs9Kg8T5
         aewpfVukm7hcT52rCiaWoq0h3D8YKgpI9SD2SbX46tBNL1QrZbpCxs0IhL8jDj7+ax5c
         rPMw==
X-Gm-Message-State: AOAM530GPmb9/Y5tGypKVm0nNWwlNTo+bpWYqwf/9jOG5/mgXY14I1Co
        Q3Ne4BzjN6/3NT8jRIPhXrrkV4Vpuyob85GBnZtVcAtjFOi491t8
X-Google-Smtp-Source: ABdhPJzrqI3jQDTENrBDI/Yml4+wQDRCrUtBHkEZlAzQnLrekXTOEwHJYIrqOs4Xkjloh7hwODIOptylXhEtIYmYx7g=
X-Received: by 2002:a50:fd11:: with SMTP id i17mr9130867eds.23.1621576568940;
 Thu, 20 May 2021 22:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092120.115153432@linuxfoundation.org>
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 11:25:57 +0530
Message-ID: <CA+G9fYsOjoBuj_YPaj+iWJhpLpzwjjedua-5NcEKnv2d4+A2mA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/323] 4.14.233-rc1 review
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

On Thu, 20 May 2021 at 15:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.233 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.233-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.233-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 7c5a6946da4494648bedd0ff4d3282d2c96f3ff2
* git describe: v4.14.232-324-g7c5a6946da44
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.232-324-g7c5a6946da44

## No Regressions (compared to v4.14.232-301-g6b85a7ccd6ab)

## No fixes (compared to v4.14.232-301-g6b85a7ccd6ab)

## Test result summary
 total: 62446, pass: 49885, fail: 1550, skip: 10128, xfail: 883,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
