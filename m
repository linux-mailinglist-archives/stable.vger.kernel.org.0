Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF7940AAE5
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 11:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhINJcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 05:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhINJck (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 05:32:40 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EA8C061762
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 02:31:23 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id e21so27368745ejz.12
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 02:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=17e6dnCGQrM5q2+qRVCN9tZEDHHPDT+i9nl8Ba63qoA=;
        b=fO18a/ZXri1YVEFcqIhfCrlV+yhZ4JuoBFIJYJ0gi3qRiWlE+WheRR9VI8s/q7Qdb9
         MpQ0vm/mMagzeCRTWE9/x00okFljf1w8M81fXCJIbzd02avrFzESu+lY68S8snGwXyha
         Kirm92Bmmyz5IXgmzmAI/Asrt48Vh2wg97sHTHCeJuF1tnUvTQCzX7sE7XI6R8p9eowY
         fob+yVX/rgWiBN569pxURVvr1G0R9E0MgcrfC7kuEX7jXczuO8A11kXhQqHupoDtqN5c
         M0CaLfPzkn+RRPuiSXzJem1keHYNHDwhlgo8U9LLFDwVJdoXENQCw1FSOM7+R89DV5GS
         0iWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=17e6dnCGQrM5q2+qRVCN9tZEDHHPDT+i9nl8Ba63qoA=;
        b=ptzGObRg80AecWiWFYPrTXUIoWlsh/b7YtIerDWBEVwFgtjPPZatkATsSx5FuGZU6u
         /7mpkF6yYWtWo3TPqbg9DKZTg6jlLFaOv2HUk81+kOmzbCb9rZBtUrOVoI3oMQjChDDQ
         6yXla6oukbIu13Sp5yx8paApmq3ZcZ+/JPiBX3S573Hwg09CJJf/Yap+Jg3KYqLCOtID
         AXjQRySfqPcQhd8hS8iQm6CbX0B0XoFA5wVUWS3+UZ+oxrbFR0oyeXiU0CFFH9ngtsqA
         vtWLngdPddd8ldqNypDVCxamLJq660YdjfNh0EzsEb+BMIorkCpubRqM8VCOG9eOlvFA
         O13w==
X-Gm-Message-State: AOAM532mDzUW2D8AsYW94dQAIGdCc4pdM8KCdFmhmL5bBQtVaXaULc6c
        lGf3UEr8lh9C0Dlv87eTTPwCRRdjHZ2RZuZU00ZzOg==
X-Google-Smtp-Source: ABdhPJwWKL1MZRa7/+NpnheWZH9rbynmXky1A4LtI1nrRurIHCzQCecTbefrwitUWW42M7q0WAIKkn0HHlfFuOcXduM=
X-Received: by 2002:a17:906:52c5:: with SMTP id w5mr17601927ejn.567.1631611881966;
 Tue, 14 Sep 2021 02:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131109.253835823@linuxfoundation.org>
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Sep 2021 15:01:09 +0530
Message-ID: <CA+G9fYvd_ppNoRiCDAgfoD9dvOdOSqRHNWh489h=g7Bt4zpfPA@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sept 2021 at 19:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on arm.

ERROR: modpost: __mulodi4 [drivers/block/nbd.ko] undefined!

arm clang-10, clang-11, clang-12 and clang-13 builds failed
on stable rc 5.14 and 5.13 with following arm configs,
  - footbridge_defconfig
  - mini2440_defconfig
  - s3c2410_defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.17-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: daeb634aa75fbff920be96c86c18510120951cd0
* git describe: v5.13.16-301-gdaeb634aa75f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.16-301-gdaeb634aa75f

## Regressions (compared to v5.13.16-264-ga06d976ecf87)

arm clang-10, clang-11, clang-12 and clang-13 builds failed
on stable rc 5.14 and 5.13 with following arm configs,
  - footbridge_defconfig
  - mini2440_defconfig
  - s3c2410_defconfig

## No fixes (compared to v5.13.16-264-ga06d976ecf87)

## Test result summary
total: 89815, pass: 75073, fail: 999, skip: 12693, xfail: 1050

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 277 passed, 12 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
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
* ltp-fcntl-l[
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
