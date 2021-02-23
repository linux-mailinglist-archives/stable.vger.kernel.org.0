Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E81322A49
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhBWMHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhBWMFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 07:05:13 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BF1C061786
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:04:32 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g3so25504502edb.11
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u54RcXY8lntpJRKlVhb5dK9TdcZjKTkI7lQxSwGkD7I=;
        b=Sj3jaLOrk9EgUNB4CMwV5RDi9NW4MNzgeXmP3xvBhZkEUwiYNmudBpdsY9O807ER/5
         qDjhj+6MigQdUh0/s2lO2tioTo9ek59WLM4IHy3+Bu+ZDTUIgkDyiI/DQTDAdP1RWgBz
         IVvwSzji17pVJfAk8Fa2kXa02wXSZipmXJJdov+lxE8tBaD2ShoSbSVuNvkS+Y6pzaeC
         t0TwwjzE2lp8jeMjSjhGKGZdeVW5bCoSi+xGDbDxMCzC6fgXJVia/0ukY3P8w0dMOxZR
         gBuYMDNqBOHsqOk+pf6efhKav+rrG+DkqLysDVUO+3MjiKNFpx/gEl0DWcVy2QJ3ntVZ
         jnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u54RcXY8lntpJRKlVhb5dK9TdcZjKTkI7lQxSwGkD7I=;
        b=hkKUu6fpXy3KOhEf9AapNJRRqFj8OYutJs+jznEBt+/5/WS15joi7P9wjg7ulecDoI
         itOVZ8falZVk2kS6maApmzxzH1ZMKauAZu8vXZ2nzCqhXANhBknROMwYSGOyZ/DeMWVG
         SP6PX+B52AcnMi39GTo49yeqVIPL/WJQc4bucaGMvn324rQAP3uRWH9VkDfiauSYOKCj
         yDHKVFHSoHBwinzx8auAKU6tQmsRWLP7ZSv7nF2QuHmG8oKVzwwNo8E3UBjZrb0yWqeU
         N4jtlwp/95Zy5m0b5bZjIRiK/Gxtvld3k0GlEGeupxfapvxJBJBUzODrvPMDY4HhaMI7
         W9Ag==
X-Gm-Message-State: AOAM530ppyUV5LkITKISrd9cUxBCqY0Dw7PLWu8PvTn1Ym4xJIyXL5NU
        WCuYURWSKt1G9HMVxHacFlh+M1XT46ZOTaBjImsxaZwf0yzagYGd
X-Google-Smtp-Source: ABdhPJzJAinCv+2pcIKwucmukYorecqSwGho/KIh01RmGZFktqdOABnysMgYqYjpAwm5nm8r0lbCQkFo1Lr2/w3llMg=
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr27137270edt.221.1614081871259;
 Tue, 23 Feb 2021 04:04:31 -0800 (PST)
MIME-Version: 1.0
References: <20210222121022.546148341@linuxfoundation.org>
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Feb 2021 17:34:19 +0530
Message-ID: <CA+G9fYsyqoo5+Vz_uYf3QkLiaKzT_p4R6r+n3-eQw1Hw3A3B5Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/49] 4.9.258-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 at 18:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.258 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.258-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.258-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-4.9.y
git commit: f0cf73f13b3979117e50a90dc884d48c1738105a
git describe: v4.9.257-50-gf0cf73f13b39
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.257-50-gf0cf73f13b39

No regressions (compared to build v4.9.257)

No fixes (compared to build v4.9.257)

Ran 39549 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* libhugetlbfs
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vm
* kselftest-kexec
* kselftest-x86

--
Linaro LKFT
https://lkft.linaro.org
