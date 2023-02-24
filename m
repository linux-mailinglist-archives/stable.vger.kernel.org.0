Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B8F6A1C0B
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 13:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBXMUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 07:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBXMUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 07:20:03 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE7B5D45C
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 04:20:02 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id a3so8294044vsi.0
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 04:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1e7HBrcZISq9fY227NGZfONjmoTlnLB/Lrx8tVCtuk=;
        b=CxU2+5WxcZ6rhvtBs/kHBSfLnoy/TB2t5slbyRCsm+iKONx9cS9AxKWyHpZg89Tawp
         mOcIAAvzlEwrNmjh/VgCdNAHKsISLamAHtbE3aOwyj8IqU9YHM3weKfyp5q30VZf8I/I
         WV0ykFI+arqIcW1wmnlmxMVaabuxg2mU0TqFxRAL5YzY3sfAQ9xMt5JHxUCIZhQfAFXW
         Ss5zHyRn44sUlvXdLD1RgfRbHh0JJUVepDftIYX5WSVOTi+G+4Seb1J51Jb/u9La9wI5
         nfqVjtHFcJa0T/Rfgl+7Tgxg8etTueVvOun93Ozj3PxQGtcmX5dpBqLlO+p1eXXhDV1d
         4OkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1e7HBrcZISq9fY227NGZfONjmoTlnLB/Lrx8tVCtuk=;
        b=Ea/Tb9+sGBnSdLShPQSLYR4wJlymVYZBINXG0XeXanfyr3Sla0foRJTKhVujkH4WYT
         3VhgF6A8wgUlQcCqwrx2MZnMqy5hHD8mWmzmpG3Z1BbhjIGYjxbUsJ22OLXqBK8XikIT
         o6UGfdbN73sjLcoz76uciRadXj2RtJtqaZRcDH8ByalkN3UpJkrKvJtpY8Drz/yE6y+H
         EKaCcC0dWTcbLUz5leKiV/GsAynVoPzLmcdY0VheWQBjHRFVO5LXzgUxfCLngc1QdPX+
         KqBysOaTHLjsarYUKz2gYTSTz14P2QSAaBmAqVvk2TupT3nhPmhF9LoARI8W+uabQ/Jr
         RoLQ==
X-Gm-Message-State: AO0yUKW0IhfC1vvaLw3HMLZ8ntfIJyx9dCXHXDaEXVlby9Mn3R/Hp4j+
        kKxQOsrQiSRX/nPOizoP7Sbj7wMXCgntKWGPoquDKw==
X-Google-Smtp-Source: AK7set/vPhs6PKjfGGjzmHiL9t8e1WIPdNx3MnAfIWuhS+6njt7Y2gOrJmu9OE69X75WJaK4oNdlIAO5odmwp8YJ6XE=
X-Received: by 2002:a05:6102:31a9:b0:415:48dd:e0b9 with SMTP id
 d9-20020a05610231a900b0041548dde0b9mr2219853vsh.3.1677241201264; Fri, 24 Feb
 2023 04:20:01 -0800 (PST)
MIME-Version: 1.0
References: <20230223141539.591151658@linuxfoundation.org>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 Feb 2023 17:49:50 +0530
Message-ID: <CA+G9fYt=mG3NPVxgxx_fivWbS2iMMOEryLqN03GjWJjwA_cZnA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
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

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.233-rc2.gz
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
* kernel: 5.4.233-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: ddf919a8b201b902ac977fb211a0191fcd2069d4
* git describe: v5.4.232-20-gddf919a8b201
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
32-20-gddf919a8b201

## Test Regressions (compared to v5.4.232)

## Metric Regressions (compared to v5.4.232)

## Test Fixes (compared to v5.4.232)

## Metric Fixes (compared to v5.4.232)

## Test result summary
total: 124351, pass: 102308, fail: 3201, skip: 18487, xfail: 355

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 143 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 10 passed, 2 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
