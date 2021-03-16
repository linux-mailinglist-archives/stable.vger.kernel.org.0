Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED233CD0D
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 06:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhCPFUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 01:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbhCPFUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 01:20:18 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45CDC06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:20:17 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id r17so70025877ejy.13
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 22:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v+vZVoEe73TrJcbOUS3PUc4e2EaY9LkOhiFvpJeSw+A=;
        b=Uc5SyMzQUCimtVDhO44u6Fk4X8Lrqv4NEk35HlLWrV+luvN+0PxgILOzrZIj2EBxyw
         kkpvaIN/X49d5JK0JeHt9+yEFoZYFFtDWGxx+KOp//Q7CT9pJoCXtDOLZow2QmF58WtP
         4ztgkQeCOu/M0+D/fraSmqdqqInrDnaEhOHJ1PFnxh6NFaT+NsJpeJopQIz/CLOg/N0s
         x3zLVJn6k7IU/1xIAUoyURCvTmrh1yEwtp1jXs553UZu0+WmfMDQX+c+MA113x2JrVnH
         G8JK09T28QtUjQaQDS6itsQzQkEm1Vy2cv2jM1SW7eIO3ZQwhFqz3quB4KftQVK5KAK3
         DJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v+vZVoEe73TrJcbOUS3PUc4e2EaY9LkOhiFvpJeSw+A=;
        b=hzKXmFmjnU2EaoXOYA3W2YA/WvRKJ7C2X1qCVJ9D7DVQ+IsOHOicIScCP5gFoDxDz2
         sR3v9dUkh876EXwuOrrszL57fw9fWFlvvUW6GcVCJU7isL+X0Pl+voxjzah7J53oDfi7
         Zg/6qLbxbOPsuyEfu3hzY5WKDkNGVXKG5O31L6p7qedEdZ/QivZOlERRw+bvdLtbdU5x
         vgOnvivHDhtfWWlY9vcOHI91T0WswSUgpbXVJHcTlkWt3XD/T0ZoDfIbXo9mf8+airnr
         n40MsRRtWU+6IrX41cBa4l1OQr+Nm62bRH+XMxUM1K4b6MZfBjDi1hJGFWqYXnUszmR8
         17xA==
X-Gm-Message-State: AOAM532yHHluiWkLi4l/TyWngFSTc6hH/Nu6pDDB5sOjCfnjUYIUxrzj
        o8vSem4mD6SpWAalDNr/+jdMX8uPCu5zlvASkyU5+A==
X-Google-Smtp-Source: ABdhPJy2+LV6iVPlGq4kvhbHckySY6NkPu61DH0IgOBhX7BAdNMGNJOC001vaKg9WngylemOzkMk7ApRBc7rzURjea8=
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr27864565ejb.18.1615872016538;
 Mon, 15 Mar 2021 22:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135541.921894249@linuxfoundation.org>
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Mar 2021 10:50:04 +0530
Message-ID: <CA+G9fYswBGH-wTJ30TNxS9Ue6=Htpcr4QGgnA4JV4-Rwc-9F1Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
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

On Mon, 15 Mar 2021 at 19:27, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.10.24 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.24-rc1.gz
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

kernel: 5.10.24-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: c6b3724e56923191dc567ceb626ba15daa49313c
git describe: v5.10.23-291-gc6b3724e5692
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.23-291-gc6b3724e5692

No regressions (compared to build v5.10.23)

No fixes (compared to build v5.10.23)

Ran 58761 total tests in the following environments and test suites.

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
* kselftest-lkdtm
* ltp-containers-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* fwts
* kselftest-
* kselftest-bpf
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
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
* ltp-open-posix-tests
* kselftest-cpufreq
* kvm-unit-tests
* kunit
* rcutorture
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
