Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81C735AC83
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhDJJn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbhDJJn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 05:43:26 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B639C061762
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:43:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n2so12337995ejy.7
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oT7wiINNDYxVGyh44UMSvOYd+UDI8vGaMi5lFMvnZWQ=;
        b=FdOCNoJJEQWupHt0LdW3FVm2gK3bmx1+iCfH5+kK0GxeCjld8Q940Vb7QVezA8CoxA
         133jZq7crxDlHCD2xyC+XoeSVbeiTEK1PYIOoGyVqEly5u52LrsEl/ZjWm7ruulxYKdM
         fBW5DAIlmJqE0fJTE2pIB7uCc7VXrBs6rxJabHpi/M7+4XmFLqqSo7jcmrPHV5MkvJNy
         gvuEgFF3foLOCQf9TyfJhSFaWc64G9nDuOHCNHhYqNFO63pHcf+ZARo2Y3wpjA5us8tB
         UvuLk51dh4VGX7kyrQKWPmYvc7m1sJhLqDbjllrksvBJZDRWMTw1JgRMMEFJjKHccNUp
         nZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oT7wiINNDYxVGyh44UMSvOYd+UDI8vGaMi5lFMvnZWQ=;
        b=CdxCMAhCy+fao1vJ6u/SjUAXOJfiU+WUO6BkRiGU/wmLamvA7c17Ba4ucycpC/8HYV
         qM5Jd2xuWokOvo1Trjj3NAV499jEz+Wn+04aHqnsMRL5Hm370ePTJJxGhNdDP4KmGSWj
         6F+29agBVkhcV5mFxKWV4oKOp2UEHaK/5DbuHEV2Qa79EvSH49XmQoXZt72vMEscZsIv
         81CNfs7X04JnLyCybdmT7WEVZfM/Lk2xxb/n1FGm02QMRLgosHKb8BKQVoOHA2PXBXvL
         f1RHRbr/8I3OWMcK01ZIT4AtwNBx1TRR9MoUqrzMT24ly9IbZP5F+L1WOPCgAcHi0fpH
         zB7w==
X-Gm-Message-State: AOAM533CwBQjzdi1ooPqqpQKyCuaqxwZy0jaZcSiEGMfVloqwl+gODtb
        vKPIVbN7b8ca2dQ39aC6tyddPlCLrGF78jh3oym8Aw==
X-Google-Smtp-Source: ABdhPJyQD3KWPVIGnfbbc1eW/uQFmBzzCchk3YUCUAQk1WuGi7O8bE90uprfRRWYBmvr6LpS3OCG8ZThU6GiwgiKWpU=
X-Received: by 2002:a17:906:9605:: with SMTP id s5mr19996604ejx.287.1618047788992;
 Sat, 10 Apr 2021 02:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095259.957388690@linuxfoundation.org>
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 15:12:57 +0530
Message-ID: <CA+G9fYt+ZNDp9NsQM7y+r62sya0=J79A4=OYg2jJME6vLRkZvQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/20] 4.4.266-rc1 review
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

On Fri, 9 Apr 2021 at 15:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.266 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.266-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.266-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 52dca0094c23c3f6c73da63a8861764f778940d5
* git describe: v4.4.265-21-g52dca0094c23
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
65-21-g52dca0094c23

## No regressions (compared to v4.4.265)

## No fixes (compared to v4.4.265)

## Test result summary
 total: 45835, pass: 37184, fail: 486, skip: 7946, xfail: 219,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
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
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
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
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
