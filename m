Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6115320A6
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 04:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiEXCGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 22:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiEXCGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 22:06:04 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9E21157
        for <stable@vger.kernel.org>; Mon, 23 May 2022 19:06:01 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v26so225765ybd.2
        for <stable@vger.kernel.org>; Mon, 23 May 2022 19:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tIkJW2gxLvGg84WdJbSo1YnKOP5/twq07nYRU0g7ITo=;
        b=VqcKdNNWsVs+ATs1ecY7HkNg10LXhevBsXbuH32rqluy/EItUj1AUXvjgIYZ68MgXq
         G4kJPNnZb8ip2D+xwUaeMzdrrFyDTLDx9Q+6gDt6+bsVOJFbtI0SXkueha41fTA/D7CV
         GcdDdlf3d1Wg5330WQWotBNycQ+WpEiTH2ZChJkmy3SDXRGkx3GLWxEt8ynX8iU0xZFg
         pR0ueFJa67dcBtq/IqWYrjKaw1TOcIgOMJ+rU9MRZUQpbK5SNpxPL31uE/GzUM96y6rf
         XIlfW1bThIqvKriwI23rm1EGfW08VqJw3OYJgTYJNX2MDUyNSWhn+fLi0mFErm2wSTDB
         B0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tIkJW2gxLvGg84WdJbSo1YnKOP5/twq07nYRU0g7ITo=;
        b=FxXtKR9VNutUuKNBX0xYG3q9l/UiVfvVmjnZnz7OegaQCHSTV6Mz4pzZgHPiaoKGwO
         MsT+wIM9azD7NOdtbjZgzyAEI0paPkzax8/UHjFudDkcaizGBhyFFRNHsAGGgkKD1WHV
         cn5nmOfsqJmLXQs+KjfeuRrR//q7iC94C9HhCgOoJWAKhgi7aUltrpOlPQatvMShoCHL
         jCEbNQbAIDDMhVJf5xgxy0YfBGWtC/FFxW/uYdBulXOLthVxX/7fQnhPDe3ofg3WD1RC
         0ZTrT2frtTSpvB62XnW5EFIqxRV8kManRVjtaEfxUOCzT9BjUwCfRQKKrgiPgn/kBUeO
         szNA==
X-Gm-Message-State: AOAM531DTz4shJMv4QZpMbJaANtkuaImMMbMpqoj3dEpjqya3RvtOAPQ
        Jxw9voiD6+9ZAga5d3diyquWlZmhunEhDajzb3zC/Q==
X-Google-Smtp-Source: ABdhPJyxlXyi5tEZkdiQo+LuI7ApwXaXj1nl9wLrSzQSPaPPfntXJU1y+Kpvxqz2tQjNr0yjo5nSFADXJ11vLZ7qk1c=
X-Received: by 2002:a25:d18a:0:b0:652:f8fd:5009 with SMTP id
 i132-20020a25d18a000000b00652f8fd5009mr396899ybg.412.1653357961048; Mon, 23
 May 2022 19:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165823.492309987@linuxfoundation.org>
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 May 2022 07:35:49 +0530
Message-ID: <CA+G9fYtXE09W56rGs5y-EdBD9fTBOmxqJ5+ndf0=gV1t_jDYpA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/132] 5.15.42-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 May 2022 at 22:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.42-rc1.gz
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
* kernel: 5.15.42-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 03faf123d8c854ca0eafbd28c2b2f11e2a3de61f
* git describe: v5.15.41-133-g03faf123d8c8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.41-133-g03faf123d8c8

## Test Regressions (compared to v5.15.40-103-g293cfb310f44)
No test regressions found.

## Metric Regressions (compared to v5.15.40-103-g293cfb310f44)
No metric regressions found.

## Test Fixes (compared to v5.15.40-103-g293cfb310f44)
No test fixes found.

## Metric Fixes (compared to v5.15.40-103-g293cfb310f44)
No metric fixes found.

## Test result summary
total: 98644, pass: 83692, fail: 622, skip: 13281, xfail: 1049

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 44 total, 40 passed, 4 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 47 total, 46 passed, 1 failed

## Test suites summary
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
