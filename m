Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11993E95D4
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 18:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhHKQWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 12:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhHKQWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 12:22:33 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C850C0613D3
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 09:22:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id by4so4687836edb.0
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 09:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sw6Jt0zasQwCv1AHq12NR9c9myNo+U4Sy7Uas4YKZJo=;
        b=aam0OJSRZraEPiPFnu5HPKBpyfB816nzuXH/FJKkrnqurvSQjtPd7WwxBnzycfR+BZ
         aDRHVlbWMwpRq2/wYWzyXdcbUjTIZZEoAP/+A7WB+Zb80UXB4P8M0JWwuP1eKNe4QQ7c
         hNIEQ6E45Wohqv+Rj0pmVdbIdyU8QeJVYSmxT3eRANVgmjKQHOAXIfSfLOrlaSxnTL3a
         10oggmhoV7biMamQTefrwl14O7RebVIKEsWib6CyI3S4OQO0fPYTvHpgvlMBwqO2fqYV
         DU/PSb5jqcppbBLGgw96xEOvB8mx2xEIHOz5oSvR49fD5jlb2VlaM8HfiIIZLwQecTtn
         JB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sw6Jt0zasQwCv1AHq12NR9c9myNo+U4Sy7Uas4YKZJo=;
        b=P0WdChUq8A/Nd7/n/NyyV9x9Oi3vUdSdkHBjDGKcqsaubDo4HyfMtXZAp7ZIcm6m1E
         APJKUf9MuMgVKK3aJ6/NhYKf2CPMHuzXyuwjh8UlQasuvR4TaMq69Sk4RuTld7Pbe59V
         WfnuZSx4+6vwEPFE5tUdJCswiG06W45DaHvta0n6eUZLqHKmh3+c3ZHrP0KFh2R0b2FK
         3DYEZ7cX2QBTstt3vzbWx80UdGZeocQKH/2f3vHlX2G/goTkvmrsRI3kfaLhlDwH3bA7
         WGdmK1ZAMVt4K/4MOAdZPocBMRMImWlXEVlpdckud7EWoJvx6IypTmlQ3xsqPBQAAErZ
         MVMQ==
X-Gm-Message-State: AOAM530EP6xCjZnzJBQ99HYnGyCTZoDGZMH88K3kCCjzPFlqgo+v6/BW
        5b+/mM9GI3DXoxZ5FB1F7i20ivLwErbHYkna0vHCkw==
X-Google-Smtp-Source: ABdhPJys2f8IHZkB8vWkiWg0q/z4QZxCaZ4QVZ7qfGlbJldrou1SgKA3LCZqQFgsGFibTEvkzJ/CvftElPXKVgANBnY=
X-Received: by 2002:aa7:cb9a:: with SMTP id r26mr12361302edt.78.1628698926906;
 Wed, 11 Aug 2021 09:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210810173000.928681411@linuxfoundation.org>
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Aug 2021 21:51:55 +0530
Message-ID: <CA+G9fYtX+CeD3xV16TMuhvee_YpE1REkicoPtNRttnAQh-ey2g@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/175] 5.13.10-rc1 review
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

On Tue, 10 Aug 2021 at 23:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.10-rc1.gz
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
* kernel: 5.13.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: 97aa49c885ec4453ea3d76036935989e68a6175b
* git describe: v5.13.9-176-g97aa49c885ec
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.9-176-g97aa49c885ec

## No regressions (compared to v5.13.9)


## No fixes (compared to v5.13.9)


## Test result summary
total: 86407, pass: 70850, fail: 2091, skip: 12372, xfail: 1094

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
