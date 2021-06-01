Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1270396DC9
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhFAHPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhFAHPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:15:15 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188E9C061756
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 00:13:31 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lz27so20009809ejb.11
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 00:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y4pIwun4lcYA5WBPfQTrtPC9bCpeKo1JjO9SfQad/uw=;
        b=ORkO2FmC8O8AMwNNjRNCIacjBr3sKBcOpNP/V3v1Y9f2YtUK8BMa6WyiW5Byd/jMho
         t5/Oumr9GuVhOkAF2C+u2l3uoZ+3ojoZI0l4ScKWXI0GVyCiy3cnafOdZ+b4tIXUuix3
         LYsqWMWvCBJEVJN6gVwS87Pab+HNvNjcUV5Kyg2kb4yu/VNsFjsRLysxhQ4IvikwPtfQ
         M2gbuyNKkBd1wPIf2fNkeJDdWihJLN+nlSGynl+LemiRXqYxsLbZLS/w4ZQMB7tEJoii
         6FcL9Q3Gc+VZYM9IgYBLOUQEJjgJnax/BrAKArJR+Dl91IgxvrpzAwbM6eSeyYv9ZHC0
         kURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y4pIwun4lcYA5WBPfQTrtPC9bCpeKo1JjO9SfQad/uw=;
        b=VCgzPbs8KpRFfdQ64vVy3KUT1nCgmRDKtbsNhMdKu6DgyzkbIeRpzAFQb5Dc/MlxBF
         s48eSsST44F1X72pOYDnPHnnctwzu0jsG4lGvtmmj1RhBi9gnsgHdPklPjgBg8zBex+O
         WrEIgkPm2LN2bEBlLY9j3aEO7JLw50Zxf7xW1NOF5mByQMFjcSt9DrIEiwIlpXkw/nWe
         Kjb852q9zXRHMIkZaGkNPJJzDHG715pZK5cZfZEESmTMIvqdUrDKOghWkwonnvJ4uB1p
         VXSU67QifB64px9cRtuISWMbC4jJOosX2dbxu3FbtOe1jisgc2FZeUCrcUPH2xX4Eulh
         5DBQ==
X-Gm-Message-State: AOAM532qaTbGos9xZL7kB4NcBwZs0c1D3C5myS7BIepP9hM2im5m0ZJm
        WDq1y/0KV3vilk+PCvP+sapcAhZA7nN9ADwE2gjZCQ==
X-Google-Smtp-Source: ABdhPJxwTRPw1SyfjHlncNSOVorvYESoFFbXMikButATomxjuwsBtRRhsFdbrn1FLDfvVaLzKr9cQ9nL1qakihnHqzI=
X-Received: by 2002:a17:906:5f93:: with SMTP id a19mr19302430eju.18.1622531609380;
 Tue, 01 Jun 2021 00:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130657.971257589@linuxfoundation.org>
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 12:43:18 +0530
Message-ID: <CA+G9fYtU3_=W-Y-SG9rdQV-JXLT82bciuy0FJ_ykcOnr4LCqQQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/252] 5.10.42-rc1 review
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

On Mon, 31 May 2021 at 19:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.42 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.42-rc1.gz
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
* kernel: 5.10.42-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 2a1bdede969e234cf4e4e8d31566ea1804d3b443
* git describe: v5.10.40-263-g2a1bdede969e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.40-263-g2a1bdede969e

## No regressions (compared to v5.10.40-10-gec1cc3ee7be2)

## No fixes (compared to v5.10.40-10-gec1cc3ee7be2)

## Test result summary
 total: 74784, pass: 63100, fail: 550, skip: 10569, xfail: 565,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
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
* packetdrill
* perf
* rcutorture
* v4l2-compliance

--
Naresh Kamboju
https://lkft.linaro.org
