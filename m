Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D54251382F4
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 19:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgAKSm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 13:42:27 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34529 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgAKSm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 13:42:26 -0500
Received: by mail-lj1-f194.google.com with SMTP id z22so5577884ljg.1
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 10:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ByfWl6md302T9/teZJbTaoU5SekodIAPf+v1ChqqWpM=;
        b=yga9Fs3XB6aXP4XFeotTBvZFN8H3VwBtnw+FbuK9cA2hwcmHOeCqHiQ+Tqkj1fL5qk
         Bt/6e70TFo863YzYdhnY6/dEwaMdBomW+nHJSUT1ieCpq04ZsGvjfDu7Yq7uNtCfNlcx
         pxzcO0bbElDXDPMCL4LgjLrGSHK41dRfwIw1e812ZKtghtSpqo9SQpQOfotIzu4n6Zcz
         eG0xsAkWBLWf3A6ov7olz+ICSkJUJePhKigCBQtSU4dOjmWNJq8y7Y3rj2wkvi7hqgEX
         67wG152e2A5uxZg5XJ1yeaL25XDjdENEqCTT25hXi+cktsjq8cMueBWeEtE9B9umcQZR
         x7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ByfWl6md302T9/teZJbTaoU5SekodIAPf+v1ChqqWpM=;
        b=Om8X/tDJJbzH8A4QzPAUeCFAldNLRWZE50h/fP7fmWY25aaMntkNzWKWUwkBdTKQcp
         fjTUhlaMRmPOCzRC5ktEhYjJoPBNBZSiAvHYMgy0vdxJQJytWK1oNWofVRbS6TbNiyu2
         +qb+wPr8snmHGiDAz45R05bQkOf0uAb8U6TR73aIWlv1hwxcmk1Ub1+wYGcHR7BFsq9p
         E6sJX+wjhcLyA2Ry8MLpgoyZ4Ux34ON1UfvLbGhREV87bb4KGwoqrIr7pXTxlWmi3Nko
         idgUW84hfdf0VGsh1fNldY2AnIYeQ/3liLzDvvE0EAIxWvTtlxovExrB/8N0wI2DGNSM
         2RMw==
X-Gm-Message-State: APjAAAVxcoEIO8F87BxrQ8IpWKq5g3X8DWP2yc30sP8uzGXTiRhMA1H3
        KTss2KXG5bnv0yIX6xE5x3fE490XusAlKpvbZYmRaQ==
X-Google-Smtp-Source: APXvYqzqA1f2adfWZ+BVAJw87QjK3DpCP3dzd7jiBn3XBatKVuysQQfYo1czR7JLqt7PPa0vXYSL9GJTRCUZcua41OU=
X-Received: by 2002:a2e:3504:: with SMTP id z4mr4101722ljz.273.1578768144949;
 Sat, 11 Jan 2020 10:42:24 -0800 (PST)
MIME-Version: 1.0
References: <20200111094921.347491861@linuxfoundation.org>
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Jan 2020 00:12:13 +0530
Message-ID: <CA+G9fYtt6YE7Js3Q+Hus2cFx9pi0g1oau_DR_TqjVdYRgbrNsQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/165] 5.4.11-stable review
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

On Sat, 11 Jan 2020 at 15:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.11 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.11-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: ed7e2ecd1b93e8f35aa93d1bd185bf9a4ad1e1dd
git describe: v5.4.10-166-ged7e2ecd1b93
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.10-166-ged7e2ecd1b93

No regressions (compared to build v5.4.10)

No fixes (compared to build v5.4.10)

Ran 22721 total tests in the following environments and test suites.

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
* linux-log-parser
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
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
