Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AA95063D0
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 07:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiDSFSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 01:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiDSFSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 01:18:50 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF75245B9
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 22:16:06 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id d19so676670ybc.5
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 22:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aAJbJ4OLMH3hjwOtMx3/fgcKkzaU5VNRUU5MWWFvTHk=;
        b=NtbOmLiodR4hcHgzZNX45+egsbYxk/64ZwnjkHy1BWUGyKQp4Uu3hIJR6wo6XTZHpI
         XFIWUBEUDdBkFBSiBZYPfz/tMeWBtKK31q8ZwY1N5GEiYrFnZvoe0s2J8YEwF28ghL18
         B4xQ4l7TdoNPn+u32LrrdTpHdMdo80ydjHs8jaLxR5rzP2WTovv4BZHO++1kiBNVT+YQ
         XVZFvVWr605gGdH6MEzDJUKTgIo8qGoJPGEsYjb0DqtK1CqwYEQPhIM2bNmjFLbE7BBs
         gAfibKwVbBnnOqUldp8NVo1ri9us4M3cr19l26VbCBuHan2jydWw6QflAhqq3jJ3AEzi
         YFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aAJbJ4OLMH3hjwOtMx3/fgcKkzaU5VNRUU5MWWFvTHk=;
        b=uEK3S3jdyEich8TYqmRBGUTHtaE8mTXHkw4YgdpAf1WYlp+nuspE3zlyS/bZZkUKEx
         H8MQgCK4YNUK1IafLUnm+XYwioqxa3ZhuEbFnDdIgLyTjk69uBOmtPxjTb/alIjT8a6o
         tCcmaqVdDF0+ZAW+KyRcvfxfhSD2yaEnP0HY/yCbIwXTU01a5/VdGs/jhevOLfqVZlKy
         dijkxeBAzrm87WmU/1YeLzNMSNC+ybtu7Y5VJ5dnm3rpdyOiHImO7a6ktpRTAJtX5p2x
         NmY8nraJ38PsUaHshgEYFEZ5ixziiKEkmw1kNxW3PimhFza5McrzSJoxQT5Pqbo3ofUE
         METQ==
X-Gm-Message-State: AOAM533fO0Cka1F3su/RFnxYpvgPAKoggsiTsEbo6XIyGXKdJZ11+CLY
        SNmXNHiRcahcP2nXVvlJi5fsJ/bwcD5NgAeZ1WHvSg==
X-Google-Smtp-Source: ABdhPJwduztLeiEZZGmMqTRwYgrt1rqAluZvqeWg5AfV8XZ0cmKSGAZnkJSiQafV5ROtKlGDzlmbRzBcCjkjtc7rJ/s=
X-Received: by 2002:a25:9909:0:b0:624:57e:d919 with SMTP id
 z9-20020a259909000000b00624057ed919mr13701562ybn.494.1650345365878; Mon, 18
 Apr 2022 22:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220418121200.312988959@linuxfoundation.org>
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Apr 2022 10:45:54 +0530
Message-ID: <CA+G9fYvm8SxQJ+q12cOgB688DkeHAQyDGa2h+Oi07XRLRcOeqg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc1 review
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

On Mon, 18 Apr 2022 at 17:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.35-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 4a9761edfcec9b095619311472fac014067f802d
* git describe: v5.15.34-190-g4a9761edfcec
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.34-190-g4a9761edfcec

## Test Regressions (compared to v5.15.33-278-g1ad810a5a764)
No test regressions found.

## Metric Regressions (compared to v5.15.33-278-g1ad810a5a764)
No metric regressions found.

## Test Fixes (compared to v5.15.33-278-g1ad810a5a764)
No metric fixes found.

## Metric Fixes (compared to v5.15.33-278-g1ad810a5a764)
No metric fixes found.

## Test result summary
total: 103748, pass: 88080, fail: 617, skip: 14029, xfail: 1022

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* ltp-npt[
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
* ssuite
* v4l2-com[
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
