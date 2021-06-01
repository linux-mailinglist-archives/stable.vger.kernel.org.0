Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84173974C6
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhFAOBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 10:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhFAOBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 10:01:35 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD76C06174A
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 06:59:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g8so13434043ejx.1
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 06:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tFMb7bg/vQB3peqjq46xeQyZ+nChrX4LuK9nvIyRXl0=;
        b=cTP+sVP8irRwNMh4SveUz7zJ9zpXdSRQ+HuUro6E2y+UPJkFTepVhSMKmoU1EM/bRN
         azUQnCnv2xD7cz/0jdBHYdtZWPRwoC4xqWzVRiW0387nQyfw7X0GUtfIRTF0w87KGgye
         VBZYFkI+f8vJfcEpjWaeUaYoZR1tWBxA7rsR95YiqVcJOPJR7CmYRLQEuxJPifnOgFN8
         /RAaELUfgPnz/5KBbjIK7p7YiB5pNt/pwt/X6Bg0BDHqKFr63sM0W65zQoIn0vCYW4B+
         svmIk+l+InWZqQ32plQ1r7Z7EfazmKJgwg/DbhLLCxcOVuUinVw3owAYi4Qc79zD1LoO
         NVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tFMb7bg/vQB3peqjq46xeQyZ+nChrX4LuK9nvIyRXl0=;
        b=b4iB3tn2TimuIPgH9JbbnABHxlF1wo69JOKsYHJm25R8wgRnO0sMw9HwNCJnKNe/Ea
         yC0x+En0R5IZeJ8tBZh0oHpAGK7ZUan5DJmRrNpnRboFGwy9cuUOk54+OEyGWA+Jaamf
         r5B7KC7+tj7RHsvzUBcyPtHIRkcFav5PJRxG4qP05dNU8YzzJ83XFAWrAnZcqi0m2/81
         2vO3vi/zTDgsXytmHpBAFoC4OejMteqBFimaj16wXmFCBFUAKPj+qHUb3VXxt2RJEL8v
         DvNGjf+1ZYHdis8Ta9h7rLSCXn3VKmBt8MjiTeORTsv/YUlOj/47E32DkubNL5+MwkpX
         NeIw==
X-Gm-Message-State: AOAM531mpPeaFrjliKGjdU1dxuKC4Fe53P/XPK5PC7TwB+KkGT9Z9jXB
        uT9z2Pcn62u/1l+IpgRsRvE76pGCXbnER9pKw5Dh0Q==
X-Google-Smtp-Source: ABdhPJxAQd20+BeORh8frgYWOwCrVg4OcIFkBQcePwgDUVjxl8dJTx3PoI141fDgWjmU/6j4ngmxzunlv0L9GOWRVDg=
X-Received: by 2002:a17:906:560c:: with SMTP id f12mr7050345ejq.503.1622555992242;
 Tue, 01 Jun 2021 06:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210601103052.063407107@linuxfoundation.org>
In-Reply-To: <20210601103052.063407107@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 19:29:40 +0530
Message-ID: <CA+G9fYtEAERBbqhOd76YkUypsCeinVdhfzo1EgVnqytGgOTA2w@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/64] 4.4.271-rc2 review
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

On Tue, 1 Jun 2021 at 16:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.271 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Jun 2021 10:30:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.271-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This set of results are from 4.4.271-rc2.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.271-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 1c2a0157411ebc80f60da29ab47915c87e6dd8f9
* git describe: v4.4.270-65-g1c2a0157411e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
70-65-g1c2a0157411e

## No regressions (compared to v4.4.269-32-gc86cdd4a598c)

## No fixes (compared to v4.4.269-32-gc86cdd4a598c)

## Test result summary
 total: 22985, pass: 18061, fail: 305, skip: 4279, xfail: 340,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 13 passed, 1 failed

## Test suites summary
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
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
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
* kselftest-zram
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* packetdrill
* perf
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
