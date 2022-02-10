Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF964B0B5D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbiBJKuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:50:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240164AbiBJKuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:50:04 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44DF101
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 02:50:05 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id m6so14077536ybc.9
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 02:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5r/KOmabvwfACUVjtuB3yUeJeF7bxhYRxcHnGYT5KbE=;
        b=EhOfGx8zrnhEVI+lDTZsOqqPxLNEcv5SCT92uQ6q2ByjTJ0ryuBTKtKcCeDlrova4Z
         V6wGkW/f1nfFXW4xVyLbk+gQfsmJkaK40RWYzjwXKOjFT08tGPIcDmh+V5NNy39QvRuc
         XPVkCymTn0QaJwz8QKXDcWw2plRd6df+jPMhNDpLJW5wJl2Kyb0Nadfvux5yK6/mHWvP
         0zSMf1sgfqCiKs78iTp9K+Gj28G9xE0UOTj7xWgTy8k5DkpPI1BOtPRAe+4p0jHlq2GQ
         cOXklaWKhj6rq1LSGSYYw0Ivc9OBOcln/aaOmlE8THtdKk6dmBF8xu/XsXlXoTluzvTY
         4IdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5r/KOmabvwfACUVjtuB3yUeJeF7bxhYRxcHnGYT5KbE=;
        b=y16ZuQ2+c2I9cjhL4ewQ4yHmA8nisR2QczPk+bC9NoqsO50rvBxCo0l/BziIHLtG7h
         LZJ89CZ2ClWNjlw8AZHs4NI5omwhrjzCJP2DBUxWYlw3+qwmVQt6wGopietoBNmiyr5Y
         dBrE5wiqKbAtXAa06a4QdrfVGZ5om2lWaQTRX2Pb8LWym5wgI48jj0Q3fjs+Sq2bl7M1
         R/TU8h8iCwZ2dGfKOf5B9rfFEaRZjPywmrKp7hGeRxcKrAR5o22JsNxTXfcPLegslWau
         JTxS4jp21kDn7b1k7F94dme9TOGZ/08nfzdyEPJyrNS968bqJiOOBitUqPBKKSY4MAx8
         kutQ==
X-Gm-Message-State: AOAM5326nFvWc+zBU9scZ3KjFihDKUmh/uHPdzYAFdTeZa7cbdl/+aAc
        qOT5keKmgFBZQvvD/zNZlnooYS/VzqGoGOU0vDzaF82bo33nnw==
X-Google-Smtp-Source: ABdhPJz5BIWFzsJBDhZTw0AIWDCQkQvkRSyMkQrExAECwf4xMEyBOSrT80eg9SAbb1LRekvtSn0VA+ZdFRSBtPLwAbE=
X-Received: by 2002:a81:a403:: with SMTP id b3mr6383105ywh.310.1644490204701;
 Thu, 10 Feb 2022 02:50:04 -0800 (PST)
MIME-Version: 1.0
References: <20220209191249.980911721@linuxfoundation.org>
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Feb 2022 16:19:53 +0530
Message-ID: <CA+G9fYuXGCtb20onu-yFaAMSPbEwPxSDUcbprnRr1_yxGXr1yw@mail.gmail.com>
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
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

On Thu, 10 Feb 2022 at 00:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.23-rc1.gz
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
* kernel: 5.15.23-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 722769939d600370e0f75656c6076add1736919a
* git describe: v5.15.21-118-g722769939d60
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.21-118-g722769939d60

## Test Regressions (compared to v5.15.21-112-g0472630a5621)
No test regressions found.

## Metric Regressions (compared to v5.15.21-112-g0472630a5621)
No metric regressions found.

## Test Fixes (compared to v5.15.21-112-g0472630a5621)
No test fixes found.

## Metric Fixes (compared to v5.15.21-112-g0472630a5621)
No metric fixes found.

## Test result summary
total: 87812, pass: 74191, fail: 495, skip: 10102, xfail: 824

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 39 passed, 13 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
