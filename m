Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8419B336C75
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 07:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhCKGu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 01:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCKGuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 01:50:14 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A63C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 22:50:13 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id p8so43860395ejb.10
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 22:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ptIec5/l5SJwE7zBjHGtTGVSGpXx725GHbS1ui0XQQg=;
        b=RNbhLnDslwV1ZAmXU6qw951y1ouK1GsjKcKS/AC4LnmMQfukacYrNpv7+yzSy3PM/8
         yEON5p/EwJ47U/JjaojqfZajlNfmoufc4ZyQo28U9uBh+YyGVHA7wrcnKEkOM9f05ZRP
         K0z9q06lIVknGwyCOCie/6WvGTwZAy34ZjL2THQYFAMC8PuZKDQD9Ftq3CnZ0gTgYrl/
         8n5MJ3NoGk0Gz/aTosOQn7pHe4t3HzAT+79wY5GAu9PhJ/SDj3RvdymY7ryzcyCkdWsp
         hV0k83Pm9PMYqnDOq/i8vtglu5Wjj73CSZzTYnvHocwdawptNfe4f5vEcX5o5GpnucZa
         kGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ptIec5/l5SJwE7zBjHGtTGVSGpXx725GHbS1ui0XQQg=;
        b=Qkz3HOkFCYiuwNxWzTtuBcDC8MKIjmFKg7rD/Wgq2o/eg/pwxOOHNgXzGOIASRCT/V
         R2bghWLweR5ECSbPCDo+41K4zcQyK7ZOXZnzhxGneBTKbkaKcW6h47y8vUT9Bw+l9GkQ
         sRrYQEvccci4dmPTpO0hgpPmum1HUJBM2Gye5vLtzcF0Z8BVG4BUWUs+amuZRzeYHh/t
         Nw7FXBuK7DjRsE0obt5vx1nu7I0jOZ6u6ZSybZ45bUiL94oHF9me2cjpzWjDvyZrj9Xl
         67tk9FrOl39OQk8+JCwqOU1lH6jzh+Daofcu1bUi1VazBeO6hRmpvfgKf+ZTy/fjLLom
         IWwg==
X-Gm-Message-State: AOAM533iI5Qa3CrjqAsEzF2lODRhWqUgm6//uxqKxGdibfOcuj+0McdS
        eESyg4LyjaMfSwY/7lVnIn+Sxnh1vfqJk6fqSqXYAQ==
X-Google-Smtp-Source: ABdhPJyszQ4KDwubpi0ogfG8RcflSl3DvQgx74jQEdqhNOhFicG4X86jAIg4rh886sWeArU+nVHdy6GuDXOjawOqMJY=
X-Received: by 2002:a17:906:b2c3:: with SMTP id cf3mr1539444ejb.133.1615445412274;
 Wed, 10 Mar 2021 22:50:12 -0800 (PST)
MIME-Version: 1.0
References: <20210310182834.696191666@linuxfoundation.org>
In-Reply-To: <20210310182834.696191666@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 12:20:01 +0530
Message-ID: <CA+G9fYuVoNR9SN+1gY9TrsxPdpyJ=x0yNyBwKOsj1q-m0uoRDg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
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

On Wed, 10 Mar 2021 at 23:59, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.23-rc2.gz
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

kernel: 5.10.23-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 93276f11b3afe08c3f213a3648483b1a8789673b
git describe: v5.10.22-48-g93276f11b3af
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.22-48-g93276f11b3af

No regressions (compared to build v5.10.22)


No fixes (compared to build v5.10.22)


Ran 56156 total tests in the following environments and test suites.

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
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
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
* kselftest-livepatch
* kselftest-ptrace
* libhugetlbfs
* ltp-containers-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* fwts
* kselftest-kvm
* kselftest-lib
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-io-tests
* ltp-math-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* kselftest-
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kexec
* kselftest-lkdtm
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* rcutorture
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
