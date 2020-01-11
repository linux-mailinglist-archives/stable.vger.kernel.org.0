Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF281382ED
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 19:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgAKSkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 13:40:03 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38810 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730777AbgAKSkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 13:40:03 -0500
Received: by mail-lj1-f196.google.com with SMTP id w1so5556246ljh.5
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 10:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7IVbMhR8sq//32TE5CkBAWNBabhEZ44ETBqIzXvc3dI=;
        b=c1ITP/mUtuvQqyzYYS8aKW1vUxXUB/GDTm+JmuybZNR5Ss0KXLCozBvO4WPOhu3dIK
         pX88HzzW0c1LJVyKKMIk6k9UNhkt6caWnUnJXPHOO4PZeQ5NO46C9/+7fqUdIb3y2WcQ
         l4ZdFzCXWiazi+kaijYhUJ81z6n2PqjJaDtwseEfIoJoDYlNZkHLqK+zh+Hcfh4i/2S9
         x95XSREzw/s3r+TLciTIk+UyM2152Z1t8qyTV4XWVpb4fILFwWZpeYQLSEC4KS5H/lcl
         BYZe89V3rnXOVMCZPoYhAx9N0bRolaTqhXV2+na4GswxwrRqj948Sz3qgya8FmnTRii3
         SxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7IVbMhR8sq//32TE5CkBAWNBabhEZ44ETBqIzXvc3dI=;
        b=dbPm1X1e5VHFJEaq6tFBdOhaj5mKFyK5m+4wkm9pg5yRtMH2dHC839TWyQUBsDt/Q7
         mCxxH/K9dkqePkYC5esmkk23TFLf66BAuvYGs4R/ypOc6jtO4xSl3ie3yvRDa85q6eFa
         SkZLYg1P6ZmxjN4/L57JBdTpGNWeuYY9RGpNtZBiKjPU3nVt14HxUNVjVBp2vqeJyUwa
         qrAz453m+1FV2uD3lOVYRcpjBx3WTKCealgdejf+VkNwm/LXem/A2KWNilZE502xQLMs
         xdP18Sk+W+3/dB+XL12SBflauLjqA9LW1dpOreiCGyGJWBdjc7KrR852/1GJKYyuWlNH
         Li3Q==
X-Gm-Message-State: APjAAAV5HXNz3zCaNlvTTnF2WTcKjBg3aj/gr571PU2VJQN7XUXH1RiK
        m/TE1ybZ5aoMik5WfrCEOmhRXSZEaynkwHo7dXTmnw==
X-Google-Smtp-Source: APXvYqxO7vmkfLLlmUYKEHrHDOwTwRElIgtZNzSDL+bQ2H74m/lD061WKyqzlCOe8RieDhGWd3MgLhMelWXK90iG5Gs=
X-Received: by 2002:a2e:9613:: with SMTP id v19mr6437995ljh.47.1578768001275;
 Sat, 11 Jan 2020 10:40:01 -0800 (PST)
MIME-Version: 1.0
References: <20200111094835.417654274@linuxfoundation.org>
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Jan 2020 00:09:50 +0530
Message-ID: <CA+G9fYuUL14N0_LNuooZgJ9K4afWsHRPzR1U7NWkpxS73Lz5uw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/59] 4.4.209-stable review
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

On Sat, 11 Jan 2020 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.209 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.209-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.209-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: ce8c9a6be3d9aebb56382d5a4409a7cd44305989
git describe: v4.4.208-60-gce8c9a6be3d9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.208-60-gce8c9a6be3d9


No regressions (compared to build v4.4.208)


No fixes (compared to build v4.4.208)

Ran 16706 total tests in the following environments and test suites.

Environments
--------------
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
* kselftest
* libhugetlbfs
* linux-log-parser
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600

Summary
------------------------------------------------------------------------

kernel: 4.4.208-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.208-rc1-hikey-20200101-645
git commit: 45aaddb4efb9c8a83ada6caeb9594f7fc5130ec3
git describe: 4.4.208-rc1-hikey-20200101-645
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.208-rc1-hikey-20200101-645


No regressions (compared to build 4.4.208-rc1-hikey-20200101-644)


No fixes (compared to build 4.4.208-rc1-hikey-20200101-644)

Ran 1568 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
