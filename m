Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5332F968
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 11:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCFKkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhCFKkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 05:40:23 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867DAC06175F
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 02:40:23 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l12so6548364edt.3
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 02:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mRhKROtaG02yUwurNBgzOTBJWtWQvo2wqnE/vQQcSmk=;
        b=uHa2yEiBKaCkyi2eo8gwvHkWoTfAlOh34qaFwnEn5pHf5ezWoAxpYNPYY8D4QvaiZ0
         OqEnuVkYEdsAf0lBq3e5/OtIOx2SOz04eFHdHFssOPrwBXEk3gPBMViB6Nh/kFScA9J5
         In4oAIFV4rlVKEX7Q7k7rzxxMuG3ZLyal5LWyxs6OgYJNzeuHU4lHyDW84C7v/fJ3u7o
         3EhZqzSKsQHTK1iQIbU+ac1a5Iy1HGxmEu0LL/SgcJ/fVkR21Zgzb7c6qqrIPgORUKC/
         lNpms2cxBbYbou30jBjWmSmd0K+CIrdPwYtOfkswxbhm6FIOfcuRcYazFqdRf8suM4gZ
         ZOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mRhKROtaG02yUwurNBgzOTBJWtWQvo2wqnE/vQQcSmk=;
        b=QrSn4o//CkJjmKQeWPT4UhIwg7ZjI+rBNG0gqdiZ3AXXaH+VWQ+uXYz6kBkptLBHoj
         EdcS2JrMzcrpKUZE72TwikBc5xNMrVcjmnc132ClOlYjybsGajpftfVu58/5w009SW6y
         kMCErX2+riWZJd266EwK1IkuU5RyY4etdvGFk+/wC46Uripo7ICtGMjkfawlts5toZT6
         6A9bxXb8YcGqaHyDcWgO+j+4x20Y13a29jEp+TU4xIys+nui2RbpSemA3rmQYPJgHvvS
         p+wAYTOYhSM3GARYcDJkvx36z0wgH8dgSIbn0cgza1oSIAixmU5czbOODzoLhTvkKMfh
         Ds/w==
X-Gm-Message-State: AOAM530nVViIdY0IcJqdbGsZzlpRPioEYnFwjcV4DD+WurFNVvWBux7E
        iOXb7BtQFbpVoNh5ncsMPLJTAMNjqDV/r2F/I0q1Rw==
X-Google-Smtp-Source: ABdhPJxD8OxYnbgWyUDqNvuc4AvP1eSI8LFiZp+kdYA3BMZjYgUVIM8HATojRxOpIw+7Bl4jpn0+xexQca6X49MKzqs=
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr13097382edv.230.1615027217055;
 Sat, 06 Mar 2021 02:40:17 -0800 (PST)
MIME-Version: 1.0
References: <20210305120849.381261651@linuxfoundation.org>
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Mar 2021 16:10:05 +0530
Message-ID: <CA+G9fYsw702Hva2NZP-btNd9yNfmU0_xnNi9+ohQCMwgX-BusQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
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

On Fri, 5 Mar 2021 at 18:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.260 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.260-rc1.gz
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

kernel: 4.4.260-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 22ce103533f98c3a483b24b6e18069e581f58f16
git describe: v4.4.259-31-g22ce103533f9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.259-31-g22ce103533f9

No regressions (compared to build v4.4.259)

No fixes (compared to build v4.4.259)

Ran 22484 total tests in the following environments and test suites.

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
- x86-kasan
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
* kselftest-livepatch
* kselftest-lkdtm
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
* kselftest-kvm
* kselftest-vm

Summary
------------------------------------------------------------------------

kernel: 4.4.260-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.260-rc1-hikey-20210305-947
git commit: cce57b0d5e1b470f2de450435f74b9eba4e898a7
git describe: 4.4.260-rc1-hikey-20210305-947
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.260-rc1-hikey-20210305-947


No regressions (compared to build 4.4.259-rc2-hikey-20210302-945)

No fixes (compared to build 4.4.259-rc2-hikey-20210302-945)

Ran 1909 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
