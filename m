Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB7F4B1407
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245130AbiBJRUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:20:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245113AbiBJRUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:20:50 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5AE71
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:20:50 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p19so17470970ybc.6
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uGPhzBguK/5/cfeFYerjCM2EsCWTLNreTG0aManfefs=;
        b=mJmnkOw50LKYU304qUoanAU2ejFM89eMtfePrkimCdow5gNbJAa6MFqtheLGqT2fWb
         Htgzgl1sfBM9XDJEaFe7CCsxvl0Vy/HeSvKHgW2Z0S2ElZ0HdEHRlX2BAW66t/Hc3PUn
         9Dc/AwhVF80UzlszCyH/mf3q6DzP2fdLu9/1AYWshZRLOmYl1Hj8hkvDqiuxlnMi61Kc
         yGOGlaMQVXQ0otWft8o5KYYffb6WBLZl/qqZCFsZp5gd/CbinxXJkjLLLi1MfuDFyttv
         TlZklQV1QLVxZJf75aAl0AsHkRWxyO7zna2qHwcHgSCTPzeVaqQh4pOYvbByCak4+YbN
         +FLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uGPhzBguK/5/cfeFYerjCM2EsCWTLNreTG0aManfefs=;
        b=U8sJkYEG/Lsm4WhtOCxYM5fS17yMTw12Shzx1WnmgciIuXBh3UpgqyWbrXedjsJnl3
         KMzBSPxF2GEdtco5dogpyObjNf6qeofAIHayBB1ZbvK5Q8if26C0/w4mUGyjD6yTOo+u
         2i636m2V5bFFj/8Pavvm7MqEWBxsp8UW3Tm5ECylZxToTbbnOfEeTTuaHu89ezEI2kuF
         n/z2oiRSJUvacGh/JzHiP+9cTrryY4g6BsTMONk+ZJrOc4MYeHc7VRylhn4Kc7RWoN6E
         JTLYnrt008JjQjaKpD1QUKaQDEC+yIIZ2b8i7WC0i92+0q55ZtfIh9gQ+VioCkHyMQhm
         Mvog==
X-Gm-Message-State: AOAM530w4HE7IOouZVHQ9V1nogc+YGdjoc9ZZOWG1m3a+8mq9jDvkaqK
        IAu11E7UsbtIHtAUmnSntOVKcZXOh72wCE1ytirECA==
X-Google-Smtp-Source: ABdhPJw9NpLvJD8mjqNP/buS9r1P2MU/8G6NTcvj2v9amb5l/1yVfGRZK8LtRA7ESaxjR5NlL+utbJSSVr2WWnk2XvE=
X-Received: by 2002:a25:5143:: with SMTP id f64mr8306603ybb.520.1644513649615;
 Thu, 10 Feb 2022 09:20:49 -0800 (PST)
MIME-Version: 1.0
References: <20220209191248.659458918@linuxfoundation.org>
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Feb 2022 22:50:38 +0530
Message-ID: <CA+G9fYvU03C2ik=s8+g5D+caizsN1=fk8FVTSW6FxQyZw7S26A@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/3] 4.14.266-rc1 review
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

On Thu, 10 Feb 2022 at 00:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.266 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.266-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.266-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 11dfe0b418492a0075056a9db72fd2a34628c1cd
* git describe: v4.14.264-74-g11dfe0b41849
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.264-74-g11dfe0b41849

## Test Regressions (compared to v4.14.264-70-g1d3edcc1650d)
No test regressions found.

## Metric Regressions (compared to v4.14.264-70-g1d3edcc1650d)
No metric regressions found.

## Test Fixes (compared to v4.14.264-70-g1d3edcc1650d)
No test fixes found.

## Metric Fixes (compared to v4.14.264-70-g1d3edcc1650d)
No metric fixes found.

## Test result summary
total: 52019, pass: 43671, fail: 273, skip: 7413, xfail: 662

## Build Summary
* arm: 126 total, 118 passed, 8 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
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
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
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
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
