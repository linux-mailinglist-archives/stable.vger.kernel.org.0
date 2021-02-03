Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D11F30D6EF
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 11:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhBCKBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 05:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbhBCKBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 05:01:03 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47CFC06174A
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 02:00:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i5so3878351edu.10
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 02:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RxywI8qyE9NRJiLP1zJVKvl6KkJlN6Ih8IJ9Z/1y9NA=;
        b=Kcvh0yrBX/CuIyzYVT3MLjiyIgQTnYoXTirWe3ya6IvWMt2AkrIjsC1W+Vlf0mMsSy
         sawtmLDQIDf/nBzSfeW1SZyPCd5hsjRr8vUZP9r8du0iGWO0J924ZKkdd6fMnGIENsI+
         YxgmKZ4rTFmoy5NyCAcJqFUA9hVw6FFIbLpIrhQQgLe66VH9CosIX8Vpcz6g+21+ZbLr
         3bY41z1Rfll+dA2ykUr6tqZWMVVU9Tv5ZEiDDOKmmTtYfmrM057yMRcussXS8WNimICP
         cpVc3uDFN1u56v5mU0l4SQcYWLFF9GNGiWClSLmHjfhrulAY6bh/afTfvlEVx8S0zA7a
         tqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RxywI8qyE9NRJiLP1zJVKvl6KkJlN6Ih8IJ9Z/1y9NA=;
        b=KsnP1VCSL3DXiPfXOb4BqREAohVJsj2sGk3CIvz/wTwitTW5eoUfV95oa6BZKHSMIH
         RB1FcbE4Wgm8HNDF86fSJslXQu+rr6ytkG9AVn8pqYsBQw72CqDHPaWvVdn5Y+o2T7jr
         bbzF1XRaIHgY9RgJrf6PGuE/u8R0wZpDoxin2hXaBucrFFF/MV03HcvwImF/ytCMeoSc
         3cwDGRjep07q1E7kadlLOiJyiFwsNSWFzlA5dsMIWnPkeYaocF8da3IqWefwXgDd/KAD
         M08ePIY42OJZakMgYEbmECd3lwtGCdz0lLN8F7iDGiigjLJqgjF73jaX6tDyX3vmVIVI
         NRLw==
X-Gm-Message-State: AOAM531WcDRoA7wazFf5jdIaxHNfpwlyrLiOQvBpSPigMOo2hKmeLb21
        HRi8wbipJ2mmBJkZvWFjMXqMlTNfO3hzIqVFrAsUBg==
X-Google-Smtp-Source: ABdhPJy8BvzGcmpU9rXO9afyH47rNiZRxEf5GJJVB0Q9pvRhj5hvLEpeWGWyIPQIBmkScZYdqNqZlqFnR8nyPqe+KYQ=
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr2183505edx.78.1612346419297;
 Wed, 03 Feb 2021 02:00:19 -0800 (PST)
MIME-Version: 1.0
References: <20210202132941.180062901@linuxfoundation.org>
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Feb 2021 15:30:07 +0530
Message-ID: <CA+G9fYv_t9ScQB=HMz8LqGYMNw12+WzbxdoHwoXqauBDt+gBiQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/28] 4.4.255-rc1 review
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

On Tue, 2 Feb 2021 at 19:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.255 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.255-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.255-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 9c98a187325d9be55b09023d4a08cf0e8790065c
git describe: v4.4.254-29-g9c98a187325d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.254-29-g9c98a187325d

No regressions (compared to build v4.4.254)

No fixes (compared to build v4.4.254)

Ran 21248 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
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
- x86_64

Test Suites
-----------
* build
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* kselftest-bpf
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
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* ltp-open-posix-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kvm
* kselftest-vm

Summary
------------------------------------------------------------------------

kernel: 4.4.254-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.254-rc1-hikey-20210129-909
git commit: 1ed9a45adbcf3362d6299d7d9eb26d2fecc1f76f
git describe: 4.4.254-rc1-hikey-20210129-909
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.254-rc1-hikey-20210129-909

No regressions (compared to build 4.4.254-rc1-hikey-20210125-907)

No fixes (compared to build 4.4.254-rc1-hikey-20210125-907)

Ran 1710 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
