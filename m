Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970486C47CE
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 11:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCVKi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 06:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjCVKiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 06:38:54 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608C148E33
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 03:38:49 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id cz11so9376569vsb.6
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 03:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679481528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOiN5G93WrfPsM2Jecc460dR5iDLmqy+gypXlUAZy1I=;
        b=YgvfzYUFqiy+iTf/4sQOI8uimJZzDdgLb0I+xiSlbKQFvwZQdBd1U9a9mgJLdNcfmn
         YtUeNoB4MAAteN80DI9FOuSQGcLPpv6nQg5CZCAXGw2gYcjbAH9+QSXKFu78bfPzkULu
         QL7m2RDBluTSLxLpw8ZA19xh4t7w5U3hE85C0xvQcsv5LfNWxObiEGlqrpMygsO8YkM4
         pRNaRmxuZ7eOWi40H7zFSBO4000wQaH+u/PM6FheQrqeVfodpn31DCgLT8V+QsUvfzVH
         5CxR8QEX9p/XxyDwj9LBSVheqrinTKuRmt674zHopPFtYrSAohdh/aIjc0933ohGBEh6
         pyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOiN5G93WrfPsM2Jecc460dR5iDLmqy+gypXlUAZy1I=;
        b=TRHAyrb14r7J2dDBWHTNCHQ2+ssiHtaYzop9+8HUpIou+ixfl+zubItY3FSEIfxa/R
         FvOUmqZ8VtUA0e+bNNr3q5oz/vYfcr4isV7HW9kaODH8h7DOqHEwT/IOTG289wHzc8G0
         OlaBmbziaCGm1/PriQMvdybX8eZdgxjzonF48EfoMcoxTrCBXvQ89gTp68CVK/AEbSN9
         YJfoyNg9yA734Ul4uKmupGFqXhvaLL1bWLcZW4KcRwmv8yEvzPyWaUgzP4LnGTyjhIkX
         7DeT/swsWq3ci1IXkqujP61XXgaLor8QylwFdnUZdm2N9laPZSe29plcepiAPV/EOoZL
         RigA==
X-Gm-Message-State: AO0yUKXh7hnvglQGkECX3O7W00gtScGKzdQap+s28TdhSGbYuBQqrcgt
        ovUl6IoSrmfx8bbedjbgfkzqsWcB5KHO/6LlGSCIdQ==
X-Google-Smtp-Source: AK7set/5W/bqhxB0kdyABAYudu1GFKIqmHXPZv3ZQNcZ8b6LlpKu4UCO7huf6zKH+hNmbM6D0gBh5fEtpcymadeipcE=
X-Received: by 2002:a67:e00b:0:b0:425:d255:dd38 with SMTP id
 c11-20020a67e00b000000b00425d255dd38mr3313118vsl.1.1679481528233; Wed, 22 Mar
 2023 03:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230321180749.921141176@linuxfoundation.org>
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Mar 2023 16:08:35 +0530
Message-ID: <CA+G9fYsG6d_A_yGQAixYTA2Wh2cowf-UQJAY=RRWnEzFcLAHCQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
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
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Mar 2023 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 18:07:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.8-rc3.gz
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
* kernel: 6.2.8-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: d9c239ae1a56ba4b39f4783b8d025cb7a75b2751
* git describe: v6.2.7-215-gd9c239ae1a56
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.7=
-215-gd9c239ae1a56

## Test Regressions (compared to v6.2.7)

## Metric Regressions (compared to v6.2.7)

## Test Fixes (compared to v6.2.7)

## Metric Fixes (compared to v6.2.7)
s
## Test result summary
total: 196699, pass: 168689, fail: 4397, skip: 23223, xfail: 390

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 143 passed, 6 failed
* arm64: 58 total, 55 passed, 3 failed
* i386: 45 total, 40 passed, 5 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 10 total, 9 passed, 1 failed
* powerpc: 42 total, 39 passed, 3 failed
* riscv: 30 total, 28 passed, 2 failed
* s390: 20 total, 17 passed, 3 failed
* sh: 16 total, 12 passed, 4 failed
* sparc: 10 total, 7 passed, 3 failed
* x86_64: 50 total, 49 passed, 1 failed

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
