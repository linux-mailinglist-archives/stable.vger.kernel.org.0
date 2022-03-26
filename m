Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F42094E7F9B
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 07:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiCZGlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 02:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiCZGlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 02:41:53 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A252132
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 23:40:16 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id f38so17541044ybi.3
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 23:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dOzwhJyzRkh873kWXrwFFU98UINOxha+ssjImeuuWo0=;
        b=IwSZ+wnlfqfcXBAUyo/4qRqEJU6g+2OvNpjwjosGZAMbHJMQwSRTdIPL4nTBksvjDv
         3qT5Mj2jW7MdQfOjyUH8Cy4R3uFamergjuRyRUnaVWwdSmEAUTkaOJOR+1sZABuwG+1P
         IOvO19fyLgi/R+o6RUuKlU+doO+JydKD615XqLZKqBaLktegKq41S8vUFfZIY/hEBdhO
         0aPGrks027kuqm4LlUgJ1Wgu+JGUB8Uz9K7FBqwjhcGXVuY1FjhZXoXD9YXNQ+ZZcT3s
         i7yMw1+DcmZt7YP0fh8FQVydkIKlYxCbjxiUAvoEz0rpsecN6Ky/h682d4/AOAmeUYjI
         DDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dOzwhJyzRkh873kWXrwFFU98UINOxha+ssjImeuuWo0=;
        b=WCrNc+wq53txK5EzlrZRdqghfxCFAzueXUTpJ3NZ67q0fYKaMZT+dRIxIB6aRrHZjY
         St0s+pSy2lrzOPVJeTdSCbHwmNmInvoKK2a6ri6M0yDQcI+vev0tS3S5F0Gex22/FNjw
         LZlKCEoMi6hEXZ8HyriSdla5XEQCiuPM0m5Gw6OlGREwyctPQHqYVak4irsV5nBwtRiA
         +Sm7f/xPltOaAFkfh126FU7niL+L8sYQEentochv2oWW6eZhjYthdo1wUZ4zzttqOumU
         7Tb1U3XJ0ysIpx0ApeH8eSszhHJQ3CKGsub/FQn3A7V8PEIZxyATaYbpGZ/XkQ83hXC/
         XK3Q==
X-Gm-Message-State: AOAM531LP7RZZbcb7+b/uxiByQrKV4w3IQiGs6QijSTxgGhhI3ffrZEH
        LE8mZbdZwEQlUnkciaaqD4ONdslS9YjK+xW39kARxw==
X-Google-Smtp-Source: ABdhPJygcLFxa+YpCKtDHjwPpF9hbbn3TFmvpi9vY3jhE66N+zVYAiBtPUFO8L2uxUHokpCWYx1/H5QjmcNm1IxeXAA=
X-Received: by 2002:a25:42c9:0:b0:634:1a46:e5c1 with SMTP id
 p192-20020a2542c9000000b006341a46e5c1mr14433984yba.474.1648276815086; Fri, 25
 Mar 2022 23:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150419.931802116@linuxfoundation.org>
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 12:10:04 +0530
Message-ID: <CA+G9fYutvyS3wny2WhdkxVmpvEJjgsZuW9vug5eCWc=378+Gig@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.32-rc1 review
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

On Fri, 25 Mar 2022 at 20:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.32-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 6b524190f92f3150d5305eaad0c35fdc063a965f
* git describe: v5.15.31-38-g6b524190f92f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.31-38-g6b524190f92f

## Test Regressions (compared to v5.15.30-33-gca23d8a1f1ca)
No test regressions found.

## Metric Regressions (compared to v5.15.30-33-gca23d8a1f1ca)
No metric regressions found.

## Test Fixes (compared to v5.15.30-33-gca23d8a1f1ca)
No test fixes found.

## Metric Fixes (compared to v5.15.30-33-gca23d8a1f1ca)
No metric fixes found.

## Test result summary
total: 107180, pass: 90309, fail: 988, skip: 14719, xfail: 1164

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
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
* kselftest-bpf
* kselftest-breakpoints
* kselftest-ca[
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
