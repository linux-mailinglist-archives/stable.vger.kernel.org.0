Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2274B673E
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 10:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiBOJPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 04:15:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbiBOJPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 04:15:54 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ECF26116
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:15:44 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y6so54019670ybc.5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JQ8erNbwz+npgXX7likCUZ50v9A5PgIOa27WXPlgNmc=;
        b=Ie08V81ttDvEretEJ7ONouefOSJgpP22/iDc+QY9Aas5xCid9zQVGZA4X/sAmTVB3Q
         ZP6Ea7d4pzrTeLoeTriSmBG7iDBs7Br4rpRGn6x28U0rayRpLqMfuSVTmEl999yDUAgO
         QqoR9GhUm4Xlt5zvF6wWNQIaynWsgn6yvXFhfPyRgwvEhS5TeFHsq9dZu7GPDbE34lkt
         4Nalo270zsFNmQ36ijhVWmYUnhTHv6t/jxiI8RziJpRHHU1NzgkmmhXD7z4ah/Yems2D
         eGOzr/Zm9+oRrUQQ5XFX9Im4E35+L+TuiKfzSBymPSbSvO4/vNhMz3L709/2UY1Cmh3A
         8Wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JQ8erNbwz+npgXX7likCUZ50v9A5PgIOa27WXPlgNmc=;
        b=iIk9Rn5Qvr9dqVL2TmaMB1vCOae1TogrRVxbverUXgxU1g/e9fpGIdKiojK5nzYaBQ
         at+ouBPg8q4KKMYRwcHs2hun/iOc8Ygz0o6DX/ah9zsgCAWHFzeNZOVjcqUTP0aFdo+8
         ZJUdW9XyO/BPJ7qf8J0mTTgDM4r0/W4V9k3cAjVIVWadK4rBZtHX+2u2aHh1EFrnelIB
         WzJrNWhW2b9xz+XFfKWDcNQNAB8jtZQ5tCXswamKhA70O80VqkdKCyeXfAONc1LXXZO/
         cP/j02DtMcobdLosrULG8ENsrwXWI3EzSp0xMSziHQGsXD0Jp/UkpFkAzQYIGsBL8Xsx
         U7jA==
X-Gm-Message-State: AOAM533IrP//q4roFSrqCYdwX1eKYKdiO9sIP3XK+A5qBdtSWqM4+7oa
        fg5T9fUWJdckGEgQf0+N0LX7eX89/+m7RxRkFYScOg==
X-Google-Smtp-Source: ABdhPJzejpe3kuNkeRpaUHEZZ1eJtkK0uRrZxhBVvX55eVzUv5yWgIqJvfXWk2Z5c8jxOnUYg2B35wO/GksuobRKX+c=
X-Received: by 2002:a81:a403:: with SMTP id b3mr2833347ywh.310.1644916543654;
 Tue, 15 Feb 2022 01:15:43 -0800 (PST)
MIME-Version: 1.0
References: <20220214092452.020713240@linuxfoundation.org>
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 14:45:32 +0530
Message-ID: <CA+G9fYsn6FRAq2iuccYGFhMKhTtxMz21sGbRaWG_OxgVq-L-jA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 at 15:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.180-rc1.gz
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
* kernel: 5.4.180-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 9a94c73110a5d71b21a49fd053026fbed3da529b
* git describe: v5.4.179-72-g9a94c73110a5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
79-72-g9a94c73110a5

## Test Regressions (compared to v5.4.178-2-g3eacd9fd7c98)
No test regressions found.

## Metric Regressions (compared to v5.4.178-2-g3eacd9fd7c98)
No metric regressions found.

## Test Fixes (compared to v5.4.178-2-g3eacd9fd7c98)
No test fixes found.

## Metric Fixes (compared to v5.4.178-2-g3eacd9fd7c98)
No metric fixes found.

## Test result summary
total: 89454, pass: 75499, fail: 571, skip: 12006, xfail: 1378

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 257 total, 257 passed, 0 failed
* arm64: 36 total, 30 passed, 6 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 39 passed, 13 failed
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
