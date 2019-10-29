Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4032AE802F
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 07:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732363AbfJ2GVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 02:21:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45405 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfJ2GVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 02:21:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so13880322ljb.12
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 23:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3mjDtFuttkWnacbQtxejyUKqELdseg1f4u1cMomtOQU=;
        b=x6H8nr6RaPjU0pdJ4CmKUdVK6ZL5SLBfcd0R2tv1CQxAF0Yo0jTq9r41P0iD8CYDY2
         4/HL/a+XspY+/FBql+UjpezlJO8jblELv13f5f1M1AQ/aEysQkcfKVKcYRNNSd3RfOzD
         u8RaWq0Ll01ts7CVQ4BMpVR1Iay4f6lW0Km5GYyxcQ4FWRZehBzrN47roEuuvXd1zrhU
         utmgBH1DuFfYBiFgWF32tGKaqykP1L0SEeaKjbOVDd93069DdvP1odQ67jWnIwuf+518
         JePsfRHggeG0stlHsaTLKQZHZPXTdUu7RnnkCDJuM4OoDpn1YSU8r+b4f7YssSSSCO/U
         r8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3mjDtFuttkWnacbQtxejyUKqELdseg1f4u1cMomtOQU=;
        b=KVvBQHj7JOiMks5aByOORmNHRJO9HwDvo9dR9uIxgMa5Dd6beF2afUZls/XTrWfTHj
         5en7a7/MmfsTMYumJBRpjZrgZNtlYFFXsjOPhcfzcX+o//gp+g+txbQb3QOJEK9f+a7c
         6BbO4JKTbkSRWLju0SegqQE+99gYEhmIgFuNDNFFf5yI6htTe44JrEqGaKehulethx+D
         H3s7hV6zRzuxCSgtiOYr585yVbhjFPyvHyL0QbQFEXINYwXsTNL/OwuC2V5GwidgQ/J5
         TzT2ezbiEMGrn6gGwNWTAGN10Rk8Vhlw2VA3hYE8HmKvr1Khd1Q+gb5iKRuj6500MWPx
         i7rg==
X-Gm-Message-State: APjAAAVx4a9dtO3J4QktjluGod+A/FmHnKN7JQfuRmzmnFPPFVpEdSr2
        vHZtD2OZwEQZvis6ddm1wq9glcuHPNGmgx+OdOjRdg==
X-Google-Smtp-Source: APXvYqwJL+KLsfQm4IBRUbyByU7cwJcmEttvyhwfzpWaxoQurPFLYDtWXtVKibJEVkwicul6oWTd4moOAlkjjtXOUXs=
X-Received: by 2002:a05:651c:1ae:: with SMTP id c14mr1021867ljn.135.1572330097959;
 Mon, 28 Oct 2019 23:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191027203251.029297948@linuxfoundation.org>
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Oct 2019 11:51:26 +0530
Message-ID: <CA+G9fYuA+kLqLo1_ev0=QRvYtMrVhwRvm+QO-tOCVYca2Mt97Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Oct 2019 at 02:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.81 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.81-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Note:
The new test case  from LTP version upgrade syscalls sync_file_range02 is a=
n
intermittent failure. We are investigating this case.
The listed fixes in the below section are due to LTP upgrade to v20190930.

Summary
------------------------------------------------------------------------

kernel: 4.19.81-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: b74869f752bfa7ad50c55349ee2f0bbd61a45f0c
git describe: v4.19.80-94-gb74869f752bf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.80-94-gb74869f752bf

No regressions (compared to build v4.19.79-82-g99661e9ccf92)

Fixes (compared to build v4.19.79-82-g99661e9ccf92)
------------------------------------------------------------------------

ltp-syscalls-tests:
    * ioctl_ns05
    * ioctl_ns06
    * ustat02

Ran 20491 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
