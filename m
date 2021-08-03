Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FB23DE72B
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 09:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhHCHYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbhHCHYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 03:24:18 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80694C06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 00:24:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f13so27699789edq.13
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 00:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ngPgwd5W9zI3HLSERpc7IgilHG9Vxsr6eSC4mxW72lk=;
        b=DyHh0gctVYvDn+Xqq6NcMMhLxnnFFk+pHLD2NA6dp17JJrr1R8nZBqprkOV4VkMlHa
         eyotaWRO8lsrP3cZ4Qtw8S1IFLQEfCmpBco9kFITum0vSZLe4snD2uJzR+MX28tjGIZP
         f+jkVkyUMIPBDAkO4s7u2sDdF77Ax2gjQHibGKETDRVrh4LsOTVO5MZiim6jkR51kUer
         aZ/ioCG3wZKK3Tqv22tyRn0QaDXqNr6NHAgaV27esBhlQUbKH6SVhFp8RVGcn8pl8rJB
         kBmYpIl9wGH1XFo76oydGNyiHjTCoz/dVOP7Nrcks745ALKrSgovZr63uP6yS/3VZD5M
         bPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ngPgwd5W9zI3HLSERpc7IgilHG9Vxsr6eSC4mxW72lk=;
        b=nNYiZaW7N1F8CyXbeDXPcfPiq913bj7hJMGGTeIP5WlBdm7RU7rJw4ASuKr7VE67zT
         qSreW3MsxubrBjoaJHmFBXbUclNP6wClvTeIqqrSmj60AkekPJqbFQwEkMCRhehI2HoV
         BHl7SfpsVqkivh9JxWNWTtTzx0NNfSCKt6ezO5WwiTdRGhzXrXmxyMZkmM6lFOzHI3pC
         sLoAd4akd8H0Iqz1cPrgqSbjZL8D73uhsLgrIyNR/4C0rYi1RlDYba2yhjchLsXq5cy2
         iC4j24uCnEyJxesTnJIfJUIWO0f9fulxKkSTbyaoQurwmiIer3tSSOL2w6LJpRn+7pP/
         b8lQ==
X-Gm-Message-State: AOAM532MaeeqKqPzdr7XKi5vkalxCjUnAGiqa5retnTMEpo6V09x5wMh
        wB1OCFNaf8kPQPMOfyjcklYVhYAIOPfiNwNdokEpiA==
X-Google-Smtp-Source: ABdhPJy1D5ri1q/JZa5RBjn16CByzeYVgMBf3GBrC8jto9FyQ3jg6vQn42uetDoMEL8cPu2vGhT4yrA13QPQ3QA8qHs=
X-Received: by 2002:aa7:c805:: with SMTP id a5mr23702597edt.23.1627975445895;
 Tue, 03 Aug 2021 00:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210802134339.023067817@linuxfoundation.org>
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Aug 2021 12:53:54 +0530
Message-ID: <CA+G9fYv6vtBzDkEtXkg9KFJSDaZbpft897a_Pu6ODgPbH+++gg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
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

On Mon, 2 Aug 2021 at 19:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.56 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.56-rc1.gz
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
* kernel: 5.10.56-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f9063e43ccbb353c5b2cafe59c6b9534aa7ddc14
* git describe: v5.10.55-68-gf9063e43ccbb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.55-68-gf9063e43ccbb

## No regressions (compared to v5.10.55-66-g099cefcf7e6b)

## No fixes (compared to v5.10.55-66-g099cefcf7e6b)


## Test result summary
 total: 79832, pass: 65260, fail: 1954, skip: 11355, xfail: 1263,

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
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
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
