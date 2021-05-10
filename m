Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A53796F1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhEJSVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 14:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhEJSVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 14:21:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C2C061760
        for <stable@vger.kernel.org>; Mon, 10 May 2021 11:20:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n25so19839769edr.5
        for <stable@vger.kernel.org>; Mon, 10 May 2021 11:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c3QbbaRgr8o8EX1t84khRzMUdSHXWmV3lu/xPgAS6HQ=;
        b=Xw2LrNe/QHmdP61IQs4q6ounUN9gzRRTYXyIU+EIzwyOeNb6QMY//7TSoMbvb0GveK
         oujKlv3QVYbEZ/uGDZseTxmnIkCaxy/biI3oHuOLlNJZFaTV92N5r74G1k6qe+WU6bMS
         oOwiYVVHg/9QTBFjxHj+Q0UzLnkLB0Nw3WfoQbdYp3LGMJUuJJGdg1G9kY/CMh7qQAzZ
         /GY/ZnVHpAjm392cpmH/NYv+9cBjfCUnegz+9VEtiNbvnAgxXUjzrqPy/W69fikS4sSq
         8FuAMxcPwGGto5nfi1FuHATQhFAigY35becQxj33IO+KY9GreRXCOcdXTYYyiM4L1o4r
         pvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c3QbbaRgr8o8EX1t84khRzMUdSHXWmV3lu/xPgAS6HQ=;
        b=Tt70pstDiCb8JqBVRh0aQ5vb+RjIyV498uapY+2c6ljwSdxW+zh7DnV3KPaxMi+ayY
         i0DjI6/97J8DSeXtKJ8yiX1Uk1QNTt9lFxUzpXZ4k+OifE1bLY0uyY6+DDPbieoJfrtj
         DL6rQs2I0kTHowZ7PqjTBTjyJB+qpX2xqgKdBme/oXnEhBfS8JXacyKQOSe83rheBWIF
         O0gk+X2fSQAggAOUaz2pn/PJIPaMcT1GAUqR1w7w+Qv2LVqkPWXHHrUpkAcXq49XpY+h
         KGyGJID/H9zzb0vc55dRtHOvT4e7gl4RI3mOa2IcJw24SNQg+RlofqKCa4mnDuQGafwu
         Rzvw==
X-Gm-Message-State: AOAM530B0wwXjnGkyBEbXequ61TLqESHe44yG12LctodgGBUXK4WagAC
        8Mxed6/XV0E0yO1F+shzrJaG5DqNwjCeQD8OkHvI+w==
X-Google-Smtp-Source: ABdhPJw0L5zSdlCIMQlwgizUs6glrL2uuSyaQl6assfbZbOQ2AZjRygRJy2bC1a6GIYwafty8jugzuHhWolJoRhK2l4=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr30703281edx.52.1620670809825;
 Mon, 10 May 2021 11:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210510102014.849075526@linuxfoundation.org>
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 May 2021 23:49:58 +0530
Message-ID: <CA+G9fYs00AkMdMJ33ysycLH5_bpc6G1VXoGQQ1_xr1tAv=Vu8w@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/384] 5.12.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 at 16:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.3 release.
> There are 384 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 47db4685df6206a3e39f7d56d6402b56e151373b
* git describe: v5.12.2-385-g47db4685df62
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.2-385-g47db4685df62

## No regressions (compared to v5.12.2-284-g66353c8ef656)

## No fixes (compared to v5.12.2-284-g66353c8ef656)

## Test result summary
 total: 76372, pass: 64454, fail: 1319, skip: 10599, xfail: 0,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-lkdtm
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
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* kvm-unit-tests
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
