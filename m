Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D655423892
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 09:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhJFHNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 03:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhJFHNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 03:13:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FDEC061749
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 00:11:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so5921598edv.12
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 00:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=exAYTb6mcr4ScjMC08up/Sr9OyLfai05n/yrjn97kfQ=;
        b=IWe+lxRT9YA0FKZcpq9XHTCtVYU7geWHNIMju8H3RU3n6H5YTEc6IeMUGNol5pf5Rq
         kMe2dBf5/aDYiK6gqbk95UJjmtGwBYh+EgijTO4XEUfICLWXmBvNHdcsnqWeWkkj3+Op
         QPuygUhWAYyEHys5mdgIlXJsY7/p3tgPgCiOnuh8XIAsy2FujS6Whzs8cykIvoddOTdK
         FQ+abApt0dfVlvQ2/vQRA21qitd1i3WkoPR1xoenHo79/v4flRDJrzXJQvIpS4UjYO+L
         7ktxmYKxFU6dFdwlAmZa5UT0SkZDgGKadMO6VE3qiJvew6IIiw8te/VUJSMlOlSLXYsN
         0WXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=exAYTb6mcr4ScjMC08up/Sr9OyLfai05n/yrjn97kfQ=;
        b=nZLszaTKoEknfUniOCbnOiiVsCJ0VGygCu2wJND+uYzszl+mj/RkjmHrwobfjct5Di
         wqGQISE2SRw36G/4g/yzYH7Sf+t452gsHGXY3kVFIUgdY2V2E1XTPlsZyVR/2sYNg5p7
         HeoMtCwFbEzGbJEZ0oaIOc47AVJq0Vh8K8HEUDmXQ3i1VHhyAq8mRcRJthNOvTUfNMyM
         kTK/ktrUq3c8ogJhWHy/q0JqUAyw231zzG9YwGbj2YvuIMa9FdtnlaPhzRu6OTyDgAJn
         XaBV7yg2PnJ+6OR1kH1y6eb6Ecb795jXKenxsDVd9K7hSSYecB9QAgTxPW+LuaIo2K/c
         sTEA==
X-Gm-Message-State: AOAM533tnIQe55/UVnC/b2NpB6sbv6LzEzaxv0hSwlFf5fqF+ZXCUd7F
        uDoU3xrqvQz7j8na7kJxN+sh/XS2d7j6de1spRkKxA==
X-Google-Smtp-Source: ABdhPJwJ/4Ehaktzcx+dKyS+TZ09JPP0OW20w2dpX/RqYG7QRJkTU48TUWQdKHAU/eNJTDbxIzq8IKPjkco0uAxC0R8=
X-Received: by 2002:a05:6402:5146:: with SMTP id n6mr31735052edd.357.1633504283426;
 Wed, 06 Oct 2021 00:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211005083300.523409586@linuxfoundation.org>
In-Reply-To: <20211005083300.523409586@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Oct 2021 12:41:12 +0530
Message-ID: <CA+G9fYuXMBp3ZCUJ_A8BzLz9mu8w=z6SxoSb1griMWxbEMz=sA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc2 review
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

On Tue, 5 Oct 2021 at 14:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.209-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.209-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 88f9c3c825ad88e33c64932c60fb5c2d130a9fb1
* git describe: v4.19.208-96-g88f9c3c825ad
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.208-96-g88f9c3c825ad

## No regressions (compared to v4.19.208-92-g95915ca2af72)

## No fixes (compared to v4.19.208-92-g95915ca2af72)

## Test result summary
total: 77007, pass: 61916, fail: 648, skip: 12772, xfail: 1671

## Build Summary
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 1 total, 1 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
