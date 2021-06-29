Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBD33B717B
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 13:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhF2Lpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 07:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhF2Lpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 07:45:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08141C061766
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 04:43:11 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bg14so35803217ejb.9
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 04:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xrJg3Y7e9QSJnkC946QU97dRLdKVVbiRKeoHJ9hNFS0=;
        b=OISl+5Nh8s0enJCyj/+V3ArIRUr1B/VS3gV/4j1h1l3R1RvOp40PEZqV66T3S75IYK
         1RtkwUTKhzrIaQtiYUxyH2HVjaiwXHyZ68ZcoT+3o0bx2ypoNzTWn954rrsFVI2Tsuur
         8t9Rp52C+qFRzUVJO8YQkMtCTHkNJyxwdw0iGrbXwNnlLvDMVkEbWK7Kas0qQMi8Z43o
         k44aIhtyPvkTg22wV1DayIDxMS0k7nqAXJe9gPvUTCDu1CdN4EDPWJXEkPFw6jia48KK
         telHbj15sZXAgROxIS2W9/z/sW9xRmBZgZQWnxR5YpB80Nyz9RdZqaO3Mw1sYETAFmsv
         JZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xrJg3Y7e9QSJnkC946QU97dRLdKVVbiRKeoHJ9hNFS0=;
        b=U49KyoVJwJvU1vyCTYtUBKHrewY7xE+OiPfjKi2jaqc86mAfdLWPG6CgnNQFkavOV6
         yUsu5hOxLxWpJDm4399BpLkowK2ocjO5mFIADQigKkqSzJyKMlt4PWLwnl6dWMJsfimh
         ZXZPKfQkBwSW++20grE5M6czyGdjGXcGB4JGHnDzjgx/dAzs8xt0QuNQ716qSszmStS0
         SlvU7sYOpyG+AzDicTUMISnK/OPbaoYroWz0pcRqbjvVRaWLH9up4Ro0K4dXgU9+TR5m
         0iAtiyUv99uZ2YmMNuPq8Mz3zGG6DYl7pjToY6KZJfzP1XZ54xJB4VkOZKJY96w9ckcO
         vvEQ==
X-Gm-Message-State: AOAM53113yLL1e1ZhiON4cP1qedycQ8bpiN+FOJ9fvN8by2PlEZ70i8f
        M7kNh0SayqmfpVy9Vob3RmSL7hrwAtTYgbX4NVSziw==
X-Google-Smtp-Source: ABdhPJwl2oBYmPKwWrgu6B1iq3Tld44qP/7HnosEGChOrq+Ys3vfb3EESpUmoBI4kQahXEMq2eII4tWuP7Q9S3VZ6HU=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr28729775ejb.170.1624966990403;
 Tue, 29 Jun 2021 04:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210628143628.33342-1-sashal@kernel.org>
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Jun 2021 17:12:59 +0530
Message-ID: <CA+G9fYsDg=3t4_1Ut_n8OP+mLxtQqR322fmmw_QgSY5uNDNH3g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/88] 4.14.238-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 at 20:06, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 4.14.238 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 30 Jun 2021 02:36:04 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-4.14.y&id2=3Dv4.14.237
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.238-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: f8f0323505c56f13af223c8b9ad54f2fad125756
* git describe: v4.14.237-88-gf8f0323505c5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.237-88-gf8f0323505c5

## No regressions (compared to v4.14.237-71-g66c6950a943b)

## No fixes (compared to v4.14.237-71-g66c6950a943b)

## Test result summary
 total: 62567, pass: 49721, fail: 1298, skip: 10514, xfail: 1034,

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
