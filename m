Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5BE4AD6E0
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245091AbiBHLaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349530AbiBHJ7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 04:59:06 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BBBC03FEC1
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 01:59:05 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v186so48391871ybg.1
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 01:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=moZt/OKpgMDud2d6VK3RmE9/CWRF/JDHh6njVgiT73c=;
        b=pe2q35b+yAqFGA7m70ub3ZQIamvOuti/gXgoxeTviub/LoPd1mXv5g1ldjQfndhSQP
         DPdQNsDJ2dXK/zzcrqKeOuRABt4dI0yCP/z9/ZVqhUQlAFTMZSfdQNfgwLw1kvbcwErA
         BlWdB/CE3lNKfKtW68w3nWlggcBBH+QYmymNs13gao41HWi6S3AZQJrZHme6Jm2kKQRx
         ognV6PQB3tMlLDqil3ktJORfzMW+Rfz42IVjhi4zOx5lH84gqQOpqG8ztQV7Fty2j1jY
         q+nPSCcHrvpWtAwtVWM+6e5KsQf29mdccKiYrhfOJGN2xZRpDOvd3ftgrRYarB1eAoGU
         QSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=moZt/OKpgMDud2d6VK3RmE9/CWRF/JDHh6njVgiT73c=;
        b=D9GaKnPGLVm63LLVYmubT+uFrEQX0NMVPRkXT/eeOLCkHlOZnzz2RwR8aYrLz5zDFE
         Z/1GxCXoTaAdMSkU6L/u+W8aipeS+P2ii8vSuXIE2PwvqzLG97jvRceMs7oEZNwepJrk
         Lau89UTJLjY3etgzUaFExYOH4g6oEsZ/9W5Uo7f/Um2jAlONz2u+ZRDPee3IPGMTbSCr
         b1K92HdkNE+ZBCqryGw1hzD9C3ehpob0AqudB29J6snczsCv+EW07D2bdciSP3332utq
         +l8iiWJC+coiuzHzfbqn2GVv6fEmLZ7vMFbUheGHYEEQRzlOdvDAxBJEGUO249I5V5vw
         k/KQ==
X-Gm-Message-State: AOAM531UZ4WiJdZ9PIWhF3EeZNe/Xfq87YGb3Om8Cf7p7C/cWgkxZUAF
        yFco3NlMT3pKW46hYQfSMhnc+26mFgOx38e2cKzAYw==
X-Google-Smtp-Source: ABdhPJwd54CbV/hg+5XyBa6zUX/6DzwRStEp53fasJdYZVccUhVGy+nwmVo8/oBY5HqIdLkRgoGtmKx/mR211vtpouo=
X-Received: by 2002:a25:97c4:: with SMTP id j4mr3977930ybo.108.1644314344226;
 Tue, 08 Feb 2022 01:59:04 -0800 (PST)
MIME-Version: 1.0
References: <20220207103755.604121441@linuxfoundation.org>
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 15:28:53 +0530
Message-ID: <CA+G9fYsJ3S-Fi53At1e1+EfOFTduZOHooqiehcMaL0HWBXF0PQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/69] 4.14.265-rc1 review
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

On Mon, 7 Feb 2022 at 16:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.265 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.265-rc1.gz
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
* kernel: 4.14.265-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 1d3edcc1650da3e08c06fb89c5e280056eef803e
* git describe: v4.14.264-70-g1d3edcc1650d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.264-70-g1d3edcc1650d

## Test Regressions (compared to v4.14.264-46-g55a655b756ef)
No test regressions found.

## Metric Regressions (compared to v4.14.264-46-g55a655b756ef)
No metric regressions found.

## Test Fixes (compared to v4.14.264-46-g55a655b756ef)
No test fixes found.

## Metric Fixes (compared to v4.14.264-46-g55a655b756ef)
No metric fixes found.

## Test result summary
total: 76266, pass: 61904, fail: 643, skip: 11693, xfail: 2026

## Build Summary
* arm: 250 total, 242 passed, 8 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 51 total, 0 passed, 51 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-bpf
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
* kselftest-net
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
