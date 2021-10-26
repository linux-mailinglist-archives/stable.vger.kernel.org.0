Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF743AC62
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 08:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhJZGsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 02:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhJZGsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 02:48:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A40C061767
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 23:46:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g8so8884025edb.2
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 23:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jesPvciL2Z3tYe6Lso6hiE0tDvr1ccCt2ycfqmFViDE=;
        b=TkVd0nGZhst0q79UPQ1It0cwrawRUGLhEsfk0hZpteRm9fgz7OrtmUW666oXeEuiVk
         QF5i3t17ZLJS02ijsyztauzOuYimK4v5gNpr2lozczMW/oyJIzI4LaDBL0ONknzNplii
         zjxZ5bLsotKYqO7lfEmY6IKB92APazzjWBAZI9idk+uNfEG4qknr+ESPpvCTt3ed5tQ3
         M1u7ajqBLQsUK+bnkGyU9wWOw5KQVnXfx1p8PN3rZQ02taLEPxgFfWDqu6PS639t+Q5/
         W5KdSNBldZ0L7URAQlNWNtxXxkuBdX6RWb6bfY2uxzTq7ZBdjn8zMhuZwyDXzcURdNdb
         77Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jesPvciL2Z3tYe6Lso6hiE0tDvr1ccCt2ycfqmFViDE=;
        b=PPErSkxDI9t4ubQvuAvmGxPcSmiHuWVGfuGzIIvqjd27anYSW+5fBMwsDJQla9jJpd
         VVS0ofVHbsIAYn4sg2mrUjPlG4yVXSu917HiI2JNXzdIq8D4W2STLtRLM3RqHN2D8yPy
         zvLoZFHXmWDe04qIXkCll17xa814PPEebv5wdpazsjWTAPGi+Z/4cvNQ9eTFn/FZa7h5
         ttFDrJ5ohujHuquJ2jOcdC/j14ymYucRJjLIfwzy2xGh8ioBrMoU4+/t9c5zHcSGEyNs
         tFXXYdWIizPrqLPAi0c6pflHLK2+7Me58agoomShqRPm5w2cXmiS38MpCPXGIOaUlXUb
         a/ug==
X-Gm-Message-State: AOAM533cmC4FuVB99Fk20W9ILWEIUqbCI60/siBvL7rqaPw6WKRBSfXi
        FN088wTkX4M+95M7PcLnLGT8piaazNkeuOsi+3JMcw==
X-Google-Smtp-Source: ABdhPJxzWPlzHAuMuFc4jC0aj8N1eqAzYzrfuk3tnhA8bkFouS2dSfK5pG1+7GVA4/QP1RGKH4V1LMaWi+O6t4Osi84=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr28526485ejc.69.1635230786128;
 Mon, 25 Oct 2021 23:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211025191017.756020307@linuxfoundation.org>
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Oct 2021 12:16:11 +0530
Message-ID: <CA+G9fYuWEfyZa2fQrm70LD+-of2uUY=5anRx5msfr_n-bOwFnA@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/169] 5.14.15-rc1 review
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

On Tue, 26 Oct 2021 at 01:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 359943f37028eaedbff9d02dba3dab341682d227
* git describe: v5.14.14-170-g359943f37028
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.14-170-g359943f37028

## No regressions (compared to v5.14.14)

## No fixes (compared to v5.14.14)

## Test result summary
total: 95431, pass: 80321, fail: 1255, skip: 13068, xfail: 787

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* kunit
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
* ltp-io-te[
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
