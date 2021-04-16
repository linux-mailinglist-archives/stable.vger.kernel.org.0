Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D55361D9D
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbhDPJip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241974AbhDPJio (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 05:38:44 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902D7C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:38:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id f8so31473373edd.11
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EavaO1INdIem+7EBZda4+NLy8hD5HqKnHAI/MSCV27s=;
        b=BLBJZ9RZRzAftUg3Gq2Uo/+pfEvog3S4JycYp9c5pQJvN9gj4gSDySH/qKvfJW5C5t
         pEdE2v9cRiN0WS0tnv88AJKDzZBBUfETZs4xWbgF69qjENaGdP2NMDbSu/6Iov/uxsAp
         zPhKGculmILxefvHVSoYicsOOzzUg9OTA0GApHlnL3gVosuw/PjlzpFc/jYIbOjD8Cu+
         lyi5sd+WHy4Gal7rK34BtcRY1hnfbWvjQ/BkTJvP4uwMVcyxhkp2JNE0f3E1xU9JnPSW
         zPwY0JmqumvjsU+U/buz6/TNDtcptEIaJZ4fwJBu+sWy5ky6kZDAHFGKESgN3GOQ1+59
         xE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EavaO1INdIem+7EBZda4+NLy8hD5HqKnHAI/MSCV27s=;
        b=uE/J8YBwJ9oOeLoMLCi7hlQB63d0oxCX8lc63VtnsUAZoJDcgswRdlx5V1CKdqRaaK
         3XD1EkKHviKvrd+P++vjBoKzX6FI4s/D+Av3ez1miJbgslR5fjSpFnzDRmQLbF/3/QYM
         2puK6lOF4VsA2u7mHMLbeF97/OSl+ejFJvwmXYzq3LKeJ5p1sI4bi4mIYlPZ/rxIqQG/
         u/yhiAUV9FC5UqbaWz8PsnFBwJjGwP5AmTOKmwebLC8xcnDYeKl5FhypUORA3PFlUc+6
         e9gLlEEsvTtjozMoKEP56OH6K0q9ZGJOsvQpjKZmlKz2p38xEB66IdBUZ6QAjCCnaPSH
         j1Mw==
X-Gm-Message-State: AOAM532J91IEPuldUh9wqlYwvM2rzFIkl6GTqynYD4+Ltu7JzpEfSUQ7
        /W9zTRZtwmY5fusv7Q8aI9o5KpWNJQCenMiyJBQufA==
X-Google-Smtp-Source: ABdhPJxxyYgkqwr8m+RWl5TdFXec5Bs0L5KHELiuYnC7pXfS+LflW2gY84/eA5Oz1CkTV84pRKsKLjjk50NqQZIC2Nw=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr8886287edf.23.1618565897210;
 Fri, 16 Apr 2021 02:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144413.165663182@linuxfoundation.org>
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Apr 2021 15:08:05 +0530
Message-ID: <CA+G9fYvRR6HPujVRzfE_-injm+Z_-Uk-x8aFG5wHnC1b6CDfhw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/25] 5.10.31-rc1 review
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

On Thu, 15 Apr 2021 at 20:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.31 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.31-rc1.gz
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
* kernel: 5.10.31-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: 32f5704a0a4f7dcc8aa74a49dbcce359d758f6d5
* git describe: v5.10.30-26-g32f5704a0a4f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.30-26-g32f5704a0a4f

## No regressions (compared to v5.10.30)

## No fixes (compared to v5.10.30)

## Test result summary
 total: 72955, pass: 61311, fail: 1785, skip: 9589, xfail: 270,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
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
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-vsyscall-mod[
* kselftest-vsyscall-mode-native-
* kselftest-x86
* kselftest-zram
* kunit
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
