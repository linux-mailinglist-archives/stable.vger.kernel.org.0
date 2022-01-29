Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD3A4A2D5E
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 10:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiA2JZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 04:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbiA2JZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 04:25:01 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C16DC06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:25:01 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id j2so12254168ybu.0
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HWHYXLII0byMrBeerylNijL1LbJPU23zk0bTGbpZSZw=;
        b=UUhLUCTGd9HfSLx0F3jmtZtSN5Gbh7g83ZZFQge0TxuO4VPWXCCuf9sj6VC59/ycGY
         McVivBeNSOvIT+WBA6PWOwXRcah8VwXhSsWsMeNmE12CxIxIX/2UtR58Q9qBgG3+AHqr
         dFym53Z/KNHw7NUh4TV9RZV3mlZ/rNdXGK2gUsFST6siKWQTKgnlJm3D9dinXL1dhUMP
         tnKsN9KsFPnjEnjHAPea/uA6kZUmbxqZ9vYQ7xxISA2OiyKs7hn0RO4JKQihkfHVHYkH
         31j+5ICkbEirIsryJ6kgg0NUfpKZ1o64M4CRINK2LExjkntYVZPraklb67wc0QPIfjMP
         gNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HWHYXLII0byMrBeerylNijL1LbJPU23zk0bTGbpZSZw=;
        b=A4nSb9NDyVeV6fSnVSea1z0/Nh3E+TTKmaOxkGkqJ4PnhHYeFqltg8pdocxcIihdOj
         rj+gKOcjP4p+3Aa8CH6Ru2p8qUX4ARiHL8n1jNFPjPxMuJsDs9XNTyD6C/NrWToOBy+a
         t0f/xi1fKedPBGggDhgESwyUQ4VG9UrxUPUUkQoU3iAXc47xYlpEWgCGGDBgw8g1EpDo
         JHTNvAqBrMgQeIBGyeUifolLfVkoZV27O8AWcQ9d+WeOFOclTeAPWklRmy5XhDKPk6Ro
         V8wNGic/pqZyXI8Y6oI6Ai3/oGQnSowyu7nubcY4G7b8wM1HJYmFWL8dZKMUTWCIxLZd
         Ph4Q==
X-Gm-Message-State: AOAM533Pc9QaKgkbPp8GtME0xi2DTKJut5NbS7juZB1o4fzZq10rNc3j
        LZQPbQ+w48ziZ0zftPVpfhOwiSH3waNaC1pIXgxTeg==
X-Google-Smtp-Source: ABdhPJwHdI1tvd5lY0c4v7muMuU4gCvQOaevnaLJ1fK+829QhTAxmgaxD3WLUww9JBS/lDgymEBDmTU88ZyJNP4GAjk=
X-Received: by 2002:a25:418b:: with SMTP id o133mr18024994yba.704.1643448300586;
 Sat, 29 Jan 2022 01:25:00 -0800 (PST)
MIME-Version: 1.0
References: <20220127180256.764665162@linuxfoundation.org>
In-Reply-To: <20220127180256.764665162@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 29 Jan 2022 14:54:49 +0530
Message-ID: <CA+G9fYu3ECvC47s7Y-bzhcTu35DnGmQ8p7BC9uaKqJ-hQeUJog@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/2] 4.14.264-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 at 23:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.264 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.264-rc1.gz
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
* kernel: 4.14.264-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: a816c082cb802807f6548940bb78b806ad74ca90
* git describe: v4.14.263-3-ga816c082cb80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.263-3-ga816c082cb80

## Test Regressions (compared to v4.14.262-185-g1cb564222633)
No test regressions found.

## Metric Regressions (compared to v4.14.262-185-g1cb564222633)
No metric regressions found.

## Test Fixes (compared to v4.14.262-185-g1cb564222633)
No test fixes found.

## Metric Fixes (compared to v4.14.262-185-g1cb564222633)
No metric fixes found.

## Test result summary
total: 69622, pass: 55697, fail: 666, skip: 11294, xfail: 1965

## Build Summary
* arm: 250 total, 242 passed, 8 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
