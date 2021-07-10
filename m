Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3768E3C3429
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 12:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhGJKjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 06:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhGJKjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 06:39:36 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AF7C0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 03:36:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m17so17997901edc.9
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 03:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TAR4RY9/gIQAHuuxAbrC3ZAk0zeAkeyd3tIQhIHHlfc=;
        b=Aqfq5gcCwtLS2+QWNJBZVND09gTHkRrHaZVP6TaKHUe/KFd+7xbQ0hZupeB5LDzjkQ
         Mrnc4AA2wFNF7Ua1tk2UoBAMQjBPGhyM1/mFpAsXSqq6PR5msoo1oe5VW7IU+E3q3O4P
         7M3XeViD3WtnmFDNYfuAyPKrU0AF3/IHBhShI6ske42YUjRw8fpNfnKKVZnQFi0hdP3P
         9oGM2E4bRmJMiT7f0KoSNUh+FNMiL/FoOb8iukk1wVbwA899YQ9YGB4tPMd3kgv4kqqz
         1QyxpcHOdjs3I24bLVeq8Rlzw45O1YM3kiKG5GFUtIOalNBStzFS+Sfuz7SKvIrVqH8P
         plAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TAR4RY9/gIQAHuuxAbrC3ZAk0zeAkeyd3tIQhIHHlfc=;
        b=oKV8hWGZ4i7HsfzACC1X0WktPFJU5EMyg4pS+mcGIVH9RzKulhLIbmouWp1CARkDqk
         dFDJuvydnBYgCQ02ck1px5V4roAY7hyFbKzXRG84trkt+OkwVN4fYU0etaX0U+Cebtdb
         VnJ/t21vVFYmyxOEGtiCETEd1hNa9Q/VTBed0cvTTZlP+gVqGTlGrmXyA4HcK6Xfezhd
         SsMfVPsDCvQf/xV+G1IKnZqUNJkyF6Bj5DLyLkQp4XWHBm6eFa/I2hp00tAvQvpcvwEO
         njz3eEGWw9SZFUhy3nIKY4iQwDhiJtCPlvclsm+CEBtIaK3hkP03nFBbtMLGmqKgMn/G
         Rouw==
X-Gm-Message-State: AOAM5303PXyJXDhvLonJoXwPdAecxCplpVygrHQqCdQ9eraIHAG030zZ
        TOVI9vJrIEzXGYatCEzQrqn26PU+KsVO87AqIJbgYA==
X-Google-Smtp-Source: ABdhPJwS9TeQQ6Wyj58R1s9c+ZlHI+x9aEzdiyCvRy25wbdOhyjnIqfWT5Ky7woeDM3juzOrlDt/lYWZtJZQSbyqKWA=
X-Received: by 2002:aa7:dc01:: with SMTP id b1mr52512105edu.239.1625913409116;
 Sat, 10 Jul 2021 03:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131531.277334979@linuxfoundation.org>
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 16:06:37 +0530
Message-ID: <CA+G9fYvjiBy7Lh2ApTgycu-60=rS1uC2Rd23J83iHQFubtgS7w@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/4] 5.4.131-rc1 review
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

On Fri, 9 Jul 2021 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.131 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.131-rc1.gz
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
* kernel: 5.4.131-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 901498b2630533698a5037666f2d140b120ac995
* git describe: v5.4.130-5-g901498b26305
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
30-5-g901498b26305

## No regressions (compared to v5.4.130)

## No fixes (compared to v5.4.130)

## Test result summary
 total: 73646, pass: 59708, fail: 787, skip: 11904, xfail: 1247,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 191 passed, 1 failed
* arm64: 26 total, 25 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 14 passed, 1 failed
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
