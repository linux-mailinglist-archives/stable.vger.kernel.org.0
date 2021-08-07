Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0716F3E36D3
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhHGSos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 14:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhHGSor (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 14:44:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC71BC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 11:44:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f13so18115357edq.13
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 11:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vH4iHcwS+oyI59VfmhkppLskDj75UUNO7iIn9MYCA/0=;
        b=uJzI/3LhK3KjIYjsQ4SyzX0yFGdmz/xNwOhNOWydJWNjpJv97qje4BzclKQ/G/w+H4
         tKgmBj1cEXLHazJNczu7iDgbwX6Hh4Ch//tD8FclzOAnpFUMDxThpWvQqriIur8T6xeY
         TPeSgssG0zUFokH85rtO/1atRyMjPFQOXYL534FIZN6vhbgn95WujtGJIFRwOpYb9DEG
         5libLhsluQbIbXjWX1lA2NvLkR5g9UPWWUKUWQtXWvpR7xDd9/zNd9C4OTvjD9g356Mv
         npS/fHQFzcgbBoLSBFLmrtLcAoT/BRS0cm3VV26wNOXkOdeAb/adWeGfvfaCHCuo4Tys
         YMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vH4iHcwS+oyI59VfmhkppLskDj75UUNO7iIn9MYCA/0=;
        b=X5iYEU+O1JvXTggvgrNoE0NKKKXK9GGLXYg+HKsHvWK2+/93rsXZSmIxmhKNT12hqO
         GrPpWymIpyRuzbzF9z0otjcWOhysTtRgH27fPTgXdqDBFMeXqXzscal9CqPQtl/GVhi+
         Gtdh+Wpepf7dz+z82JY1m4nfwX7slctctf1lhqwQovd1dm2FxPwQygxWwzfAx8uGiJGE
         1o27LpRUZX1zJXBa1Z72L9XABN9+fZbU53huXzgt+n5ndUIVjjX8CnFUsq9yZ/IZlaIr
         HkJa6/FXdrOO/YlGBaJpuj2Lx9b7wlySHB3oPhFB71CW1s9rTEW6mPleBtTzGb6s3rGU
         DX7A==
X-Gm-Message-State: AOAM5322LgRNFHSYovMAQmQuYhrKpjwrrKEMgWM6LjSr73PI9JSt/NgY
        0OkB7vmB0mbpq+POH/2ruhEY2EXSF7RkTZzti5Gm/g==
X-Google-Smtp-Source: ABdhPJzJQVSwSO2E3RGj6vchMweukRXvtn9bViKDtVzYCJkLS33Bvf3igt3RtZE/MGxll/rtu/upJb3EA3k5c8NRrss=
X-Received: by 2002:aa7:c805:: with SMTP id a5mr19987282edt.23.1628361867210;
 Sat, 07 Aug 2021 11:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210806081111.144943357@linuxfoundation.org>
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 8 Aug 2021 00:14:15 +0530
Message-ID: <CA+G9fYsow5FMRdVHq3CRB6sHCW+FQBtDco8r3At5UnxRsx7UGw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/16] 4.19.202-rc1 review
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

On Fri, 6 Aug 2021 at 13:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.202 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.202-rc1.gz
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

## Build
* kernel: 4.19.202-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 9c68cf432f4cb6091ecc834b0e3a729892247335
* git describe: v4.19.201-17-g9c68cf432f4c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.201-17-g9c68cf432f4c

## No regressions (compared to v4.19.201)

## No fixes (compared to v4.19.201)

## Test result summary
total: 76501, pass: 59304, fail: 1758, skip: 13148, xfail: 2291

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
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
