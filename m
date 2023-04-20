Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9FC6E8FEB
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbjDTKSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjDTKRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:17:49 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E904E74
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 03:16:40 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-42e3647a43bso46542137.3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 03:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681985799; x=1684577799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Oe9nNp1PNC9itpMYnM9q0LI6ruH3RY1gwVYjWL8WjY=;
        b=nm8nZXAQ5Ng8QZ2DON8y8jfYYIw7wz7tHREzrfhxJa4UqxY1cCpQXmdX2W18pvJgJ8
         b5onsl68oW8mn8LWjTOOmMrHKEgwrczBoA0oZ1A5EZWKwAXR5SG3ljydvOZgkQIe20Vp
         ZOEaTIpeDhvbhHKYReFCdKXFQtWc2+H4MArzYtM5C/tE6Q+l5f97N0MR7EIP6OiUw03H
         JOFpkJlPMQhmEjxV2KKVP95IXvtMHes0gR5OR6nj706ENRcg1C2IsqGgWeQlP2n+JdTW
         EBhZFs79EGafNbayJZ+wxlWwA+hMg0ZT8gmKu9A1vAsbZTYcNY5JY1woGup6eKgTDUX6
         +mOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681985799; x=1684577799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Oe9nNp1PNC9itpMYnM9q0LI6ruH3RY1gwVYjWL8WjY=;
        b=aVIprn9ACdcg9UpF+zRqnC6JuFFnFEcypuMZz0INgamrRjUh6wKuQR6UsYjpPu96dK
         CY1Ifwty6bC6IEBA+o6HFFOD1y88EDVyY0JQwkgu/8pPQbZapOLsdWjBKfhkYB0D/B7d
         iyVRrm4E148/tT45lj0OiaJ8CH60cRoTROH7fu9kxOLjTN9qCZwCAtWrP148p/jYV9Wf
         jlxZyL71bNTZCkFBU/KdM2bWVrhMFcwEcXNEO1oqlZQfhzP68tb3kc3WK8vpFq9VD8R3
         Y1pF/BzxQ5Uk20ZN2Z4bfsPGf/MK2CRTlrMbIhF5JtlQrEfkwnmpHMlnEfWx07WA8sJX
         0w2g==
X-Gm-Message-State: AAQBX9eoTK4MQrbv9cgnTGB4WySeg6CCU7hhN0WL/ydgSqMw8M77ZzBh
        CgL1mAdytcGNYHIJrJ8xn0tLPuztABdegq2sRdTIZQ==
X-Google-Smtp-Source: AKy350YEEon9wAWEMoJgiPOVsj2z9xphpqdpgfOobKCaAPJv+/irhx+a9rrWFdvz7UTvMPsRzTj1AEh8PIDT+lPhDL0=
X-Received: by 2002:a05:6102:210:b0:42f:f08b:6f64 with SMTP id
 z16-20020a056102021000b0042ff08b6f64mr571195vsp.21.1681985799586; Thu, 20 Apr
 2023 03:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230419132054.228391649@linuxfoundation.org>
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Apr 2023 15:46:28 +0530
Message-ID: <CA+G9fYtrFAgA7shAMpegsoyO2f9KVnpj28aepurx9UzYRBoH9A@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Apr 2023 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.12-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h



Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.12-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 7507bdf58f79a562e3d8c98e1f3c9790f419f5c8
* git describe: v6.2.9-497-g7507bdf58f79
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.9=
-497-g7507bdf58f79

## Test Regressions (compared to v6.2.9-361-g5f50ce97de71)

## Metric Regressions (compared to v6.2.9-361-g5f50ce97de71)

## Test Fixes (compared to v6.2.9-361-g5f50ce97de71)

## Metric Fixes (compared to v6.2.9-361-g5f50ce97de71)

## Test result summary
total: 185548, pass: 158561, fail: 4041, skip: 22637, xfail: 309

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
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
