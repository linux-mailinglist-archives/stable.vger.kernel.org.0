Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A94A3AAF49
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 11:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFQJHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 05:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFQJHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 05:07:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CDEC061574
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 02:05:04 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t3so2937837edc.7
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 02:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wBgmj9LJ8gse7uLiZ3HnRfyRIqaVEI3uIkfkvdTNNJ8=;
        b=jDj2eZowaegr07JTjShwa1vmlMST553DVlwxVnjHB658JSJ05McwNd5jv8Btk3NzZu
         VOe0DvCcKHt4jVlVjE7PDtjIzwL7n4hYF4lHIAdgtErUHMcIvc1s8IkbG0p/sV2wMdcI
         tIGKa2mClJZAfrs9X4oPZbodDmmqHH/d/AR0TyOWJQnrJBpTRbw83ZNOnA8ZxXwYk33V
         +21Ye4ohwfBRy9NcwyTcBqaQOB26s/ZyHgJm9w8jZqg5e04S8rkKucD5upDj+R7UxZBa
         Bv54uEHfHFH36W3YPw094/GSL0emZAvz0nkApNxbbGq6aSqs6/yrI1895nFrAD7SQ9jJ
         vtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wBgmj9LJ8gse7uLiZ3HnRfyRIqaVEI3uIkfkvdTNNJ8=;
        b=Bjr53Z5yoQg2EH3oSkXKDlGDasjPX7JIHvYFzFYg7KiRaryecWKBaST+Nw09Y1ZZIC
         bkVq1WRbsTrBt6o/Lrj06rQHxcvPtoVa4Wia11+w774mUkI7D1gcVDMY03EfhXSdr1ah
         fLHc5Llat4HXqv4Whx/vNBFM70StY5IPwcW79+krt4i625jm9Re2Dxp4IfNfYiEetKI/
         CVPCkzvY2S+gx4b7DjcTKVyT1iS2Q9VoN/UAulbMPbg+CgFPwHwW5V4ux7/bE7+wS96b
         zzXAUGLG6iUfnNWFplx3mBez0zXrZwj3KgY53E+7ULssdWEK9aCJ7PBgYjzPyammgBY/
         IXyQ==
X-Gm-Message-State: AOAM531FbGhBk/Yn7xWaRYmbSc72XR9lhXZeUQdL8rkI3+v++jVYLPtl
        QsBJjIlVxrm8M7KG4Ci2Q1uAoAbFJ6Q2amDa/5UY8w==
X-Google-Smtp-Source: ABdhPJwIN+rMNJZRHoRS7WWemJWjQymiir6fvWwrrTef23oRjK2xYEK4mReUDuFM99Tdhe985fLkmpMnMaVNQznw7gY=
X-Received: by 2002:a05:6402:22fa:: with SMTP id dn26mr5029415edb.230.1623920702814;
 Thu, 17 Jun 2021 02:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210616152835.407925718@linuxfoundation.org>
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 17 Jun 2021 14:34:51 +0530
Message-ID: <CA+G9fYtoOU-t=Y4SiydjV-LTDnkD=i1tXgjsQO9nUZx4kpy9Sg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/38] 5.10.45-rc1 review
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

On Wed, 16 Jun 2021 at 21:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.45-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: aba9bf2d6e4093d75b06b37d11ebebd7f637636d
* git describe: v5.10.44-39-gaba9bf2d6e40
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.44-39-gaba9bf2d6e40

## No regressions (compared to v5.10.43-131-g3f05ff8b3370)

## No fixes (compared to v5.10.43-131-g3f05ff8b3370)

## Test result summary
 total: 80674, pass: 65924, fail: 2590, skip: 11497, xfail: 663,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kunit
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
