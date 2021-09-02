Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729C93FF186
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346332AbhIBQgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346193AbhIBQgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 12:36:46 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED18CC061764
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 09:35:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bt14so5805980ejb.3
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZMTYvWDVLVaZmkl9P+pxPt5exqXKOmySVprAY9JOzrA=;
        b=FRhLhl3bw24GlLtojoeGcWo42vivIwtkcFGpaE9Fx6fMXEpMzLbCJEgJ3iJnMIA/bC
         Le73au67auR0Qb1LRBtdjDCTZmJ+rwUTqifxiK5D7s4ZhsacBa/B+LgyJgFjHO8qJEyp
         +aa4TeQOiqSwGCq1nss7M2Q/8rQDVR39pxSIJ2s+Jas7J7Z4IvWxDelX8nol3yIAHu5P
         k9xI1kVq2/CkEFl707st6AgRL61wM0ePxibt/2WHP1A4JdbSeKYWfHjCPcJCU8b6nLRY
         Dp66vxWEcA+n9QPsCjF3cQLlUosoMyVb8brFtyUwXM1Wh5Xv4apkv/N2Ne2+66BuP5F9
         FpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZMTYvWDVLVaZmkl9P+pxPt5exqXKOmySVprAY9JOzrA=;
        b=ARqQ2FLumJAwkjYOQQselSNhqwwGPYdMD+SPQ/x4AZeMAfJDD/aYdHkS2Zco3WMEND
         3jlAG1iivTssX9n1MF2U+JAfRcmW0lKKbVUg5GHucBTgH5lmKRiollWiYuhDLUelZHWP
         avC4d3wqavf941XQTnH8ODyz+wnPr36pfbsILdJJcSoK4VrFoF/w6XqwxsEW/V+jP8qI
         SXVVFZ56SNrnQa1uX9UDz/cQAMjhrrqT7Jy5Zyw/tV4+5AA6Lk7cxP4Pnh+tkQD9zlsx
         LBi/5z7XnxsNRxYACnIlXb+RSewZrh9/DOPniC5gYmOw17ktjuObXk7fBn7ZBI433JRv
         SmAQ==
X-Gm-Message-State: AOAM5329TSedG8WxgGh+cJCHVnQ/FAK6oGDHU9g55n6ZwQ2srSjzAlfZ
        LX0Eic3FrZg0egm4kcHYcTha2ShPot+hKJ7f1Zp1Nw==
X-Google-Smtp-Source: ABdhPJxE0mffasb9PypQPGlvLgEtkeqtiLZEcquaeHPA0FZ3RKd/DhyZMjC/W6J+eVq2ZFFln+Y+/BKV5aOOnsoqE0s=
X-Received: by 2002:a17:906:802:: with SMTP id e2mr4669869ejd.133.1630600546396;
 Thu, 02 Sep 2021 09:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122248.051808371@linuxfoundation.org>
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 22:05:34 +0530
Message-ID: <CA+G9fYtuf0STPADH+Mv11arDJNYYH789i6pdRPcbrOCUZdNg7A@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/10] 4.4.283-rc1 review
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

On Wed, 1 Sept 2021 at 17:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.283 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.283-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.283-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: d0f43d936dd1700f7b90bcf6ee0b333159a0feb3
* git describe: v4.4.282-11-gd0f43d936dd1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
82-11-gd0f43d936dd1

## No regressions (compared to v4.4.282-6-gdeced08a3ab0)

## No fixes (compared to v4.4.282-6-gdeced08a3ab0)

## Test result summary
total: 53253, pass: 42320, fail: 257, skip: 9391, xfail: 1285

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
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

--
Linaro LKFT
https://lkft.linaro.org
