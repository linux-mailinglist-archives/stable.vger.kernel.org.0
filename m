Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B604B1227
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 16:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243852AbiBJP5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 10:57:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243850AbiBJP5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 10:57:40 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6112D108
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 07:57:40 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id o19so16615516ybc.12
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 07:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L/gmacHO+nIX8yUgzR5WCryJPsq0BTK07bA0MOZtRbo=;
        b=sesbnoOHpiOR51+54Hd3unKOwAtRmwNA/IDMT54hgrg/u8vsTTfmua5W1cVqQW6x3a
         DDJ8WJAYKeOAwnXiQpx5C0Q0Q8+3qk9zGrZRi6tOGEi/6ReidqsgrrckprUbMIb2OdpM
         GxNZeJz7gN23OIpZPRR1K/wZWlvRnVByZokAjV5QXgGrCdFNl9FOJH6H8t7ZkmAp+HW/
         PDLrA2rdRidg9J9ry4zdTEni7zXLm4SVleUn8pzINVztSn9zEnhtyVO7IqK6/Yon2PSE
         pbQ2Opd6A2SoR23ztkgAlJEPoYFWNB4C9vbwbvkq5bZfyPW3fWya92z5SjYQWb7pguYd
         d9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L/gmacHO+nIX8yUgzR5WCryJPsq0BTK07bA0MOZtRbo=;
        b=3jq+VEcOGPsGE2inZ7ScyX7k7T94cUMQp4pSrIPKpbTRN2pvemmfSFLwhLMj6/8nZn
         4Nx0IoPIqalEEewPLwDdvtVirVQvhi1GtLMndor1HHTjFWDFIK9UF5rFPln9LrWNZOki
         J7HUKV7/nehMggZEmf+XQ7KnWtnH4U0bj4wuAeUkCHejWm+ABWEpIFpyr2DVGRCQ9one
         JAYVh6nJbYKjqbxsHX17YutEYy09UqBb5W6DVop8fcGskY6eidTH4+SjCsNH04aNsW7E
         F87SIZa+sL9CvEzePGnAHPLAmrW59fVb3FvticKcZb416RnF4oLmaqPVD4HtyLApW30d
         a/SA==
X-Gm-Message-State: AOAM5324qh/6kWrFnGDkPdZASKK3Oz78LWrazO+JlBH+LjVmrJi7Lx/i
        oxuBIS4e3XMRIA6eyjNlJ8x1sNr5rcp/EIgVVZvBtkIrZjisHg==
X-Google-Smtp-Source: ABdhPJwtHUHoicTc62W51Ae15FqUt4uok6ofdnQlOyyNuQ+oj4nZayQ1Bjk9IjD6f/RqrnYy+n8F6kqdh5txmwgpJUQ=
X-Received: by 2002:a25:1402:: with SMTP id 2mr6943610ybu.684.1644508659379;
 Thu, 10 Feb 2022 07:57:39 -0800 (PST)
MIME-Version: 1.0
References: <20220209191248.688351316@linuxfoundation.org>
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Feb 2022 21:27:28 +0530
Message-ID: <CA+G9fYtmysoxC=HMRTqQ9jPWWuzqBwukpPuhBoh3e82cu7NhNw@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
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
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.179-rc1.gz
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
* kernel: 5.4.179-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 3eacd9fd7c98dd0c2574ea8f3692776fd62b4557
* git describe: v5.4.177-47-g3eacd9fd7c98
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
77-47-g3eacd9fd7c98

## Test Regressions (compared to v5.4.177-45-g3836147e31ee)
No test regressions found.

## Metric Regressions (compared to v5.4.177-45-g3836147e31ee)
No metric regressions found.

## Test Fixes (compared to v5.4.177-45-g3836147e31ee)
No test fixes found.

## Metric Fixes (compared to v5.4.177-45-g3836147e31ee)
No metric fixes found.

## Test result summary
total: 70784, pass: 60720, fail: 227, skip: 9035, xfail: 802

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 35 total, 30 passed, 5 failed
* i386: 19 total, 19 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 39 passed, 13 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
