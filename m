Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CFD3D0CFC
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbhGUKRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbhGUKCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 06:02:02 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59292C061762
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 03:42:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id k27so1788167edk.9
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 03:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H9+b5G9rxnn453yRniu/zgI7VzDo3SnBtzxRBHr7Ky4=;
        b=mjMwcqUpLRBqwXNaiR6nsk156liqE7DrrEFdmvSyYiY+n4ogjDaRUEdzf/RPTR+7YT
         BWi/H8yLVv2kuZ0HqutS7CvF9bFQDmSVPd4hsxKlbWn02hp5AUgaT/i7cKKQocWuS4Ig
         0JcebyRSpwO44QLmkMiycpxol+qcTXxA1bORDGenxT47xB4em0xJVKI4neo3ZOt11s9k
         3qLI2LyHKmDXapx7EgHhkb65lHYWUo2xDJOtivXhMg0hgG+G58v04oiKZpWpa7BhLSax
         ChRtGf0AtCp1tgdPKB6ZNrfy/C+pDU+h9nsHb/ZiIfIoveVzzdxWXgLYUiQHAfxrvLJv
         6yTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H9+b5G9rxnn453yRniu/zgI7VzDo3SnBtzxRBHr7Ky4=;
        b=WP67nm8phLySARIpObxIgc+unWTzSH5OqOicbxVmmDcmyZ7ZbU8m9e4wbd9ad3mOon
         fNrxj+2RG94QkjOpM7gGXZcBP4JgAMcpSjYNqa/FfpONTjCWLghUIXMN+QsUuH1jpB/M
         hvmwGF35vzikqWPRqp1eXGP+i0cRZu8FV/fyBqSEx4z4XzxM/2q0O74rCyeo516K9qfB
         ZMrTLLPQP9fxBsLZUlE5he8naBDu/uxg6DO3rEcxj2s8G0hTdgkLzz7pRzIZUZlH6VXQ
         ps3hLssBhBt0kPfaxLMRXKWekuuDIZkHgwpIklimSTVa4uKQsQvKi25Z3CFIReSuDfZI
         ihnQ==
X-Gm-Message-State: AOAM532v0mN9jSDByWHG7q1fLneGDFNHmCgnMMG5yJ18Y1wUQp0NH+jc
        OAKN2K7DBqFFGijwKNnh5Ke7Y0JO2ppymftV2C4TYg==
X-Google-Smtp-Source: ABdhPJxk/+pxj1rD6bqxCsVi/HZQN69ddCsvTNTuxvXVVRlhPmcpMaNmddytqfvKvS0sjaVgaIGeZNMVDt4/JhfjLnA=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr46898026edu.221.1626864156740;
 Wed, 21 Jul 2021 03:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144913.076563739@linuxfoundation.org>
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 21 Jul 2021 16:12:25 +0530
Message-ID: <CA+G9fYvom3Kt0tLnFpFzgBEBe0FyuUTp56XPnx8FgvkF0=Y5jw@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/188] 4.4.276-rc1 review
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

On Mon, 19 Jul 2021 at 20:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.276 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.276-rc1.gz
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
* kernel: 4.4.276-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: ffa748a4e4ff211e492aa3a41d20c4b2e4a15aca
* git describe: v4.4.275-189-gffa748a4e4ff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
75-189-gffa748a4e4ff

## Regressions (compared to v4.4.275-189-g56a34275371b)
No regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Fixes (compared to v4.4.275-189-g56a34275371b)
No fixes found.

## Test result summary
 total: 45986, pass: 36399, fail: 314, skip: 8033, xfail: 1240,

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
* packetdrill
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
