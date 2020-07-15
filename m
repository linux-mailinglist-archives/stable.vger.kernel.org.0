Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA315220904
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgGOJlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 05:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgGOJla (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 05:41:30 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5310C061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 02:41:28 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u25so720285lfm.1
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 02:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k1aB59xJzzV9Zgka5kmL2bgePHq7UP95SPUQANhn3lY=;
        b=bkNDVDfwdUPMmXauAUFTxo1rAPhNE72iTW4BCL8OCMD5iQw4E7xMAr+aXLcVnKx9Jj
         YD+j/VUN7IIwTlUPxVvaaNphv7aHSZHn8NFoQ6iqHokGrmxx17+G7263R6adbOZowbnw
         S2TWnaCyaXqAN2Z+icpQyBAfsziTjlMuzEJ7D1xWrU5hfcpHxj/eijd2KGwD7W6K/+h6
         MdKHtNYgr4VGmF8x+8xfhOPJZ/FqnpzSmjGCeiQP560uokoeo4ALR5uy1NVU0iNSrhnE
         Vny8JMBoNBUKHNvDMvrri/Jt1sIkQu8CEXZltxHkKcdVWPzIKQnD1wDpvtggcUbDu+CO
         I+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k1aB59xJzzV9Zgka5kmL2bgePHq7UP95SPUQANhn3lY=;
        b=WyBknullIjnqVpBNgwabrFGH/Y+oiLvh1y+vyMVKOKS7cDkWM4fVOjFjqKf74UEMc8
         0ZWqdBeCHK7Z8LrF7s2pJ5jYK1HqEcR7So2d2EMX0IRt7gbPsaF7mKXC/8rU3u4px/p+
         aCIsyM5ewd7Oi/3V3pTb+dWfaqOm/6efEqJPPf8UgjWvzjJrLlQnsKSfimiTt0JQCvbV
         S/ffywI0dVbkA9nVRsGMTEYmgN7c9bgXDiOhgUU7DossfOP4ha7b0tPwJIinkBl5pXje
         TODQGkQm5drD+cM+5pzmijABnawMOuNsUwf99kzalxRHwVtYtTG8oHnqh/IBK7XxHdDd
         IT7w==
X-Gm-Message-State: AOAM533Qm0yectgGjnBV+t/WLXvpcntIiTL6CgEWx3xywKHfVAty3J/x
        VxwKsaQNutngK9/7z4oMWmZf+5AcQ910eRWvfweY26eGalxJOw==
X-Google-Smtp-Source: ABdhPJw3G7L5gZTWxkRfp4kncFkH4fBbb2QptrMvbD/7lSCGCCpOwSWcEyUcCV4SeuQni2N8/XwPVvNEOzq7Zr9bhZQ=
X-Received: by 2002:a19:2292:: with SMTP id i140mr4252097lfi.95.1594806087007;
 Wed, 15 Jul 2020 02:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200714184056.149119318@linuxfoundation.org>
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jul 2020 15:11:15 +0530
Message-ID: <CA+G9fYuicrgx6sPfovfzMX4W31HPE=LbxXtBKB5M-M+2sz+sXA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/58] 4.19.133-rc1 review
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

On Wed, 15 Jul 2020 at 00:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.133 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.133-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.133-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 4e2a5cde3f03246325a5db594e9aff787b2b7fab
git describe: v4.19.132-59-g4e2a5cde3f03
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.132-59-g4e2a5cde3f03

No regressions (compared to build v4.19.132)

No fixes (compared to build v4.19.132)

Ran 30760 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
