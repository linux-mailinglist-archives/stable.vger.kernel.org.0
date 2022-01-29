Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A143B4A2D6C
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 10:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiA2Jii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 04:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiA2Jii (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 04:38:38 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09921C06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:38:38 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id m6so25485146ybc.9
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x8oTHXyVoob250FmOz+GtPBKKlC5Finw/OsEFce6MMs=;
        b=vHnWZhQ1GIcVvWQL9ktXBM4umWNVRj93nDCaawDMUNc6CAHd9OvNrp9Im580678g3D
         A8ojea6lJV+WoTN66GkGACURlt5MMjwjM2sy3yZ1hR+CCOU7D59mEILl5uXoe/x/rNlW
         BqkyJfdWKjs6ykX4J5PvQspxtql6lrqmCsc063fZyxx6IrW+PgNvSc1d1mcnLPaBvYJu
         mfFUQf5LVVdlacJN9qeYZHTIwRbIoY1bGi+LZeED0h750L9549fw4dk7I9W5vV3G0gld
         CCiqizMz438r1dWjdLF2Jy8xViR3rtduLfxNBLh3VpokXZwAD0K6MHgXJrt4vx9AUzzm
         QsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x8oTHXyVoob250FmOz+GtPBKKlC5Finw/OsEFce6MMs=;
        b=UHq46BXAv2GSwWR3smnGhvM11MRpoyJQes+Qc+I4KwQqgjEAWI+1cI7vlpGjj+Lzho
         IkdCuQIT9IlLPGg8ijKPBg7rShhMiGc8PlPi79gkrXFvNzdX3EUPKCGJ2Wop2Hq0fXrK
         Jp5nyBr1WzltmkhIgHQ2PDsBWyr40Ke4XlqamFON2prHDNQwBLWDcmhfbGF/4OGEHpbh
         2Sx9ANb5euFZuLTlEUAjVB7VGhJez0m9/oMP2vc7V0+iJm0i2RZZVS6xjM6j83m+qvOD
         y1Scq+Foqx/vt5jZcUKyZLO83iSQpiN4j3Ewfq+c97VnNfWtRfS0oegx82XWnmLzYPPY
         JtXQ==
X-Gm-Message-State: AOAM530Nz50185oLYA91uU5w18n+fEd42Y34aAjPYd/Cwrc84SwV8ewJ
        bJ5nmpos8UI27xt8XYfMZ3frTena6ZNUcRtpbNRQQw==
X-Google-Smtp-Source: ABdhPJwMb3vOBAmNK/GUt0OhtvjRstXoGlHNhlZw9/5SrdD/uIglcigRMoUGe4wHu9e53sWVyqX1yHIOqMJnGKSLjd4=
X-Received: by 2002:a25:97c4:: with SMTP id j4mr19123089ybo.108.1643449117114;
 Sat, 29 Jan 2022 01:38:37 -0800 (PST)
MIME-Version: 1.0
References: <20220127180256.347004543@linuxfoundation.org>
In-Reply-To: <20220127180256.347004543@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 29 Jan 2022 15:08:26 +0530
Message-ID: <CA+G9fYvk5Ye+6Y+Tu0mwYhe9bEL5y+dgAmQKDpQ=2CFtu9Td9Q@mail.gmail.com>
Subject: Re: [PATCH 4.4 0/1] 4.4.301-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.301 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.301-rc1.gz
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
* kernel: 4.4.301-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: 187d7c3b8ca09131c71f6dbb8c8761f7f809402c
* git describe: v4.4.300-2-g187d7c3b8ca0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.3=
00-2-g187d7c3b8ca0

## Test Regressions (compared to v4.4.299-114-g67ca9c44f63d)
No test regressions found.

## Metric Regressions (compared to v4.4.299-114-g67ca9c44f63d)
No metric regressions found.

## Test Fixes (compared to v4.4.299-114-g67ca9c44f63d)
No test fixes found.

## Metric Fixes (compared to v4.4.299-114-g67ca9c44f63d)
No metric fixes found.

## Test result summary
total: 33090, pass: 26341, fail: 104, skip: 5946, xfail: 699

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 24 passed, 6 failed

## Test suites summary
* kselftest-bpf
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-ptrace
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
