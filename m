Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399F44DD960
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiCRMFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiCRMFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 08:05:22 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF16204AB7
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 05:04:02 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2d07ae0b1c0so88740947b3.2
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 05:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DBvV4G6vOU2kREwkM4zbHp8OUt3CMWwQq1dJoUZwDd4=;
        b=QK41pf21otxSJ7KIemOIbH4kWR5S01A46Yz0lBCrgNMX6PnAW41AqoAhOl7fFhigkw
         faZomf4Z+f755BDK0AsAlBH1D493CEDQIom0dhx4o3uBAjxBWJf2ObNr+5EDtN3ptdzJ
         jRE52rXKwcm380pWpW/geHXEDDi0hrjbuBtDy/VAuzdUWfHdsLdGxKHb5lPlh2Ucw5lo
         zEWA/kCoeNGcijLMsfRj8mMBM/YivkOCN4+eVX98xhxaOuUkYEA3qp+NeudUWxQErB3x
         GGM3//v4XxlZNmd86M7XJrwDlhI6XfywQBioLC0gk4kZ9cc9APDJI5QxevquC4KyOigj
         pSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DBvV4G6vOU2kREwkM4zbHp8OUt3CMWwQq1dJoUZwDd4=;
        b=hReq+dHX0/vCg6tWw55gDTaGxbYe/kZlxNix4n7bMSnYGcW5NFZhyrD6GB6IL7efCY
         Mt4wZMVIrLwLCnlnEclerDpcOBBCEwbTJx9CavY0fNQ+j/+405nWVvjQL3q9gEzTUMLd
         ALpE8IgrOhL+ZgG3GlZq5x6PO7+89wtlf2/jiHm2j2sRVP1nS66WpWXyDGYpFjLm5ZE8
         rd+IklBK7b2xSxosI5whvLyOoOi3EGB8WjznQIQKBatFik75m5nUdFE7tYhqhH5sPfNY
         gxccizz2MHwFYPFgS1YyekGZEF3KBX0unHzP847ZKZ1RPtB+1FWAmqDtQWIQiCG0Vy5h
         /7aw==
X-Gm-Message-State: AOAM5331phVnbmd92Qj9UJtXvb2lbNKBLK3pKVpkzfhouLr7+cwez38U
        0FnE96mECsR+TOkvbaiYRUnZovZZfEABc+B+768+kQ==
X-Google-Smtp-Source: ABdhPJzwRtRyLqTheT8yJL/ej55d6PdmwoyGt8xO0LaNXvPUKZb4vJ5Ydf5uk4Aus+GxE3qWx2fwVVWMxFIZM661TKM=
X-Received: by 2002:a81:7812:0:b0:2d0:8c2c:5159 with SMTP id
 t18-20020a817812000000b002d08c2c5159mr10557677ywc.120.1647605041628; Fri, 18
 Mar 2022 05:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220317124527.672236844@linuxfoundation.org>
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 18 Mar 2022 17:33:49 +0530
Message-ID: <CA+G9fYvLHr=ihMou7hvAWeJCxhfE7mnxUNkUhXRMApNrNFZ-ng@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/43] 5.4.186-rc1 review
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

On Thu, 17 Mar 2022 at 18:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.186 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.186-rc1.gz
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
* kernel: 5.4.186-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 4eb765392859512cee9488eb5831d73f5b47b4ac
* git describe: v5.4.185-44-g4eb765392859
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
85-44-g4eb765392859

## Test Regressions (compared to v5.4.185)
No test regressions found.

## Metric Regressions (compared to v5.4.185)
No metric regressions found.

## Test Fixes (compared to v5.4.185)
No test fixes found.

## Metric Fixes (compared to v5.4.185)
No metric fixes found.

## Test result summary
total: 92947, pass: 76842, fail: 1135, skip: 13484, xfail: 1486

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 34 passed, 6 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
