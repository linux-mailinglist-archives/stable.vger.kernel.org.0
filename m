Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E567A523149
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 13:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiEKLPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 07:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiEKLPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 07:15:15 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C461423726B
        for <stable@vger.kernel.org>; Wed, 11 May 2022 04:15:14 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2fb965b34easo16934147b3.1
        for <stable@vger.kernel.org>; Wed, 11 May 2022 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eSCurJ4ghpxs8YXtVvBKXMNXNhwTELGU9OmHkyGedXQ=;
        b=Gx8mo99eRQyvZg9T0g22nL+WNohNJT6ZErCf73vIQvX17kOheuurYqHNaJFB6XGH/E
         43d4AJEjJ0uutOHSR7m9sIokq4yKYLHdBNAzWgo+MCMk1OMXhvElYj6Ol5yFh53Pn7Cv
         wJq2rQ20xK+jwKPATwgDJZ3ebr1aJiWFEXjkRGO6DKofbuZtKzVEp3D8Rdezl/z+vYZe
         jaZ54l5KRMtdDsek6LpKlUObbhdO9BSjbB0S5Rr8aPIW2o9g6pGiyvfnJxHtFP+ZiNVE
         5bFTfCSjulf9s+WCMNmM77AUy3YN7d3d6L0CDBAtDO4aM1fnyYEA1i068M3YQ+f9Irq8
         XZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eSCurJ4ghpxs8YXtVvBKXMNXNhwTELGU9OmHkyGedXQ=;
        b=MjcyEq60WRzw2Ix5KESElNQrwSr/SHW4JPiSZptarhbY5bdry/eLUiRfVRSReVcZtQ
         4oHlgfkYayyXrPqQyf7SzCErSplVGet4/VwQ59GeOhMmEiV8rKG73VLucCQYm5VQOLYI
         2n0PgnjPJeHNrXXFUlPD7yhN7Iv1uYFpyGTxzQab2YoKjJhEaeIHY1WYbP8tBviQAKVm
         1G472XdBUzwX0g+wjbaXui7+H7KT9EgNtFQ+3AyAe1jZqEBXAjWi09ezk9F8YhWrWmIz
         wkRTzqoSGZjBk1YzIGSpvKMCxE6SrGxO67C8ADqIl2eFbBa9yo2n3tgAB2mWspg6TFUO
         61ew==
X-Gm-Message-State: AOAM53102mDB30uznvhmE/ZxcaXZwMMUcIl1wlT9Ex1Yhtdd5PB9WNGD
        WtfN7KEPAui8tYND51HMsPkJevwWW0MXD5bA+Wq0k4HglB6fSQ==
X-Google-Smtp-Source: ABdhPJx9ROe+fPWiYR2Lpd+JkD+5ml+xHth0XXMWQCkZvGos1zeFiLHoeAW80RbgsDnAgnJgHLz84D2wogX6aN63emU=
X-Received: by 2002:a81:23ce:0:b0:2f8:ad74:1185 with SMTP id
 j197-20020a8123ce000000b002f8ad741185mr24246559ywj.120.1652267713817; Wed, 11
 May 2022 04:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130729.762341544@linuxfoundation.org>
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 16:45:02 +0530
Message-ID: <CA+G9fYu0=-RBEf4bxLDVX2H+wvLuAQ1_1gwZ3+1CvLqP=SSbnw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/66] 4.9.313-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 at 18:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.313 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.313-rc1.gz
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
* kernel: 4.9.313-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: bc7a724ac0ce0bc37f8b7335bfcbbc0d9bf71e51
* git describe: v4.9.312-67-gbc7a724ac0ce
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
12-67-gbc7a724ac0ce

## Test Regressions (compared to v4.9.312-60-g806e59090c6c)
No test regressions found.

## Metric Regressions (compared to v4.9.312-60-g806e59090c6c)
No metric regressions found.

## Test Fixes (compared to v4.9.312-60-g806e59090c6c)
No test fixes found.

## Metric Fixes (compared to v4.9.312-60-g806e59090c6c)
No metric fixes found.

## Test result summary
total: 65257, pass: 51559, fail: 751, skip: 11207, xfail: 1740

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
