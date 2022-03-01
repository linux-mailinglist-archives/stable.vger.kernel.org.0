Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA734C9115
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiCARHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbiCARHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:07:18 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ADEBD
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 09:06:36 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id x200so3224101ybe.6
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 09:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XkVlnu9AtNC2+SicDtIG4fxqcqjgfAv/ZB91VRirVw0=;
        b=XRTnXzc/bFS2NiCeBH+VzaXBII9PowNBaJw1k92sgK3ewkBotbS27s2bmuYryZYvsE
         7TMEpf/enRtwzdTQiqLm5OR/RoV9MmWWSCtQR8bEYas8vGe6dwnZq3JQibb4bTmxSG72
         ct85mN2DcajDL0ZtdoLL/H95LxYbKH4ro6z3tn/oeKWQaBmo+pfuYkQx1tfoK08Y7KfL
         mOx1k4imIiTVCCl+TI2kIecEc9LdUXDRGQHZ7aw0tmU9xR+n/NilNriXqU5720mqT9tJ
         D8KNIZkpX9lnE3ZNOYc8iA4p0/QiENfP4ypJ5+ChDtr1ZZlfUbdoPQC3sFFsdmbKpXq0
         kcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XkVlnu9AtNC2+SicDtIG4fxqcqjgfAv/ZB91VRirVw0=;
        b=3bEj2muD2FQfo1Vidc59jpSxzQQnyE5IFUCFBp+5LRioKlLll6NBtnSpHobKydLTbM
         7NXq/t5esSbaviku4JtGtJCQImNqG2di5O+TSSNBlPRWuVMmIj+9SNlF4grpkWB+vWvh
         FXW/HmLSqNTtAZM0Eu12dbXG3ALkYdGbnqqr7t+hCdfHoqI6SM1avumz6td5uzzOc8Vr
         BIuew1STt2XS5KZGYvwdgotCfjj3ZKD0h5o0Yr4vUmJg/YXHVkLVVySKUdXCvbJlTRpa
         jzGMFVTrCrGiUwX3oUGj1bpjacmL+WPqBW6gGp0JYtqvH4zcabtblRNZU3ZPUtEsnw8r
         V+aw==
X-Gm-Message-State: AOAM53364S0fKT1XaSSx9mxWzOYMaaacEOgXh82/3t31tYNIYFvfnCUh
        NaWstcDENPiSBNKWU9L8VO5eAleanYZ+U/9YSHEGbA==
X-Google-Smtp-Source: ABdhPJxEizutKQdV7q7qn1WzkF3e07qHyb7EKzhgajAZ8SDK394GGVIfury2LPL//VGhSYk8qYbWqbCjbsjfCUq9+bg=
X-Received: by 2002:a25:d0c5:0:b0:621:c44b:b219 with SMTP id
 h188-20020a25d0c5000000b00621c44bb219mr24085216ybg.88.1646154395818; Tue, 01
 Mar 2022 09:06:35 -0800 (PST)
MIME-Version: 1.0
References: <20220228172141.744228435@linuxfoundation.org>
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Mar 2022 22:36:24 +0530
Message-ID: <CA+G9fYskrxEoW1c=4pCiJxAM5KYvAY91LpovxRpYvp60fMxw3Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/29] 4.9.304-rc1 review
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

On Mon, 28 Feb 2022 at 22:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.304 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.304-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.304-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 796b7c82bdd7bb76761023d7077dc83ebc321efd
* git describe: v4.9.303-30-g796b7c82bdd7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
03-30-g796b7c82bdd7

## Test Regressions (compared to v4.9.302-34-g6686f147d38f)
No test regressions found.

## Metric Regressions (compared to v4.9.302-34-g6686f147d38f)
No metric regressions found.

## Test Fixes (compared to v4.9.302-34-g6686f147d38f)
No test fixes found.

## Metric Fixes (compared to v4.9.302-34-g6686f147d38f)
No metric fixes found.

## Test result summary
total: 77979, pass: 64313, fail: 294, skip: 11828, xfail: 1544

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
