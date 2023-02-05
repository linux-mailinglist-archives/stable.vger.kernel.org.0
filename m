Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7311D68AEF6
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 10:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBEJKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 04:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBEJKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 04:10:36 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0041F5C5
        for <stable@vger.kernel.org>; Sun,  5 Feb 2023 01:10:35 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id j7so9726216vsl.11
        for <stable@vger.kernel.org>; Sun, 05 Feb 2023 01:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLxzCfAuB3mMk0uOkOzfb8NTkZjPf17jvrqwzu/1ISY=;
        b=LVbfIkquomoFzGFHhWUONhQqxwqv+LS4MWZlVn49h+UdRpco4ZCzOuWcFAhmfaM49L
         Bqwt642qdOqVvesPhDSaVQwgPcEjrtuPS2t9K8MMtHmNBmLOaV08071az9XNvhPJ4Oen
         07aPiTNIxuwzYYPHa2TFcJV+IefwDL41QTKuzvhT7ypomYgweR3G6+m705eN6z+xRSct
         fpO5j87s3K+MwpWHApucWNFC1Mq4D5lVUmx2yZqD0Z6/kLg6a1oRRmlSa1Uc+Pq4Jsiw
         xPaU211SzB76fXOE7w9tszpGRW/SXdB7PuqnqgHxo/vN2wGj5Xz/7FQqo5gxfrG7EZ95
         t+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLxzCfAuB3mMk0uOkOzfb8NTkZjPf17jvrqwzu/1ISY=;
        b=6cjvD3NOvUZ44+FanIJAv2e+rkGnRZtsUoBGto/RxlB7jFRnoaVLXkjhHR9mOokS6g
         43Va8Crk6kAkfLwIpHdOH8P4nl1G24wuLFt1rSBt0GycxqbOuszTj9K09hvz8RtxU7o7
         2i8/Nd04kq0YSDsiABUpL+APMlvrbRfpmeewgukNUF203slMnISB5D5nuoXStHCqPZSS
         6pWLaTBRIBnuFVF4kQAzDBnW1CGWbYanvep2mUr1mf4eQx1MJu/4k1upoXid1IdUPfRI
         qygWjWKDV7XLr9ljBbLVsCOH5Q62rRFWmOAzuMvSHV6CJsi0uu0OxkQ5vbDRqDOV95tD
         J0rA==
X-Gm-Message-State: AO0yUKUQFVuC9p5DycxTZr20++zMp5473/4TZ0GKVkr5WdiF4fMTfwA8
        WypgxZg9n9qNbVquVbmS3Z3//bRxvgVf6MR/QQbZuQ==
X-Google-Smtp-Source: AK7set/pVSJu6Y4up8NykcK+C2LBpNAQPMFNCR4rxU88lIwjPITS2blC1yvy263f14ZeaOSs2ayEXFo71brvGWZEUAE=
X-Received: by 2002:a05:6102:3fa5:b0:3f7:4e35:cdfa with SMTP id
 o37-20020a0561023fa500b003f74e35cdfamr2265041vsv.83.1675588234014; Sun, 05
 Feb 2023 01:10:34 -0800 (PST)
MIME-Version: 1.0
References: <20230204143556.057468358@linuxfoundation.org>
In-Reply-To: <20230204143556.057468358@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Feb 2023 14:40:23 +0530
Message-ID: <CA+G9fYumzgMVJZjAjYaGq8vzs0eqBCppe=L=bWTougpu_W5k6A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc2 review
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

On Sat, 4 Feb 2023 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.305-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.305-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 76cd9cefc3a262da4fc9d16dc3946124e0218cdc
* git describe: v4.14.304-63-g76cd9cefc3a2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.304-63-g76cd9cefc3a2

## Test Regressions (compared to v4.14.304-63-g001d96b34795)

## Metric Regressions (compared to v4.14.304-63-g001d96b34795)

## Test Fixes (compared to v4.14.304-63-g001d96b34795)

## Metric Fixes (compared to v4.14.304-63-g001d96b34795)

## Test result summary
total: 91909, pass: 79431, fail: 2980, skip: 9151, xfail: 347

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 306 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

## Test suites summary
* boot
* fwts
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
