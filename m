Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F23414142
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 07:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhIVFcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 01:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbhIVFcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 01:32:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CE6C061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:31:13 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c21so5485443edj.0
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KYxXjTlbQN9CxW3/w/qvU4vCPhyT/2SxMQBkAs2c15Y=;
        b=DRN32zQY8MSjedsZ1CzTxqNI0MhKx+iZJWMLuWqxxLC6/F58DITbgnb9Je+lca0uh3
         3XxIyLtwKxT3UbP/ADhxAtZ1xkEOFjtro7lHH+MNn31CJNNG73aYfAJi6vHmfqLdYWih
         HTh7bYcDGuBG24qEm1KsEv7ftR9a9eY+Dps+y/bZdiIZ+RwaKPJnm3lvFcNicvq076j+
         tQSQ6GeKawADVPQzCpJ1xxIiQBPfUQitpLWMzX0W0ahA0AkMPktzfr1TEAzO1xQNOpGC
         QuT3NKSAwo5pl8OkxiY6luHrwIuNPhE/aueevFL1o3SEBUU7D4uxd3p+qWaVSLRvEk5E
         a7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KYxXjTlbQN9CxW3/w/qvU4vCPhyT/2SxMQBkAs2c15Y=;
        b=U38XJVwwKh3EV+v/KEtfgwKfszEaai+2z0reajm74N2Zj8Ry/wKr9wHT92/UI9IksQ
         GKfK3u7xWZNFra5EmEgpUAjxfxAAfcwuzBnDaslQQiKyI+rhYCdR1yqUKy0HUlqoQtkP
         DU0HmrCmbYxrQwl08dIGSXruaeV6j5qFsLriOGK+0Ea3HIGrpRpcpEGpAgrHG50f06mK
         ycMLEMbc7/C9+GWJtZEZHFFy/YMHNgR0rahZGA6ZjdVRPpuBefDc0a2B/aJhzsFdFKEV
         QbjH1Ef/TCMQqY2wpm6qbBlW6cAn+SD5EQ7JeUpAldgFpoXBG5mHGWRUjLFnQm1QaSvD
         6QZw==
X-Gm-Message-State: AOAM531I8C/2NGHeuY9mtwYgwFbY0Co14r3cmy3qV/OnME/HFtdLngJI
        VpBint4thEWfJD/B1RrSKvh0xNp411pn39QVSLEJPg==
X-Google-Smtp-Source: ABdhPJyPgK6Z8DKnWDo1q/pFSlysmkNK8I23tQ0+ywk3wqsHmEDIOl592BKWenRi0jacmrKoUcSSplirSKnwnXCYaLA=
X-Received: by 2002:a17:907:3f18:: with SMTP id hq24mr39129051ejc.384.1632288672379;
 Tue, 21 Sep 2021 22:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163931.123590023@linuxfoundation.org> <b3c63009-3b09-6b00-d688-fcc6fce21a71@linaro.org>
In-Reply-To: <b3c63009-3b09-6b00-d688-fcc6fce21a71@linaro.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 11:01:01 +0530
Message-ID: <CA+G9fYsb6P0w5xAjzGK_VxbC=yYCeOxre8SeCx1v4ggmPmOqcw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Sept 2021 at 10:26, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wr=
ote:
>
> Hello!
>
> On 9/20/21 11:40 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.148 release.
> > There are 260 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.148-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro's test farm.
> No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> ## Build
> * kernel: 5.4.148-rc1
> * git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc=
']
> * git branch: linux-5.4.y
> * git commit: 9f540728b6a345a2a70420f891d351c4397d3849
> * git describe: v5.4.147-261-g9f540728b6a3
> * test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-=
5.4.y/build/v5.4.147-261-g9f540728b6a3
>
> ## No regressions (compared to v5.4.147)
>
> ## No fixes (compared to v5.4.147)
>
> ## Test result summary
> total: 81694, pass: 67304, fail: 635, skip: 12557, xfail: 1198
>
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 288 total, 288 passed, 0 failed
> * arm64: 38 total, 38 passed, 0 failed
> * dragonboard-410c: 1 total, 1 passed, 0 failed
> * hi6220-hikey: 1 total, 1 passed, 0 failed
> * i386: 19 total, 19 passed, 0 failed
> * juno-r2: 1 total, 1 passed, 0 failed
> * mips: 51 total, 51 passed, 0 failed
> * parisc: 12 total, 12 passed, 0 failed
> * powerpc: 36 total, 36 passed, 0 failed
> * riscv: 30 total, 30 passed, 0 failed
> * s390: 12 total, 12 passed, 0 failed
> * sh: 24 total, 24 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x15: 1 total, 1 passed, 0 failed
> * x86: 1 total, 1 passed, 0 failed
> * x86_64: 38 total, 38 passed, 0 failed
>
> ## Test suites summary
> * fwts
> * igt-gpu-tools
> * install-android-platform-tools-r2600
> * kselftest-android
> * kselftest-arm64
> * kselftest-bpf
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-drivers
> * kselftest-efivarfs
> * kselftest-filesystems
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-ir
> * kselftest-kcmp
> * kselftest-kexec
> * kselftest-kvm
> * kselftest-lib
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-memory-hotplug
> * kselftest-mincore
> * kselftest-mount
> * kselftest-mqueue
> * kselftest-net
> * kselftest-netfilter
> * kselftest-nsfs
> * kselftest-openat2
> * kselftest-pid_namespace
> * kselftest-pidfd
> * kselftest-proc
> * kselftest-pstore
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-splice
> * kselftest-static_keys
> * kselftest-sync
> * kselftest-sysctl
> * kselftest-tc-testing
> * kselftest-timens
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user
> * kselftest-vm
> * kselftest-x86
> * kselftest-zram
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * linux-log-parser
> * ltp-cap_bounds-tests
> * ltp-commands-tests
> * ltp-containers-tests
> * ltp-controllers-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-mm-tests
> * ltp-nptl-tests
> * ltp-open-posix-tests
> * ltp-pty-tests
> * ltp-sched-tests
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * ltp-tracing-tests
> * network-basic-tests
> * packetdrill
> * perf
> * rcutorture
> * ssuite
> * v4l2-compliance
>
>
> Greetings!
>
> Daniel D=C3=ADaz
> daniel.diaz@linaro.org
>
> --
> Linaro LKFT
> https://lkft.linaro.org
