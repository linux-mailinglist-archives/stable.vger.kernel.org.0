Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F25446BDD4
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhLGOjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhLGOje (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 09:39:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31011C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 06:36:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o20so57819989eds.10
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 06:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XdR083vlxGfR2DxbW2vfHYekMcObry/69dcNA44yDFc=;
        b=ifG0H7bOPdop+xatYzESVgBWbJSaxC+ihYWZ5WW8yNP9CD80m7Bb7zqSTWXsDYsrs0
         2y48z2XCRCnGrVC920UKvQVHD4y4xBfvLCVvoTpyLfyboL5bt+HqOnsgca12nu2q65vm
         vA1hyRJULPMAu+T64vmzaesQQx4ttimdJdil5ONPrizuInKT9kwhw+5Ih2OmmlZavSue
         t8jWkAcCNwTWHZCvqlQwrmyWcroAD+icbh5lZohjKX0BP6Aqb2pzUkL24n98ON1VC8vk
         ddOu7fuvfpcdYZV0a/lk2N0bVObpkHIfY0UhmVTMUbxT8ZtGj4aF9ZiiuMgTsJBeKlcF
         OBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XdR083vlxGfR2DxbW2vfHYekMcObry/69dcNA44yDFc=;
        b=pGrcRiZvkyt4mv5S+YoDrINwyZAjsQIA1cjtvkG56KGnmkmfP+r91l4+lWQMtp6eWb
         tCQxIdRUwIHtYF+6AlR6D90Pav75cVhcqUub5lmaZGsiNFp4ru9wFe5dwr7q4rgD4gUk
         +PppuKJIDjLpiZhcFcNUFZTY2hW0nWpp+Xh+odIyrSdSF/y0LpsU3660ZY6jU+Sdj0hv
         SX+YHBR46+INIW+THO2LPVDoxV9WoT73yuzXcbJZSECUXInFVdWv3Fa5G7/D35r8xDpL
         Q7RUzgOwMpwJr/A9nk0SYXttbzXODXyv6p39BFKvAb2Pz0Xbytxe/jTVW9qsLjSCXn66
         H5Sw==
X-Gm-Message-State: AOAM5316rjTH4KGQSjtgFgDny+tMsP4CyNAJ60OcdmF9yKbaIT+6xF8o
        SbmTVMUxlqQghhRr8+WqTZofDzRIwlJUwvsQWzfBS+RxmuTkRw==
X-Google-Smtp-Source: ABdhPJxRuiYyyiUlORnM6uZ4axlURoSqWuiWmAXv3sEAclXVDH1Uagv6o1M6XSXrKQzVzuadIZ9i+nOrOCKoyZU4Nas=
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr54309258ejc.493.1638887762262;
 Tue, 07 Dec 2021 06:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20211207081114.760201765@linuxfoundation.org>
In-Reply-To: <20211207081114.760201765@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Dec 2021 20:05:50 +0530
Message-ID: <CA+G9fYv5GG9aY=hxjNzp-FPEnnV-YDo6rz+ErQsit_QKV4Fovg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/125] 5.10.84-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Dec 2021 at 13:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.84-rc2.gz
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

## Build
* kernel: 5.10.84-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 05722611cd6fddc7f5ed4610f0ac2cca13745edc
* git describe: v5.10.83-126-g05722611cd6f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.83-126-g05722611cd6f

## No Test Regressions (compared to v5.10.83-131-g7dfedcfa0e17)

## No Test Fixes (compared to v5.10.83-131-g7dfedcfa0e17)

## Test result summary
total: 95714, pass: 82034, fail: 550, skip: 12354, xfail: 776

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 260 total, 260 passed, 0 failed
* arm64: 42 total, 42 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 39 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 58 total, 48 passed, 10 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 22 total, 20 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* kunit
* kvm-unit-tests
* libgpiod
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
