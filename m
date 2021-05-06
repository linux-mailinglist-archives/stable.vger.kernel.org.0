Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF503751AA
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 11:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhEFJkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 05:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhEFJke (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 05:40:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0125C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 02:39:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id r9so7314175ejj.3
        for <stable@vger.kernel.org>; Thu, 06 May 2021 02:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lSJfukBNYGaR57fjMkjDjV2hADrBhZIekKAIeFVmjPU=;
        b=UxhNagcdu2V+GDeis2IeCglIznQHfqWoSqZkH+jUJ9BR/cEL+qNvR121e1xvnOVJi5
         NSXjpZ5PY8lMdZtHyX8yRIuEZP8OktJVSJP95m9WI8o3gbmPvxCh9T8xkAUUcudkwRPp
         863q08U3Xqrhwmk0lbh6iijnKy5si28jLuTKs6zvYorjd3HMWqjikHL6Xf9e7mzwgWoq
         4xwE6nX5L/w67AaZcEo18poyzYfdZx4ZRdNxVIWUDHRcFdvTkhGA6EjoRQfvoXMK+9Mt
         FS0TJ1ulkmGlGy8URPLNcHre1g0vM+cKMYbk1wFGCw0iB1j/FtrkG+aT8SDFrPN72Z3B
         ysCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lSJfukBNYGaR57fjMkjDjV2hADrBhZIekKAIeFVmjPU=;
        b=PU58OoYsDUBRjfhFvp7BbfLmK//65XTXr/PvihXbebUKwSCo7POBX95sXRIMztUXjV
         5U97/9JLI3/g4rCyBWVRJoAE3A50og54FPxftvN+JuhaI++xBXJ6V4dHtwDcmwayU/Hl
         /vNyqdXfLDEierTKxzY1i+Z0cvw6s4voqJszAhrcUEdk2DzH1Ph4nsjvZVP9Sg+Bh/Xj
         ZoOSy6cGVHc3Y2I5FSsglJl6PtnmbZC4XSNed6QnJiDwcEwj3w+qWl1sDLtjAWdP1dhn
         LZzA+xKl4YgQ2cZ9rFv4w4zIGlna4jNCvT2eSpxzQ0anytxlUM0Mi+SmOLqZs5pcC/cb
         WL8g==
X-Gm-Message-State: AOAM5317fbGH3ANILbJVpz0/HnaKNWno08Po7uEA0q8CUagWp22c8+fD
        XfeNjLiPdaZndFMkoeBLRdv1WG3LxcvsDoXYHHEUQw==
X-Google-Smtp-Source: ABdhPJxsy3zOr7hbZSdPe1CwK0WxFZh1IZfDCLdBcZvEIJDfPe4vkfrj6tpGplne1z26QvlF73VQKaAYtl4bU/usmV8=
X-Received: by 2002:a17:906:4a8c:: with SMTP id x12mr3375585eju.133.1620293973119;
 Thu, 06 May 2021 02:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210505120503.781531508@linuxfoundation.org>
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 May 2021 15:09:21 +0530
Message-ID: <CA+G9fYtROOt8A4hbcrm_s=pkS8s_=aEMEXhYaJVwbYjCW-AzhQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
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

On Wed, 5 May 2021 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.190 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.190-rc1.gz
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
* kernel: 4.19.190-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 5a3ba2f90f8789162a03e07a37224bab4c643d1d
* git describe: v4.19.189-16-g5a3ba2f90f87
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.189-16-g5a3ba2f90f87

## No regressions (compared to v4.19.189-2-g1bd8f1c8ad2f)

## No fixes (compared to v4.19.189-2-g1bd8f1c8ad2f)

## Test result summary
 total: 68631, pass: 54812, fail: 2758, skip: 10808, xfail: 253,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
