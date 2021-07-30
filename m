Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CCA3DB278
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 06:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhG3Erm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 00:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhG3Erm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 00:47:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A52C0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 21:47:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y7so9018501eda.5
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 21:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oWijScta93u77EkQI80GqOwsKgVDQhjKRK78cbphwE0=;
        b=VAjS1UWM6eku6WZYpaDzrsNR7Jk1bTC6d33uP3RxgRJphg6F8VgSusyob/g273zG/b
         TS+mYwTg3bN0EpXkBxmhQ+ujIiBah1cBjy8j77lx5Y49yqfgpQ7QGEXmRJo3kkAr3pWy
         jTt1J40884qfntYbJGbSFESB6YdTWrE0tU3fVVFBmr1JlGKXqsYefZlSQND4tFOuEc9y
         gu799PRNnI4A+BO5PfgO9Bij7wpGvxpPZX5llQbQRwDJnsgWZuFbXlXIJPQzubN/ic/O
         oDu1evyXjzH/4U82XXG3N/+7fzi9O51te5UzjeHXP56fppob9UbVn95Fh3qOw2rUGpiA
         Ezbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oWijScta93u77EkQI80GqOwsKgVDQhjKRK78cbphwE0=;
        b=RgC0y0LAuYufGQ28I89p0hUuyIY099tpm8JrX7tNkKG1qrgsctkChUkteNSNloHfn6
         p7A4293Zl/QRew2Lcx95qn2uuR1El4xlzKcad3JnHKCFdnXCJ6Q8sBGK+66EziWZ/Hjw
         BXbMXbd8tu77JyvYKtNqMa4WxgIToczJnqBwGeM+NbBWlrm4q54KuqtlXiSnxjdikZ7y
         KRYpcxzqKz1vMSbAPgT9o5iBSLehGIWRMNFip1da3dEvRWn4AYcu79DaDyCX82Ahub98
         N1UQW9F2U3V+3wG7FeDa7slmHcEPvEEo3cR+eXUSK9KqF+oG+Sg7gs+nBpJtekiJfNLQ
         U8WQ==
X-Gm-Message-State: AOAM533HsJ3PmkpbbtwU9XG3h6HBBzxio51qn0CH8RWzICJjA7qDXebM
        R52+qhMMlPTyyWoamVn43Lk5tDzGRk1mJ6kMNSdCtg==
X-Google-Smtp-Source: ABdhPJzrUuVtuT12YWCAlZZPKIa0rHqm3K43IOk0szYhRdGaZN926/J4gyIMygH5xK1XNcs/zo/aealA+4QQOXdnAek=
X-Received: by 2002:a05:6402:4386:: with SMTP id o6mr698263edc.239.1627620455978;
 Thu, 29 Jul 2021 21:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210729135137.336097792@linuxfoundation.org>
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 30 Jul 2021 10:17:24 +0530
Message-ID: <CA+G9fYsm9Aj4yLvUdJDJaaaBFkZ3zH4N3gBfH7wCs8=ERUfV6A@mail.gmail.com>
Subject: Re: [PATCH 5.13 00/22] 5.13.7-rc1 review
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

On Thu, 29 Jul 2021 at 19:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.7 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: a572733cda320244f6671ae091728a755de1b031
* git describe: v5.13.6-23-ga572733cda32
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.6-23-ga572733cda32

## No regressions (compared to v5.13.5-225-g692072e7b7fa)

## No fixes (compared to v5.13.5-225-g692072e7b7fa)


## Test result summary
 total: 85331, pass: 70359, fail: 1666, skip: 12268, xfail: 1038,

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
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
