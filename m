Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3668AEDA
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 09:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjBEIba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 03:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBEIb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 03:31:29 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FB9206A5
        for <stable@vger.kernel.org>; Sun,  5 Feb 2023 00:31:28 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id e9so9719596vsj.3
        for <stable@vger.kernel.org>; Sun, 05 Feb 2023 00:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYyeRq7xl+tuiz7ZJF3eYfcgQ/Nq1xTGEfXuuhTyZS8=;
        b=MDaInQOuHRwY3UvQKjUpJWng3BGJl0oYIieGJwS+fQv52klvd6/Yw2EiWoLKsyTCJg
         JEBgjy6wPl7EPexbSL4mUqQjs4WXZ7e0VpeE7ZC9fVaIJQOvinskcOD4BniqQvRfyjCB
         yLlA8kg3m5ROPKQtWy4TjUCkp+54TRvZ2yy6cWmV92g2OCXgmtjibmJHh3SLp/Uypv8O
         p6lwKIs6XNX8jldV2Sc0R2vS9nZ+sI4jHyv2si515yXiO6XQ2sdbs+LvDpTno4WQQMkX
         qUwMtU4AkoqBRJm8sm+0TUMonIiMSM0cqnEmX8TBJltoGVFv0wXqoqg4/+Ni/JoxclgW
         AwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lYyeRq7xl+tuiz7ZJF3eYfcgQ/Nq1xTGEfXuuhTyZS8=;
        b=H0to6XW/cFmWeddPK4cXISxpcrByeBwbCYfG7TOG41eOMmO/tuJJKrTngp404WnzWE
         eaps5OqCegkO3Rm2T8CV0L2VyfSfDZi3SD8pc1dsWDE9jdi/iybFLw9yAoYehsgVc34N
         k7PmzGEc+Ck1oQxgpx8MkrF+EV/Z83A2g1HeJvy94BMAKDyMjRT8G9RGMe7BR3ShpIRp
         fowQrZdkvzYNrN7mMdLYEX4WYksPZVcMJ6uw/NcPNMH6Y2jFvFkN7WIaEuTIRp2pu2a/
         egxtYAwF0BPiaLNbo59Jh5kT3nw2iP5l4vyJ6ML8iL3fCRtoSncI8jPD8CN2rokWCVrH
         e6lg==
X-Gm-Message-State: AO0yUKUFJ0gy3HcnSTeKGCssh94GKhJerpGaeOKkzap0scHt7easiyEO
        VmMYKtdzEKuTPVB7leUi2r7sBwIHDW2R4ug86OF+j3Pp6EnUcnJP
X-Google-Smtp-Source: AK7set9+Cs1D4X7WmBM9GG8sXxybA9CPmJ1iYp1Z46rKWLZjvHhBTY/ITZPkzOH61j85bu1inAVd1NGvpYpsXUl1D8w=
X-Received: by 2002:a05:6102:204d:b0:3f1:53d4:9e87 with SMTP id
 q13-20020a056102204d00b003f153d49e87mr2165046vsr.34.1675585887609; Sun, 05
 Feb 2023 00:31:27 -0800 (PST)
MIME-Version: 1.0
References: <20230204143608.813973353@linuxfoundation.org>
In-Reply-To: <20230204143608.813973353@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Feb 2023 14:01:16 +0530
Message-ID: <CA+G9fYujE69U12-h0jmsQou4Zh_7tzD2q_DkytcZB0pmc_bQSw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc2 review
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

On Sat, 4 Feb 2023 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.231-rc2.gz
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
* kernel: 5.4.231-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 9d36c855cb4a7dd9498bddd4095b51a237b3217f
* git describe: v5.4.230-135-g9d36c855cb4a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
30-135-g9d36c855cb4a

## Test Regressions (compared to v5.4.230-135-gf094cca7f934)

## Metric Regressions (compared to v5.4.230-135-gf094cca7f934)

## Test Fixes (compared to v5.4.230-135-gf094cca7f934)

## Metric Fixes (compared to v5.4.230-135-gf094cca7f934)

## Test result summary
total: 128559, pass: 103058, fail: 3021, skip: 22125, xfail: 355

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 143 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

## Test suites summary
* boot
* fwts
* kselftest-android
* kselftest-arm64
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
* kselftest-seccomp
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
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
