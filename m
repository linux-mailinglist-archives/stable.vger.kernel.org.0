Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456D549C840
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240442AbiAZLFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiAZLFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:05:15 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3ECC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:05:15 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id g81so70222241ybg.10
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UImJRfhvqAzf1Dt1yTwW4tv7UXuP3UpAdmLGwD1ulh8=;
        b=O+ngrIx40MwPukAJqc17VwT5ioFLl/rdwUMT0KxlhuYCPe4gXjjG/inxGzKzvhzjUS
         TFBJmvEv/pQldqM55LUpTjcxpqQD3WfhpS6WAdacBU5rdteotJBcRm83YHuMHGj7Ica5
         3hDHwZKMVuYx8xyA8nesYse5JOMcQmJvuM9lIN/HPn7g1aXo9vrNNlOO5HHGgW+38hq0
         A1aywNsuDXGwJTF5BZkBdEnCzXSBX4KoyFjVOx6ArAqbfZfALjL//VW+6tLchIDwur0j
         +LDOb1I3mz3pWJdwYP7cIb+iQM/yy58hOWoxhA8aJBr6vfVQ7iVDjbO3i7XENZrR/zvB
         A9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UImJRfhvqAzf1Dt1yTwW4tv7UXuP3UpAdmLGwD1ulh8=;
        b=eDgNw5uf2glUcCYg9dfru8iDxx4v2U9SNFSfQR7nL+L/TKB3K6f8yAuzR4JgJhX092
         lQd3lpA7re+vWBrc6Syvi3vViFZL6yyNOwZQDK1M2B38a58IpogAHf8okhapfL7JeVec
         kT3foPgun0g+CyXOc9AKxJ8lR0rI2MsaEYDjXdJMvY7bp3p1pVEDir0VUlQz6PgnlAIh
         WHp26SOW+JAwgu/uQCqDe8vNmuakmfkU4ZIczkaiwSC10RdKKEdv2dKOM0hLVnpNDol4
         e+2f+4VUUWUffNweo+1Y2NNmLUIkYzyCMVEmuMl+rRpluegRPixvDdK05KW1iIgs6hCk
         hEIg==
X-Gm-Message-State: AOAM530SlYnUtwSdDYxz+ziN2fCBeq667BqoD3uAT4zyXIyKPtm76Tcf
        Eq99uykSN4CEIMbYGtO50Hs2HsI0w0BlyTZR/7d8LA==
X-Google-Smtp-Source: ABdhPJw0PQ/y392CnugHvY3ZFSGzOw9puRyRMDyTT6E2ZH1vbr7ChoNZPsKjwap1b6dTFMPkniv0A6Ej0qzauw3DC/U=
X-Received: by 2002:a5b:346:: with SMTP id q6mr36352306ybp.704.1643195114350;
 Wed, 26 Jan 2022 03:05:14 -0800 (PST)
MIME-Version: 1.0
References: <20220125155348.141138434@linuxfoundation.org>
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 26 Jan 2022 16:35:02 +0530
Message-ID: <CA+G9fYs-DqzMKpPHkO5xATRdBw30_XSUhsVV3US00RcPTgVMWA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 22:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.94-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.94-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: f32eb088b1394f3a0df66e84e55ebdb8132dbe7b
* git describe: v5.10.93-561-gf32eb088b139
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.93-561-gf32eb088b139

## Test Regressions (compared to v5.10.93-564-g822f7d03ddf1)
No test regressions found.

## Metric Regressions (compared to v5.10.93-564-g822f7d03ddf1)
No metric regressions found.

## Test Fixes (compared to v5.10.93-564-g822f7d03ddf1)
No test fixes found.

## Metric Fixes (compared to v5.10.93-564-g822f7d03ddf1)
No metric fixes found.

## Test result summary
total: 97073, pass: 82752, fail: 623, skip: 12779, xfail: 919

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
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
