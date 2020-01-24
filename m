Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC2A148CF8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 18:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388594AbgAXR2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 12:28:05 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46360 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388023AbgAXR2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 12:28:05 -0500
Received: by mail-lj1-f196.google.com with SMTP id x14so974619ljd.13
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 09:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UGMSWK76YdUJLyg/HEwmEe/+T4vUjTTYEZ1ajGzTMqY=;
        b=lgKYwjUjZTof1gSEQSFrujri+3PDPFyGTTggqYxzgqP8HQY+17ABImTM+sEIO6/bbm
         TmQKG9KGdY0EVIoYXp8orfht0wpVPmsGoLn7GEWhvi4PkyL925nRXEJjtui8Zcrvvp2Q
         s2GT/PRt3Uv6JRYB4SKoCuW5LXaycyha7T5E6H2SckBEyfy0VgpthNGNMq7h1LM2f3GH
         dRWu35H/QRygaSsErhXWNuRwNRjoP8c4lQTog21i7Z9YpdadHJ1XC55PvLv3ydYwjgdD
         QVnvcs7fjEhplOJy7PWJVs3juLl2VnwcNI3ZZ17rM5trQkTdu5vJVEJqASOQOFqeAbIc
         aWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UGMSWK76YdUJLyg/HEwmEe/+T4vUjTTYEZ1ajGzTMqY=;
        b=sQxit75SBTxm33KkXK2/RrzG5l+oq9v/4R6fdbaIKmSLVngQeknzceSRieJHqt/vhm
         XF8bhJpC0y6FyRNmEmMkpSxNOKyZL2UXphD8ZAPWGrEvQDiQBO9hDmhQYGEhtk8OVo/V
         XlqEjOX0INXBXWJjMuw7BjVYWgQVj/Es1Fp8tidMYQkXcd2QmQ67l9OCVbaNasuExH69
         oZB/iG2PIxVST5+12yQqgvwAJUS/VULNpdIp+R/9tW/VQ7w+6N4g7gDd9dR7KLxFnQ5S
         hzctBUc1gSlqOuXKxqAR7FZsY71MPppeW5u+U+sTR92e5Wb/JYd91bEnQdEMY9aCwOlL
         av9g==
X-Gm-Message-State: APjAAAW90LrVryvrGmXYGqZIfOTGXApNFDdRgWntEDjqEVZSMHFE0ie/
        mY5V0cQZP7kVcfIz+uW0F6JqCo17f61dcqJq6WaCVg==
X-Google-Smtp-Source: APXvYqxRYP4fYsYxiT3t3PxbIXqTMQPcarw9xwK44aXITbQvo8PJc5+Zz+AHMJXhXhG2NjY/bEQI2C6ApWOBXGplPSA=
X-Received: by 2002:a2e:e12:: with SMTP id 18mr2925450ljo.123.1579886883335;
 Fri, 24 Jan 2020 09:28:03 -0800 (PST)
MIME-Version: 1.0
References: <20200124093047.008739095@linuxfoundation.org>
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 Jan 2020 22:57:52 +0530
Message-ID: <CA+G9fYu4Vwux7yKxrVZ6ZAMQXp16O_=odyMpzLDSM8YTD4CaQA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
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

On Fri, 24 Jan 2020 at 15:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.99 release.
> There are 639 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.99-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> Petr Machata <petrm@mellanox.com>
>    vxlan: changelink: Fix handling of default remotes

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

selftest / net / test_vxlan_fdb_changelink.sh fixed.

Summary
------------------------------------------------------------------------

kernel: 4.19.99-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d521598bed2464511b7d1f1dd553132c7b658394
git describe: v4.19.98-640-gd521598bed24
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.98-640-gd521598bed24

No regressions (compared to build v4.19.98)

Fixes (compared to build v4.19.98)
------------------------------------------------------------------------
  kselftest:
    * net_test_vxlan_fdb_changelink.sh


Ran 24093 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- nxp-ls2088
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
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-ipc-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* kselftest
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* perf
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
