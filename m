Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31B3311DE0
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 15:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhBFOo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 09:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBFOoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 09:44:19 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394AFC06174A
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 06:43:39 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id w2so17537054ejk.13
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 06:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s8gzRxBOUWpYvYUjAHTudDzEzdkPAGSWptjJZFM921U=;
        b=esTil7M8UeFtwP/f6Hl/GIu6Xyi2XiHr6YP1bFtq7BeA9PDVX0Zw7BUWfijO74VQEY
         E2O0Gfkh4L+xRnqZ1M/HmiWpeLv96x4+oxekWQkuYMDTVZsGMtZa3X6M0v4R5+V564uU
         Uobr3Q5zFztjge+5+e9ufrQEa52i2L0MTuIT7bReMKJSy6lybLVCyXXxPK2LiUmFMsdZ
         Tu+TBVC6X40HPLOMA8Udy4Yhq+DoSkcBbJ9yfgd1zSxDCbD6pSCi5LPaVcMDNuBlGAk0
         BOAeglJaYcDZBeJKmklzueKtEfOLAd+eVtGdSvlxFMrvQw4ft8mvITtoO++5Z/hLp1NV
         8qGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s8gzRxBOUWpYvYUjAHTudDzEzdkPAGSWptjJZFM921U=;
        b=C+2uDUCtAYHLjE3pn6/V+MW29dlRTu3Wv73jIReNu873Rov29p2/WaWh26LY+a4t9I
         C/horMQWEZxQjEh7jMba7Zc9qQWepGWnPU4vAOey+4yMbjYToUdrJAEpABgzvkhZ5EGG
         NFy4yIfRnSDcYMHFpbOrbGP6LL4CB3tLxQnAW2+QRHvheVkEcNOxgEaQ7E726OwEtocn
         NtrL2u4oFFIjGnn1+9WBTjIZF/YSUxkj5dgaKBDpJgHMnvIiuHcZGU3c8jKlWhKQACwi
         w8g4JJQ7DlaYP05p6tM6bkadSEr6McyjQysUdBNADCP2AMK9CN8coEW2BHPifBGlLGdo
         cYVQ==
X-Gm-Message-State: AOAM532hdZIFEeO4sgPbJBjHUMkxYZnEiZo9y9gkSK2MM1KW9st87yb2
        gYiSkBpsgN7p6CWuBTH7fQj1rIljU30Qz/yj1qpUWA==
X-Google-Smtp-Source: ABdhPJwMb9QZlLMK2z3VMshR0px2Pd6ZatzlqukPwGfqXwhyqeT5hu179TeTsanlOrI0t7u54jJ/HtarUdtBidqrCL0=
X-Received: by 2002:a17:906:a153:: with SMTP id bu19mr9360181ejb.287.1612622617636;
 Sat, 06 Feb 2021 06:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20210205140649.825180779@linuxfoundation.org>
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Feb 2021 20:13:26 +0530
Message-ID: <CA+G9fYvMAAQe32VnoTf0bQA7Ep4NvT5jEEo7jUwjHtz9nKUhcg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/17] 4.19.174-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Feb 2021 at 19:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.174 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.174-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.174-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7a4e5f94ac6ccb0ba6023c08e97db26a20dc7dd6
git describe: v4.19.173-18-g7a4e5f94ac6c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.173-18-g7a4e5f94ac6c

No regressions (compared to build v4.19.173)

No fixes (compared to build v4.19.173)


Ran 45341 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-kasan
- mips
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* fwts
* install-android-platform-tools-r2600
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
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* rcutorture
* kselftest-
* kselftest-kvm
* kselftest-vm

--=20
Linaro LKFT
https://lkft.linaro.org
