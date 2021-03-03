Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EE332C81F
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355598AbhCDAeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381293AbhCCPbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 10:31:39 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C884EC061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 07:30:50 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b13so21324144edx.1
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 07:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PVT3UCrEsC9d+lg3+Q1jrnmN9m0cQ+gdh8SN2a1PHvY=;
        b=HvBqoYp9+PpT/RbZvsE9Wydpa4H6GjYsK5JsxEuGODGsdoBrbYwUG94YciGwjI58Kn
         POQ4uUWvx7T46TeUhm3mzoXdR7UWrowcSG+/0SBfRXX0LSNJP8dNWZtW/mBh9MvS6LlR
         lOPrbhPiOG/BUuKcoYnMR6xP3kZhODt8WwSdKOd0RmnGkf/iaSl136Q0yYnRK0PLfD9x
         51Px9IEVfAe7b7LGOkFLGhtGEy53oO4K0laiZxb9QgUKSmE8VHo/dwYP/AW7wiajTo5V
         RpN3HELXPySh/PUheYwYiHxpi2GOQ3jH/Gq7TgZVzmQTCr/Sx69xl9dwvScH9oaP+iLr
         1aPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PVT3UCrEsC9d+lg3+Q1jrnmN9m0cQ+gdh8SN2a1PHvY=;
        b=cQnO1yksisPA9fqKMXjeVeX/7jTe2Xv4SrXr/om3rqQiSO67EC6YDcuciIueDPMsBQ
         QwYOHPcp9n/VX3hEV/YCCKYgSsUvRBfH1oIU40Vzh3IvLX+KezME4e2COTA7U65aoNAS
         1OK2mv5vKgrANCEh/yyg4TyOqVfJXrR2UVDjewnObTr8MzTQlQsoNwuwyRAamFqd/HHY
         nb4L1Djg6PCKPpnXhQH0WmOkdjYcGPrBO8Unkwo44Z86orc+qXMGSwfue9rgWkReciXE
         G2JKUFrAXb0xVTa2cM28p75KjV0RtKYaigtT0Ils9fZSIup/gaML1EMSSlI046QCH8s2
         9Zow==
X-Gm-Message-State: AOAM533FMBf0jWmdzqcVvdc/yZkfIWBH6XkOWMex5dWbqZ6pGWxG3j3W
        hX0Bf/cyHeecLGwZ4XTXP2mvYJPLeZ3KxEQLV/CvXQ==
X-Google-Smtp-Source: ABdhPJyu75kquABO8rnyReT4gLo1WyjHbbeaEKFtKsY7c5GAoho/l/Dqi6Bx5a6QE6Xq4rJ2CBf24CawNan6WmkbyXo=
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr25498421edt.221.1614785449416;
 Wed, 03 Mar 2021 07:30:49 -0800 (PST)
MIME-Version: 1.0
References: <20210302192539.408045707@linuxfoundation.org>
In-Reply-To: <20210302192539.408045707@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Mar 2021 21:00:36 +0530
Message-ID: <CA+G9fYukkvH_mcMQmWeYFK4r-dwNV+fwNz_8ozxJNH+AT5uy5A@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/175] 4.14.223-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
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

On Wed, 3 Mar 2021 at 00:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.223 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.223-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.223-rc4
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 451d68c3cf2f3a60361954e664e9a97a67f069dd
git describe: v4.14.222-176-g451d68c3cf2f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.222-176-g451d68c3cf2f


No regressions (compared to build v4.14.222)

No fixes (compared to build v4.14.222)

Ran 41005 total tests in the following environments and test suites.


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
* fwts
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
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
* network-basic-tests
* v4l2-compliance
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
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* perf
* kvm-unit-tests
* rcutorture


--
Linaro LKFT
https://lkft.linaro.org
