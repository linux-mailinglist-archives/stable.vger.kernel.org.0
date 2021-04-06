Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363DA354D96
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 09:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244188AbhDFHOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 03:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbhDFHOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 03:14:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D68C061756
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 00:14:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id mh7so10256489ejb.12
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 00:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5o8F8pFpSh9SovEOCoJlZCcSPH/Bz3/ZuKM7tkIfuTg=;
        b=Dqb9WCEpwD/fE/GfwGGwIsVYtDLVbctvrsCphUaZ34WNe7zaFe2o69exVFZY6W5cgz
         S48BkSgZdTjbze8f5qdm6ndcVfoUxtC4ZQwyVLdzT1E2lLIVhdGRjivjEDaW17fkL/f9
         CMIqrhfnsKnowXrqW1yoD2R1PoBry4Vl1QRiRLh1CeQaWSkCUDHhWrSdAK4XbE8znuci
         mrOeBbdas8+LXJnWpW35nKEBR/owcT9SthjMcHL4CC4REQAwCOxj5OysoiXyM8rxvYEt
         FrJolInrsnYjgpRzFwZ/VgugTVL9rDk9OinKQ6+s1eCwRMFc275PaCDdEiZigxNC/92x
         IDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5o8F8pFpSh9SovEOCoJlZCcSPH/Bz3/ZuKM7tkIfuTg=;
        b=ivMH3FLGenGycybg7gGhVyEt10XlP9KYWtFJKYjYQxc8rPsja4QeW87tdm0YZ0BRq3
         EMS7xgZzdYqNWOXBqw5pqSmmlZKVFGxNtvT42PDj5itX05KUhM0uTVhV9pzKPFIsuBlK
         sMQyLfPStUOuDZxTSIwt8a9EvOoLCMBPKwXg3Sg6fVErY7J+0XADJ5sOTxSjPgrGG71U
         tiFyzSsWEcrd9p16HTwgd5bzHOmLhGFSoV+57QvSGg4KSWIBKneHke4QmCC1dBabvMGT
         FXQf1ywsPNiY/J1wUkimrkOydpwdTY7fJdBtkKuoh6sFhu0fghI91WXGdGaO2ZnEkn5R
         Babg==
X-Gm-Message-State: AOAM532MajiuisEDnzYuRCweG4/3s+PFOka4fJspI4A1RRi8BIAGSjsw
        YgUB9+NH3cB7U+6lCioUQt6zTH5c7/2DkBIkkPSL1Q==
X-Google-Smtp-Source: ABdhPJxvkgdf7NNPYXg1ME2HJt2DO3J0gWz9j/pgmOIhNy8OLcybUK4vzXag2jE36m8BcmkYbr/CRUNtrGcJSJstsW0=
X-Received: by 2002:a17:907:2509:: with SMTP id y9mr19984250ejl.170.1617693268779;
 Tue, 06 Apr 2021 00:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085021.996963957@linuxfoundation.org>
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Apr 2021 12:44:16 +0530
Message-ID: <CA+G9fYt2oX=297Hn75_9=3L1d-6LMMYA_p9EXA9Ejwc32Zvnnw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/52] 4.14.229-rc1 review
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

On Mon, 5 Apr 2021 at 14:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.229 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.229-rc1.gz
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
* kernel: 4.14.229-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.14.y
* git commit: 9d1c6513551e6928da195e22c6b32ed0adf42593
* git describe: v4.14.228-53-g9d1c6513551e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.228-53-g9d1c6513551e

## No regressions (compared to v4.14.228)

## No fixes (compared to v4.14.228)

## Test result summary
 total: 56301, pass: 46585, fail: 686, skip: 8844, xfail: 186,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 13 passed, 1 failed
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
