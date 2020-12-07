Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D15C2D0DBC
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 11:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLGKFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 05:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgLGKFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 05:05:37 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC13C0613D0
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 02:04:57 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so13047443edt.9
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 02:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b3t3jIgI6hpQGlzQVEB3OyTOWvlTte2ZpFg6vSpZvaQ=;
        b=S5euiYuGAK8GUznJef4H3eBuwo2+mvjjz1hb8IPp40u1iAiQ3lZRbkzyv8JWedQ1cN
         WXb388WDDrfH19dKbv+bj8WazUC8ytJ9JLP8H59PdnOwgIFx8uVjEs8TVXhCZPXoxANP
         l0CRr7DLiCJ9LZHKGlFuiOkm1O/r8TMHV/3FOFLg/QzvJRSM+dXN30mu8Ch/ObNINJHv
         1e7hAwE1Q22Q4FJl6bbkxiyMcAVvx6rmek4Ol7r15wCYPzbcCE/sbwjPVBqeC9IuIvJE
         Gg61V+7Zh/BYyEd2rCbz75hpRLQeCicw+jUo/sHdawHyVxh4OxcmFSB9qCgmyTeO87Mk
         7DbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b3t3jIgI6hpQGlzQVEB3OyTOWvlTte2ZpFg6vSpZvaQ=;
        b=hdVNU/2egVT3AQnbUjtkZF4JLA25UmqZpE15aoK/ShNZWDGJDuHbI5BMGaY/DXHwNb
         J6GvPUgteGSSCc6+qMKaP3leiPEI5CIQHS7GTmDLplCCYFCNbbVdItSNChsIgJy4ztlY
         jo7Madws7p09pxvpC5O64IEkfYSk6wTAV9t8OufhWXOKw1RZBIUEss2F4GzGKIVw1j1H
         GbrRLZOTehSqicz5FVd5bQYHv9Z+0w5JE/ZmBmH+eqIiGJ7AfZPRZIfAMUCfirTvnlKh
         9epCF65zELKfjMqSleUGaW0ygrNClw1RylN6f3wXW9YYFbiuEC5HloKZpwTuunJ7TeiV
         y5kg==
X-Gm-Message-State: AOAM532i/ahAmt7dwmGfCOJnR1qxCqMPkxqXhZIVLQpQKkVrS3/msRxG
        jmQER1gQyrkxq3Spgq4yxdjFkqeZG/zoS4+VlI86eQ==
X-Google-Smtp-Source: ABdhPJyRuF3/CkVrrf2pNnKEBpAOWcPwzPm8tJqXn5JWFFeVUQEx2lrYPXECFOpfLcD/f9Px4VNIxLhPKQ5Oz0ziXAQ=
X-Received: by 2002:a05:6402:229b:: with SMTP id cw27mr18902420edb.23.1607335495692;
 Mon, 07 Dec 2020 02:04:55 -0800 (PST)
MIME-Version: 1.0
References: <20201206111555.569713359@linuxfoundation.org>
In-Reply-To: <20201206111555.569713359@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Dec 2020 15:34:44 +0530
Message-ID: <CA+G9fYvppziAj5RzG6et2UCX+PWzgmFKGMy0eCMe=eFYaUXxww@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/20] 4.14.211-rc1 review
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

On Sun, 6 Dec 2020 at 17:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.211 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.211-rc1.gz
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

kernel: 4.14.211-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: eea918eb2691ce5a9daaeff667dd08ea71687abf
git describe: v4.14.210-21-geea918eb2691
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.210-21-geea918eb2691

No regressions (compared to build v4.14.210)

No fixes (compared to build v4.14.210)

Ran 38523 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* ltp-syscalls-tests
* install-android-platform-tools-r2600
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
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
* network-basic-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
