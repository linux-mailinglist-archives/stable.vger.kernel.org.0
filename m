Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5434D1B88
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347262AbiCHPVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbiCHPVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:21:04 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8694E4D9DF
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 07:20:07 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2d07ae0b1c4so205116277b3.11
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 07:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TW5DuVeZioy5k5ycTW+HgZh0KEDOR1mt5wI/Tftings=;
        b=QO7KiJWDlfWZ63d1+80jU+ekzZyPJfI2Qp8wJxe6b1GMgpp+qumQVEwtNHZiNUDvnM
         tIzfNDmL99wzF1YXpWKiI/QksjCXdM/axl3Ss/sdFZq4TCC0KgA/z3cwH0UHlwtDGxRJ
         dbYRQSWlX9UyudRRWRHuDfTGKr7saFBOSpv2ythsTog49AzE4Lo6gdx3jwpm6wkh1c8h
         xn8DlJNl7DVnBL4MqCfSQBbPOGbgc9NmFZmY6PCG9sF09xd+1eUVQ8psN55mhrBZzIDB
         DTdAmu08qfd/Dk82Yyd4HDL9PyYTLb3SH6KT70/sJwv8lMIFPw/HufwTCm/DOHzwW2GY
         2/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TW5DuVeZioy5k5ycTW+HgZh0KEDOR1mt5wI/Tftings=;
        b=eOvSqeRTWH9isEV9e2ih5+aJzdGCkcMY58220GUgRHw7oha+mwBS8SVTrHXKve9Y1V
         jlahuOzZKMVmAhtCCPegFU/foHtxlX5e12UcdrwlUzqT8UQOP+pOAYqm5Lf+uocUNEkv
         MgLGj3pOVPLiddRyz1llOU5wqGlcPg0rCdUv9C+jgaTt9WxZt/ZMH4qXs+g29yGzMWWW
         HVJcNtBereKlRmxKEATg6bvBaJJ/dt8G8toIimmkBZVLp3MPbu9GeooEFfB8xoELdhzv
         JOW96JJ0wNRDo5icoT3CXwc4lm0BIom6LKeQF9jDsgo4usyDZ57M6MS8RxeBZZU6YK7H
         BjWQ==
X-Gm-Message-State: AOAM532w4Ixe12exnjYbbGHe/BsV+xFxE5U2o5TxYpUvKrJFlK4I8cdF
        ud1dpreDb5HKo3xTeI5ALOsrzDEU8Wk0hTDAM0qfWQ==
X-Google-Smtp-Source: ABdhPJyEEG51jdggQk/hCE8uBW/pe/mNHosmNht7Ft2VdkSfne7r2rPUbYQipgK3kruUseZ17mDCwNB2645EM8U6ul4=
X-Received: by 2002:a0d:f347:0:b0:2d6:916b:eb3f with SMTP id
 c68-20020a0df347000000b002d6916beb3fmr13464406ywf.141.1646752806552; Tue, 08
 Mar 2022 07:20:06 -0800 (PST)
MIME-Version: 1.0
References: <20220307091639.136830784@linuxfoundation.org>
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 20:49:54 +0530
Message-ID: <CA+G9fYu8VDPouKEmdEOx97UyG-w1oQRMcn6xXF0fUfde1hdWqA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/64] 5.4.183-rc1 review
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

On Mon, 7 Mar 2022 at 14:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.183 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.183-rc1.gz
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
* kernel: 5.4.183-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 5adb518895b328593a1c9d96828aa6b1a19746e6
* git describe: v5.4.182-66-g5adb518895b3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
82-66-g5adb518895b3

## Test Regressions (compared to v5.4.182-54-gf27af6bf3c32)
No test regressions found.

## Metric Regressions (compared to v5.4.182-54-gf27af6bf3c32)
No metric regressions found.

## Test Fixes (compared to v5.4.182-54-gf27af6bf3c32)
No test fixes found.

## Metric Fixes (compared to v5.4.182-54-gf27af6bf3c32)
No metric fixes found.

## Test result summary
total: 93068, pass: 77054, fail: 1146, skip: 13606, xfail: 1262

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 25 total, 23 passed, 2 failed
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
* kselftest[
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
