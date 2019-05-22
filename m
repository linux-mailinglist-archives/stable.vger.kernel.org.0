Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A72325D40
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 07:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfEVFDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 01:03:19 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36157 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEVFDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 01:03:18 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10so636934lfl.3
        for <stable@vger.kernel.org>; Tue, 21 May 2019 22:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mUgfIatM1kNjKURa7+IMrbSjjhGKxtvO6ACGQdb9pzM=;
        b=ncEOkkxDHtN4gVhQJkMwZJj4ftteqcFlcKphPUCO7EoaKiiFviK2UnxLfkn0knC57s
         z4pcAJD2osjV++jYV6r8c2Z1E6viES+7eJp0nDhLo5NNrnfJOpbfWWaxNmEwC1fTpky8
         46NSfU2C4GxDKSQbIzqvfTPInh8XIBO6Z7hAlpaRF+8PcJm3BhMRhnQ9BlLnSN455tQI
         M7mNBmom6lpbOxja8AgzR/g93s9bR03Oz/+Gv28LAyuxfEUe3Fsj6QT66P1w923OYmCo
         eatClC5LK8u5ZLRTeWj6Kox/2KWkGCAHpf3YDL3eRuUfSN4GEYgNvkCB+G2aIrlwZoDw
         l+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mUgfIatM1kNjKURa7+IMrbSjjhGKxtvO6ACGQdb9pzM=;
        b=DATRBSiW+cc9zkAAWO6s6gCHkzu5NS3wVvHPVwcmADt3VVng5aWEXo5NBATWTu3Gie
         iCnzUofDR29ZDtHaGTofTWTygiUJk21XpQR229MOEstzmqzRNdgO9sDbqG/Qg8kjuU7J
         gAkTPMPiyzPXt8eSvTLw1LB+GKHpc4cW3P84Z8PM8Y7It6yAxq7a0DYE8f8+1IrcTiHE
         b82YNnXPjHmHewx4LDHwhvPeK6KGyQX2QXWEOJP4zsUzlt06EDrmr2HiuBS/EtTmIdAw
         cUSl24dRAvSXOTwWH7NA11EYMO+nqL/BTUlIjGYz8vkePdfwdEWPpaDIEjwArHSF3c9c
         jzUA==
X-Gm-Message-State: APjAAAUQtCwMYyeuYcGEj+8QJkK2Z2u05ZMY3eOgcSBt+y1c+BlYvUw3
        qhHYPb+aJQ+iVn5crR9cLREMrQRXGqupa/8kGrqLqw==
X-Google-Smtp-Source: APXvYqwcppd3L1otyTrAFvU8gyjkN7zogkSWy3i20uwcGWBoADbYkkqhGmZ/rWNAJyJIGd4giF4x3k6yihqVpZaSHwE=
X-Received: by 2002:ac2:4286:: with SMTP id m6mr598910lfh.150.1558501397174;
 Tue, 21 May 2019 22:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115249.449077487@linuxfoundation.org>
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 May 2019 10:33:06 +0530
Message-ID: <CA+G9fYsUvkgLUnb5AcZBUqd_FMo5JSH-RHEWOqTNRdwKqsrnSw@mail.gmail.com>
Subject: Re: [PATCH 5.1 000/128] 5.1.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 May 2019 at 18:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.4 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 22 May 2019 11:50:41 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

5.1.4-rc2 report,

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.4-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: a8112defa801e2b32d9da822880f32966d30158c
git describe: v5.1.3-126-ga8112defa801
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.3-126-ga8112defa801


No regressions (compared to build v5.1.3)

No fixes (compared to build v5.1.3)


Ran 20655 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none


--
Linaro LKFT
https://lkft.linaro.org
