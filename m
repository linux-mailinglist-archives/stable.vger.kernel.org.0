Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD3A1B6085
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgDWQRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 12:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729456AbgDWQRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 12:17:02 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79425C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 09:17:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y4so6832641ljn.7
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 09:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ijdMMcHPH4n9eA8V/gf4wWgLkrDvsP5TIce3A7fesiQ=;
        b=fMUlAg+qtZ6dX+Y7V6T45czdEPdEGPmMSmY28fuEEUVckkLLuNibGnDgO+dzFDVV6+
         FgWKFGSei0MQlkX/W2PTf6QBBpLSOHZVOStT+DunErONz2dXeQRka8Z/0Qto5RUr0W6a
         3LTJEGZ6LkdRvcyR0iqlQnMJuVVpaIuH498BX6bZDgUcGq+sQ1AXXoZU8njOyh4r5wNn
         fZwMoD7b2DdlktE/8nKhmDX/aQwFbNF0dUDltXSRY80+OQar4xQQQ6WyP0y2Pn+Hw4N9
         FFdgIXU63pgwC6ylGpbfIxC691BBK3/rrQPmCbdHChS7rua4hOLalpUTOFaBS4VEEUcZ
         9Yqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ijdMMcHPH4n9eA8V/gf4wWgLkrDvsP5TIce3A7fesiQ=;
        b=PaxNbHN0o+7U9cnTaUZfvMge5gqR/9SgW2opa63JCRetQxRQvtw/txamInMKyzusg7
         9gPZeOsRTyLbbdKxfFb0ofPeHfjqqFt+AIXmK5Uu5HB4vQ9uHBVoJpKQnq1CJ4/3eXTK
         GSdp9GTK/9rFw3+w8w/fhspY8Lyn/cWWoLofyjpa0KgYAX64fSbzcGOpR4CrIXLKpB4f
         6IoBj72Uid0m8U1yqkbl7c/FAe/WuTTETML8A8ANfVG13PkuN0ueY3KMrronxziDDqYT
         p6mNRk0fH953pkUKpSxaaRsapzegVrMRKpIhA6CoTb6PogpL52Gl7UcUEUfh0vG+fNfc
         Wdig==
X-Gm-Message-State: AGi0PuaLUmeioj5NgNxlb6LJZoZX7wC9jqt+ja8GOJndHgbKWkq37HF5
        lp1c8U2INeFhq9+W+n2dtzrx1kF2sUuH47kkZ4/CgVhs6d+0qQ==
X-Google-Smtp-Source: APiQypIpnUzSguFj/Ur2JF6UTX7TBHAiOEbSz2jo1tBf9L4BT22dZ70fZ5krajNFS2Q0sjOzBV9WvEaYTjH5OWHPc94=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr2871939ljh.245.1587658620689;
 Thu, 23 Apr 2020 09:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200423103313.886224224@linuxfoundation.org>
In-Reply-To: <20200423103313.886224224@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 21:46:49 +0530
Message-ID: <CA+G9fYu5Onq3iULgsuzBWmWtkkauSxvLR3Ms2EewyNwqp7vOxA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/99] 4.4.220-rc2 review
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

On Thu, 23 Apr 2020 at 16:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.220 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.220-rc2.gz
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

kernel: 4.4.220-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: b7353bd580c08b4aef6e29998477a8c6c44e0e4b
git describe: v4.4.219-100-gb7353bd580c0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.219-100-gb7353bd580c0

No regressions (compared to build v4.4.219)

No fixes (compared to build v4.4.219)

Ran 21536 total tests in the following environments and test suites.

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
* linux-log-parser
* libhugetlbfs
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* spectre-meltdown-checker-test
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kvm-unit-tests


Summary
------------------------------------------------------------------------

kernel: 4.4.220-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.220-rc2-hikey-20200423-702
git commit: fbc771dad6485f27aa5ae4cbaf83d47cd02a943e
git describe: 4.4.220-rc2-hikey-20200423-702
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.220-rc2-hikey-20200423-702


No regressions (compared to build 4.4.220-rc1-hikey-20200422-701)

No fixes (compared to build 4.4.220-rc1-hikey-20200422-701)

Ran 1814 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
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
