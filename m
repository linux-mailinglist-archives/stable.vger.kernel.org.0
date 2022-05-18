Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1733252B544
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 11:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbiERIqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiERIqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 04:46:39 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02356FD28
        for <stable@vger.kernel.org>; Wed, 18 May 2022 01:46:36 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2f83983782fso16629557b3.6
        for <stable@vger.kernel.org>; Wed, 18 May 2022 01:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qPcKS1Ha+hKfB2lrvxghAjYU5JFm8iV16VHBnSnQMMs=;
        b=moffsW5YZQuTFTUwPQu0v29BDmri2WHu0YtRzq2bvstH6QEBFna3ydED/dthnqnIah
         cAxmAvPik9cNa9fknZOGyzwqCQJVjrGRGdbaBZRgtqYTY+KXjGv2H191T4dCWADm7Vil
         evKE7U2qrgJUcj9bpDIJLXbH8+kjV64n32K+YALbYKbrduLPP4QeUC4uQOW2g1QyUHbG
         KhZXjSkJe9RK+NOtc4UE1zMiRdBSGKjgaWGLKxbx7SvyIFH38v7lpqgOxR2eyyvtG1DY
         H0Tz7jxJqR19kLHuYqt4f7HKj6B+UDsYKjmHhcGefNb+sI4dVfbdBV3gilCRwIMlhHs2
         vW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qPcKS1Ha+hKfB2lrvxghAjYU5JFm8iV16VHBnSnQMMs=;
        b=UTqDTIDpVkbJLBOGcSFJwO+J/vfpuQK9sEOjZUBq96T1eTamCsCowi7ymMqRUbEqNl
         buCW1doxWzmDnR65tjpkTg2w4GSfQFZN9vYnWshJ8o+yybQna8KnGauEDzrlxt6kefJX
         EHrrSECfWdNfw+NR1cdAq/XOZmd4LiQRG6KyV1CiuT4hDrOjpJ8ZBGNn0Ak1w8704Hw4
         fWMvxctapSL5MYZWdmuqks++za8GaWi1B5ZERuHtumYFRSGaNCx8HS5BpwK2nf2x4fVR
         AjPRaRqL6365YXuoBDsLlqAMkJB8Vp8tukHruaxJ6R2p8TV5pUl/8VDUWUuhQS2cZBXc
         tf9Q==
X-Gm-Message-State: AOAM532TLHZS1RbYhSv1KI0XXy3mjthmZYJBftBgQ9XiiaMbagguvn9J
        6d75UderMIUTKyWuCICvKOGF8uWVWksOHyvy6fYgyA==
X-Google-Smtp-Source: ABdhPJzKJHs24G9bBTdAAJdbd7PD2VDpfRxHHH4l80yKXHscXrAk081wTw1rc2EdCUO27l8eEclEZuXt/OFQgSYbYvE=
X-Received: by 2002:a81:3ac2:0:b0:2f7:f777:a43 with SMTP id
 h185-20020a813ac2000000b002f7f7770a43mr30466814ywa.60.1652863595994; Wed, 18
 May 2022 01:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193613.497233635@linuxfoundation.org>
In-Reply-To: <20220516193613.497233635@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 May 2022 14:16:24 +0530
Message-ID: <CA+G9fYuX+-cb5V=OtgpAH2w762yUTwccmdBOG-GsOJuYLHuQjg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/19] 4.9.315-rc1 review
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

On Tue, 17 May 2022 at 01:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.315 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.315-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.315-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: f71a7b3321693ff2eb8f97a521ad23ca53934428
* git describe: v4.9.314-20-gf71a7b332169
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
14-20-gf71a7b332169

## Test Regressions (compared to v4.9.313-8-g0d0d580b3778)
No test regressions found.

## Metric Regressions (compared to v4.9.313-8-g0d0d580b3778)
No metric regressions found.

## Test Fixes (compared to v4.9.313-8-g0d0d580b3778)
No test fixes found.

## Metric Fixes (compared to v4.9.313-8-g0d0d580b3778)
No metric fixes found.

## Test result summary
total: 80137, pass: 63338, fail: 858, skip: 13732, xfail: 2209

## Build Summary
* arm: 238 total, 238 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* kselftest-inte[
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
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
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
