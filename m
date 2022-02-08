Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63854AD6E6
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355828AbiBHLag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356265AbiBHK2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 05:28:07 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945E8C03FEC1
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 02:28:06 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id m6so48377227ybc.9
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 02:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VAes0K6H43qfG6qT4tOIU7yUDpw4vagrCK/oQ0t1jOI=;
        b=oAr6eSm3TD8rCF2JEmCTotEPI8lh7hDCZ5jBdG5Msbv5GWN8OQ1N/WoO8HNAjrEtoq
         CGG+0Tdqd/oSgjBBVpGa7dL9D/QvmXoiNwhulQfyxnyUV+EvIi6+zwS1BjiMrgwCSqR2
         LsdeCcyqfltn+pdi5YhbvjdXYJw8sMZRYDZh6OGH/BT180m76xMtkOaXWdERlN/AAe5f
         OYjigrRSoul3oIBCLbM4uaX1SHafJoAMEFmZLwKeea2Kb5xChKNSdzWGfPSyt9XYUbT/
         luRhfitKVY4ckdo5bPuAi3gH2NnNGdbfKBNJBTS5QnN4226362crEBhksXj2AfWQuyuT
         gGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VAes0K6H43qfG6qT4tOIU7yUDpw4vagrCK/oQ0t1jOI=;
        b=M/+PJCXantM6Fkryw0p7YXJj4TMa0DOFcmOknlQ4zhCC+hH2txVJ0yKzHb2a++pzrM
         VRV/49wVIh+OdAiaXK3LGUsgKPezdv03T10mO/FNR/hPYAAFxxvaHYctVTyxzg1wbcxD
         5O4ObfF8t2JIf5duWj48GYlYbwZKTwcu8cVDy7aRsacspmDlsKfHg4AQT6WrJR//PUgL
         5HYTEUtvO8J35mNxpY0eEvtam1Q/hGh7PAy6zMpwoapHyRX+/uvUWSZqFQlBpFtfrDoc
         lxrdloF+ac61nsNptIsAF7A5aWqdDES/KsWxVPV7iOgFfVSQmn578pgTpxZwyUUN5hjh
         1muw==
X-Gm-Message-State: AOAM533J5Jzj76UX8gwfvruUxFyhoMrRbr2F1sPkQZoz3RWAbCHM99th
        zdLSxFOzoZEuVEUbMfkm1ubQ9LxY0KfnxA7fr4+74w==
X-Google-Smtp-Source: ABdhPJyVazHeiw1TonQOpILqoVJAAKrGDCS+kDoFH7vl2vrRGlIkkpXy2B9+8Kkjwpil5ybXXYiUHTiXPGRsSLsUzP4=
X-Received: by 2002:a25:6b45:: with SMTP id o5mr3696692ybm.704.1644316085503;
 Tue, 08 Feb 2022 02:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20220207103752.341184175@linuxfoundation.org>
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 15:57:54 +0530
Message-ID: <CA+G9fYssiwEbu2oyVo-uQ+gQLL8kpc+v+2CGg5+tr7NTydS1dQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/48] 4.9.300-rc1 review
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

On Mon, 7 Feb 2022 at 16:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.300 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.300-rc1.gz
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
* kernel: 4.9.300-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: fa39f098578af99470f3762bca8001c0db1c3335
* git describe: v4.9.299-49-gfa39f098578a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
99-49-gfa39f098578a

## Test Regressions (compared to v4.9.299-33-g5e40da2b7be3)
No test regressions found.

## Metric Regressions (compared to v4.9.299-33-g5e40da2b7be3)
No metric regressions found.

## Test Fixes (compared to v4.9.299-33-g5e40da2b7be3)
No test fixes found.

## Metric Fixes (compared to v4.9.299-33-g5e40da2b7be3)
No metric fixes found.

## Test result summary
total: 62346, pass: 50123, fail: 394, skip: 10326, xfail: 1503

## Build Summary
* arm: 254 total, 238 passed, 16 failed
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

--
Linaro LKFT
https://lkft.linaro.org
