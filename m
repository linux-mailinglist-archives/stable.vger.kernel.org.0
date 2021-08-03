Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B473DEEF3
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 15:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhHCNRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 09:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbhHCNRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 09:17:53 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43197C06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 06:17:41 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z11so6496377edb.11
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 06:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yR4S2ZQmok+LMwRMPbSCkfcF7S1VTidPl8mrJI1OXHY=;
        b=naF0LMmxmvdiLihArultg5bRuKRC75ZA5oWeTTC3K8Gs/UBvNgSO5Y0pKskfkvVX9Y
         PKIBdIDo0+5rXqpPU5tR8qnQjh6k1dBD1GRaVm/I4Zr13QVFdTsfJkkpItu6QNaRo7Ik
         BPeRCtCf9LM0/A8/+Ia5JjhUW1D3uMVVnZDR/uIN+PRFc9xSmWuk8EEgWJtgZDlxTG3j
         wPzumiw9qSYshJU+/WtnjNO6T6mYPFBJdgewUQAmnKHb7gaEpNzsZGfE/OzXwE2UPdGR
         6j0hsAnvja18HbJ1S9IGnXdZMjSrRk+LgtCyPnZ1uZ46nZcR212YSVtVNV5nHVyhpQuX
         Mu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yR4S2ZQmok+LMwRMPbSCkfcF7S1VTidPl8mrJI1OXHY=;
        b=fkOtvaMV4lcIRB/9tRWZmp5CXUud00dS3d/IjeY5+O6U6wOqy0974iwv7QHgfNcHzV
         e05aSzaUtZtekkmunelJ28P0em6QKi7x1+k8udBrLdh+NR2SZhb7+9IWXEIYB9SowDX4
         IhET7xnUMdC+/ujC6ONS2FyMz/duaqXgrWd2W7Kiw3Jc0evZpNxVMTGz/ng8K2oW97X3
         Wt8QUSkApd8WmTsmzKWN9jUcySIigfnfLZ36tmEzR98Y2O98HbvMDkMFHHsTCr9KagML
         z+Pndg8VEdUau3wB8nRhzlsccSpVz2uycOoWT5tvTNRuvCKySWcuI0vzRGOfbYXTTjUY
         U4/Q==
X-Gm-Message-State: AOAM531WgzVhD109HSJTbRmW36bRFOQemOUCWwEUfoAloVX2FRusbOUU
        2bguKEgJi9MLHGR1zCyXX1tLrd18dW4o5TGpAe168w==
X-Google-Smtp-Source: ABdhPJxmVBMhBwyLrU9wZlYjM14fpf07QrSSuWhRKwy/bhfuFtk/QC+rp3AfFWRskkGwVtWXmT29uvhG1IgahYzr+mw=
X-Received: by 2002:aa7:c805:: with SMTP id a5mr25236154edt.23.1627996659650;
 Tue, 03 Aug 2021 06:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210802134334.835358048@linuxfoundation.org>
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Aug 2021 18:47:27 +0530
Message-ID: <CA+G9fYui0Z1RMgMx4Sa41btUxTXMMuZ2uEL6Nhe3G9w7hZH6Pg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/38] 4.14.242-rc1 review
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

On Mon, 2 Aug 2021 at 19:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.242 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.242-rc1.gz
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
* kernel: 4.14.242-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: ec038bb8339f8cbc9d78324a4e62c5cb3992e69f
* git describe: v4.14.241-39-gec038bb8339f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.241-39-gec038bb8339f

## No regressions (compared to v4.14.241-14-g8cb34df08062)

## No fixes (compared to v4.14.241-14-g8cb34df08062)

## Test result summary
 total: 66149, pass: 52221, fail: 673, skip: 11274, xfail: 1981,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
