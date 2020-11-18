Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D1A2B78D9
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 09:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgKRIe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 03:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgKRIe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 03:34:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE28CC061A4D
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 00:34:28 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id a15so1103469edy.1
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 00:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KiT5O/+mIMugwt2IchneSQyaEW/eTHkqP8xR8gAz9KM=;
        b=TlVjYcGLikbXC7Ba8AzFoj1UQBHQB152Wog6Sphe8P7I69Ez1H4dN1QnZBljObF41L
         kZieAu5NkIN4POJ2u3Er5ZcW4hqK6bG8CNZrLF6Uko4RKpjgKHZbi5+bBWh4X8/rIxCf
         TfnKZT7Z1HRAfwAaCPNNMx8SMMa0I3QWjuky/kdQHwWlN9tvSYSlHAEU4xA0Picl70QN
         Id7Umx5joSs5KT7WwC1TVVc45m4YiXWoXVuqIGf4nh1YZaz/IhJoOhLULCBcFE3W4wD9
         eRuEdjkfpB7XRoH6zacAjiAmD0+Q7bQhNayfU0cXFftSJXFro2kAdDM1CIhmHPiHFf0h
         DDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KiT5O/+mIMugwt2IchneSQyaEW/eTHkqP8xR8gAz9KM=;
        b=Gwfsfry5kalavcBsdp39FKGsKuEC8U3YmUInv+GNlff91LV5ZWJzcUR2U8Zp3A8k+S
         HGS4syXKS9gZBiYyg9VpVHccKtYJhdvsSh2lby7xsSPffI2NYmM3Jf1YQeGwuATT0339
         V6Fk9bDzOjmgiilBZ+5QxpbwrLSnNWWJre2eJZg7+7iTUOnHg1MGIDI07LSnTL9Pzumw
         noqnFrC1ybdEsW0BEECO9/Iy8VHEkprQiyfKaWx1Zn8qU10ap/+y36V4PMXhQdTAQEnF
         rsXjhmLcs6Y1//AP8UKH+Az75NxkrdQcArovKpIMFbg/fqTiK4EetLuKG1unu0DSRnca
         WS2Q==
X-Gm-Message-State: AOAM532pL0VPvzbELRR1sYEXTrtqtEaRc+CYPXhhxixASb1ww2tTC3EY
        aLOqtuwpixG56zB1CWCrSj6hD6aQRJ4WuGAJ9pGytQ==
X-Google-Smtp-Source: ABdhPJz/YOjZPn4gjs3pC0XJGQ4A/tkkBPRc3Fg4WlUoebGv9HmI1X0b+uPuEF69eP1Q/juYEJeeupZ+F+LOXd+O7FA=
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr26169156edb.52.1605688467227;
 Wed, 18 Nov 2020 00:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20201117122111.018425544@linuxfoundation.org>
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 14:04:15 +0530
Message-ID: <CA+G9fYt-sTu-idO9c3RaBVu77po6f3+MPg-bkd4n9e+n1G-Q3Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/85] 4.14.207-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 at 18:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.207 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.207-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.207-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: abaf3bc53e472252e05a2c43674a48e7aed19e7e
git describe: v4.14.206-86-gabaf3bc53e47
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.206-86-gabaf3bc53e47


No regressions (compared to build v4.14.206)

No fixes (compared to build v4.14.206)

Ran 40995 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
