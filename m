Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0055677BC
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 05:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfGMDFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 23:05:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42023 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfGMDFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 23:05:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so11095472lje.9
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 20:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xGCNM2E6Vf2bKEDhIUTL8F00ewA4KlinsHR9+GCg3hg=;
        b=wpOn8oqBAHkefeN5DnP08xmFfrNNiiohDBn/iC9IBMhm93AnbvYIeHCkGjw3LKjckx
         Kjnq23pPJTiR1+WotqBxd2MkOUCRVprl8xrAn/vYhhKrTdiwjQq5FLZQsT5LU6hgcA8q
         1gwsnC6BATsITNkCIyzuToZxquw+aVpzWRB3IjmJB3nCj8gQeuUPPuUpJx4Zf1tE7OR/
         SMWSyCAywbkTvzMCexLjX7CU2B5c50s58HJL6Mq9ptX5E+70kP26z3/28jBQ84MXN0eh
         bFRp8MTI07OIQxrVmzEeTxagt7Q4MQNaMiaJjvAwybuzGB7ju+oHJTdqufCCRhN/nSfL
         LY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xGCNM2E6Vf2bKEDhIUTL8F00ewA4KlinsHR9+GCg3hg=;
        b=Z07gtY2Ms1WM9Pbk7khFNBUuNaYUXma6tcROxUFDUyIaM8aSpz0eJ/+fs6n6jRiEpk
         gLKXy+5SqLJE9Mm6TFChTyXtdHdrgHJkL/zgDpPO/HQLgSHIhfNMDBgFITlt+OGJ44wd
         5FJmvfp8wKc4T5WuC7EgWyXzmbsQfxd4Uwz6rvrU8xf+bE4KwvjmCAgtLuvIjw4HMGZz
         ZXkba6PYdIS6psmdDyMII00riswTiwznfXOG7aEzUbil0EkcOvMACu/Kt2EPef1km0G6
         Umn2WpbdVfEq7ZXFtdQmx4UNoeg+vExBCHl36/36dK04mwlkA63sMi5pdqiPOT1zEZgJ
         tnyg==
X-Gm-Message-State: APjAAAUyrhRCyPpAeDYz/eFlDBhHv9DznmHskEQHfj2Nbt0bAWEgt3xT
        Bna1XS0+KLzwAUeWXapDc8KTvJAA61t50rr0NPwDQQ==
X-Google-Smtp-Source: APXvYqy+2bIYH5q+DuXF113WtyoJ2JRjhc0VqseuHWx59/q7EeozlRYkZ5IFph5LLN93IQqQV1CTd8YV/2zFNVZdwww=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr7632583ljj.224.1562987102807;
 Fri, 12 Jul 2019 20:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190712121620.632595223@linuxfoundation.org>
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 13 Jul 2019 08:34:51 +0530
Message-ID: <CA+G9fYsm6jgQm6tdQU9Pyc5cUoW9D5Ff7kxb-2mPzzhE99+Q5w@mail.gmail.com>
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
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

On Fri, 12 Jul 2019 at 18:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.1 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.1-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: 61731e8fe278d37915a743554d370bc33a2037cb
git describe: v5.2-62-g61731e8fe278
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2-62-g61731e8fe278


No regressions (compared to build v5.2)

No fixes (compared to build v5.2)

Ran 22507 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
