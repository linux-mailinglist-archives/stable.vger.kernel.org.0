Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9D830D1F1
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 04:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhBCDGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 22:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbhBCDGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 22:06:05 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36D6C06178C
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 19:05:27 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id rv9so33228612ejb.13
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 19:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bTXKeC/FJjwVsNQpdbqIvZbsTcSxubzadb/mfFc5/ZA=;
        b=Dt84TITp4FNe9hBic5NhBTLIiPWAHxrQXFZZvvv/nh1GVdWyX+rKqSdQJobSrmTUgh
         657UNyItTcm6EUYlXO8P1kdAv0u+M3qX+46pvMjrvBX3mywkF/dvQRJC880eW7On5ib+
         8DebcnqCW4rANSE2v6cDuref2QS7ZtJOke80emEYruHAV2nIo8/ZQpQK4wSYwIRBsKv4
         XvAIN2ucny2arjKomv0m8gJhqw6seTnWApOKKtvjc7koT9MUA4lb/2osB0fTVi5TyFZe
         ztaacw5I3Z22tJWtQ625GTfbNq8RdjxilLdkR0IxGH+XSFcwfhHCOtI6zcPWhlJ93mBw
         mx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bTXKeC/FJjwVsNQpdbqIvZbsTcSxubzadb/mfFc5/ZA=;
        b=jMCazNp0gahRqEyN5SAfwdGDYiOZ+VSG9CqHwU6ULhnky4qCILVFUzvV+XVwaCmiCL
         apEIxrEpWSbLEqbTrCycbaIAxBz84M29/wNuRtJJRjZ6XIZiEbF7oI0sd4sioOV2zgwZ
         9vXSd3wOfwznHUNQgUR/oeKQDeGYHbMnw4Pbu22nvmy2YeQP9DSveMVkzMdUK3DO9B4w
         PGzRDCmpYypcd85/d6bNNdfwQ367jRXqhGYDeXKCwMXRmSLKaE7CfajheOZBBlXHH/XI
         rUuY0tlZyvF6uV9Y3TwzWvsKdoHmwZWhAvy+ZpRZ5bZwtnlqAWlERWkxFhQmE+vj0xze
         znTQ==
X-Gm-Message-State: AOAM532HALeCwlxCLZKXjwkbRE8nKR1VtCMlhDXx7IIx80WUDZPRUIWd
        fLu+YTJDgJC5syh7oPA2m/7ClCA9XP04gPMLstF2vA==
X-Google-Smtp-Source: ABdhPJzGwGCAgwPrGFzBCbIyUmp9xOTDU1fgz8pagXGTYxaD7BDdCjJaE2euD0C1B5X/QIl8vKqrIhE3T+zXPJDDVno=
X-Received: by 2002:a17:906:a153:: with SMTP id bu19mr1068491ejb.287.1612321526571;
 Tue, 02 Feb 2021 19:05:26 -0800 (PST)
MIME-Version: 1.0
References: <20210202132957.692094111@linuxfoundation.org>
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Feb 2021 08:35:15 +0530
Message-ID: <CA+G9fYt2uhMnUT-PjHXs=5FQdTLycBoZb1znu3zpN-kvY+cKKA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
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

On Tue, 2 Feb 2021 at 19:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.13 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------

kernel: 5.10.13-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: b34e59747fbb2a46f329a8562d3fd5ec6e24b2a1
git describe: v5.10.12-143-gb34e59747fbb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.12-143-gb34e59747fbb

No regressions (compared to build v5.10.12)

No fixes (compared to build v5.10.12)


Ran 52801 total tests in the following environments and test suites.

Environments
-------------
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
------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kvm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-tc-testing
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-sched-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* ltp-commands-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* kselftest-kexec
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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* libhugetlbfs
* ltp-containers-tests
* ltp-controllers-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* perf
* kvm-unit-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

-
Linaro LKFT
https://lkft.linaro.org
