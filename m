Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0267A44DB96
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 19:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhKKSaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 13:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhKKSaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 13:30:00 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78581C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 10:27:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f4so27553651edx.12
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 10:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T1jwxPk1RXD/ec6P3EaU2QcuBrfCqbQCQKTkeZy+/MI=;
        b=bTojq4ZgpqZd7aeml/3AQ21KsdJXtyGV58pvX9gj3hNOm5ZAZWtEIvWW1yU/VoW2yI
         Gn9G2XKYtFDgP24d88UsU3+3TbKe4JGpIKajpyeN2uDWxrydTaoNyyKuWoiCLoihASb7
         b+OaH+Bvj8zb/6wcaZVOqm8qVvS/tVKRuBZsiksxVra4df5HzTbOGwYPeguZQa9QYO9Z
         pYYspWc+8ZS5eLLm4f09DbBYLSWLkaPs0PWiF6829P43CkZfS59CunYEVV0ZBMA5LWiS
         lZup+yaaJ6Lvb/oR3+7WqCg0lWZWJnZqe+ptsqHaLQjyrwkJbAEk+iH+ta831cmSZlYy
         xX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T1jwxPk1RXD/ec6P3EaU2QcuBrfCqbQCQKTkeZy+/MI=;
        b=WTqsK5jn4aHzsQnhJzl/G96ZRuNNVqb3QBA/HtpUNiMxULUINNZ4pbzRP6WOMAfBaT
         wAf7a5NLaQeMCrZosGeBXk25ocL5qd+eMylGupGWr/aTceOY72uVuhLruh5j/zH4bCMF
         QhEV4e/h5gYoq80VSNoNFUVu/l5fWJfjcIYfllC27id9XfBSKHH1+U7fKdtM5BcEA7aU
         ZQLuabNxZg98XZFtXuu0gxBsKiWuyZypn0LOmKNbyEuNVLN44KmaVyxTvWjhv0wNks4H
         PdO0WrjCdEjTmo7Anynk443xrgZofsEqmuaHwG9455zN/uUuAXliLVY0ezoajR3Ys6RP
         LxZg==
X-Gm-Message-State: AOAM532p3QY0JTG9yqwP6PlBdKhB9a4KM3X+TFyfXWkOgG/fbXgljsK1
        6Hfdl6i5GwMBTRtnz0K0n4nuuTslSwq2Jx3prnlodw==
X-Google-Smtp-Source: ABdhPJw++JLNVLrIVFIeLd39o65ucuCKh35yaRPhwK1p7Bth0hILA6Ail12wkGBOxzh9BKhtq+//DM6Nwl9kh4KfhKQ=
X-Received: by 2002:a17:907:7f90:: with SMTP id qk16mr12009344ejc.169.1636655227509;
 Thu, 11 Nov 2021 10:27:07 -0800 (PST)
MIME-Version: 1.0
References: <20211110182002.666244094@linuxfoundation.org>
In-Reply-To: <20211110182002.666244094@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 23:56:56 +0530
Message-ID: <CA+G9fYuUTNv1phEJ+8RXPJiDzgrnm84DhASgB=aSp_QTm9BorA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/22] 4.14.255-rc1 review
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

On Thu, 11 Nov 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.255 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.255-rc1.gz
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
* kernel: 4.14.255-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 0e0c342dbc368325d81b6ae17b54f1e668fa7447
* git describe: v4.14.254-23-g0e0c342dbc36
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.254-23-g0e0c342dbc36

## No regressions (compared to v4.14.254-8-g158dfc742cc7)

## Fixes (compared to v4.14.254-8-g158dfc742cc7)
No fixes found.

## Test result summary
total: 79228, pass: 63222, fail: 787, skip: 13230, xfail: 1989

## Build Summary
* arm: 130 total, 108 passed, 22 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 19 total, 19 passed, 0 failed

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
