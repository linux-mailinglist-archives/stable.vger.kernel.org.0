Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37414344F89
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhCVTBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 15:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbhCVTBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 15:01:03 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4425CC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 12:01:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ce10so23047084ejb.6
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 12:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EgzBGxEy0DIFa0CcEUK6NEKja39j0w1/XI4Nrd9WRT4=;
        b=NqE1fCTLKKRZEZc/bNdnFRm+Pt11QwEax2feflGrBEqi8nVetDFXRr16+beCaw/KIx
         NQni1q1IGD1ZwKSN5cEd9S/JU2UqnaUQpk+/iBUhGhRUcdNXPSvLqkVmfvCqQAjPNY/J
         QxGlVGLM+wtEDa8vwjCpS73u3AO6NmpPY9HD0w4S7T6NJg5XvkNfPtXCE39gn53MhMFw
         XjHV4AqV4ki83JxNgn4dA/MVEdM2Z+lqVlDj9YpMeh1g0Hf+GqqbgFW/Gz4cQf+QZIMY
         1252usAs4z51rxtbhUgKAJJ7I8W2TYib9QH7PKUkzfPmei6hnmnRV76cInS13nBnyTgL
         1LqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EgzBGxEy0DIFa0CcEUK6NEKja39j0w1/XI4Nrd9WRT4=;
        b=UTZD/NPVOLpxuX8HB3d8TPYVHtfKxaLR8atkhetfmwrKdcODLfAqMoSFQxqtGjE5ro
         F/U2Y3fxy8uIRlRR4qWbo/BsQ5Shj9m7klYT5y4gXCGwCIw4XrccSutkkRSOb/mSbmHE
         MPB3uwoDXcWdK5Pb2BQt2TPs8YiUEBfwPbPvV5AfqB0pblt+wwPzJDAY10ffuTFfDoyv
         7tQYC84jkQ4myH/yjP6jgyzjQprVoNX84JzOriWd8Tm0y2s4kyhSzNWOoS6yw8Z09Esy
         lBGUlVAeh14r2TAvqavIYTSulkjnY3r8q3a09/DeEpcw3D6qrLTTyVuaCydl6apb8W5A
         Grjw==
X-Gm-Message-State: AOAM531gf7YXL6Cc2wnrjvGwaT1Vua8PX9bttqnrj1+Kh6sQaDSel8po
        Ku6T/997+484+Xwpe4pw84JwTW0Sv3OCUB45DRiz2g==
X-Google-Smtp-Source: ABdhPJy09k43Wxiy1w0EXf9IM4aFUGLp23DQXknwtRT2qw1/YmniweDpWaO4fIRR0Zyef/Hyn0sllQvuzxEz9SJBF74=
X-Received: by 2002:a17:906:2a16:: with SMTP id j22mr1218375eje.247.1616439660844;
 Mon, 22 Mar 2021 12:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121929.669628946@linuxfoundation.org>
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Mar 2021 00:30:49 +0530
Message-ID: <CA+G9fYtKsQfO1QnH-KZ7MU4VQeRegMJo7_=qC5Df-LXeSxR9JQ@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/120] 5.11.9-rc1 review
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

On Mon, 22 Mar 2021 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.9 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.9-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.11.9-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 3f03c425f75c4a6828beda5de7774ce0b75d55f2
git describe: v5.11.8-121-g3f03c425f75c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.8-121-g3f03c425f75c

No regressions (compared to build v5.11.8)


No fixes (compared to build v5.11.8)


Ran 65573 total tests in the following environments and test suites.

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
* kselftest-
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kexec
* kselftest-kvm
* kselftest-vm
* kselftest-x86
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kselftest-lkdtm
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* fwts
* rcutorture
* kunit
* igt-gpu-tools
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
