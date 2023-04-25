Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6B6EE0F2
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 13:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjDYLNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 07:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjDYLNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 07:13:47 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2924B133
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 04:13:46 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-4403744aa44so2126164e0c.2
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 04:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682421225; x=1685013225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93dXe5MGpSc5fed6Fjsx0gENfCmJpSkSMYV5KcxSt9Q=;
        b=rH5qPRvzcBkmEjA9OrixklL9mmyRZ93ThHfXowcyrqRk2wx08rDoJ+inLKlo+xbMY2
         INESeuDhPJjjasspazwFkTWSx54hjYEWH5uz3oclgpFAbSWU9bajSBkkVwIxYzGGHE6l
         ssBkeKF81rILKQmYTAcQZJCHVntyQ0lMBGAoUIsCMX80hcUUsGZ2Kn5bb+BOUFApErOX
         46209TOt4qJ+vTEV7ntCnA3Xf3a1+sdoSvnimKXtrWGxHdR67vvMdc9Sgu0GkFK+goGc
         B8eBcFWqVIo28du8F8XriENtet6rnNyMAXywvzZygYm2RDzxvfYJzy/Wv3Agm6AUixZJ
         UlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682421225; x=1685013225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93dXe5MGpSc5fed6Fjsx0gENfCmJpSkSMYV5KcxSt9Q=;
        b=JYU4VAuGVWnabRBWm5Ib2dH05vmZX7zSk/8ialwm7lLJ8y07xAPy9ubI5nVQmGK6dL
         yMI3To7L3mS4ClWdUJvu8KXI9BsXDoHl8Jk6zRET4mUL5gz6gDuBWUq9KsOqa5q5GcDm
         8SCemJ1uZ0/p+FssFqc5iQEazQwXMAC16bKL7i4rCM+oSTiw7rC2nC5Uqyxteqf4GqGy
         0MJND+1Bn/ZFsRCxGJ/JPKLmrP66BeUZeasjzTGXOgpFtIh5XubmEGO4XTzfTYBsZcp1
         fNXAZ680vj0OgF+hB2TGN0alOTzJMKLMs5i72PU+VnRi4pIVrRA6c7HYtoxN3u+d47BB
         XiSQ==
X-Gm-Message-State: AAQBX9c+JUFv3guPhDt0d3gGqX9CRdZfsDVzdCrMPBotOywLbLfG3Jxk
        VVjAp7N0ybbmEr/VORc8cIg+U/HFj0uNZOp7t+aCSA==
X-Google-Smtp-Source: AKy350amCuilSr5bPCVSIYXv3x7/8EBQqYelQcUkNKz22Tsi9XU9FHjXiiEq8ydl8olMxCtDjj+6e5ECvj7Uu5Bs9uo=
X-Received: by 2002:a1f:43d1:0:b0:443:ddb3:1512 with SMTP id
 q200-20020a1f43d1000000b00443ddb31512mr4380394vka.3.1682421225077; Tue, 25
 Apr 2023 04:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230424131123.040556994@linuxfoundation.org>
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Apr 2023 12:13:33 +0100
Message-ID: <CA+G9fYs=S9B1OcpmXcA_LPY_mX_Bke+72a7AfA9o00VzCrBhtQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Apr 2023 at 14:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.242-rc1.gz
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

NOTE:
----
FYI, This is not a show stopper but worth reporting.

As I reported on stable rc 4.19 kernel,

Following kernel warning notices on stable rc 5.4.242-rc1 from the
previous releases 5.4.238-rc1 noticed on arm64, i386 and x86_64.
After this kernel warning, the system is still stable and up and running.

This kernel is built with kselftest ftrace merge configs with all
required Kconfigs.

[    3.273073] WARNING: CPU: 1 PID: 0 at
include/trace/events/lock.h:13 lock_acquire+0x142/0x150
[    3.273847] WARNING: CPU: 0 PID: 0 at
include/trace/events/lock.h:58 lock_release+0x1d7/0x260
[    3.273847] Modules linked in:
[    3.273073] Modules linked in:
[    3.273847] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.242-rc1 #1
[    3.273073] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.242-rc1 #1
[    3.273847] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[    3.273847] RIP: 0010:lock_release+0x1d7/0x260
[    3.273073] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[    3.273073] RIP: 0010:lock_acquire+0x142/0x150

log:
- https://lkft.validation.linaro.org/scheduler/job/6288834#L860
- https://lkft.validation.linaro.org/scheduler/job/6373719#L867

## Build
* kernel: 5.4.242-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 00161130fc2321eeea08f3a2ffacfa653e685d5a
* git describe: v5.4.238-239-g00161130fc23
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
38-239-g00161130fc23

## Test Regressions (compared to v5.4.238-199-g230f1bde44b6)

## Metric Regressions (compared to v5.4.238-199-g230f1bde44b6)

## Test Fixes (compared to v5.4.238-199-g230f1bde44b6)

## Metric Fixes (compared to v5.4.238-199-g230f1bde44b6)

## Test result summary
total: 135130, pass: 109048, fail: 3400, skip: 22432, xfail: 250

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 143 total, 142 passed, 1 failed
* arm64: 43 total, 39 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 10 passed, 2 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
