Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729F76CD0E0
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 05:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjC2DxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 23:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjC2DxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 23:53:05 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B41721
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 20:53:04 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id d2so12220977vso.9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 20:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680061983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWG1N+zyaRXNS817+JxirvhNvLjC8z+Uk0Ll74FpTtU=;
        b=pvHY/1n4hHCEbNAON5jo7vyuLegwBqPFqb9c/kgyowAK5i42qsCes+B3pOvh0PbHA3
         BdmNOGgfFeqYXf1FoFv/e1GaQLS7nqhjgZvxHPmp5fL641e48tuIEuRNPx8u0HvGM7KC
         QrPuchp7bA1lr3jWAQ/L4Eo4AaUVUaUzqRXKErUbZb5DxE1iseekeMJA68u0VZ7QwLXR
         o7Ne8h1VtdlgpXguGB3Jc9izi9F5vjJz/BNO7vLv55l/16kpOwNbCqz6UptuOfGBgo9r
         WA7kjgtDjmNeeKtI6qdV8cDYP9lJrPc1LGpKX71sEqlrEmKidev251sWzk3FWn35rzh5
         J+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680061983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWG1N+zyaRXNS817+JxirvhNvLjC8z+Uk0Ll74FpTtU=;
        b=riuVOMIo/wTWxSy+aYKpSupW9Rr+1TfwgXuMmUdoMcL+PB93KoarnArnj7ryv5eqCD
         B9xL3vOgMKdSU0XWZMLQPyPtVk2YqmOvCHZaGOjFsCyUUs1IPhDOSWkYjzdxZ2cNIuNm
         wyYcOvVOSxbXxtrnHJLfSmn0jlgYR2RXkEhbzqZ2u0XVattIG8ffwcEBctNPTW6bPYyc
         hSM0CNFZ0ICbp8qVp+ox25jdlR/WS1iMQrmR5QX8IEUHb50bTamtiHSDJpp/j3QA4iG6
         9NQFosHkPKYONPJHoyIjidFs6zDOYvXdcalzSgTf3LF2u1Q1pvfboIwsdZLEi3CQyaIq
         CRcg==
X-Gm-Message-State: AAQBX9fK5M5XSu2Fr404veUwz7Z2NrdBfPF9XQle+WOgGVkuMaor6guq
        HOVfCCtl5AaCwXBiI+JXkClPvRPULVQPW+6RkGshCQ==
X-Google-Smtp-Source: AKy350aU50RVFZwttkiznb4TqjRW56mfkqxoDmdI47ILe63HR7eFdwYFMitFAU0jBASctzs7c53Pae55m+izMgm35nQ=
X-Received: by 2002:a67:c802:0:b0:416:2ad3:35ba with SMTP id
 u2-20020a67c802000000b004162ad335bamr10503427vsk.1.1680061983310; Tue, 28 Mar
 2023 20:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230328142602.660084725@linuxfoundation.org>
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Mar 2023 09:22:52 +0530
Message-ID: <CA+G9fYvzm5iZFkSVoswK_XN5SB7-k803_RgAdM2crrwMRLDWiQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Mar 2023 at 20:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.105-rc1.gz
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
* kernel: 5.15.105-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: ea115396267e89b54136b19bb93bd16781a9d033
* git describe: v5.15.104-147-gea115396267e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.104-147-gea115396267e

## Test Regressions (compared to v5.15.104)

## Metric Regressions (compared to v5.15.104)

## Test Fixes (compared to v5.15.104)

## Metric Fixes (compared to v5.15.104)

## Test result summary
total: 141325, pass: 115971, fail: 3742, skip: 21383, xfail: 229

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 42 total, 42 passed, 0 failed
* i386: 33 total, 31 passed, 2 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
