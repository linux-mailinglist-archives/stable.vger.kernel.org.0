Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CB133D389
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 13:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhCPMIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 08:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhCPMHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 08:07:46 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F75AC06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 05:07:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id u4so21170187edv.9
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 05:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6HtHHZ++i9Sp4DSeONedSewEzbhA+aKhuSNlC2WbViw=;
        b=bDuA03JYRGlE+RRNJLJAj5ywBlu+X1V9M7Jv59P0PcKMCwwB0r4SD3n2/zVaCH0oD1
         KOVYAvWgNhZKwfvKsEw0ExU4Z6CM8ZsWM7PZtMWoVcE6lNpe+ExV2HRie5uQ/ijksJuS
         MSeg0vj41sDHyhSpjRtRDJWklOBBGAWV77H9D3JZuciZlTeeQ8xwtKhyIxFpWXR5Z1Sq
         poS8AxtpmCGPZT02piGBcweTP6dLw8onKrA1fzqW9Zcaj4yhB6XFTP+TkHcpXHvmxnNw
         Npt/PBSiLjB2npUKGYG1bAWpRkuJ6REATomDxXd5PX7SFG9yH8OM1j+s5B/kERvZzCzG
         cQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6HtHHZ++i9Sp4DSeONedSewEzbhA+aKhuSNlC2WbViw=;
        b=ji1gEp5Nfkuv6J1hI9QdNTshXlLmZPrtwRP7uqAGrPPfyOgsziNAl1eJ15vFkysoc0
         KS0WnbsxfmST/BuBvWzVbwtFxahGcR3WOAgrXqZsI4HnfEcuYwcgccwTMkscoBX5danV
         8wc23gxFUiWXIKo0vPwq8jFA2oqvt9ttxZgHr9OWb0mEQi+1sSTgHwSF+Hd4hl5FUjGN
         LlEk2rWM31Ep9HL3lAl05wUx6WUvpyYGPGWZP5PQd4V2m90FLvcWAyYu7y5nNIjMNA1T
         gAxS5arpbTl1KCIQ3WRIDbdzXkyr+xSnz0DrrZC8WBTSOWCY93gEOEeox9h5n73ZXEML
         YLiQ==
X-Gm-Message-State: AOAM530XyvvIlEdrcPlKJfbiy3cQB5e6I3ZEv3QqTB3OdnhdLqg4Km9B
        EtepVh25pQAqs7UjX7+Wvf3VYW2yTwL155F1/WD8bg==
X-Google-Smtp-Source: ABdhPJwv0IrWpnXPCUNOwZDVQNPKDoEEjcP6SQyZFbL/NgmGTvr/LerWYX1xSO6W9lyuQ8YpmA1DeyetKlWs9oPmsWk=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr36289517edd.78.1615896463093;
 Tue, 16 Mar 2021 05:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135208.252034256@linuxfoundation.org>
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Mar 2021 17:37:31 +0530
Message-ID: <CA+G9fYso_m+8YaWjVaSxwbv4tjdCRHrEcEKz53oySPuuWYYpJw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/75] 4.4.262-rc1 review
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

On Mon, 15 Mar 2021 at 19:23, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.4.262 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Mar 2021 13:51:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.262-rc1.gz
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

kernel: 4.4.262-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 712d2b53fc1193899b028c57bb0fe069936e958e
git describe: v4.4.261-76-g712d2b53fc11
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.261-76-g712d2b53fc11


No regressions (compared to build v4.4.261)

No fixes (compared to build v4.4.261)

Ran 30821 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
- x86-kasan
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
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* kselftest-sync
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* fwts
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.262-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.262-rc1-hikey-20210315-965
git commit: 0571025494b76ef8d857a1bbf7937b881e18ba1e
git describe: 4.4.262-rc1-hikey-20210315-965
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.262-rc1-hikey-20210315-965


No regressions (compared to build 4.4.262-rc1-hikey-20210315-962)


No fixes (compared to build 4.4.262-rc1-hikey-20210315-962)

Ran 1966 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
* kselftest-zram
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
* ltp-fs-tests
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

--=20
Linaro LKFT
https://lkft.linaro.org
