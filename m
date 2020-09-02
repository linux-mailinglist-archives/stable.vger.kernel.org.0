Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C8825B1D8
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgIBQh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 12:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgIBQhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 12:37:55 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71774C061244
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 09:37:55 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id g20so1774967uap.8
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 09:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rqBYiFZGLOpfEEFyqYe8Lf1o94A1iyHyS2oebwYcAQI=;
        b=lO+hQTJ2eeT0/CFHSt8LT8m6Dv31NjXrOjhW3yLTKTg0XLguY8LXON/siFxYYMnDpg
         j/06bH73ROslHJA64/8bClr5nv89a0ZGlGX/JvQHphEBDK+wQAJPpnLrgwfBXJ4r7YRH
         cW/XL+jWLla6jEk3I4Y53UEPB6tBQnGsmb9GKE7y+fSM0DPegqyyJA7XBWnRPxgaaUtR
         gQTI62nWQ68Mb7FGW7Vhm48YLdz2H87UZgyvDC0r8UCtnUUqwUfQaPE4zKaZnTXOL6TW
         Yv5HQg3EyA47MZbKE3YIi5xz8z7zrxREmhPD4lbBo516S4NiHe/QQ+Mx+2nPjOUc3sYc
         F2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rqBYiFZGLOpfEEFyqYe8Lf1o94A1iyHyS2oebwYcAQI=;
        b=dKLlqKyjVZtURk0uC8l+7hbebtJ99IU/eBrs2aaEd3E0ixhT+VSc3xyberHtvaIXxW
         5criTacMUqD1yJyJWOqeluMwoux0pwb+N0QXOil2cKQTpls6ysolk0F1j5NAWN7YXfvY
         +F69RJb7G2l/xFyYFe754vJa7puwX+0CSyfGUu6CMY85x1lzT6HcqDYS582t3gEIDEtR
         6kap2hDqpsfuo8WD7RQkbJF3MmUVYHKw0Bc5A8xNB03VXIuaIU6amtIWA7qxYt1YVHn8
         r22DumWFJuFRpBW+9cvIYo+8ZPNk6Gq5RK11Llndr/ykuXRfOFz6XzvFX0Mn/6YTU00f
         5NPw==
X-Gm-Message-State: AOAM533u7vUnRRY3HJw557SiHCz3lS2IJke3Q0oh90YChJXejztKAzFM
        mzI+TmZf01APw36kLcjY/32UKxTSpCMfNuk+vq3RvA==
X-Google-Smtp-Source: ABdhPJyWUIC3FATDj/mmDu8fYugbxH6epoihEdmcQ+0xu61BFcihn8aG0uwPRXZHPqPEtW2pwR0kcpRzZY+RFlYPkxY=
X-Received: by 2002:ab0:3443:: with SMTP id a3mr5854076uaq.6.1599064674531;
 Wed, 02 Sep 2020 09:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200902074834.222878009@linuxfoundation.org>
In-Reply-To: <20200902074834.222878009@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Sep 2020 22:07:42 +0530
Message-ID: <CA+G9fYu9HD80dZMan0Xa57CbexuHwENFxzUGggLZp1ToAs+Lgg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/213] 5.4.62-rc2 review
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

On Wed, 2 Sep 2020 at 13:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.62 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Sep 2020 07:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.62-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.62-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 04f875777fa691b1a41d4545eeea72694643fcae
git describe: v5.4.61-214-g04f875777fa6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.61-214-g04f875777fa6

No regressions (compared to build v5.4.61)

No fixes (compared to build v5.4.61)

Ran 35699 total tests in the following environments and test suites.

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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-dio-tests
* ltp-open-posix-tests
* igt-gpu-tools
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
