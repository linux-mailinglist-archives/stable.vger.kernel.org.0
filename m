Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A0B1CBF71
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 10:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEII6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 04:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgEII6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 04:58:32 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06711C05BD09
        for <stable@vger.kernel.org>; Sat,  9 May 2020 01:58:31 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so4155219lja.13
        for <stable@vger.kernel.org>; Sat, 09 May 2020 01:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5cFq6mnReSJOlIHJ83KboL83Q02sFWdUd1ilkeH//JM=;
        b=GdgIHU4msEKXyL7U6kPerKF7VB+wU/NhKADbYFiOgPywrGxqyeS7NWTtz6vvYWyLMS
         XZsgvpRhVWftc2MKfjbyTl4lgEV1wRCg8nHTlFvzQ/Ye4NPw6fNsa+6HATKoC+3v8cc1
         KQbIdxvQxwZuW7pqEfpHsEhtwp/PoHIzZP0XLfXAoxLR18bhuBluCmbCR1URh82A6uIs
         ZIp/ANS1b5pBzGVFyJNdjC/j3B0UMEHf6suuq0lX2I6a/GEW3lsHi+HisYB2RNKvQMZa
         IuFeeLYzhrug7iOQVl1pc3nrFm0tDd5QVW6s2l/gM+z2zN7qPuA28w5tPiM/znwMY34B
         b7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5cFq6mnReSJOlIHJ83KboL83Q02sFWdUd1ilkeH//JM=;
        b=TS2Enbuf/FnRC6HvQ7IcCP9CgG5SD66ZlnMBMh6vHPk+0cVS07IdXeSKxlawbCdZiq
         5tKn7oTcrhRi8Lx6TweBDQTX/W3NUpB/+jFtG5eBuqf8KYsxt+GLpKyolR2+Ok4GEyn4
         5pCghUpIbko2kS2Hgs53Fc4i8LCLiEgePw+5pFvvrUKW04LCSnZextV3V3E3ME0tZYpE
         PdxgXy39QAiQRodUeYTeBrQEF0KfvjT1WtARj0dRqhlDjZBNRvg5P9SbYxbF+rhXvM7w
         bWOpqHv07S2OipCMuCl6LA+Qwn3KBfSAqzDl0CP7FDHA2yGMlh631CNe/F62G1s9I6J/
         0FRA==
X-Gm-Message-State: AOAM530AHpx7n5s8paKKdblqbKlzKFcrVFxeu6l1VnksFMhMVzvcgF1a
        /RgIst2SvgzI/OYa4HaFVNBxtURBBCzP6Aj881qFrA==
X-Google-Smtp-Source: ABdhPJxFEfJoGGXxvoDb7qDNnc2/eJqU3UrwQaveX6HKMmtgZljtoDc7zxFCIbEYtEpyMx7pOKk+HCBuWgFtzv5leI8=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr4282861lji.73.1589014710276;
 Sat, 09 May 2020 01:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200508132934.548989409@linuxfoundation.org>
In-Reply-To: <20200508132934.548989409@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 May 2020 14:28:18 +0530
Message-ID: <CA+G9fYs8Q=nMdpLNvzwwJ-+6GiBeZJCqjj5qbpA6nrYPvC8ssw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/49] 5.4.40-rc2 review
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

On Fri, 8 May 2020 at 19:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.40 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 May 2020 13:29:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.40-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.40-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 695621e788325e527588a26f1a9c6c526b69a2ee
git describe: v5.4.39-50-g695621e78832
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.39-50-g695621e78832

No regressions (compared to build v5.4.39)

No fixes (compared to build v5.4.39)

Ran 30255 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* kvm-unit-tests
* libgpiod
* linux-log-parser
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
