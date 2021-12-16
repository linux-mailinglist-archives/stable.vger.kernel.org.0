Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1408E477107
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 12:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhLPLrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 06:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhLPLrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 06:47:41 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6599BC06173E
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 03:47:41 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z7so24425854edc.11
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 03:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XCEmBcYZzRIN6OKtRB2AeETTwqwp1B43Rh6YS4Pk4vI=;
        b=PhysAmhygWwuOaltk3bjYqbLTNmswu5AMbRzCMWACHlOOBITfhxJySZBYqBiP/AsMK
         oBq3ZkNpwhS5ZGMJKqvOj6q8AYq+kok+unZSgwKtIhtlkLKg+TT9Akuyt5KsPTEgB30Z
         0dJWlq7I+2OZ+b2bol5qLpC+uGQj8aYs9NVsrFXOZ9tj055OOFPcBrrspzAwa9+1YRNJ
         0P5u+xDPybN2X6ZsqItfAYxCot6zTyPvX8/+N9DkzCof4NZKxGrXeRLhYwyIs4JEVZV5
         6LRMQBxCGje0oJLVO0Xe7V889kik6s7ARvhV43AAjXkh/PtIMeAK2DWvSGpEiStGFMo+
         WCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XCEmBcYZzRIN6OKtRB2AeETTwqwp1B43Rh6YS4Pk4vI=;
        b=ggxmMA8EOIhM/xP1X4ZpVQPBn9UKzlFOby6zyjOOZ16v4ZXhzUfKJ9u6P5TNPPsn3Q
         mpWKnR4329aSfyThNypNPiodnC9ee58OwB762UQHQE+LgcYSkrnr9/s3Hyn4pPqa7OtR
         QjhTfn5blCf57ur/x/H1SjT2D/gDGpMzNZEWg/aT/f3F6YzJGjNIzp6cXY6EvWvFn8Pf
         4i9M0bBYn/pyr5IhJJYYAUJetAzyMxMUUBx1pdGhhhtwVuy24UQAtmybwGjg2CitOAxa
         kLoKly/67BDHfzPHfjjkapXUdlMKrs0yfHGjbQrdA/r6TK3VWems1nBJ93YugwhjuTtA
         48uw==
X-Gm-Message-State: AOAM532yfoHHq9hqMYASWAxyrLsZs6mk9J+PyrS1sqe3y199kQSCK+Ts
        MsmUe7kpmxqdbJLLfsP8kt73BLJQpQBZYiZnHUBt+A==
X-Google-Smtp-Source: ABdhPJx5kmU4qZesErWYNPX7/IQcqg6D/B158M+8r1cIhF6jaNBYxPV2Xe8KP9eAmwRQBUEZnFIvlgtUZ5C1SM01mpY=
X-Received: by 2002:a17:907:7da5:: with SMTP id oz37mr15895831ejc.586.1639655259747;
 Thu, 16 Dec 2021 03:47:39 -0800 (PST)
MIME-Version: 1.0
References: <20211215172022.795825673@linuxfoundation.org>
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Dec 2021 17:17:28 +0530
Message-ID: <CA+G9fYt=myg0Xpxn5NqjRvL23oFKYsbsqvVPSi_c-2kqsRuSUA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/18] 5.4.166-rc1 review
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

On Wed, 15 Dec 2021 at 22:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.166 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.166-rc1.gz
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
* kernel: 5.4.166-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: b780ab989d6045e3a7f03d21348c50a4ac4fb2c5
* git describe: v5.4.165-19-gb780ab989d60
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
65-19-gb780ab989d60

## No Test Regressions (compared to v5.4.164-89-gc50f1e613033)

## No Test Fixes (compared to v5.4.164-89-gc50f1e613033)

## Test result summary
total: 82641, pass: 68845, fail: 666, skip: 12220, xfail: 910

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 254 passed, 4 failed
* arm64: 36 total, 31 passed, 5 failed
* dragonboard-410c: 2 total, 1 passed, 1 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
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
