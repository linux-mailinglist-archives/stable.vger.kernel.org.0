Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B9D336DD7
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhCKIbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhCKIa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 03:30:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA7FC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 00:30:59 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i61so1442553edd.7
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 00:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NBSPLtUn2dyF0yPANjmhingDcHQoPHZlxpbtzfl/OHQ=;
        b=Su8QgkGF4OChLXB8mHx8QBQ72TwgAEAT/BregRE5v38WlY87JDijmoq+L/6jPcKvBo
         Lhj8bSS6CsdkoJ0O2JcUEn/ucOB+BEFtgx49FIEXzbSxmFk+mfRNQUWBrM6hN2JTj2hs
         zznpF2E8tSTiBaVJm2qsGA7+S4JHr098mBbNGhGwvODoaKQ1IpQ+dWBoqpHcfwQ3ktoy
         YNdsmgcmxdXIknjxSxZYRPBD66+G0bWuM+Va4zI6jT7f1NutyNLe+kcU09zpTwqFghnJ
         k0/h+A0UDoO4fhYIfwIfqjIYx0xm/hISi2b0LlPAf/4RmiSThOXuV8l4zMAu5vXsmAsT
         IyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NBSPLtUn2dyF0yPANjmhingDcHQoPHZlxpbtzfl/OHQ=;
        b=JmhY3j/brBCloPklC55x18iDgDz7JIA0JL2t0m024Yty/hW7L5tomTOokUBx5itnss
         fBb9onCvwOv6v9kI0krrJ2iav0cHaofABHZ90EoGwnMfx/ragT8JMXYxXZX2qcL2045K
         SRUdbfchPfAluCvQI4jKajIYITwATJpMdfs1gMynTqrbAi964rFTvYJYXGgyN0iGanoJ
         fQHTk3O+VW55oA8klmonkaTiYI6JXypJmx2y6WwIuo8e8/xaygPJrY1YWiBrz3mdUc03
         Gq3axm8stYyeiHsMhM6uUDgEk+jqzS77gQ2vyi5/FahQSMIiabBa26fkCdz+3musOWAE
         oFrA==
X-Gm-Message-State: AOAM5307NQZbcSZikKiapfDcFIU6541kknGW5n+ihl5WGTO18md/wRSB
        kGPuvFvKbf7kWM8Qxnr6JUCViRjUKs758BnhEAcF2g==
X-Google-Smtp-Source: ABdhPJyWL3On2xd1gMOWCTPAgc4EiVm1wt1A1LbH8eeYJCXUxHhMWshh7rWXy27Wrpsg/C/JcHbqAycQ4tEuPXe+m74=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr7506432edd.78.1615451457609;
 Thu, 11 Mar 2021 00:30:57 -0800 (PST)
MIME-Version: 1.0
References: <20210310132320.512307035@linuxfoundation.org>
In-Reply-To: <20210310132320.512307035@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 14:00:46 +0530
Message-ID: <CA+G9fYsGu0NVJK59cJuECo1meKWn=+RWGCsEGvUGwd-5APqUOw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/20] 4.14.225-rc1 review
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

On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.14.225 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.225-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.225-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 878d7bf8fdf6e16616c200ff20d091126f795542
git describe: v4.14.224-21-g878d7bf8fdf6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.224-21-g878d7bf8fdf6

No regressions (compared to build v4.14.224)

No fixes (compared to build v4.14.224)

Ran 42230 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* install-android-platform-tools-r2600
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-lkdtm
* kselftest-membarrier
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
* ltp-commands-tests
* ltp-controllers-tests
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
* v4l2-compliance
* fwts
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kexec
* kselftest-livepatch
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-ptrace
* kselftest-tc-testing
* kselftest-vm
* kselftest-x86
* ltp-containers-tests
* ltp-open-posix-tests
* kselftest-cpu-hotplug
* kvm-unit-tests
* rcutorture

--=20
Linaro LKFT
https://lkft.linaro.org
