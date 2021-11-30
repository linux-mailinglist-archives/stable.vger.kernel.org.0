Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866F2462F75
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbhK3J0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240104AbhK3J0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:26:13 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84F6C061746
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:22:54 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so84043301edd.9
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9wQszIeRh4bpsoce3nUa0NtBzpPb4PwcSOLJ/Afz228=;
        b=kWowWy6MhC5TwMfMyVQbkXHrUua5tPqpT9ZbXiXDxUh/UjiPSk0qpbPYTwRmsi79Xt
         MYzUABrQaxslr8pnspe13laObdVvB7hqyaZpHjZnGDwPRs2aCZTF6rLIYnQlQ/r7uth3
         pt/+VdO2YGaj34GppBzRjMZDB4vt1iK1qKQa81Lwxudp8ddADGI2F83FbPZGFS5TH2da
         JlCO/TAATKdwB63xKlH973vqgVKgx1QTmuE8Kbd2RCmWUujsCc5dz+cR6GOG9X06CyVX
         JL3D+bdJv9PyPiuK1OsFTfLOB4RbvGy0HjsRNpJFMSKDcblMqLJXKSl0dGsWmbN02esc
         1UOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9wQszIeRh4bpsoce3nUa0NtBzpPb4PwcSOLJ/Afz228=;
        b=bZYURaERX0QUe3WHh9RjoJ46DbqU139ze29Mtr0XT4NDqnjleHQZ7aNszF20c8EWqj
         vgnvHKkmUE9j/3Yli37WLvitAzk16tcPBvxK0Y5K1MN8ysqFvlGkkJTrblpoWM6OY0yt
         +RlL7aZFERF3UZk9LNBnItYvprBddM8LiXCcIqzZyHstN8BfB7QwlnY+Yl6NuHHwujjl
         SOG6XTSJB0DFnF4D9nlpuYo25Pps4vsQ36sP2T0PrRwyb3rtkzERsS9y7ACi81jHVH5b
         iko6gzfiQHgYk8XUC7Ley3faQjFdcAewmpcFXCDEHwM5qo2V21lxF8PkAgRNnDy4x/a+
         MFNg==
X-Gm-Message-State: AOAM530MSQlUB/1qDYX25PEsRStqe7BSKzNFXBHbeyey2pqWKtubrs+H
        9PEieswt00w6zLMVPw7PG9d1iU9Iz/FCV2VZGCqfew==
X-Google-Smtp-Source: ABdhPJxnKQRpI2lCrFZN1y1BOpa6vytqk5GjBcdQnNy5phw9URpj1qewuWngQz3S2WGhHgsAUD7PyjNmLAtwXPegp4A=
X-Received: by 2002:a05:6402:2813:: with SMTP id h19mr82042918ede.267.1638264173221;
 Tue, 30 Nov 2021 01:22:53 -0800 (PST)
MIME-Version: 1.0
References: <20211129181707.392764191@linuxfoundation.org>
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Nov 2021 14:52:41 +0530
Message-ID: <CA+G9fYtOY8LgCGUZ3rQa-=Xu-BCLQyT2V9LaGp7nvuaLx3cWCA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.163-rc1 review
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

On Mon, 29 Nov 2021 at 23:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.163 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.163-rc1.gz
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
* kernel: 5.4.163-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 53673b0fe933a85d63ae4a4ed78945e5a2ce1b8f
* git describe: v5.4.162-93-g53673b0fe933
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
62-93-g53673b0fe933

## No regressions (compared to v5.4.161-101-ge0db70362c5c)

## No fixes (compared to v5.4.161-101-ge0db70362c5c)

## Test result summary
total: 84761, pass: 69858, fail: 802, skip: 12926, xfail: 1175

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 74 total, 48 passed, 26 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
