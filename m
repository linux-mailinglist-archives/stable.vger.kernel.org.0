Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457D831A192
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 16:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhBLPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 10:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhBLPVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 10:21:34 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFDFC061788
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 07:20:54 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id y26so3469087eju.13
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 07:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=slq6ueUgpPdgBtLvydLK5qzaduqPiP8HW93VCeAsw5c=;
        b=f5iDugPSBWAsaVrx+h8qV+LKoCqAiXPMdfRr02RE3IA0aRAnfDdo75RMuthx1+YaRm
         yu5KnyMSeH5Y5HH2KuxBzLCdQ4e1lj0e+0ZUk2/Q7Q1p4HReaJ+fnUTYb0FLDQhx9wbz
         MqMn/miE7B5DHqJJRaGa47yMhV+p02tOAdSafMfUco8R1KGiZVN1bdTBwftLhw3ptl6D
         65scNan7qCa1mLidzEoRlGpSkJoVSYg9GveteAtXtV0AKLLkpkovQ05AzxJASytzVDwS
         TxhqUPq371T1HXtDQPo5tXUSAo+M5kXSKqGHNVQ4aTcJF2R0vqgM10EalmRzen9cvjEd
         zezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=slq6ueUgpPdgBtLvydLK5qzaduqPiP8HW93VCeAsw5c=;
        b=PCPfE69hFlR69HveeTvaSfFElMOs7Q2PpCeaxX02cCwSEw7WxEs+ysecbQMfLUmIUA
         g3ZIAgPuIkBoseZVo5ESEKlyuTn0ZoeThsYGNGrq88CJtLP4B1bzGCwVK3T5Q73vswrg
         EyoUJ7OU9Ver0b2/0j91pMbNqw3LZDrwlC/XewlQnPQeNmUByLkg7a54Dj52et6zQp+s
         HkmVoa1wEDix1xvI17W7qw4EDgCNgNPe9PfnOFmNWDaXtS8mmD3odCxU8uhozlMk8lfs
         RiDpLbS8LkayecN/Gn5imarwcg0M0uP/AUOiEhiHneyp0/t3cqKATkIIiGSKdHfXyafV
         C2Ww==
X-Gm-Message-State: AOAM532dzm4kN0TIOKYdzslxYR/zNrSAie36Qr7THri2Rp7zVo8qRfES
        7N4Owxse2RfkLjJ9v4K2H9gooIvsloNCjc3JP6tV3w==
X-Google-Smtp-Source: ABdhPJzqeIzjy5N/wAnucZyDDEu9g4rRnyJmRE/sq0XVEi3CQtC4jXxczIgggHgKzE/ucmyEOtZHBDrOMhYK3Lwsj2Y=
X-Received: by 2002:a17:906:7a49:: with SMTP id i9mr3525907ejo.247.1613143251066;
 Fri, 12 Feb 2021 07:20:51 -0800 (PST)
MIME-Version: 1.0
References: <20210211150148.516371325@linuxfoundation.org>
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Feb 2021 20:50:39 +0530
Message-ID: <CA+G9fYtvpqNrkNZDJCjHYUeDHneGz4QZikvm9+k30b-i7wMzjQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/24] 5.4.98-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Feb 2021 at 20:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.98 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.98-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The following lockdep warning was found during the arm64 db410c boot.
And this is easily reproducible.

WARNING: possible recursive locking detected
5.4.98-rc1 #1 Not tainted

kworker/1:1/31 is trying to acquire lock:
ffff00000eb36940 (regulator_ww_class_mutex){+.+.}, at:
create_regulator+0x23c/0x360

This was noticed on Linux next and reported on linux arm msm mailing list.
https://lore.kernel.org/linux-arm-msm/CA+G9fYunK_2h3-pHtZT_+56Xf8b=3DM-8Q9G=
nTsCJ3KxVaJULorA@mail.gmail.com/

Summary
------------------------------------------------------------------------

kernel: 5.4.98-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 539f3bba2f5bb16b852f7d0cf50f8d39d0c4c4e3
git describe: v5.4.97-25-g539f3bba2f5b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.97-25-g539f3bba2f5b

No regressions (compared to build v5.4.97)

No fixes (compared to build v5.4.97)

Ran 51109 total tests in the following environments and test suites.

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
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
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
* kvm-unit-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kexec
* kselftest-kvm
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* rcutorture
* kselftest-
* kselftest-vsyscall-mode-native-
* ssuite
* timesync-off

--=20
Linaro LKFT
https://lkft.linaro.org
