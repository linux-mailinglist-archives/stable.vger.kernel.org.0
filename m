Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2DE361ED5
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 13:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242824AbhDPLeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 07:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242807AbhDPLd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 07:33:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B1C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 04:33:32 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id e14so41609321ejz.11
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 04:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1sdD/l1VwhH+c/F3S78fVTVhAzf9Cd31X/5+m6bD7as=;
        b=lz327AlYYflNXq+TsKYKDMgHowev0TrdrxUAdAto4opqVwt1nu64BS3TJ8RHOPdsgE
         TsCNxJPFONTRpyhVXm3YWomO/Ey8i/SFnXpjhZ37tEYUc2js6xQaibgG/cDiVVbCMjAc
         PB8WLSE3GwgTqEcYDrTf+8uIXtxrdXitwSo740MkXTP2BhuBrLKYx96+lIqVge+R9biQ
         IKR9Hep6cN9NJX/zmjJLksBOckplYOxbawv8yJc8xVrz5HaVdp9tYIUwTBSV0U9Q1Vng
         jZuSuQE1en7dtaveddAdI/SeAuBCwpQbCnYstxXFu7ITqOwgAwJBtq3Ms4MQGtvA/RiN
         id/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1sdD/l1VwhH+c/F3S78fVTVhAzf9Cd31X/5+m6bD7as=;
        b=KO9FkrxEq5g/U9pqxFPOHBUDjkvz9F/LacAfXoxvFGjuaT+iXnYpUxL+vRPxeExJ8x
         a8ngWS9TebuYvNOSjTLd0wCY0F+wPiPL8XmbMypMHOT0ogH14ivWCDmTp9CyXsZxATMO
         IIEupf0jZlmWXj+zCahqI6mTKjn3yfCh5cwlL97CP2Z2gDL5W5FkH8mFln1LpraPovlr
         I1qfQYLe+3Qhf//NMUjwVh73ZiV6Zbtfb57OVmWOC39juFQnSGy8i2vxhDOx7kve9hEd
         0ufTmdKgswjglwC8fHcocsvBAPY6eZbU3I6alYfnNkf2O4K5pr8HyGkC+uDtspi4Y5o/
         H8Qw==
X-Gm-Message-State: AOAM532SGMTwg4Lhd6ZtXMJNz1WIhZjEyehV63uHaxNlQC35PuY6N39C
        Vm/3Vu81dqq+TlpAE8OLuLj4CygObxiqQLt9MwiiLg==
X-Google-Smtp-Source: ABdhPJzvdSG8fbZGiT8fEHiTOQXLTngBXTSxPHs1eNCNdlZBW1eGb9cDlpPwE6tFopqUzo1E0xm/HEUmuMZeU6KUXHA=
X-Received: by 2002:a17:907:98ae:: with SMTP id ju14mr8061101ejc.287.1618572810946;
 Fri, 16 Apr 2021 04:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144414.464797272@linuxfoundation.org>
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Apr 2021 17:03:19 +0530
Message-ID: <CA+G9fYsGWrqPD4OQ0ejwSKMsxVkdJj7GBSD1kNTWxOLQfy6GVQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/68] 4.14.231-rc1 review
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

On Thu, 15 Apr 2021 at 20:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.231 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.231-rc1.gz
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
* kernel: 4.14.231-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 520c87617485a8885f18d5cb9d70076199e37b43
* git describe: v4.14.230-69-g520c87617485
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.230-69-g520c87617485

## No regressions (compared to v4.14.230-60-g9c0b97ea1e55)

## No fixes (compared to v4.14.230-60-g9c0b97ea1e55)

## Test result summary
 total: 57382, pass: 47701, fail: 583, skip: 8861, xfail: 237,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
