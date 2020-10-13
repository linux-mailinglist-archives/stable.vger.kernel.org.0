Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0C28CA72
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403956AbgJMIqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403884AbgJMIqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 04:46:24 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56958C0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:46:24 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l16so19616671ilt.13
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=inxASniRk+nKPwQE5RqwMS79wSDTalVbSDOYsROMjGU=;
        b=zUwWbGL0KmDNH2kfOC2wq2piH6iJ+MHtTesnpM5Hm5g2zYrqmzxKFOkKcpI3x25PaH
         SZ2Y20eGc4jFCIc71YeKfDzA6pMM04m5SLSiypMEAQySN1khCC8rzHGgqNyFX8Ol3gHY
         m7pg4C58iJz/XEUmpF3G2SOMBJTfMvZPVZyPg2LbXOoJrWtOzFzPGWiyTyv0uNLMRyWQ
         uJW6ik5C6xivO0a0UKzFkFxnvZnivJuWtAyWZJe/GinS9wQQhO+zD+TMzFDx/Sh6wHPg
         /gORZBvZt7J0EFX+Vn4jvEA12HOP6HA/wjghntg+kaDWxs/Ed47EC7+yIGxyn/Dp3xH8
         2FGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=inxASniRk+nKPwQE5RqwMS79wSDTalVbSDOYsROMjGU=;
        b=Iyd4HSPB0RGiC0x8NktJBfNZgnc8kVqJ+NEHrYWvpOyp1gNT3gxW5OP95Dx1QyWz4Q
         Eoj10fRiDfj+9EQnIi4vDukTasnnVXMh6Z+pgyAnpwUAbyTl/W6OCgyRpsfK3zrUfb/N
         dZQhw/vsvnautJvQE+3SR5xFFDPOtJDFO6jpeHHXJEojVwwmK3CIUh105O3OATMoNaz3
         wW0rMZLnR5Sc4rX+EoFdg5uVk+DrNAd8P4l1U2JqB4C4r1TS2miWdZ6CYQarucmnAL7+
         u5pVpE/mMKoJnTtuPjbEzUoy/FoprplQOKPJI0u20egG6jD2PNZmak3B1ONwM71dEHJW
         ieGQ==
X-Gm-Message-State: AOAM530+4PXMEszgQV64F9r1hIzqH7QRE0yU5qQ1sO1fY1MZaOAEZwe0
        ZF0z7jHyhrp+XzVbLHZtDAMO4+16mPQOXAbLKReHHA==
X-Google-Smtp-Source: ABdhPJy32YaZGZqMwyirJbci3IlbfeRACXpCMzLMIYsB9mlyURbQD8gL/Jo+e5PYuS5Jdzwp6J72f9yb3bSvoHa1wHU=
X-Received: by 2002:a05:6e02:4d:: with SMTP id i13mr2213600ilr.216.1602578783566;
 Tue, 13 Oct 2020 01:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201012132628.130632267@linuxfoundation.org>
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 14:16:11 +0530
Message-ID: <CA+G9fYu61UPujPUSwH4bviWuQdYRty5jbyTmAeTvn92iEVCLEw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/39] 4.4.239-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 at 19:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.239 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.239-rc1.gz
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

kernel: 4.4.239-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 36437aaa551298340a942cd706837e40efdae9c3
git describe: v4.4.238-40-g36437aaa5512
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.238-40-g36437aaa5512


No regressions (compared to build v4.4.238)

No fixes (compared to build v4.4.238)

Ran 15013 total tests in the following environments and test suites.

Environments
--------------
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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.239-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.239-rc1-hikey-20201012-828
git commit: 018c0e7c8dc0d88c038fd4495aa01958e4bce669
git describe: 4.4.239-rc1-hikey-20201012-828
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.239-rc1-hikey-20201012-828


No regressions (compared to build 4.4.239-rc1-hikey-20201011-826)

No fixes (compared to build 4.4.239-rc1-hikey-20201011-826)

Ran 1745 total tests in the following environments and test suites.

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
