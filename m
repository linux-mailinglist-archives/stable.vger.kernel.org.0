Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E2D645A30
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 13:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLGMxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 07:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiLGMxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 07:53:39 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7DDFCE7
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 04:53:38 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h24so15995953qta.9
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 04:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oX2hEWcNCnMhXAw0Zyyc0hdlvqduzjj1VD9AltKk4o=;
        b=Dvnw3p+w6JbEhxONWTqtnhUyE29QVMK2SccqWoyfZMnh30k3DBWuFeByzNI3eKyXtm
         OLblWOgvb4si9Rh0i/qZjckJjp0dsIjkqb0OlUDhXNX4qboa5bJ7V8xkbkApAV3eZhDc
         LUtb2y4D6QbwltqX3/6cpfyrlH5V2FhCdP9+dIlIWwsR88B3Q5APJZNf0nG/R+6jDkTf
         0IRyiTxyC4D9S+pKnsx12LqwkjBHjkzXi6LgJAmFOMD57V4Uht9Ekundfxq7U+SYwuGl
         +1CA/+sIa0oRhhsksyTL4Ae3MoMXd3x9jJEWz5kG5jDwIyj2vT79SODdeuaaiS4ZJQdj
         CHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3oX2hEWcNCnMhXAw0Zyyc0hdlvqduzjj1VD9AltKk4o=;
        b=jcrEJm2sTKsgV5oPjJvQSVyrZXAKiLHiedd9KPGmIUqhmUkp59+HtGtKBBb9WQi+bM
         me4Pg5mbDz62Nt4AoTkFvUkDLgq1SX/Hb8MLZbsxEHzYoebv4tMGzrGIAAC7l8Gd0N1P
         2ai13KrO3LjZrkIfnrWhWRWJ4CylCpQj8mySiurBAN12ndWdpTP5jYn9iNA2i0vDmqdv
         DwghU9xmh4r3QIe39goPtjcCz3PG1vYCjqGVQ84mGAVvdDfnJGcv4kPFUcFpgcqfrC/U
         M8Vh7hpuGY2feJWt7oXEIpxhX2CX5saU6jEX+7ge1Io/41ag4Y6LppPIy0ObkPvWrIuz
         UFhQ==
X-Gm-Message-State: ANoB5pn8uetlezIitmkU/UDDOPn27tVzgKQMj1d9mmuCdU3ozxU1T6gA
        ZuV8ickA4b24zKaOfF+7dHIR7NOzRyLLIYMA0EP9QQ==
X-Google-Smtp-Source: AA0mqf6sWEhh/YM6/9+5j/MgiOggRCCx9lK7v+SXkN2suW5zL7i1zui1qdoJpwcFpSA9+UQRU8WLJrfjw6j1MGn8CXc=
X-Received: by 2002:a05:622a:4ac9:b0:3a5:ae7:9ada with SMTP id
 fx9-20020a05622a4ac900b003a50ae79adamr67195959qtb.191.1670417617339; Wed, 07
 Dec 2022 04:53:37 -0800 (PST)
MIME-Version: 1.0
References: <20221206124049.108349681@linuxfoundation.org>
In-Reply-To: <20221206124049.108349681@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Dec 2022 18:23:25 +0530
Message-ID: <CA+G9fYtuHd3Nxy0ry=Zjqonp1wQWoToHO8o_S6RfuHK_v=Dhyw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/110] 4.19.268-rc2 review
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

On Tue, 6 Dec 2022 at 18:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.268-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.268-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 4ab1b944115715d57d8b573c00bd402e60810d30
* git describe: v4.19.267-111-g4ab1b9441157
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.267-111-g4ab1b9441157

## Test Regressions (compared to v4.19.266-114-gc1ccef20f08e)

## Metric Regressions (compared to v4.19.266-114-gc1ccef20f08e)

## Test Fixes (compared to v4.19.266-114-gc1ccef20f08e)

## Metric Fixes (compared to v4.19.266-114-gc1ccef20f08e)


## Test result summary
total: 52261, pass: 44029, fail: 858, skip: 6622, xfail: 752

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 318 passed, 5 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

## Test suites summary
* boot
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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
