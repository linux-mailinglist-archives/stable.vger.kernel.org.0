Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A198315250
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 16:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBIPDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 10:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhBIPDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 10:03:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA89C061788
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 07:03:11 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s26so18357805edt.10
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 07:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hf40SMql2cpJ00lLxJ2Q57iPteMc3eOneN8yQh7cveg=;
        b=FCASHMWZB3dngwfI3RrNgL4gf0qYbXoVxiFqBJ6CTjCPYn9UNV5haUOaKYBYNgQYV0
         R2nmuA7PAJo+XYGBCD1q0Jp0enmLwZlym7uGGGrPTdGtXXyagSwCJT3G2FLMG4QRGUb8
         6RRXYOW5Mov75AisKoIiSrlSrVnA5zsKKImTpkHh7WwrbpS1R/HmW+sgrC9EF8zeNzQo
         lZzu2SgDpAjmOIMQ4n5luq2SVebbmjxTnRfyya5kDVzmvKKcHk7AW0Okq1VLIqXVXtSo
         AexMB9TVMjap5mYRCNctDxJnKpbpvToZRq7ud7aLSYci8vRoPu6vnav1j2P48OykgSHh
         i4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hf40SMql2cpJ00lLxJ2Q57iPteMc3eOneN8yQh7cveg=;
        b=qt0MBHGpM0GjSshksFYa3d6yaYb8VmxhAXXvjfWJrAStbXKZxkHzmnfrv/k3qXeI0N
         casJuWEqzbqMHXXeUrzguIL4DVw6pZhdQ1Q35pBawRF3Wv5j+6B73kqSrE3Yi3xdAIX6
         /R4r6FjdlmDa9+eihQlsbPmvN1H1jPnpIzqH2qBYJqbRUysONnoqMfLuobj5x3fR4GAV
         /ITIWiamcH1Biu7XBwCrI3Aymms7dgA85MXOx1ikMttZmi+5V15eUB9Zr6SJ/RMEht4X
         EqFrRcFJdP8TmXzaU45uiDiB9uHIumpWJZZxIkXhlEJCad6vrO/WakkIJRv1eW6kur2b
         yrcw==
X-Gm-Message-State: AOAM533smJeuK7r/s34VYl8dsjSyIVCltV5KUeXFIqt1skZJSHvx89tI
        uMGiORiVAHbWbTmv6x3YnOQALZ1kbBB/Dals3gL/WECAZucqaNGZ
X-Google-Smtp-Source: ABdhPJx9YhjjkL1LqR/0j459tp1u9dH9jSbjKMS70Ct70fTc13eyh4ZeGDaWBByGYI/VbxNWF0pxwu/XAACmhTC3q80=
X-Received: by 2002:aa7:d3c7:: with SMTP id o7mr23339582edr.23.1612882990358;
 Tue, 09 Feb 2021 07:03:10 -0800 (PST)
MIME-Version: 1.0
References: <20210208145806.141056364@linuxfoundation.org>
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Feb 2021 20:32:57 +0530
Message-ID: <CA+G9fYsvC21HbauGfmSkOksebNzUePBBFS=a=4YqnKSSaGy_4A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/38] 4.19.175-rc1 review
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

On Mon, 8 Feb 2021 at 20:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.175 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.175-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.175-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 69312fa724104d8af5a6124d4f61935bac6a8562
git describe: v4.19.174-39-g69312fa72410
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.174-39-g69312fa72410

No regressions (compared to build v4.19.174)

No fixes (compared to build v4.19.174)

Ran 49968 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kvm-unit-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-bpf
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-cve-tests
* ltp-open-posix-tests
* rcutorture
* ssuite
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
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
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
* kselftest-zram
* kselftest-
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
