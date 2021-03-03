Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54E132C822
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348036AbhCDAe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhCCQJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 11:09:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B9C06175F
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 08:08:47 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id c10so16742220ejx.9
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QXzwi7K89SM65l2xmgOkE5chltGcXBKL1/8sSWy7BjA=;
        b=zwtYDbfXS5Zh4lhYqnAozwwS25vDd0/GaaKVk5ENt+5QRlSeC/0UffsXOi8aUevNpe
         0lMzsmahYip2OjkDVEUtvWWCU2K4IuSvgDAI7NyZQIeRNPTFgng3nK0WaFC6/r7Zo5ia
         9s2WUSRFLC/pMfHgu3CqozLlTuUqRxvgWa3WBn8lUESA9KfEDVNLSM59ZrBSQDCdThhA
         FTs8dtH5W82Q5P1KnwXjoc8Y9HofyLl/sEsvV9gbWASPpv9bgP5sueehKpp2nf/m1qVT
         338NguDIThvnvSI34B3sD4SeO7y5Vbi3xuqzTFE8fXSzVd4rOTu2ipzfqDzjzDRxb3A6
         t9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QXzwi7K89SM65l2xmgOkE5chltGcXBKL1/8sSWy7BjA=;
        b=SkkgzWVdqNtIDW7C4OGWUacCjexV1tJCRFYwz39wD67hcLRgbd+jx/WPdF4uaAFk5u
         HsoA8LyltpHx6/UrX+/mS1nK5Gi59mAm9yL4Xy++3PuoS7OnYxFwABQzeHRwm5lfLhSd
         Nanp3oaIn/BESOJAVQHcd3Tg3Z1Q9K3R0I5QzkGls1xP+QdSwgIiEBZKPyA9NNIyiOCA
         MR16mhZz9pzxeky71LnvaqTY7JQgj0egNOGo38xW1aj8QfZAbdLxOD9qnDei6onK6cUY
         yENxpPI4cNAEtfjsTsV7flC9T0ZWVpxtq9PJTuEAyu8PeAJIljVoIVOrbKCu3D6PVctx
         v4PQ==
X-Gm-Message-State: AOAM533iFhPkB2y7ykLrC6H6g3+kM3z4jlVz0YhPYwr4/gAppLC3xD3f
        3d9xsVHXpMwKJUXM6y4sVwcSyB9bUr+UQ+pR+mBLgw==
X-Google-Smtp-Source: ABdhPJxDYmONyMmSsWX01gOQMI8Lxt9u62CZnPjPjHJ5Ep/EoYeh2LIVFljf/qYH9Iv98cYABdAvzpe2NvUxiA3MwJQ=
X-Received: by 2002:a17:906:b2c3:: with SMTP id cf3mr25558356ejb.133.1614787726489;
 Wed, 03 Mar 2021 08:08:46 -0800 (PST)
MIME-Version: 1.0
References: <20210302192525.276142994@linuxfoundation.org>
In-Reply-To: <20210302192525.276142994@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Mar 2021 21:38:33 +0530
Message-ID: <CA+G9fYuNBYTjTQuEDk7KEoTHQt6hwnoAavCP6=XC8GvEnme3Zg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/92] 4.4.259-rc2 review
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
> This is the start of the stable review cycle for the 4.4.259 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.259-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.259-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: a8379a8a874e8a88249eb6f87a66d886cb72259f
git describe: v4.4.258-93-ga8379a8a874e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.258-93-ga8379a8a874e

No regressions (compared to build v4.4.258)


No fixes (compared to build v4.4.258)


Ran 27052 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* network-basic-tests
* perf
* kvm-unit-tests
* libhugetlbfs
* ltp-controllers-tests
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
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* install-android-platform-tools-r2600
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.259-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git tag: 4.4.259-rc2-hikey-20210302-945
git commit: 425e0998cf27fbb998d5d1e6692f592dd9ff6a14
git describe: 4.4.259-rc2-hikey-20210302-945
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.259-rc2-hikey-20210302-945


No regressions (compared to build 4.4.259-rc1-hikey-20210228-942)


No fixes (compared to build 4.4.259-rc1-hikey-20210228-942)


Ran 1951 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
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
* kselftest-vm
* kselftest-x86
* kselftest-zram

--=20
Linaro LKFT
https://lkft.linaro.org
