Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8E64FEFCB
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 08:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiDMGaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 02:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiDMGaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 02:30:04 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A815FBF
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:27:44 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ec0bb4b715so11479647b3.5
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gfr+yFv+alpSNVfS5J2ynVyzX3s0qBnSigSkSVyt5qo=;
        b=lb6BCQUIv/I7NgwAMBBW7VFQUaXsxx5Mae1osQaABtBEHa6/rWY7zLhzObo+mkW1Hi
         HsyHIwuT995ah/aczmtfGrSwQgQDJKQHkI9zx39d4D4ws21EBLm0fGb4OcDyIouS8ToD
         pjb8jUET2YCx/64CFvXI2bdLhbBkWTVrl29CpW9kpnMptj4pf5FWp42BmViLdUnbBn3q
         yiUgWxpBsXylNwu9gXvkX0r7LXH9lDSJK6jfpf5f2W1SSyj/8r3H9XPCs0H12ARddQmW
         xdDoXkRahnH3g6dmelgpIr5ZxoLotG0ag+3E0Owp3i3PPU36aUhAQfQxV761rIBN28Y5
         nqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gfr+yFv+alpSNVfS5J2ynVyzX3s0qBnSigSkSVyt5qo=;
        b=aHDBgk0sSiNy7e+8vzI1n3YbE4WtN5Ll7dxOJ+7ykGJqGSl9xnSMWL2o9jzAw93A4U
         cIkWMP++RvjwUoSxVA5MpWvYbHVsIY7qwBQKuUYEzc5jTyVkpqiSsvZ/qjcQ7hKMtExp
         3PB6S2xj/Y/k3/hRddV91BeYlHJq4H0RVbOYbzR6RYfiyN6diYQhm1RuhsagSrJCBAmf
         CPd99Q1Jco6m9/1Tod13zN54shHJ9+pgcWHMCUw5pxMUcwyYw1xTDj3+g1oNUwDH7GqJ
         cbF++z1akFfZDVSl6GY6i2MwK+m2RnXAlx6k7IFJSXR+5TZ6h8A3WbUnb5GBW/apOAlP
         Bgkw==
X-Gm-Message-State: AOAM531MVrOOmYOQWU3YBb5IGLKeDY4h16/RB6aKNTAnEfa+VpsUu/l5
        UE6tRpQChjMbfn8Epabe/XSaEZtdr48dt4AfTaybWQ==
X-Google-Smtp-Source: ABdhPJysSuKSW6gTaJmCvHOpSFnmLQSXLpIiGYvmF8L9dXrhxJdRWG1wOG2V7da99cDpVqT2dtlgVU9hkASxT02WV5E=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr34784132ywm.60.1649831263712; Tue, 12
 Apr 2022 23:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220412173819.234884577@linuxfoundation.org>
In-Reply-To: <20220412173819.234884577@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Apr 2022 11:57:32 +0530
Message-ID: <CA+G9fYsD9FnViDYUpGC1VSKp92MfdagvPunnHcYtK55KaYyxSQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/170] 5.10.111-rc2 review
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

On Tue, 12 Apr 2022 at 23:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.111 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Apr 2022 17:37:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.111-rc2.gz
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
* kernel: 5.10.111-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: b82c8b005aaf13b8aa97a4fea425ae4fb1f3fc8c
* git describe: v5.10.110-171-gb82c8b005aaf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.110-171-gb82c8b005aaf

## Test Regressions (compared to v5.10.109-593-gd189d4a7b878)
No test regressions found.

## Metric Regressions (compared to v5.10.109-593-gd189d4a7b878)
No metric regressions found.

## Test Fixes (compared to v5.10.109-593-gd189d4a7b878)
No metric fixes found.

## Metric Fixes (compared to v5.10.109-593-gd189d4a7b878)
No metric fixes found.

## Test result summary
total: 88872, pass: 74945, fail: 768, skip: 12466, xfail: 693

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 51 passed, 9 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
