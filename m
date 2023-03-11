Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C416B58AB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 06:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCKFjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 00:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjCKFjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 00:39:04 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42522E8439
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 21:39:02 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id r7so862935uaj.2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 21:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678513141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtTOaJXJFIxTutKMBRL4Tmd6aYY6I5kNoGgR+eC6gcM=;
        b=MtrnFD+OzINsyL9aj8JIFAqmxRlf/ncpWk4E7LB+EQCsbSgIGuOf29LOddOJmk9JZT
         zFf1Hy7Y8DmZiKj5G4ysXMuOTnmd+CkRmOk0daT1wPJn2RCKrfpTRwf6kYmiSEWGDIGh
         hS9SNfq5clb555FiKGIXaRwzpjCAyA3ja+7X7DpAJpU2QLT4t50RnAQ72t6J8HrB8TQa
         yD05wDELaDKOa4D/bL+HX4uzRTZucRXAiGF/toeaaGu7v1fzex2WTy+RfZb5hO+t4gcv
         M7HUKbd6rbuSV6tD/HWCKcJz6WJopw6QzrhHk+KuJcd/PEka9A0EHU5ZDxUpOJYaFMQ4
         gnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678513141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtTOaJXJFIxTutKMBRL4Tmd6aYY6I5kNoGgR+eC6gcM=;
        b=4Xz/A6sy8CLIUDF7D3B4V4eAByHW/iqIc4K6hTst2bfG5zEIiej8Rdu4KGpn7ygPk3
         ZZFv1NGqptr/mv3LDWtCYuDs9GT/eaThdpe31qpKhoheWpd230Czt/vD712azwhNkxNv
         4fM9NPkElQeuQlWkkmah9Sml+0yEnw9Pxs/l99GMkNOqg6bv9ICivOTyIJI6P82P8Fpe
         t+56SC8+IbGFmefPTC55yixo77w2vBM64JKCfMyOd4zTx13SnQ+hyJKxHHAI41kbckxR
         I0WkWXGDgT/2Vxek5YYn24JYvyhCcJ810iIDeAklxqF1m/MyKU4RDY+A0nbs2jTw8YYa
         Ejcw==
X-Gm-Message-State: AO0yUKUtiP3Op8xqsXVLow4fP3JDpkPqPGYY6Ly4MvJL7l7Z21sU2ZYi
        Uh1QSx+KbYpCIGhwcztA3hQtGh+Bi4OgoIB9dty8YA==
X-Google-Smtp-Source: AK7set/klKpLMuSG0kNbXd8n+bIQNOmP9UmXF0n8L8A7cnrwqkAWU2LMwwMUBU5AWzbZdUiU78wH5+GWZeZiXBA01dE=
X-Received: by 2002:ab0:4a05:0:b0:68b:6325:4061 with SMTP id
 q5-20020ab04a05000000b0068b63254061mr19829618uae.0.1678513141165; Fri, 10 Mar
 2023 21:39:01 -0800 (PST)
MIME-Version: 1.0
References: <20230310133718.689332661@linuxfoundation.org>
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 11 Mar 2023 11:08:50 +0530
Message-ID: <CA+G9fYvq=xM8eKEhCDB0A_OCZq_rgw2OOLhGkpgvUaub0SE5PA@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Mar 2023 at 19:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.4-rc1.gz
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
* kernel: 6.2.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 54d58d14b95c4ebd0d562fb22a86a3696f6b8557
* git describe: v6.2.3-212-g54d58d14b95c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.3=
-212-g54d58d14b95c

## Test Regressions (compared to v6.2.3)

## Metric Regressions (compared to v6.2.3)

## Test Fixes (compared to v6.2.3)

## Metric Fixes (compared to v6.2.3)

## Test result summary
total: 197897, pass: 169533, fail: 4900, skip: 23464, xfail: 0

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
* ltp-math++
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* ltpa-6248579/0/tests/4_ltp-fsx
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* v4l2-complianciance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
