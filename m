Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C365E645900
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 12:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiLGL2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 06:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLGL2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 06:28:44 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEFA63E3
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 03:28:43 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c15so15882318qtw.8
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 03:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8F6zuUbnnWX6FbXjZkqcfyxeunydod4ZZtHAFDkt4o=;
        b=MA0XEoFCJTXFG5RUybSr7AhZENvexNlpYrPT//vHNLyaskzWf1lGvgQaq5FCNwcC3+
         oQlVc5pSUj0puILpM+bzL8YdNa2O3VHDID35WaFi7ZuvxcO1enD/zn/pgv0Eq58pWAJF
         synNDcfAud98K+vvVzoBOvuHNBHMh3JlnJ/SebLx9aJr5zvVDafgK+EM6Mj3wdKFAtN1
         GGoIBgd8sT9QxUq53bt/mwBNwMUb4ydter7QKarrqKUkfMfM25ACMxK+ja4GLIe8/GTy
         okmqSoFwXLUGUsXsSmSfhYpAmwd1CvscnvpqRdW1EwdRUC4iWE59gQtE+IEXE4LubUXh
         rGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8F6zuUbnnWX6FbXjZkqcfyxeunydod4ZZtHAFDkt4o=;
        b=WtdiHGX1FFk7aUM684fp+Feo5g93di44qnuzph81nqydrTLaMbdBYe17aGbkgonpB1
         ilIniR2eUnhXYVbAFucclWwX8HxdtJug8lqTXNg375PcN7pYduqU4y03pKGELPOTzYEN
         37xL048t9/DtP7UGB2CQp7sNk9Ucj/eVRfwClh5LbhRejGVuKJjWSbXRLsqUq50Dh5vN
         fc3Qc0OKzNHjy4cQkrg3UJUoY5z4ABCgKtGnI7TBrWrkI3Np5O9S3MiUZ3phCgyr3e2L
         J9VjVu1eiUU6YnDfMVu0A6cCJHHBOcp/eap2PYQzsm0yxaDOaGBCm+Gd9mDhUkKy3pr5
         FXgA==
X-Gm-Message-State: ANoB5pnnKARK5ZEfehNsI62TG7FzrNV0D4NYLAtPvZ2Fuk/sU/gREBBh
        shQ09UQJNvLLnIqYphtOiTOZiOtvl0KfI7Tbvi2zmA==
X-Google-Smtp-Source: AA0mqf6aRmzdWZl8DjEsLb5UWfJsO5sYcvlu4aJXx0h+FRnKY9DDMqDc1ivbkTWM7949CU9Jc84t3QbwEBKb6jGJ0Hw=
X-Received: by 2002:a05:622a:4ac9:b0:3a5:ae7:9ada with SMTP id
 fx9-20020a05622a4ac900b003a50ae79adamr66967856qtb.191.1670412522083; Wed, 07
 Dec 2022 03:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20221206124048.850573317@linuxfoundation.org>
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Dec 2022 16:58:30 +0530
Message-ID: <CA+G9fYtXnk2q8V5OH+UQv-4z9D_8qHEz5DPrwh7n4eMfPyMn4g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Dec 2022 at 18:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.158-rc2.gz
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
* kernel: 5.10.158-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 8dca57ec68a7eca30ce178d858b45748b2a65eaf
* git describe: v5.10.157-97-g8dca57ec68a7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.157-97-g8dca57ec68a7

## Test Regressions (compared to v5.10.157)

## Metric Regressions (compared to v5.10.157)

## Test Fixes (compared to v5.10.157)

## Metric Fixes (compared to v5.10.157)

## Test result summary
total: 61785, pass: 51491, fail: 2027, skip: 8109, xfail: 158

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 26 passed, 6 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

## Test suites summary
* boot
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
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
