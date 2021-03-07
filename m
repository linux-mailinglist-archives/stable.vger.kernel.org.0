Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D141732FE6C
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 03:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhCGCQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 21:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhCGCQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 21:16:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9210C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 18:16:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b7so9234651edz.8
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 18:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2wLUmejhcVRcqc+rAjZMStnlGz+fratQopF1EIC76k4=;
        b=R9cms9de9UeuR0CiH0ytJw9WpeNwHpeOjmccfGr0e06l0DDz6dJOZAGtCHmr7Pfg+G
         GrpZfbcrKP3HGB/7tWn/2+xD1LUlaGD9QBbKT1V71rugJSph48F/JqlDG5SHTFGuZQiE
         6wJufX4XCIukc1YKxAJkJLTLfyxPFAmKPtPPWBuSLtO6FN5R+uCSk3BJwoiU/W9wxq56
         03ZHBsEqAVrXYCifoEWDctVJ/J29S9wtiTfNCBj/2eErODmRC1XdrPo+FJyGvyElghyJ
         D8e31WqCIaISYQ0IKvhqHckuLL+ALeSEruUlyaq8/OqNoFEvJ1MEXyeMsP0dJzkxJKoq
         q5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wLUmejhcVRcqc+rAjZMStnlGz+fratQopF1EIC76k4=;
        b=OuiEZKMd+nFMMruZOC746+ETkKYzJ242rywYZiWbSt6M3Zm3aG9aEuknQGSaJeQI4a
         wkkHNycnDkXyk6bm0cSZA2kV8AiBuyy2ou07I+VY+KPlfMRG1fydmRxnva5qp+XVA7YV
         1CAvVw0BIg5dApR04ExgSR4vQ+F34ia2JipVjayVh7igv9LPwIKjpcAMsIiOEF1Atdzx
         DyAJBFx6iRLNMg6oGt8ml43r11ZjW6KGG4pmKe96WlCgE+TeCHWM9Uy1bJTcEntFUib1
         NMx9h7T72DnvZnUZtZ5Rg1Mt42662MjZ+PAxFYHa6wfcP96eYmQhJjrKdz6spTq2MZOy
         cWrg==
X-Gm-Message-State: AOAM532tBZr+OU6bfeU5a0ixinjYUVwSYmgbL+6BllIpTGGr+eFlgpy8
        M1eomRg6nUIfASWDoEBUW7E2dPDtfl1vXlnVTE9spg==
X-Google-Smtp-Source: ABdhPJwAqKweDEd+pxpKfoQCzGiTgN/Z0cGTtZjqwUxAVO0H88pV6opbajSQ5mlvsTykHNIysMu4x1bsrAbclHmDses=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr2572301edd.78.1615083377192;
 Sat, 06 Mar 2021 18:16:17 -0800 (PST)
MIME-Version: 1.0
References: <20210305120903.166929741@linuxfoundation.org>
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 7 Mar 2021 07:46:06 +0530
Message-ID: <CA+G9fYvu8RgxGFwr3J4W5NjZLkukYh1SM6-_+2-1dot13Y2s6w@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/104] 5.11.4-rc1 review
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

On Fri, 5 Mar 2021 at 17:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.4 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
LTP pty test case hangup01 is getting PASS on this version.

Summary
------------------------------------------------------------------------

kernel: 5.11.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: f598f183ed0a259f541fe8479bbadcc20c89c7a9
git describe: v5.11.3-105-gf598f183ed0a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.3-105-gf598f183ed0a

No regressions (compared to build v5.11.3)


fixes (compared to build 5.11.3)
------------------
  ltp-pty-tests:
    * hangup01


Ran 45135 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-64k_page_size
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-
* kselftest-bpf
* kselftest-intel_pstate
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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-android
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lkdtm
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* ltp-controllers-tests
* ltp-open-posix-tests
* ltp-sched-tests
* kvm-unit-tests
* fwts
* kunit
* rcutorture

--=20
Linaro LKFT
https://lkft.linaro.org
