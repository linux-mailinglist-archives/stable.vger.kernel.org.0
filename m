Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780F23D0C18
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 12:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbhGUJIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 05:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhGUJGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 05:06:20 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A12C061762
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:46:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ec55so1632422edb.1
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gzjxDLUqoUvSxoycSb08tnn85oHnjXsEZ6h09GbSgZM=;
        b=wr60v9r8jkrY0U0yx8Np2eOMi1nocQbVhKOSs9D6ppxdukw78Lz68fo1E1e1AiUpHK
         um9nkwZiMeyw1+U0IRBlVX8yN3Vi1wfwpKi2w/mh9F6k0YdrWFDLXDZP51LrCOkaiCSE
         qHX00DS9QCEyCOVX8oGFXRPr+l3EaoYPmnkSuUqlovpHE6uMSnJTfMLndk91SvylZP0F
         ip+et0zPrOSSrRUUwnxf5unXstYXVuh4NrEN+g0KQGU3Mq/JtUfFPBz7DfBWin/9UWoX
         4WRAuZOw4Ewi3kRruLrvpnqSui+pB08piagBj6FqGeqJlKfiOQ2JPCx/TBD/mvQ3i8Uu
         pKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gzjxDLUqoUvSxoycSb08tnn85oHnjXsEZ6h09GbSgZM=;
        b=mqoUCovGkvBd5iM6qkzzOOmgz5suAdu9eRSC1ZautEFe9L8ywborKXUbb5bVi4rH3h
         pkp1gwDmJTJ/PmJzVrb21kX/6wh0BESdldbn54Z9aTnPl1Sd4HWJkKiedXjUR6xRCzkv
         z07sf0+emicJrWAMkkPxasmfWGl529c+Q8mu/oOG1ewW2/7uFBHpb83P7Xq+wIJLM6Sh
         ugKPe1M6j+udXwNKKmHZbSQ0q/+QEYISaQ8CYlf18Cy/VUnvrl8qVtTzOK73vcuKezzD
         dDixfa4pq4fI765wX++Nou/vQCEljJD2okQ+K2bFnuqx6bzfUxla0FreVlKcWyeR1CIE
         Kbeg==
X-Gm-Message-State: AOAM5308sZYAw0h9VBVFfvkrBDlO4EsFuQGSq4jZAYtQutev+ELlkU2k
        6eLYCWgSl/ZMWPBzobQuuGkDNbizlkNr8c6/TGr7iA==
X-Google-Smtp-Source: ABdhPJyDZRlRYY8QXVLGBeaEAiW9B+NCkGGkItXs899WT3Q2IcZlmH4WzRCpkGwZ7DFubYto/sH0NSeQFZjXKLPCSNo=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr46628782edu.221.1626860816059;
 Wed, 21 Jul 2021 02:46:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210719184316.271467313@linuxfoundation.org>
In-Reply-To: <20210719184316.271467313@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 21 Jul 2021 15:16:44 +0530
Message-ID: <CA+G9fYvfqM2Uaa2f0oJTL6X2ZEYeNOQBs-E3pJgspLt8cwyDNw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/314] 4.14.240-rc2 review
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

On Tue, 20 Jul 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.240 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 18:42:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.240-rc2.gz
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

## Build
* kernel: 4.14.240-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 0389571aa4961edf535388163d29a35aa85cf450
* git describe: v4.14.239-315-g0389571aa496
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.239-315-g0389571aa496

## Regressions (compared to v4.14.239-316-g2d310f23f16b)
No regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Fixes (compared to v4.14.239-316-g2d310f23f16b)
* arm64, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig


## Test result summary
 total: 60044, pass: 47693, fail: 560, skip: 10150, xfail: 1641,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
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
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
