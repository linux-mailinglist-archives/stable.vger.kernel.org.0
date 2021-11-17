Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A4453FB3
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 05:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhKQEtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhKQEtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:49:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D582C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 20:46:33 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y12so4885490eda.12
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 20:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lOv0r/ATI6QLRS9u2BPh/qJgTiXnU5Aqk78bm8xvf4Q=;
        b=wJ2T3Kdj7HQBri5Su5jivBbDLnVmWQZJCbdu6JQtuOLnmrWE+9tlzgOFI8sEYEaJuu
         FgEGdTo4uILEvPd8qve6lpTXmm3wTzh94gO3C9bFo8JHIX5/rmYR0n9egLQUSyb0YTZI
         P9lPfbxgtS9x3hTey/8Okqij0pbnJCl7UFeMFSuQjiFnaNfFyLq71xnTJNGxjm9er2aU
         dAu10XVk0AL/3Z2lYtDc+KaEi5E7kghSQ2nd4lT+7zMgL7WhEHFTr/c5FfnLkKL8GbNU
         010AlmPL7falenUfTfsvPr9vpfaEo2IAMZtpZr1x7bh2t8ai8Z2CoTrHvByCF4kSvp2u
         /ObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lOv0r/ATI6QLRS9u2BPh/qJgTiXnU5Aqk78bm8xvf4Q=;
        b=2iPUVUvanfZiigN7Yg2iA7+HMj3GeM+X0kl/q/QWJv/jXi6tC7veRKFyxRqpK+QNLs
         REYrdqoAXHrA045SBOulf0xYLWgYttFSjoXb0zvEpNHNRMJajggG8I7rdWSmp5uycXJG
         e0TWy89NqO2G/GuodPrTDXcliFNv6LVJ8LRblWwY8M/ANToLRKQC/7g7InB43EytD/wo
         8VZth9EsO57C2RBtZFyt594G5wmM5tVs2CtCthq9NgN8qSaGXNEoS+xXra7Dz2FO+Rj9
         YbMQYn4FNbwujUw3rSCyEUpzfWzsAtZ1Sr4MEDq6dPCXDIeyYv8LGuydGiOOjuzsnWNw
         OTTA==
X-Gm-Message-State: AOAM5337BnI0JnFSLNvcJu8MJeKTfZ7pblLX0qX4gCF1I6WfJ8gI4AgF
        O9KDSW9zghKC7qRzWIllVyhPEoyIPlyt1VPKmeR2SQ==
X-Google-Smtp-Source: ABdhPJxp8RlnOAtTIaDvQqNStEn5QFzp3akaLfqifKQLlRc9gjadU/pv7Khe8+iih424Ix2251jvlbe/MQZjGGGBX3M=
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr17960634ejc.493.1637124391477;
 Tue, 16 Nov 2021 20:46:31 -0800 (PST)
MIME-Version: 1.0
References: <20211116142514.833707661@linuxfoundation.org>
In-Reply-To: <20211116142514.833707661@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 17 Nov 2021 10:16:20 +0530
Message-ID: <CA+G9fYvPQE=A+qfn8CcPbU4ywz9KzW8_iiXxgGEpawAXSxT38w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/353] 5.4.160-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 at 20:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.160-rc2.gz
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
* kernel: 5.4.160-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: a24b83ec1134f1e2472df24989488b0dc4e134ce
* git describe: v5.4.159-354-ga24b83ec1134
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
59-354-ga24b83ec1134

## No regressions (compared to v5.4.159-356-g25f79f19e14f)

## No fixes (compared to v5.4.159-356-g25f79f19e14f)

## Test result summary
total: 84613, pass: 69739, fail: 779, skip: 12698, xfail: 1397

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
