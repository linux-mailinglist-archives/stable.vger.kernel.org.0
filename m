Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED26E903F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjDTKcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbjDTKbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:31:44 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EFC5FE9
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 03:29:20 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a1e0cc1a2514c-773c30de3a4so119479241.1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 03:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681986559; x=1684578559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yoFhtYReLRyKxkqbyv29o5oc/zCEFAU+pzBC0jHw8c=;
        b=sogqy1KdR0kOC1RtT2z+6Z9jSXFdwwlaoSCRR3R452OGSRwFomkHDfgqQVNb8TUJ0l
         i9wshDSta8TI2/M0Up9nKSDr1kMDjD5UOAt17pe+yhqi0nSSQXZhnsREBj06fgML9xNU
         r6Z9mnCSv888TUjdbzsv4qcARCMkkLHj7ibLwdKiICgag5H+n2mglzT+hu/Hb+FqcwT0
         O6nixEvxVh3EYsecSE7le3gEO2Rw2dw7yQbrVpfh60wLkmd2/RPvjs9r/8W2EEEBfQwS
         Se3irOZO7fAVoq5xind1Ft5EclZZdwo3eAk2MjIEITm2TjXKmjy/fVYnlU7BsKhsBGZU
         48pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681986559; x=1684578559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+yoFhtYReLRyKxkqbyv29o5oc/zCEFAU+pzBC0jHw8c=;
        b=fOlsV2UExBtaMGO7qK9rCNQE6N36BNx8Vgkm5vem4145neCz0rYftG+UnvcsXL+Yxg
         4bOXeEH49SRR+TsaWtmuRSy7/gaPNMJpP6loL+yngGkN7VQrZ0k1uNr4YQzqWUFXV6I1
         NkOf3XZAdxoJMHHJ/4J91Ahb9MWxpyq4g8Mrz4Kp475sXQw8jE7ytmIxv9ixKt5B4kmX
         yg653O9c+Dl0KOw+AtZyDwi54I+AZnP6XMoMnWwj50Ux0vJCaVuwCWTy5DUZjWxdluya
         1Pg4shkmoyTBUALydvVk1wpgp+xIXG4RemtwZVu6BFMr6p0xhHHNIaOBaJQbH7mmh+2i
         ZzzQ==
X-Gm-Message-State: AAQBX9eFekuQjDn5aidqaMNoVuBpSir6hbQ67WGUFMb005o8+n24LPvQ
        hg3hJiooO6aXXDswBscTrDIDZV33LIPn7EwjBYcSjw==
X-Google-Smtp-Source: AKy350aH2Je7qoipZNoyKO5+fwXqf6r5UwLhNebUF5NinNiDbUoCeDAPQWN0NhEL1cxyo6DqNzLeQ4KfAREKbDcAAHQ=
X-Received: by 2002:a67:fa0c:0:b0:42e:cfbe:c19e with SMTP id
 i12-20020a67fa0c000000b0042ecfbec19emr626839vsq.27.1681986559227; Thu, 20 Apr
 2023 03:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230419132034.475843587@linuxfoundation.org>
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Apr 2023 15:59:08 +0530
Message-ID: <CA+G9fYuy8Juuz_6bsoB+Dn=aSbwgVqAxLNkw6Q4CkF5CQ7t_2Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Apr 2023 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Apr 2023 13:20:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.108-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.108-rc4
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: df26c2ac7edab467aaa49544362100c86ab2759d
* git describe: v5.15.105-273-gdf26c2ac7eda
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.105-273-gdf26c2ac7eda

## Test Regressions (compared to v5.15.105-194-g415a9d81c640)

## Metric Regressions (compared to v5.15.105-194-g415a9d81c640)

## Test Fixes (compared to v5.15.105-194-g415a9d81c640)

## Metric Fixes (compared to v5.15.105-194-g415a9d81c640)

## Test result summary
total: 132220, pass: 105848, fail: 4053, skip: 22081, xfail: 238

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 43 total, 41 passed, 2 failed
* i386: 33 total, 30 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
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
* ltp-n[
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
