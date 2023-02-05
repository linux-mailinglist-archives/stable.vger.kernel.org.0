Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA09668AEDE
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 09:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBEImI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 03:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBEImI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 03:42:08 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7D9222F0
        for <stable@vger.kernel.org>; Sun,  5 Feb 2023 00:42:06 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id j7so9692765vsl.11
        for <stable@vger.kernel.org>; Sun, 05 Feb 2023 00:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3WSvLiAEDdvc1pRKD7l9k6PhsyRBAsv121S6tLVwPU=;
        b=FOdDLJxEyhkl03bWbzjeZkoZ9A6XjX411axCfeAxP3GonwoQnzt2B1BplAlpi39tFn
         4vQp9S0RxlH+hf9uWwaXPYe55Tp5dV7mOLdtUMhYDXhfYOCxIxiejbebCQ8UgnTl50eQ
         H8uJTuzEK5idv/FtyeuWzNSV2kZ9s0Ykb9db7bZ0sc66jyhZ2TQaU/s1Aq5xYQzlA6Y4
         mmhuFJDaLJP43UHQzkKSDJbulRdn/N8lwKE6fz9FbcdSIW808ZTe55FFLKD+99IZ3wIX
         Bo7HO6C/LkysovW2iTZFb7PbM1qETNpOk7W4gShSoJnvJ+sJauh8NW9mO59V2A1oEocs
         dlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3WSvLiAEDdvc1pRKD7l9k6PhsyRBAsv121S6tLVwPU=;
        b=t9G4OFGAxNN0ogC7diODp42KYEtd3ce9XhJYB8PVFVV64rn6K4fDlVQ+fCziIVZTxm
         iTB1yUtiL9LPd9GDQuo3kLJJ7RFoIMZm4u3nUauJVAzAkgFmXgLSFJtc1iFFDzB2nl3S
         rjR24oYW4SiuL5u0Ov/w/Q9Au64GQHHwJ+n/6a+gcbAxjjJ3nWGTh26wIwHH5okcV0Ve
         j5Do1Frt29SuwGylRqPhSsNX3UK+US1mUvrkqQAwpnkAqFNz5oWR63LepiCmlpFLg8t6
         vszuWoIvNPgvAJFJ50SxPNG5YWxv7MGjBK2FgzkmsszY1ikVoQrQP9oDQwXUymjFsVes
         Jdnw==
X-Gm-Message-State: AO0yUKVt/KlbtJfsKsnv1YceMuDbFIxmxpFKS9G+CFnZjb1dpOtw/ICD
        CixZziJzZCtAY527OORvla3ekgbpW0svaxqC7nZ6Ag==
X-Google-Smtp-Source: AK7set8M9uWwXVvCqF0IBhFBfdSf7R2hW/GD5Mai14e9HOLKenWOcjXeeJe/QrFgN+hdUGfyMtV4yPyQTKu4Z2mhkYw=
X-Received: by 2002:a05:6102:3fa5:b0:3f7:4e35:cdfa with SMTP id
 o37-20020a0561023fa500b003f74e35cdfamr2258436vsv.83.1675586525533; Sun, 05
 Feb 2023 00:42:05 -0800 (PST)
MIME-Version: 1.0
References: <20230204143559.734584366@linuxfoundation.org>
In-Reply-To: <20230204143559.734584366@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Feb 2023 14:11:54 +0530
Message-ID: <CA+G9fYtfPDRFDCvPrW+So85XY80=QGS6mXSMDa5V3FphX6VWpQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc3 review
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
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.272-rc3.gz
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
* kernel: 4.19.272-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 84a0c172d04c64ace38743c8f5b0203e20df828e
* git describe: v4.19.271-80-g84a0c172d04c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.271-80-g84a0c172d04c

## Test Regressions (compared to v4.19.271-80-g825071b614ee)

## Metric Regressions (compared to v4.19.271-80-g825071b614ee)

## Test Fixes (compared to v4.19.271-80-g825071b614ee)

## Metric Fixes (compared to v4.19.271-80-g825071b614ee)

## Test result summary
total: 112407, pass: 85327, fail: 3218, skip: 23521, xfail: 341

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 321 total, 317 passed, 4 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

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
* kunit
* kvm-unit-tests
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
