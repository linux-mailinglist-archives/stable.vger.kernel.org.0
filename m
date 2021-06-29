Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6138B3B74B6
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhF2OzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 10:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbhF2OzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 10:55:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1FAC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 07:52:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q14so31668048eds.5
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DPU9Q6gwrzv94ZsGwUmEvxsph9n8pWTojpUV5jCNo9g=;
        b=A8iBjZPbzMenjyuebF6rSpOt8ubLUNgXGEzjEu14nxKlq6jdBbEG7EVv5iP4suBuBE
         iNAxPQKC2TL+KufioLj0P2w+Y/uObzskg+M+/VNfnRvCJBBhPpbeeoGP+Y5D6rRlYfe/
         A/aHn/5McNMSCYAJcMYg3V5imX0HvHH/P6lpOZIuumXvfepa2xGKs6afznR0vTjhubNj
         eDgJPbDFLL0Z6W9+wOqpP5w53gl2cLyPiojFLAdqK/J7YInJaqT3G9Rs0LzQNrUxYSu7
         hffvXdMKlshQCnKjYARsCrNW9io2A6dJfzPiawxiyemLTpLPHBpvDKw4Uy9c+dDq9Z8W
         xqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DPU9Q6gwrzv94ZsGwUmEvxsph9n8pWTojpUV5jCNo9g=;
        b=bk3ATjfdGi+utIcm8RNIcFr6+KElWKx/FuKGt0D9FkWdxUanzNsHBn3zVCYd3ROmP0
         14ABOrClwyN06rkDlZd8XKBCQi1DgcweEpqtSLwNJMZGa9uCT6QhmjAhPSmd941Op5bU
         a8A2sAwwaGJf5Ac89gkmRUD4D1KQjVibPXDHNa07OxWkc1YL8nazCQXphc0MfrvSPeoc
         sTgoku8s9WfFy8V/4ULm3XigBVbjRE+iHc8C4JJ+mIPd8PrGFfvPouWw8ypi5/pEO9AM
         U6yqfbgnY1ABjiZrybm2FC+mLKG8Tb4y3pxSq29EV25MGtP9ZPqVVoK+m2NepAXOoS1I
         LIIA==
X-Gm-Message-State: AOAM532m4AObX4SfVGPNlQ1Okk3fGZqBMsBvHFVwPJ4mYRYQRuQ/emlx
        UYbYJAvfuq+IcqhGMxPeKZa651vb2oPof2XnsHHXpg==
X-Google-Smtp-Source: ABdhPJwejZhCljL+LLqakBbwrTGTXpTO+OdismZ3LiT50zPXGdwTZH4aHAqnVF9FiNjqqYZRmChpMn/+9IW7gsqcQ4w=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr40196473edu.221.1624978357112;
 Tue, 29 Jun 2021 07:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144256.34524-1-sashal@kernel.org>
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Jun 2021 20:22:25 +0530
Message-ID: <CA+G9fYs1ExQAXQ8KfHAQ2HFTyjij0JV8H_yqnyjmBTY5BMYEbg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/57] 4.4.274-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 at 20:16, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 4.4.274 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 30 Jun 2021 02:42:54 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-4.4.y&id2=3Dv4.4.273
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.274-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 5429409d4e80dda1d9007a0212f7bc9686802783
* git describe: v4.4.273-57-g5429409d4e80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
73-57-g5429409d4e80

## No regressions (compared to v4.4.273-45-g39f2381bafbb)

## No fixes (compared to v4.4.273-45-g39f2381bafbb)

## Test result summary
 total: 23394, pass: 18219, fail: 152, skip: 4281, xfail: 742,

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
* network-basic-tests
* packetdrill
* perf
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
