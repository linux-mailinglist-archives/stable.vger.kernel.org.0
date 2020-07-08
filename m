Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BE2217F99
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 08:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgGHGcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 02:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGHGcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 02:32:19 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67656C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 23:32:19 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q4so17095455lji.2
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 23:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J7FD3wyRdwBNOi/EykurQuvQUzOKvlavtfJpUAUaU7g=;
        b=Gng73fQQ5bGpkQQXBfkiyRpyh850JbOPGbjIx74a0TBkyc1a+WBm+cj2q34s6T6Kvi
         VXZ3kuWmVaqhpgBnD1ZvqofgvSnOxW0y7o7IPCSat7rfjFCP4SJvztomx6P3ZclcS9X/
         YkXLkFNAz95GuJwYoUpoE42pgli7AdQX/gdmC/dt59iRx+gvcdEbzS5IsNDscq/2tz76
         9iHqF+jpTLfArg3J41UQzx1n1IVC1pE1BHAnHiY0OQnrCR0ZrBZ+Bl0v0/arXk5ni3+p
         6YpOy6AQuX7e4RkTM+ZsSiCU19cgB42kbTdr5YeXr8XYlD7Vu35DDZdmmv14UBIruQp1
         laHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J7FD3wyRdwBNOi/EykurQuvQUzOKvlavtfJpUAUaU7g=;
        b=l5BLdnQOCR9+cMtA0FohtQzjGFhkmASoYTZINKVENbbu9I8NewAoVkK1wA4E9gteyh
         fmLvZ0dy+Z05PV88QOKqmPkcw/RfbA+j8tnUVKfLiP9i4usgkmVB1fLhFOKg1bbJXN5h
         kmweqdX1UcrRTLrUnmwmKFtZQslhfQXkGYBGShEHQd0cw6VQogxAgPZwMUwfX+Vd8hUu
         ooPm/NoLa8PvhlnpCCFNmwPwF6p9Xoc1OZDwrSzMa+djYTjIkGLSR0EzoEj00hWPL42L
         yXmZufu7HaF4W6bYqBqb9d3JOMQGh/dI5mI0E6F0/yKpg/CH4uvDS7Yc4B/cSAWPfX5F
         TlQg==
X-Gm-Message-State: AOAM5302BXXbsYDgQCxuTfK9gcKN4YvpQsfnaWfd/NVwPJrmoWYXw1zl
        NhqsSDTuv7fdhD2/jD7mB1YfB+dwQKVGc7K1SbNxVQ==
X-Google-Smtp-Source: ABdhPJz/r/4x+DrSYFGl66qJYR5Z8zMx7jfFeL8g6oxvgXFTJdt46micN1m/l+peWd8jNxTMexLvbqVSBw6OS6YoZqo=
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr31765497ljj.102.1594189937768;
 Tue, 07 Jul 2020 23:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200707145748.944863698@linuxfoundation.org>
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jul 2020 12:02:06 +0530
Message-ID: <CA+G9fYt-oGckUtzUQBQxLVeca99TKjgPN-cw4mqG6TXg+vKLzQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/27] 4.14.188-rc1 review
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

On Tue, 7 Jul 2020 at 20:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.188 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.188-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.188-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: ca554d6bb6dd4f99d8c97a4f13c8a02674586b58
git describe: v4.14.186-106-gca554d6bb6dd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.186-106-gca554d6bb6dd

No regressions (compared to build v4.14.186)

No fixes (compared to build v4.14.186)

Ran 31496 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
