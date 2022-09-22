Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B795E5EBF
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiIVJjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIVJjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:39:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDA1D4A81
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:39:19 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b35so12816615edf.0
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=g212aaB9s6G5YiOKra2HHbgqzyT13URpuJ/igvRQHVA=;
        b=DqnMyJ0WSh26epyzfZSwELrKFrk/MoIrsyyrYvn5MLMgwJGe6kyZybBtUiUdY7suoO
         FLcD2c29S8QRULTKpJOwmH9JJ8hcRsfzkk/ncVl+i+mtKcTP0gb45f75oo3eCmeufngb
         h4/boH22JRwrtL9KDPquWyNyEs0MAqO9LFvvpQTjXbwDz14i8rU8Hq3b0ohRDqPZGyY/
         GNrSeYJJrXbSLqIpqf1/iasLBI36X5Nxxuu4DXmRZFi00B8jp+2MOSV0cqs/TJw/9GkQ
         82j49aUhwwcY35ibLBTFOPhwkEQLmy2BOGCaHw+TVpLpDTuMbglsaK48J8+rJRgVgQEd
         EgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=g212aaB9s6G5YiOKra2HHbgqzyT13URpuJ/igvRQHVA=;
        b=BFnB4YP4tiiXlUEoGo67+AditnqWzeGwZPDDyXTZJckbXiop4Ta2iC9D9Vb436FTJu
         v/J1Rgk+vTJYKbsKExQqYcqImfJ4FqQ5p9ftOJnW3PgN9klayEmCpeP/u/DijlQaLWaV
         fLH2lUBigX4q2IL/W/zuS0zaOz2QgfLagu3JFCYE7B+OS7TCbzJ63I1G6aF5Iox1mfHe
         RbeSgkiyYSBOy2T2IKRr1Yc6gIyVTgQ2mDeHA2sdnQ2cUGn+0sawERef4m0dDJ5dZkoW
         nDWlC8OhRsqqFkKatYWx9io5dXWVj7D3djENsaNGBbLQcIq+pxh00FBgEUWMeWLLNQWC
         fviw==
X-Gm-Message-State: ACrzQf26pQkxx2eWQSRTri9J6poD1HwK7k/gselPjzb41lnA/urk2l9g
        Q6bowsQIrFOuw7+VoDB536uonDSquC4xGIC/2Lf3HQ==
X-Google-Smtp-Source: AMsMyM6dtKQTIJXG+dOR6Cz9VoVggP/7sOOEdaN+UvoxMPfgNyRHi96wgGZFUZAvZ6zPn5aqu8M9PiSu+CFXYiD2av8=
X-Received: by 2002:a05:6402:b85:b0:44e:dad7:3e24 with SMTP id
 cf5-20020a0564020b8500b0044edad73e24mr2416321edb.264.1663839558176; Thu, 22
 Sep 2022 02:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220921164741.757857192@linuxfoundation.org>
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 22 Sep 2022 15:09:06 +0530
Message-ID: <CA+G9fYuULy6jqbWznNSYz5bhOebTXgCSLEnznmsb+LsesEN5oA@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        William Breathitt Gray <william.gray@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sept 2022 at 22:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.19.11-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
As we have already reported from the previous stable rc review
about the gpiod test runs causing kernel crash on 5.19. 5.15 and 5.10

This is caused by commit 303e6da99429 ("gpio: mockup: remove gpio
debugfs when remove device")

Crash log:
---------
+ cd ./automated/linux/gpiod
+ ./gpiod.sh /opt/libgpiod/bin/
[INFO]  libgpiod test suite
[INFO]  117 tests registered
[INFO]  checking the linux kernel version
[INFO]  kernel release is v5.19.11 - ok to run tests
[INFO]  using gpio-tools from '/usr/bin'
[   11.896410] Unable to handle kernel NULL pointer dereference at
virtual address 00000000000000a0
[   11.897453] Mem abort info:
[   11.897727]   ESR =3D 0x0000000096000006
[   11.898066]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   11.898534]   SET =3D 0, FnV =3D 0
[   11.898819]   EA =3D 0, S1PTW =3D 0
[   11.899087]   FSC =3D 0x06: level 2 translation fault
[   11.903218] Data abort info:
[   11.903507]   ISV =3D 0, ISS =3D 0x00000006
[   11.903832]   CM =3D 0, WnR =3D 0
[   11.904072] user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000103292000
[   11.904618] [00000000000000a0] pgd=3D08000001070fb003,
p4d=3D08000001070fb003, pud=3D0800000104941003, pmd=3D0000000000000000
[   11.905598] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[   11.906088] Modules linked in: gpio_mockup(-) bluetooth cfg80211
rfkill crct10dif_ce fuse drm
[   11.906899] CPU: 3 PID: 366 Comm: gpiod-test Not tainted 5.19.11-rc2 #1
[   11.907491] Hardware name: linux,dummy-virt (DT)
[   11.907932] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   11.908535] pc : down_write+0x1c/0x24c
[   11.908885] lr : simple_recursive_removal+0x50/0x280

https://lore.kernel.org/lkml/CA+G9fYtxYKgqia+Crjok5yLshm3TpFwMyD8V5_-OkayA8=
UnDww@mail.gmail.com/

## Build
* kernel: 5.19.11-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 8d4fd61ab089cbb028a32652f9096cf53dfe54b3
* git describe: v5.19.10-40-g8d4fd61ab089
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19=
.10-40-g8d4fd61ab089

## No Test Regressions (compared to v5.19.10)

## No Metric Regressions (compared to v5.19.10)

## No Test Fixes (compared to v5.19.10)

## No Metric Fixes (compared to v5.19.10)

## Test result summary
total: 112536, pass: 99749, fail: 876, skip: 11697, xfail: 214

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 70 passed, 2 failed
* i386: 61 total, 55 passed, 6 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 75 total, 66 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 24 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
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
* kselftest-tc-testing
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
