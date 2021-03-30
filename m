Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC6C34E0BF
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 07:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhC3Fk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 01:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC3Fjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 01:39:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E8EC061764
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 22:39:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kt15so22863786ejb.12
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 22:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hroys88JGmvJUmHfPEHvZaUwXpyKigO3zNzUlmaHVHE=;
        b=NyWQMP6hKkunnWRE2FJVzrsTdwg48BIBoawJW/N8ukzhzS28uP+rDSLYXVoZ6lZXmi
         0v5FiztxpD6k82dGzI8BvJqRCwhYhN7Q5MV/P1Z6tkmTLPhzvWQ0YgGyVeqYOSlBYlHr
         V4nmC3VO3G67CAxPFtX810MI04lLFC4GsBMdKqRdE6YVeIxTQbijujvMGg3E9nt4dx+3
         SnZvEkC/GEh2KVw1sp8eBrm1e+MEgNAwriOQq5l1FDl4B9KcMQi0G0xfh4j+CyXNlOL3
         GJOr3Jx5Owg5pxJ+gMLmZLfng4FPwyMlQiMrWA6ELITm4z0acnWzYQRagqP75wsOSk4K
         Z2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hroys88JGmvJUmHfPEHvZaUwXpyKigO3zNzUlmaHVHE=;
        b=Lh7n5lqb0VLkknpETXXXDQHNCwTb3kGKRpyswcyGylwpF/dQWuuJJnKDG82YrT22aj
         h7FZTpJWnglf/La7fi57HzjQBAky+fkMCH+a8abHCNqMcDhaT2wqf4Ttxjkwn/eFH/R6
         5FtTICsHwjy1QnIvMqqUgosrJ6qBuVEJaYCEB9f0pXCSOdrTmBOGFvtuxnQQmBs4bGjl
         vUXqiSiwZBk6rLy/Ik6cEZFESfOx0NNUkQKJWldxtio+T6olzJYCdSZClVc8xosnK9aa
         vPkRwDGvVga623YMFivR40ZIVoVRCD5AX3odRezPayVYwQcW/NIM2dLzzLH61OFeBpfi
         cpdw==
X-Gm-Message-State: AOAM530E8gbyhd0tlvseL13AJLP71ScnbIgXvN9hjPWscwnobhJkBnlG
        IWYclqAYY9AtirWzlqFYTLuIjeHV5CTpCGKGyhnKLg==
X-Google-Smtp-Source: ABdhPJyApvgtDhTuNQElD901+lXBwc/we44N+u96SPdNhRTaer6eLhNIS32SIcE4+xeMxYw9imrNFcNk2GyvFHQAUQk=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr30812724ejc.133.1617082793715;
 Mon, 29 Mar 2021 22:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210329101340.196712908@linuxfoundation.org>
In-Reply-To: <20210329101340.196712908@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Mar 2021 11:09:42 +0530
Message-ID: <CA+G9fYsdPaSRwuXGowmXxbWybrupH9ny4geTKGBzAttN_a+Tdg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/219] 5.10.27-rc2 review
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

On Mon, 29 Mar 2021 at 15:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.27 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 10:13:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.27-rc2.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.10.27-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 8c8bcec351223764ccc3ab7551540172989b5194
git describe: v5.10.26-220-g8c8bcec35122
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.26-220-g8c8bcec35122

No regressions (compared to build v5.10.26)

No fixes (compared to build v5.10.26)


Ran 65388 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kvm-unit-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* perf
* kselftest-
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
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
* kselftest-tc-testing
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-dio-tests
* ltp-open-posix-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
