Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DA652985C
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiEQDkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbiEQDkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:40:51 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1DB2AFF
        for <stable@vger.kernel.org>; Mon, 16 May 2022 20:40:49 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2ec42eae76bso173856187b3.10
        for <stable@vger.kernel.org>; Mon, 16 May 2022 20:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=677cDWpgH8GvesDxcRnGkKjYm3aHwCnLyfkOuwTpuvE=;
        b=yrnmPlKVq0LGnM60CZmd/5XYFlk4jq82qelp4gG+0m6JXVSSMzF86B5zEVYuyfY2Pb
         LjfGsYWN6tfqwX6pySR3FnLYLDjC0WIebjG+WUHGFKBxfDAshrLd9zJyq83k+58IJabC
         kWq47xZj/HzADqjFpslTbNa6qDofaUYOob/XKai9ZLXaHiVz+lGwKG+iZVb0Bj0y/YJG
         rmoG212u0L7U1hACDrZV7p6m9FEgjbeMHJTxddK1UpAW4Qhb09KSTgLGKRmZPv922asm
         nNRgOMsYPu0NcvYo6iHJJj5VpDGfYsRnphTv6Nhdfei4h6fr4rbm4FdM4S1/kKzZkkxl
         ryQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=677cDWpgH8GvesDxcRnGkKjYm3aHwCnLyfkOuwTpuvE=;
        b=D16hQwS0KQuEKt+5ZJmqEKIWRhmpKDz82c5RGDyyArTnD2ey9UkyfAgsd/ohBD3IMH
         i01lZyJem/+9O+vWL2l9PUH8VJazFe5pkX4B/MxwjC3h0o78Lmn2X2QbFjeD60Efr5sP
         wUp8WLfo6Z6DWKwe7HoF7Ke5KBZjw1s4QJ8vj/SQ4Y+8ogp7bpxQGyGPXN72A/+xhBSa
         EEK8RiUmjHN0E6QRwmj9/WVvlZaskJbre9suJpD8yfx3rsXgyJCyFmPdezBux6yce7dY
         CW6Kj53JGgSGSVrAuldFp5E3+cwPxXI8JRPMqkckQdNsVF26Bfsq46T2jdXQBRxi8V4B
         TRWQ==
X-Gm-Message-State: AOAM531GiSNinwGVX6atyxpNJba0hF68bxHDuj7CVqAmBJ7c6Ek5DCn+
        8BwHK+ZHlzWNozTUyTyxKdsL55cg7CAatGcwuhn3FA==
X-Google-Smtp-Source: ABdhPJykVBxmFIohvZ/wsLkXwzcFRuVH8Z3z4vecVzCsIb3i+tg8vTynWaRJdXp5TWZxhQtS7SxaQWNaFhE0G8NiQX4=
X-Received: by 2002:a05:690c:443:b0:2fe:eefc:1ad5 with SMTP id
 bj3-20020a05690c044300b002feeefc1ad5mr10155459ywb.199.1652758848625; Mon, 16
 May 2022 20:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193625.489108457@linuxfoundation.org>
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 May 2022 09:10:37 +0530
Message-ID: <CA+G9fYsEs43YK_n8pzLaPJY6adjQ1bqH48oSxi7Dd1v=xpt9Qw@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
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

On Tue, 17 May 2022 at 01:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.17.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.17.y
* git commit: e1382731ef4e5e1634896596ebe74e48b9ed2b73
* git describe: v5.17.8-115-ge1382731ef4e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.8-115-ge1382731ef4e

## Test Regressions (compared to v5.17.7-12-g841daaf9b4bb)
No test regressions found.

## Metric Regressions (compared to v5.17.7-12-g841daaf9b4bb)
No metric regressions found.

## Test Fixes (compared to v5.17.7-12-g841daaf9b4bb)
No test fixes found.

## Metric Fixes (compared to v5.17.7-12-g841daaf9b4bb)
No metric fixes found.

## Test result summary
total: 105256, pass: 88573, fail: 1048, skip: 14403, xfail: 1232

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* perf/Zstd-perf.data-compression
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
