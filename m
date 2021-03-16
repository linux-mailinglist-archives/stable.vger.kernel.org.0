Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381A033D36A
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 12:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhCPLzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 07:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237516AbhCPLzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 07:55:10 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C65C061756
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 04:55:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ci14so71478825ejc.7
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 04:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=czxLCL6NCDvGC8nAhkmWQQR24vihQ+0uEiOhuhxLbKY=;
        b=LZAM3/Ap3vfDvfYWnMlpRRL+5q69zqnBwKv7eXMAiMsVpCgV6kx6Q1lHzmimVq3vSn
         MjNhs9AKtIb/SPGF+5Nv+hyb3NlMwKqOZSOmxECVXSAVrJMsGOOJA75CHKYbPS7N+zJF
         ld2x5DsNnGO02qiQ+mATHXCkr2DoFiKuYv+iRzPR/glqwteI42I+uiqYmvK/hDQYZCA2
         rdBiBWMFDBgOEG2IU7pRYNmeRJCZHXkcLB0OBVNd4fPcb7bySM8CZNV/oYgkfZw9sSsN
         gWhi70dN+tTq0QnZjJkBVNXBdidhx9XvhcSkRaTUUv/qViamRY3VX0U4hJIYL+pXCgu4
         npNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=czxLCL6NCDvGC8nAhkmWQQR24vihQ+0uEiOhuhxLbKY=;
        b=mDyx6PMVpCzNi/w352t7eis+xtHC7fP0mrfxbR3QOABx4zO7OtPEuob2BRZBEO8O93
         gOs3qeEGXuKHS9PXbQ8CG3N9E6EeTR4OUFw6kRlvtlMQaw51Di04VT5Zuwi8HqkOUFj2
         volGS2+JPA1uZeQFcUf4r6pdFahN7EoSVhSD+tb+Y8Iai3vF2FGprp03eve3XD2uJ3qQ
         H176e1Cq1LwYJpiRFzTI5uFfAUaaAakyGjgxeRbTEQLPu0xYd+VbRsLxPwQZP+F3CbRu
         H4ibFfArUS4hvrm9tSxwzLbdBnEC18IFabvtpsiCzY04a6IxHEuXOAimGqBl4Qq7oeeV
         SpUw==
X-Gm-Message-State: AOAM531HGKg7RB7ogMnpL9LuNSONBIqyLtILn+kX9sAbbiZ+UnfwKbq2
        REzfbrkRonhRqehWr0xV2u5/J//YRnt2thAzu+cH3g==
X-Google-Smtp-Source: ABdhPJzan15ic8sxh2xyeC7XvZBA3sGNHqwFZsxkgSkXdGymGdYmafdnUpmxaBxJ9nhFzSQ2lqeb6lNqQjoAEE/SCVc=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr17707695ejc.133.1615895708688;
 Tue, 16 Mar 2021 04:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135740.245494252@linuxfoundation.org>
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Mar 2021 17:24:57 +0530
Message-ID: <CA+G9fYucp81Z3xVFwcUjtfLZD8BMgEJguPRXP+z-iDFXCf9ZXA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 at 19:29, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.14.226 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.226-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.14.226-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 57cc62fb2d2b8e81c02cb9197e303c7782dee4cd
git describe: v4.14.225-96-g57cc62fb2d2b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.225-96-g57cc62fb2d2b

No regressions (compared to build v4.14.225)

No fixes (compared to build v4.14.225)


Ran 41401 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-bpf
* kselftest-intel_pstate
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-sched-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* kselftest-android
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-x86
* ltp-open-posix-tests
* ltp-tracing-tests
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kvm-unit-tests
* rcutorture
* kselftest-vm
* fwts
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
