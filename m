Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594C66D7415
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 08:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbjDEGC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 02:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236833AbjDEGC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 02:02:58 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F9D94
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 23:02:57 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id 89so24893585uao.0
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 23:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680674576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ndgn/iJqx5H0ygZB2D9YoJqpZd2YRXT7dQHVM0KIKAw=;
        b=Ek/YX3pSomZMmkS15XIviXmWNi5yRYacSg7QjhKFWM0LyhDTprZ3vf2Wxxv/y72HBA
         T2zj1YlVHoGXcgvarFxsv4W3Afug76ek9AkLPcj3LnLJ3JKqjYGvOtgRuqTzRDB0bD23
         UN9StbobxfNEC3uGztcMo46mVNzfP0kwuYb+a2WfmmOu4LrCLQxuZO8LVAXR+nFm6oNz
         siSO4ymrjySvxyJM/BOfKtdvrqQC3hID4eX8m/W7b0EQHm94iV7tkKJ7gp3tgCrlgs7f
         jAxOHfrq45hnt7aQYp35Fe8Is/IxSU/IntnP5T3gI/ZsStY9sSi8jteNa10P097D8zQG
         XkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680674576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ndgn/iJqx5H0ygZB2D9YoJqpZd2YRXT7dQHVM0KIKAw=;
        b=aggiszhdDHJQzQLIJqF1V5NZW0KuJ4GZYjSFf/hOl2bgDlXavRuJofIHQvNkEw7AAB
         NpHvK3MSHl1Hkzs3BZB0St+N5SWy4k5CUHonxc8L+VfrZVpAqVDEcHDYNDoJ/lq4h7Qv
         /doTT38p67u3wgiLFtdqE/8KNz9wfR++Mik54Gv+cs7xP+zUTyuk+D2tMQXLLKZtLhqG
         sbTAa6sQGyIq5RveVDDsscWwgXqQsbMfLWlofqyQN8pRShV7OsgJxDvYrBrio/wOei0F
         5H82HLcE0bMR+3w2vxld/Jud1Vy6BXD9cavWVkhBBIJq77uNlkY1CP9hljrIlwo6PkoY
         OkIw==
X-Gm-Message-State: AAQBX9dIrtKWbKsClfxkWr6TwDzTfZUTDayettaP5YDHob7GkX/thOJs
        ns5/Q4yUaif/mROO1+5M6kxoi7Gsl58EzFMCGGGOZw==
X-Google-Smtp-Source: AKy350ZaQVVS7mIObHamuUjfMiBRpWoXccmcj3C/uuYjJdv9uXXLPvy3VSIpkrngUh913jByp72WyRp2Lrp3ILJ3it4=
X-Received: by 2002:ab0:4744:0:b0:663:e17a:e5f6 with SMTP id
 i4-20020ab04744000000b00663e17ae5f6mr3139596uac.2.1680674575935; Tue, 04 Apr
 2023 23:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230404183150.381314754@linuxfoundation.org>
In-Reply-To: <20230404183150.381314754@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Apr 2023 11:32:44 +0530
Message-ID: <CA+G9fYs7n3E8nf2vQ=adBcEtY4-5JBOfkzK+NJ7jUOmE9CGoqA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
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

On Wed, 5 Apr 2023 at 00:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.23-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: e7511568ce95fadd2a8f6727b0ace195f8149d94
* git describe: v6.1.22-180-ge7511568ce95
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-180-ge7511568ce95

## Test Regressions (compared to v6.1.22)

## Metric Regressions (compared to v6.1.22)

## Test Fixes (compared to v6.1.22)

## Metric Fixes (compared to v6.1.22)

## Test result summary
total: 165387, pass: 144091, fail: 4259, skip: 16695, xfail: 342

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* ltp-controllerllers
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
