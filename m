Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A141413D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 07:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhIVFbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 01:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhIVFbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 01:31:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9387C061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:30:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v10so709649edj.10
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Avbx75+fkjXXPuaxxzU1jo1j4VOu6DvWyuqO+QASGjY=;
        b=VFuSl4Dnxx+6MinhkYzbXggrEO75rjFV1A0gRaH178bF54Vlvd0tniQenyWCg66N3R
         Pco4DzzlgW/Lq+1T1WLsD1+WKcDHkG8WydC1tmNX9BejawEFC5tNfrhZZ5Uj9bgY4HVr
         whcEpi3UaA5rhqKpeSqDChfb7fbFdUxI8H5YgusyMBaLq6ZAO84oLAamP/ta25/ajkaW
         ep6ImoCz0QL5qCawfL5+js2vIBHRjvXnAx8F7SoDMv0cQXpZvUEwMW0FjhZzLenQurfQ
         dbIsrw+pBZDDJ115POsnCblNBM89a8vrcbGdMg9l3tJ1iWruU1EOZxWSwdqduJvGD42O
         Tsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Avbx75+fkjXXPuaxxzU1jo1j4VOu6DvWyuqO+QASGjY=;
        b=zmk0jlV3ft+g3xfH1ErCUtV+upJuHIvA6B7LFTKHK1UZ0f3hHjZIraeB8LCa4vcxgF
         iNUw1Tc87LAnouJeBaGcDqcXoo2sqcjvAWLilwGuONWeD6Kn4hVT+gUbgEj+EW2DcXLB
         96laklJ3dcqrZcKikd8r3PPJLBkJhD96Flx5wqPhOjguJGC6O8Q+JED1x0x6BiOi/P2j
         6G5EFsrQAJip6GzMhPEz50qRfhfAb5HBudf1Mq0pGDfqEPp7sdpageMGZGXwmHH/rN2c
         q7I7QfXIKcC3xjXb1X66FRmK8oTV3ZY6zyEojMgsfPPBpcolIwbc/0CkjkVOdDvJ0kZl
         yuhg==
X-Gm-Message-State: AOAM531u4n2R9oDBHv70EVKG60bCQfvBfiNtg0fLx0Xs5eLFblfW+A/e
        2Edo6EtVKjJ+fsT44szCiD6Ds77qMrPRWd6OnimWEA==
X-Google-Smtp-Source: ABdhPJz3Syp2kOEsHPP0XmP22Zdnd6dHUi8VDZr3aOCnpT/nX9eD6FwrZzIyHQGvd/3ta829K2jJ6Xc0uYCoU5/Uw6k=
X-Received: by 2002:a50:8163:: with SMTP id 90mr24253281edc.198.1632288618203;
 Tue, 21 Sep 2021 22:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163921.633181900@linuxfoundation.org> <35a539d6-9b20-c196-0838-29a2cdcbffe9@linaro.org>
In-Reply-To: <35a539d6-9b20-c196-0838-29a2cdcbffe9@linaro.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 11:00:06 +0530
Message-ID: <CA+G9fYt6BPfWS_JMHRTyshHS_FSjEq7zYz9pAzxfCNd4RAXwNA@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
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

On Wed, 22 Sept 2021 at 10:24, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wr=
ote:
>
> Hello!
>
> On 9/20/21 11:42 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.7 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.7-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
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
> * kernel: 5.14.7-rc1
> * git: https://gitlab.com/Linaro/lkft/users/daniel.diaz/linux
> * git branch: linux-5.14.y
> * git commit: c25893599ebc571ecb26074f1338ac0c642078e4
> * git describe: v5.14.6-171-gc25893599ebc
> * test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-=
5.14.y/build/v5.14.6-171-gc25893599ebc
>
> ## No regressions (compared to v5.14.6)
>
> ## No fixes (compared to v5.14.6)
>
> ## Test result summary
> total: 91141, pass: 75795, fail: 1053, skip: 13212, xfail: 1081
>
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 289 total, 277 passed, 12 failed
> * arm64: 39 total, 39 passed, 0 failed
> * dragonboard-410c: 1 total, 1 passed, 0 failed
> * hi6220-hikey: 1 total, 1 passed, 0 failed
> * i386: 38 total, 38 passed, 0 failed
> * juno-r2: 1 total, 1 passed, 0 failed
> * mips: 51 total, 51 passed, 0 failed
> * parisc: 12 total, 12 passed, 0 failed
> * powerpc: 36 total, 35 passed, 1 failed
> * riscv: 30 total, 30 passed, 0 failed
> * s390: 18 total, 18 passed, 0 failed
> * sh: 24 total, 24 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x15: 1 total, 0 passed, 1 failed
> * x86: 1 total, 1 passed, 0 failed
> * x86_64: 39 total, 39 passed, 0 failed
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
> * kselftest-lkdtm
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
> * kunit
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
> * ltp-sc[
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
