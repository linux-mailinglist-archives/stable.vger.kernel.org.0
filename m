Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4742F427C7E
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 20:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhJISIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 14:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJISIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 14:08:54 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA150C061762
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 11:06:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id p13so49738061edw.0
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 11:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P5vKfi+9td8NhqpCP6I+GiD2oc/BmGL/ilhpzsfT3Ow=;
        b=x5eh8NbQc6Obxe+4AnG+SZCVUbY5WnMGMfN7jeJJDtdMM7S/ecm+EdD6gUFHk2ukjE
         JIt4zNZbaeX/R04UaBB3QFX38NvRqxOA2vTPwLIehZySTobbbD9PEgTVHqCXLtwUv1FL
         LQobFB75wQzBb3Moo1ciEHERr0PoEPD9dMDEqHgzqCLBAm6vRgZuwoEfzUOMnY41wFwD
         CcAuOX2ldEXC14AJV9k6bWQArEsAYyfHTuXxWE2UKafHeujEC0ntWCPIZdoGLSg3d7fS
         RBPWgix41MOrFqyoCrlyKaIkfa5x8ESsffwoVe24EUDhKePMPzw/rPsvxFwsRou5pE4b
         QxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P5vKfi+9td8NhqpCP6I+GiD2oc/BmGL/ilhpzsfT3Ow=;
        b=Ym40on+vecD5utccEd1bqQ8UX5+rPAsH5iil8uc0u6Qw85MIi6rjzBoECRyjmwnLyb
         K1Chc6d5nQ1MW+Ac7qQDES+P98IY9DBbAKvdnWHQrlinpJip8uDGexmRAS6EUNlHgvQz
         OGCkroM4ft9Y7bPSyjbnPzgEUahrj0/omHoS9NNokWie0yUpbkZKGJYgaX7VE8YDTVO2
         pkuuEF28iGKkWJ9N0N23SsJIXLeBoREcL5zisR19k0clgV22TwMIV1q9TNKoD29FgE/R
         JPM8YKfa4OPlKAAIfyMuObfXY0x5xG1i+Y6GQuFnndR/4hj+cP17Mx8ggUbRFR7UDOFx
         VgDA==
X-Gm-Message-State: AOAM532pZugJbVdcROE8StDqLgskymZOtGjReYyogmOnUcbbkjVOtSRZ
        ll3W+oq2U1DF2Fv4EcqhiY9RqJgmIJQhkxDjr1y49g==
X-Google-Smtp-Source: ABdhPJwtOeuBviCkxf0FgD01Ay0AfL2n69BofneDxcuVFToH92Ejz6lSWxYP63CjqOzVU8fiSQHcXgPaxAvWk+AgCyI=
X-Received: by 2002:a50:bf07:: with SMTP id f7mr26062474edk.288.1633802816110;
 Sat, 09 Oct 2021 11:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211008112713.941269121@linuxfoundation.org>
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Oct 2021 23:36:44 +0530
Message-ID: <CA+G9fYus19QMLfPy_Z2z87AKOwUP4v8aC0L=aF4x+1=hrpF87Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/8] 4.9.286-rc1 review
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

On Fri, 8 Oct 2021 at 16:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.286 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.286-rc1.gz
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
* kernel: 4.9.286-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: b57b518625d959467e72b2a28682237a0b7973c6
* git describe: v4.9.285-9-gb57b518625d9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
85-9-gb57b518625d9

## No regressions (compared to v4.9.285-9-gdf647e504ac8)

## No fixes (compared to v4.9.285-9-gdf647e504ac8)

## Test result summary
total: 76039, pass: 60936, fail: 492, skip: 12752, xfail: 1859

## Build Summary
* arm: 258 total, 258 passed, 0 failed
* arm64: 68 total, 68 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 48 total, 48 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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

--
Linaro LKFT
https://lkft.linaro.org
