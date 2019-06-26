Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C50056B8E
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 16:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfFZOMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 10:12:49 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38121 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZOMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 10:12:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id r9so2375937ljg.5
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kGCczBKMmwtoAPIgAgoAK1znJOqwuffap+U95oP48aQ=;
        b=fHToLBWCNEeWsBMFXKrNOdgEUWNTOeJrz0554a7bFhtX9GLdUlMqMf8eMlPt8hwilX
         +VVLuOLlhQGyXFIUj4Jg7zo1sizfFMbYYm3tVhtVB6d8UEriMJ95D9Sj+AMh1oqyzD4L
         jWOJSGlCr1CGiRnnXPCFnkhZA1e4FUhc6o5PyAaY06LiuFFPsfdshGm7TDqGAC81LgcE
         2SdeOYVImXn7oRjkU6NVWLVZxiZ/U8TTiFT0Pvk/4AZBENYZwlRXlSKG+ZyouOTVRAaZ
         dtHybT6MvLpI/KYOARDvhhR8xkqGWqUaJoZt40YStS8FrQ0T+VNyGk/XxPdV4aMnazy5
         bs5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kGCczBKMmwtoAPIgAgoAK1znJOqwuffap+U95oP48aQ=;
        b=k07I7adMVHFyWkUjqV19UIVntuGAAIgUC9LT3QK7BzKGUh6/pQShLnnJrcBjACUdX0
         SKRmfhMNb2Q4/gLTV9wC3zcwR9j1zcI4Acvqm1o0fXsW46T3UDHsz29pvNDarQ9w9SVx
         N+S77oNL1FUxbLq8iHpdmADFUZovsp7fWb/E4QH4N4u7TgvPbM1iKgsECofK0un+gzvj
         SCjzigu42XKibf/MABitlKeTAQ6YkPnr2K4riUsrMSPZXCV5QTMip1BB25l3Ak6xCy7I
         q5tEWZDh/YH8Mr/kH64rSDlzCNABRAS4CTxjOb30T6RIrvfCGe7VmY6QfGzkaCKxdiZ9
         07EA==
X-Gm-Message-State: APjAAAXJNRQmOYOKqgwiSUYRcRLy4Ai5dmJVLjY/sxZhucb+Ejr2cJK2
        dRz2W2FDfWoNvPHIsUndOMOfWDzZRqz+9ClrReCzYQ==
X-Google-Smtp-Source: APXvYqwJYX6lmMho+zfiBhOo3RnlUAcYYPVwf5Hth73GQMEDhxUSp5mZl/XLAYKOm4qt+EDbgr8RSOP4q23wfWeHiQY=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr3107951ljj.224.1561558366442;
 Wed, 26 Jun 2019 07:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190626083606.302057200@linuxfoundation.org>
In-Reply-To: <20190626083606.302057200@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 26 Jun 2019 19:42:35 +0530
Message-ID: <CA+G9fYs2SMLGe+vtbXXLHdf95KwEDkitZL_Te5CuHr8nB3A5fA@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/1] 4.9.184-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Jun 2019 at 14:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.184 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.184-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.184-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 493abc5bd1493261577ac0c23c94c9ca7ab7b435
git describe: v4.9.183-2-g493abc5bd149
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.183-2-g493abc5bd149

No regressions (compared to build v4.9.183)

No fixes (compared to build v4.9.183)

Ran 23674 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
