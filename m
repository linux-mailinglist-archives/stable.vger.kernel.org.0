Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415D938BDF4
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 07:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhEUFsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 01:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbhEUFsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 01:48:13 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87500C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:46:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lz27so28696823ejb.11
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sSSVkkFFUQ6Cskr/VZlEF5ZDg9jXTSgymxzbW89Kiq8=;
        b=rWpnCoVX79LejXTQWqRMyqbhUunXquUI+AGuSHwMVVRzTnzzEte/YYG4mt4nm+BbkG
         +pJpu+xyTFkXz61TBhDHhl5oz/7NO6n7fYI12JNUvu0lZtxCvWUfRs9JHdysFLIMokhR
         dvNTLFs4Spv4RgaeAXXArcOmpRaDMcsDkVD+5ErTsdYNjbIlBsp0zyBmv07T3RoeNbXJ
         SDbbcnlhNqCdK9h5Mi4OHV6AzBcrIMfWtTikmO/iisgAaqqQ/Y3gS+XUSJdjj00REqHE
         vR3KgdWBH7XF1RE5SfXt+XKy6NoUSH3lV0QUs3lL2veKXv1Bd97n55AUoW1u4d+wEPjE
         ijrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sSSVkkFFUQ6Cskr/VZlEF5ZDg9jXTSgymxzbW89Kiq8=;
        b=d6fFX2uh96OxX5DbId4Uh/LI3pdIiHDHTGy7VKrY4mA026lb0MaGQ3niO7+RuHt7la
         ZJFQ4ET0omJeliEB7VbUE2xUScnQM28XAsup83y529s/RZh/uigITKc6o8p+bqVDLv8J
         UGe5T5PlT3OhSGHKwVKFaHAq0r6Dj3N1ziIoOabCsxr/RvtoMlBfsF023fadAN1UsNth
         nc9l1AM+i89Ix3wOASds+2gyxSOVfC3XbXLG/i2B5O5LFUPwV1fFoz5lxFBWGPT0RupA
         akyJtglYe8UD0q/x7ocgokb4ilaBLoJJRg21Nrg8xePQ9WcB7FkvJYfLjIM/Q5FvvYSG
         Io7A==
X-Gm-Message-State: AOAM533bYy7OPyeyva4y8YHxswcxhPx+JZKZLGJUmKyBPaweqj0bUN02
        c50tt8/UJpBw+xDqKQO468wSwnufNyqnwcQEplBYDA==
X-Google-Smtp-Source: ABdhPJxBmGa9E5PI0i1vwkylcCRl2T5RaPGVBpD1QAymGJH3vdSV48CFT0KsGYp5f5zWF6Zh3P3QaFZSZfwl3Lhn/Io=
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr8510056ejj.18.1621576007982;
 Thu, 20 May 2021 22:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092131.308959589@linuxfoundation.org>
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 11:16:36 +0530
Message-ID: <CA+G9fYs-sz=sgn_=yp39r+OqjDf_XtzvUeoQ4FgCujsmehnxPQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/425] 4.19.191-rc1 review
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

On Thu, 20 May 2021 at 15:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.191 release.
> There are 425 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.191-rc1.gz
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
* kernel: 4.19.191-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 06c717b4df3acb666920610a100d04ebdc485e6c
* git describe: v4.19.190-426-g06c717b4df3a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.190-426-g06c717b4df3a

## No regressions (compared to v4.19.190-393-g3423fd68b29e)

## No fixes (compared to v4.19.190-393-g3423fd68b29e)

## Test result summary
 total: 67254, pass: 53425, fail: 2253, skip: 10797, xfail: 779,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
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
