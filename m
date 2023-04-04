Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054FD6D57ED
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 07:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbjDDFTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 01:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjDDFTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 01:19:30 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE79B1FF6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 22:19:19 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id q8so14763471uas.7
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 22:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680585559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clcP9IEhfBzHUgmu2eabXxj1HhcsLZSikrHXTq7mjew=;
        b=WqZh3ZQqkwMnYTHL9/Hn12la9xxjFiBj6hogHmP0n5N8XpJ6byQtOhn4Cy7wHm5BC1
         sKjUkHR1TFtRgmI8WRConujPh4o04Z6IvkMkgawdcX2AlECufnrZcdsbF+g9Yh2qdgJi
         a64NOsXc+vQbSHvxD7m3RqEcYhV7KV/FrXdxId2zLa/xw/DXIUbJ6dXjY59L62OhFdRC
         A2hZjXx1gGQondx67YMuYhNt86/ybzqRf26yRE6LjQ9WJ6FphqZ+Hmuvi6YWzTT7cx4h
         AToCTRYmsKvmqHoJgjRQsWN/4Y+lCv0EbCt//2ASVavCEGKRl6m7tvzIs34yh+eFR/XC
         LOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680585559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clcP9IEhfBzHUgmu2eabXxj1HhcsLZSikrHXTq7mjew=;
        b=asklJ0ZnjACEPZ+uEkoeyZpxpU9MZ+pxwkcW7nduiBckpOvvDkt8lSQvyko+p3KPfl
         cCkZ0Q+F/CHklzVJhabEji8Z8EeYy0RuN8eeuiwEbrW3K74MZnh0PqxZkoXq5pF+mgn5
         29FfEEFNocAXaCRJBRvG4ODaSuc1+oROKuWcmCy7NHk71vVb4igMD444pyxLzbIj+LxV
         UGeGuNxhYQaJdCqYDOZe3yAbEEyjUBD2Bu8vpjeDylPZPKvgX1KrdB/AAKOzIeH5zUu2
         x8SlOO8x79A3yKmG3W/HZ+DTIjOLGYHBjya4c82qSPbM+r/zo7wYexuByngSm8uZXbwm
         fSJw==
X-Gm-Message-State: AAQBX9eT0mH95orOqBFqfgbzmzm3HVKg3VhBWgS8ig4v9KPX9kmp62OM
        YbpArHiMXn0jH8dWq2Uy+cFcdD+2JANUcEAGg/wmyA==
X-Google-Smtp-Source: AKy350biw/EtOjp4EPoVplJeSd1seQsfwdamzCoQOFSHghz995LymiXjKViuwHdeCcdV4H5EQ7xcmvCMF8i/LYNb2AI=
X-Received: by 2002:ab0:5485:0:b0:755:9b3:fef8 with SMTP id
 p5-20020ab05485000000b0075509b3fef8mr651393uaa.2.1680585558616; Mon, 03 Apr
 2023 22:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140353.406927418@linuxfoundation.org>
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Apr 2023 10:49:07 +0530
Message-ID: <CA+G9fYsPfDX3HB=7WDYsKDCygHg51bOo+Gi54QdfgMkZR=JC3g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/84] 4.19.280-rc1 review
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

On Mon, 3 Apr 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.280 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.280-rc1.gz
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
* kernel: 4.19.280-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: e4a87ad39c9847a7bfb3415dabc4c56e738bc93a
* git describe: v4.19.279-85-ge4a87ad39c98
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.279-85-ge4a87ad39c98

## Test Regressions (compared to v4.19.279)

## Metric Regressions (compared to v4.19.279)

## Test Fixes (compared to v4.19.279)

## Metric Fixes (compared to v4.19.279)

## Test result summary
total: 92995, pass: 70324, fail: 3023, skip: 19502, xfail: 146

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 107 passed, 1 failed
* arm64: 34 total, 33 passed, 1 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 27 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
