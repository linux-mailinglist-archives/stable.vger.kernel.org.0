Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D0738FC6B
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEYIPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhEYIPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 04:15:52 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3525EC061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 01:14:23 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id f18so15738416ejq.10
        for <stable@vger.kernel.org>; Tue, 25 May 2021 01:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UDstGcPO0oEYnMeTBWxaM5Zd83buYyEcpZqkj2fsUgg=;
        b=h9n6+L6alvXFbuCvhuy2SI+sxod2v5QnLICxT9CTq8ESP0NqoCgE//sKt3AOQQtKuR
         r4puQEsjwVbNW/+yh3IFjGODwj/SlwwT3g/hyKD5UTZjDLbi/AlZAEEYAe01OfqNu0YE
         Co0k/8Bp0HIWQUMeLGWZWDGvNgknrJ5ti1aFKQ+NBEiL19da0YS7haySDEvOi9weS5Tn
         ME6lRWUEUtJ958t5NQUyybrOB1qqXDnvps4q3KEFtyRzkT4jGtT0QIvYs1+4ytwdG8Zk
         5OEtGMw8JKwtOKZ9T+KjOh7LvcspK6k8UpVzkkivrC+dniLjHaDC/wLW39BosQpWZD8P
         phiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UDstGcPO0oEYnMeTBWxaM5Zd83buYyEcpZqkj2fsUgg=;
        b=g0gtC1cAmfPnDXmcRMTCPeQK6V4lU77YKuURHUi3d69N9sWPxUjYj1izuIjox5acC4
         iFlJstAnlArDXC9QP6zM5iFOJh5SmCDtF6GTfa5Sv/Fln4BxBOj9M1YhauwsngY+6K4+
         p5jQEUEyOq0KJF1mcG2TU+yxbM0s8jFzQvGOrDyX40ETwLvMB8lsUxhBLSsZcoCA4Fgv
         KD4MG0rHV8xp+FHD3QZGGx5AMLoADG9YT5qS0CFAWmDuzaxzLmMH7N8pKEvM04JoCX8w
         vT05RwQrTTLBt+sQdpqY9QKjGlbyTDj2T1WRfyhomn+gz3UCG3Xv4QlmcrZehCsHIe9c
         lANA==
X-Gm-Message-State: AOAM530mKJG69/zFoSrjnM8dV0UsoBQca5LNpQ/HHON5uEUcGbqZgQ8i
        wWUb5qiux8FwlfnFCKiGSA5uX+3r4oK8024gbBV/nQ==
X-Google-Smtp-Source: ABdhPJx8SnR66s36hmQ5CiGihym/QBsPzGdN4ugPs/pX0MerewDZ3afy/S6X8E03Djp/UyAAGwhns3mJs1cskinyDC8=
X-Received: by 2002:a17:906:f896:: with SMTP id lg22mr26172734ejb.170.1621930461603;
 Tue, 25 May 2021 01:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210524152324.382084875@linuxfoundation.org>
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 May 2021 13:44:10 +0530
Message-ID: <CA+G9fYstj16MQOFpTR-fYeGu_nS6N9msAUtUM+BFTzFTk28Q7g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.192-rc1 review
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

On Mon, 24 May 2021 at 21:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.192 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.192-rc1.gz
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
* kernel: 4.19.192-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 01268129ebb2be2b9872ed9bc56d075f438318e8
* git describe: v4.19.191-50-g01268129ebb2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.191-50-g01268129ebb2

## No regressions (compared to v4.19.190-426-g06c717b4df3a)

## No fixes (compared to v4.19.190-426-g06c717b4df3a)

## Test result summary
 total: 64461, pass: 51145, fail: 2196, skip: 10350, xfail: 770,

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
