Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F040335AC60
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhDJJT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhDJJT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 05:19:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466F2C061762
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:19:44 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z1so9242095edb.8
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x1zp53gqDdFPW8OmjeliTqKcL6DNQcviFf3Xmcla3rk=;
        b=Pn1kr33VnCcTth1XQzAwLw4DjQfwaUzfCTu2DNWHRqO52cSeEcTIdp7Ouoj6RxPc2N
         bG6e14DUnSV4XmF31JFObQT+Zy/Xbg28mRKeiaIA7yFt10CfveLhXF8YWFvYALxw1gem
         /k0c4RemDCU6AB0Q1obLQs3G0D78UtAYiT8IpV/4QdWzZyiuysYtWJlNIGuTLKgJUQ+v
         AqfPmWhIKMQV29sp1jHG5ZOJFGhPt+h3Buv11Wy/IU9CXnhYBf7Wa0yqxGHT1cOaxnjz
         Ol31rNUxkUK8EXxVVAM4TirkK4wBA8tThCX9KGeoYHc7FelhyC86rUfnum2k7txmY/Rs
         jJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x1zp53gqDdFPW8OmjeliTqKcL6DNQcviFf3Xmcla3rk=;
        b=BGVzZCvFB5Pnd6GnKsdTyIR/CqaU5EFlJip7bgPJKCDqrxYB4xtORtlsEUq5fmQNsQ
         ZloquUSmAEQMjH1qFv54RtE4BbLDLijq7Z3NkDr+suseEOIxFJksjgVzwl+wf82Zegxx
         Lwunvs5tGRCuKwxGxD3PTKQT1OpD6fSwmsStVpm95KizJVC929V0te2x1ZiShjoeM4xd
         Pmwq+2v/1IeuXdEy7hGyt3B23CVGWV8EpLfTG7UpJJl+KwVGgE/+3nxwzd5ezms8/LIH
         3x+wUY56E2SJRCw9xRDqMzF2nMgadFijlKInty6THGzxXGF7ldZD7KdWbDVcrPS0yJMz
         rE7Q==
X-Gm-Message-State: AOAM531IGfNoVdW2gK0IqMM98+xde5PBjYtUwIl9RgmM1hYqsjxyUzai
        HfXDhAaEdMXXRWzSYdLOIrvj7rsmxlDUPpLsGTlh2g==
X-Google-Smtp-Source: ABdhPJzLRUufAYfOJ5hW/Am57eGfw44F4kgbDz6OnXz/Nl17zc/pKvs2prh5vnivt0JYOdVIm1Y0MOTzAPIFd7m3Va4=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr21263813edx.365.1618046382906;
 Sat, 10 Apr 2021 02:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095300.391558233@linuxfoundation.org>
In-Reply-To: <20210409095300.391558233@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 14:49:30 +0530
Message-ID: <CA+G9fYtZZ_73b_i3Cca3UunpbJPSBTWufTVGs4RG5r9iLTu2rQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/14] 4.14.230-rc1 review
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

On Fri, 9 Apr 2021 at 15:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.230 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.230-rc1.gz
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
* kernel: 4.14.230-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: bbc0ac1df3446fb814abe1f0486c72f81bb95577
* git describe: v4.14.229-15-gbbc0ac1df344
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.229-15-gbbc0ac1df344

## No regressions (compared to v4.14.229)

## No fixes (compared to v4.14.229)


## Test result summary
 total: 54655, pass: 45540, fail: 651, skip: 8277, xfail: 187,

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
