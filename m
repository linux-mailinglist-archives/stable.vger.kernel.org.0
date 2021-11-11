Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445CE44D675
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 13:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhKKMSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbhKKMSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 07:18:51 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62012C061767
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 04:16:02 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j21so23139088edt.11
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 04:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xRvVQxe2maqTo/5rXGRR2f58OkYf5yGEeq6jLRm3FCQ=;
        b=bJK2ExcJxoc1Z5j8CGhk7qf9QKdPD31mkNj5qCFm9COmoP1m8Sx6nF5ypZZNHKgqDY
         7VmSicQ5sFQRhR2FGRh2+Sq1eoTcxPlbPUBxqohtN2Q/Bg5ARvqjgSItC/UdjNXkGK0+
         S2pDZWXj/Dryav0CVeUIpZzzTjIIU9ZWyU89DEeHpX/5s1yAa8+9wgbLAf2DEufdY8KZ
         j3p5WCUGnAoHTCuKIKYbsFNK49fYlrSwwphJ3QaBttMxC0tG2xrx3uA04piHx6GqbcTP
         qjFJkMnXyh2Ef8z3X00OBztMa4QFTJJRF2IwvRAIrKArxFhukTJBol+sisb3MVPDLiZD
         eZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xRvVQxe2maqTo/5rXGRR2f58OkYf5yGEeq6jLRm3FCQ=;
        b=qck5894dVx3RbuyG85W3hemTZ7WiQLcLJZgI9bXTjspmqI05s5yal3ke1m2p27ghWx
         UO5A2fFPF3cUDruiARokgDe2iEzvmvk+EvyMboJEc57PXwIsiH9vyrExGj5F2kO4o+ZN
         Y4l4uHLdV+3A+uybXQtBvCG2gFlD5UED1ltWVwfh+5AMAIIn49U/NMgsRuiXJC2JfPhK
         6+zWEU7IizDeAkYqH30gPZvTnFmEqqprrwBuEbbIXVeaL+htnXW8XQ5FpuuWS2LpXYFL
         n90jwkhDA9bMoEPzcIQHFNevhIolVfmQ3SNhg/dypLH+3NGiUjAqZcFcX6wQbG7LAB6u
         xWVA==
X-Gm-Message-State: AOAM533l7yE2PBP5PRtL9IL/ZPFZC2r0hVSQAzhypqOpv4uz7BPY2b1A
        4+8yFs32w20V1INy2ONXliEzNO2Nv5WVE5+ToWNPHg==
X-Google-Smtp-Source: ABdhPJzm7yOSzMlWQ1HfnTPQoU4+qFy9iRqvreji9Jl2pfhTN8KZrGNsG1QRnAJaEZX9I5D+SSOVgJwjLobgel2hv9Y=
X-Received: by 2002:a50:e184:: with SMTP id k4mr9282043edl.217.1636632960343;
 Thu, 11 Nov 2021 04:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20211110182002.206203228@linuxfoundation.org>
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 17:45:48 +0530
Message-ID: <CA+G9fYturr1Uvfedq+9b9dJbytwiiXYkokE+wNMQNCEwRXeK-g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/17] 5.4.159-rc1 review
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

On Thu, 11 Nov 2021 at 00:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.159 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.159-rc1.gz
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

## Build
* kernel: 5.4.159-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 1422b7f3f43d27856aa1eaf04eac12fc7e565f66
* git describe: v5.4.158-18-g1422b7f3f43d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
58-18-g1422b7f3f43d

## No regressions (compared to v5.4.158)

## No fixes (compared to v5.4.158)

## Test result summary
total: 90024, pass: 74328, fail: 796, skip: 13498, xfail: 1402

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 267 passed, 22 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
