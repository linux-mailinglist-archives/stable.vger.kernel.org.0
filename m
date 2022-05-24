Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5B532A6F
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 14:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237356AbiEXMed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 08:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiEXMec (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 08:34:32 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3158F95A39
        for <stable@vger.kernel.org>; Tue, 24 May 2022 05:34:31 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2ff53d86abbso160877927b3.8
        for <stable@vger.kernel.org>; Tue, 24 May 2022 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JJhwxfwW7n7VLkGPMvpANvwbmPIJmDkcwtkzvJnYyJk=;
        b=biww96eDtZOSmJhMMIl0jKPsL5VhgecE1zdzoSokTJqL2yKrSOr2xVnEPWPH1VY4O2
         P+fHfPP/calICpdhAf4RdlGk/ot6MKOLOgjnLxZM7CKwlW9G6gd3iBCshLFMGwMG/fM5
         3P/ii6fpdR/JtE68MCJAXRbQeasPH4hMU2+Po+MlEy9QtRWNmllxrUGSXWqTDuGCjxq+
         qO7QGxxBnkT4/bfqvJlL1Sz7dxpwQEk0ZiNE5qZV1cVWEO1UizcsdOEhrpnSuB5mEfJ5
         kEILaOY46Lu8rwsGe25PQ5D1KzxWmKRQhG1vWE/cLcSWyihd+egdRaBxRwM6ToLBIsKw
         TsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JJhwxfwW7n7VLkGPMvpANvwbmPIJmDkcwtkzvJnYyJk=;
        b=QDGwULgXRzsUl8INrtOVDCx2DdPu+eGeDINMM7VWm20nq8zUJEyHxHvmh6xvoXfnex
         a3mZo6oxAA0oaQedpEZu1TWBdPyS/V5aJDRtowGe/RS2H+VUD6BZlZ4oLumMds2cnxmX
         TO58CKj7yO80nJ1hoOvG74HBkmdhNs2V6MYKjf1f2/KOSOZtNHA2+dsPTh6O1SbdXzzP
         pGJ0/rKyrSZnKbMXt3licpQ/4nNoJ+T6MAYtJR3oTxvBZHw3rtVD5shSoWKWKpG/O7v1
         lpp1VyUSfecU3rwxDxaUb18Zp2OCsNP5Dx9/rC0U+nFtL7XHjV9+19t3W9jk3L08QhB8
         3prg==
X-Gm-Message-State: AOAM530riecwlKOn4TcrhQ+JF0ybBNBaf4byPYhukJlWh/WjkxqVR+2m
        qz1JcCnzsXVSWdmRmaFxSEtf7RIVLQ3cPHcJ0RiJPg==
X-Google-Smtp-Source: ABdhPJw9XyKlYZWLxvVbRuzoifixIo/Au5GciofjDzJUooDwGxnk79ZQnTT5HbOkUkzNGZdIkXcrM4yISawI6me1ea0=
X-Received: by 2002:a81:4c8e:0:b0:300:37ba:2c1e with SMTP id
 z136-20020a814c8e000000b0030037ba2c1emr1445603ywa.141.1653395670220; Tue, 24
 May 2022 05:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165752.797318097@linuxfoundation.org>
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 May 2022 18:04:18 +0530
Message-ID: <CA+G9fYuj7-BSEcm8_+4DCjr5WgGdbKDkLn=hf1s6v6-bxAFOyw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/44] 4.19.245-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 May 2022 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.245 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.245-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.245-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: e88efc48b31fe3946b6e39d613eeae6d96ada4fb
* git describe: v4.19.244-45-ge88efc48b31f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.244-45-ge88efc48b31f

## Test Regressions (compared to v4.19.244)
No test regressions found.

## Metric Regressions (compared to v4.19.244)
No metric regressions found.

## Test Fixes (compared to v4.19.244)
No test fixes found.

## Metric Fixes (compared to v4.19.244)
No metric fixes found.

## Test result summary
total: 85385, pass: 70036, fail: 859, skip: 12899, xfail: 1591

## Build Summary
* arm: 275 total, 275 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* log-parser-boot
* log-parser-test
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
