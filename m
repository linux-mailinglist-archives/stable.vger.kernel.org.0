Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD35336DF0
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhCKIjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhCKIjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 03:39:13 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0D8C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 00:39:12 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id bx7so1485301edb.12
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 00:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TGOFJXs5ttYJbh2qbl9PCocPOfFdqA3yKC8zVQhcGxU=;
        b=prDMXNaydyrGw8bqd0fvNq25wElCMZTN7GsDi7kDU2BVApKNCxSnyHTvgCm8/RwG/l
         tEQLsVa+RtKDdzdWP3njllCJzVqD+zT5N/wG4/NJRBa0xoXdPc44fTH0If4xcREJG5LD
         mrLk8J3mzcjC6WngrrEg3t1g3k28PYLcJPs5JSVO5VZVm36OaX7BsjuCdoWefdk03rfB
         FaWfekOWxlLMy6nKDPW8o2loc5jaDoFanDSIEj4eoHHl3ixgIVqpcLZukTX/XYxY+PYY
         5GOGUNf6GUyXJkuTnvagu8pP6PQnF9XacHHJ1MpVEkHp+RBo9sYisqGv3tzGjxcJBz2p
         BvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TGOFJXs5ttYJbh2qbl9PCocPOfFdqA3yKC8zVQhcGxU=;
        b=q5Jfoz+RrDcpSC0HVSC1Ogk+B6mDSdSmQuK13zXkGOW4rycLFDwOiZr2woXwqN8+au
         gcfwyFhaNvc24HNCuRF3vl3amH0g7kq+cNfcOSHrap2sRBs9ZNTC2FLkVh14JcYSD2Z6
         edrY+WdeIVtmtxEZNJkMd5FaP3rjeI9dLcq2t5tOL5g5fR+I1uTQHHjaVUeRpf3vGs69
         kWQPtC5C8zc7xsVJU7lOjoS/vWepIei9uLvar6TlFux4jUl6UtmildXP8XgiwsMg9FQV
         3B2RJspHtidDxKmj6I1qnt5F4SA6cn8Ql3ZpB2c8WHCCsz/phTDYXqHWHP8UN0L8gCzP
         D1Nw==
X-Gm-Message-State: AOAM533/Za8b6GrpKDXqGVIbWb4tqd7YD1ZTckoK3GgiPKfl7ThXmJ2W
        l4vQMXZ4IrBw1/uIz8XawwbBsDYksmK7LMTGy2oCWQ==
X-Google-Smtp-Source: ABdhPJymSPeN6UBqT56voe0FfMH/udSk1NzayynpcFenxBzNk6KoQFzmihDVfixKRf24QN40x8s9/MbWQrbxyXxxX4o=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr7449847edx.365.1615451951256;
 Thu, 11 Mar 2021 00:39:11 -0800 (PST)
MIME-Version: 1.0
References: <20210310132319.155338551@linuxfoundation.org>
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 14:08:58 +0530
Message-ID: <CA+G9fYtoYbSLWW10qXFrv1k7qzwuo+SttUm=Cng-7UpoQbB0zQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 0/7] 4.4.261-rc1 review
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

On Wed, 10 Mar 2021 at 18:57, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.4.261 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.261-rc1.gz
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

kernel: 4.4.261-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 9de32cd2fc5194157c9c116eec56a219048dc511
git describe: v4.4.260-8-g9de32cd2fc51
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.260-8-g9de32cd2fc51

No regressions (compared to build v4.4.260)

No fixes (compared to build v4.4.260)


Ran 26428 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-cap_bounds-tests
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
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
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
* kvm-unit-tests
* ltp-open-posix-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-kvm
* kselftest-vm
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.261-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.261-rc1-hikey-20210310-953
git commit: bf1bdacd039d70403f1ce3196f223cae689ca15f
git describe: 4.4.261-rc1-hikey-20210310-953
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.261-rc1-hikey-20210310-953

No regressions (compared to build 4.4.261-rc1-hikey-20210308-951)


No fixes (compared to build 4.4.261-rc1-hikey-20210308-951)

Ran 1965 total tests in the following environments and test suites.

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
