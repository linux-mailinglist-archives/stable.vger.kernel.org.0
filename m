Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C016B723F
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCMJMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjCMJMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:12:40 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A4714E93
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 02:12:12 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id o32so10330155vsv.12
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 02:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678698729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KU+1KB/mSCK1kUVuZr3vnBGvCkC3xPMK1fQL4PyjNtw=;
        b=Mf7zvro85B2JVV2GNTga96Hd6rDAoQBS9ocSiV9VVOW1/OX52K1uCFY+hhzNVeZyqj
         iosrkqHsweFJKURbN34Ye5p72cvBlcwlb4LZS1H/GKQkEmdNIS5IQpnO6KHLM7vltVYx
         zLgDX8JrGl1NVDEYdaZHlOvNyNXz1kwkI8OkuPhqJat4VBCVUGqsIh2TRMH5eY60+phM
         dCtlfjsFSW2phvN8LVM4VMKLwoS9gAkaP8FHlsPeSMC+8+wgJFn1t8GTlNoLaq3gnkCE
         9DWtmmVwc+YdkNyHtaTScUmL9ofFe+s8WMO99gw0/Mpj7ecCrlxDPU/eWbLr6UF7rsFy
         ZYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678698729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KU+1KB/mSCK1kUVuZr3vnBGvCkC3xPMK1fQL4PyjNtw=;
        b=XaB5QT8twGrEE3WvPq4EJQvUrfwHFLKa6nSMS3CTmcRVQXc3UZHnP0uWPyqYFts5p4
         nmuLnasdZ7o9pePEPxB+ca3sXmIsyoH0l2mlZoLeeW59Z8SJGvAQQZTvDBQtyfZ/7aAZ
         h1V3CxgtqnmbfGxYvu1Y+o82uL6LEtZ3dDPesYHOEen1azteF1mLTb96jjfDYHrf6vSJ
         /EF0oJNgbAIJez7uqxjP4tLSDIEaMco+pi/reRtzp68EpHfDZ2rjEVqy0kiO7z/Ju5Sz
         z8JLOD7HziHqe72kPzvN2YSbySYs1VIVQ2PdOquar+P+brFKiwBtCxy9ScPa+YstLuqX
         3ePA==
X-Gm-Message-State: AO0yUKUGxZcW4HRxnbjBFsdnr6HzXXF+gnpF8CkTFBQnJr0/k6mtWGc4
        A5gpx4jcCZQcVz44hTJ2ZRJfycNXRa5gEYUqPRk6jw==
X-Google-Smtp-Source: AK7set9sRLVwl/2GQMYpXa42kVrD6n3JiglTX4kX9rxJegaEdvikrn6bASplGJ6qr0dIN05z6gkwJ4ZnhLqRm6RMvwE=
X-Received: by 2002:a05:6102:3679:b0:425:8923:d34a with SMTP id
 bg25-20020a056102367900b004258923d34amr1379060vsb.3.1678698729336; Mon, 13
 Mar 2023 02:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230311092102.206109890@linuxfoundation.org>
In-Reply-To: <20230311092102.206109890@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Mar 2023 14:41:58 +0530
Message-ID: <CA+G9fYsxuiRQbZRVWexx+WboeHs7OAgiNz62d18_36-r9F-cPg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/192] 4.14.308-rc2 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Mar 2023 at 15:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Mar 2023 09:20:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.308-rc2.gz
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
* kernel: 4.14.308-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 2326e906147b0f87bfaf7f0655b2a8282b93314d
* git describe: v4.14.307-193-g2326e906147b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.307-193-g2326e906147b

## Test Regressions (compared to v4.14.307)

## Metric Regressions (compared to v4.14.307)

## Test Fixes (compared to v4.14.307)

## Metric Fixes (compared to v4.14.307)

## Test result summary
total: 84985, pass: 71620, fail: 3674, skip: 9328, xfail: 363

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 199 total, 197 passed, 2 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 33 passed, 1 failed

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
