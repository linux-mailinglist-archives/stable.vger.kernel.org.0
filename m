Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD252CB4E8
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 07:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgLBGSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 01:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLBGSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 01:18:49 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A31C0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 22:18:08 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so1739542edt.9
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 22:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s6hbxRJQzk5VDsUXqjqzyxcRudTmI7qavNHvO3TBENc=;
        b=yYKSkXL5bv0GUxuUzoMfAgQiWAW4YK183fiV3+8jB+MBujLb1hHMP7oh9HbnWepSQ0
         xl1qHgE05MsAOl1EQW7fmgY95nowZqH3SOKGy4bJ2qDgZBardsBINgL+W95RQMeMPwN6
         8ATg9j5UxvUzT7vgzEvapF1jmVh+eD1gx3yc9qKpzS2mHpEpcQPBoheLaXUuGLsRF7fk
         iUtfDMVrp40M12vF+0QR6e4p36jQ0LrQxctu+Ux14CblIUy8OxFsepTkOsk0MK3EPNdV
         FMCA6oSTJvbyS3wtkZoHku+P4eN4C39Caq6ZL6aiDNgpMWYvBhjDf+qbfgUG2vsu7gTA
         Fj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s6hbxRJQzk5VDsUXqjqzyxcRudTmI7qavNHvO3TBENc=;
        b=oPukApznQfhAlk9GAXrmo4uM6g8Wah/7oAtio5Zo4DNfIzgT1mnwSbaHrNcriiUng1
         vB0WK4dxJFHioDI32CcZmpGSj2sGzvRPgkDWMznE91dbOzc7fmRe+fZ4N1Rh4vcsY9b6
         tXe/74DI9PyeKhb56QGMnF6BmFhuKLISSvT9VPcPjlBUZ1tEZJWJQcChiBvMRU4ILi5S
         4fFhHUi+jbu1tW7WHHMoILKgRUeegJWzHP3Jc2+Qhf8StBxA7vqGvs807Ln70Jvqyjyt
         aip3INeYmDp15hxBN+B6Vg5czGtc9iBNjFfE9PUh62PHt1UIlBC1Vhhbf+g2aBrdpGH5
         XzJw==
X-Gm-Message-State: AOAM532bNQNcCltAjiWrH2FUzKml736UQTQ9l/vver8xCMZJZS09IvJ9
        MN3fLCss5LRXk3RLVJrq5F1o8t66uxpKCLMeQOVKvw==
X-Google-Smtp-Source: ABdhPJz5hgJbTWxUrUFXZzkajs7b0tUqWkyr3x6VV6g86DH8tOoSdADGa6lYBowzl2sMk7u5w4V+Agy1GMu0/hAk4KA=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr1102676edb.365.1606889887010;
 Tue, 01 Dec 2020 22:18:07 -0800 (PST)
MIME-Version: 1.0
References: <20201201084637.754785180@linuxfoundation.org>
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 11:47:55 +0530
Message-ID: <CA+G9fYum_Lbsvj545_hpBtpeDOPcgYKUPuFdpP6WVRPYbBUFEw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/24] 4.4.247-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Dec 2020 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.247 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.247-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.247-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 412881df37c2300a95caf9e61b42c25814c64af9
git describe: v4.4.246-25-g412881df37c2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.246-25-g412881df37c2

No regressions (compared to build v4.4.246)

No fixes (compared to build v4.4.246)

Ran 12293 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-controllers-tests
* ltp-tracing-tests
* libhugetlbfs
* v4l2-compliance
* install-android-platform-tools-r2600
* network-basic-tests
* perf

Summary
------------------------------------------------------------------------

kernel: 4.4.247-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.247-rc1-hikey-20201201-867
git commit: 56c68faa4c221dab59e36da4f9fc198e41a73808
git describe: 4.4.247-rc1-hikey-20201201-867
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.247-rc1-hikey-20201201-867

No regressions (compared to build 4.4.246-rc1-hikey-20201123-865)

No fixes (compared to build 4.4.246-rc1-hikey-20201123-865)

Ran 1758 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
