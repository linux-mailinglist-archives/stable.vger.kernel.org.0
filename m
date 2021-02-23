Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05F23228A9
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 11:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhBWKM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 05:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbhBWKLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 05:11:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A867C06178A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 02:11:03 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id e13so30447648ejl.8
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 02:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JczxKF/UVhFH+ht01ZpfRi7LHgcA15d/I8GTQFGKlp8=;
        b=C3NwQmXlrncR0De6qbxYwsIQzTQ5k8sthatWiVx/3t67qgzBYFKtRfSox5BL5TWja4
         VUeV+lBugrJFXgD6doR1yemmtdn+8y7XJgg0ChlPo7Mq/Hxv7HxNmLXIyp+8J716hMxX
         n0scFkdj/69m0hWn950W3V+gmtD4sOMZePGNsNVVPAV5uSw/wYHVKtHQbXE6DSNvXytA
         uz7c5oYDQ+ZRwMMbm1cmfhrrJxKZ+KS6uButx/1QRZBPO7cJjIwxx06vzsUNVLy7k26K
         EkgXxo/KH2w5KACSB27AhVCzFu4nLqsKxaeijICxWnOLduW4GyklNg8rcb8AyNXkVtUO
         UscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JczxKF/UVhFH+ht01ZpfRi7LHgcA15d/I8GTQFGKlp8=;
        b=pZhZ0OKhD/zO4gKHze6/YGepdOE3VWtPVeqxWNYTV8RlnrC7ureKkK3AKPfBH/Xzum
         0DhiobpdqNIDyLIZcYAVVTmNGmpy7kAkNU8AwY2Z604cFIijlAEs8Oi4i01OW6w16gPl
         Gz+tZwMrKNar4Gqv1w6JUUZuCzHLN4ktgD19bZyW4L+xCpAFc9EY2gOwtFI5PNy0l4iJ
         oMsaiD8GyfRHlQGP8Y4R9Lmu3CuvspZY1w31pnn0hlcv1gCKVmdDtTrTrocmSFrnnid4
         JP5vPZvGZBbSjUiK5VuCXMRygdTHozVCBMXNkNH4nHMH6njbeYsM7zPxBMU73OxQ6PWU
         HSZg==
X-Gm-Message-State: AOAM5326RGwmivblMNkeekLbF31DQ48qEtrIQ9bi6A9HOQbTwwlD1GDE
        XQQ3p0CIAw8Swc08mtUDU4YidFEwJhNd1bUY1mo82w==
X-Google-Smtp-Source: ABdhPJz8oK13TwhCjrB0QfY/FNlegXcsFcuxacbb9QQFDopfytKNKtQLdq0VRCkx1Wa3LlvL0hdFoQGtMExTka+MlWA=
X-Received: by 2002:a17:906:d155:: with SMTP id br21mr25088477ejb.503.1614075061628;
 Tue, 23 Feb 2021 02:11:01 -0800 (PST)
MIME-Version: 1.0
References: <20210222121019.925481519@linuxfoundation.org>
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Feb 2021 15:40:50 +0530
Message-ID: <CA+G9fYuSWesDE3g2XP7+1tPW8Wv4gYp1-3recQakasg7se0+9Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/50] 4.19.177-rc1 review
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

On Mon, 22 Feb 2021 at 17:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.177 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.177-rc1.gz
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

kernel: 4.19.177-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 413fa3cdbf28627d28d937d9ac27b1d184c24711
git describe: v4.19.176-51-g413fa3cdbf28
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.176-51-g413fa3cdbf28

No regressions (compared to build v4.19.176-37-ga4346d5d945c)

No fixes (compared to build v4.19.176-37-ga4346d5d945c)

Ran 49321 total tests in the following environments and test suites.

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
