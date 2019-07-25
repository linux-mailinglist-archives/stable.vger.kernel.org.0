Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645C374480
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 06:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfGYEoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 00:44:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45438 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGYEoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 00:44:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so46571559lje.12
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 21:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AyGiyyjXDEEbxEDjW6wSuafMmtzbdAu0GXJfcJOiDP8=;
        b=SJ4Dwf4Cc8/OlTK6xpQs5Q211vS83evBe73sA/AQGoPy6GL0kcJ6fSDe+9t7KpX1BY
         NKuhvf0I+9ubX/4dHOF7XlVHaOr31Lvkknfy5f4Qn+oEYj4e+b80psju2yVlKMZiO32J
         5gmQKEU9K90nGO3ktkYYtg+hDIGBxjMHsEQJM85R1Yf2mZDwj3K4ZGbN8Y53xdYDf0Ip
         4wNrCHkZConZEpvdgy5z/hjXzwXaof8thFlBRlN7ToALGgVnHO+Cx3IXq9eiCaomj0UI
         RiMfiPiDN9irmrpemqnVu/fxOfXGmGCVvkn5iGt3TzNeSH3P3a716oOgATq3TbTkHwvg
         9Lmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AyGiyyjXDEEbxEDjW6wSuafMmtzbdAu0GXJfcJOiDP8=;
        b=TuCINiKGG2rDc7TNz7ft/SJn7NdDVAs35j09BqS/+bmI1h5SzNBFlabSSw+QbNKWPH
         GoIIbtOBqHi0DlA3i14GbKhzN7xy/AhDvgvn/Im4MBJ1kBfjnvjw5/G1ad63iDtlBICc
         9KOu7bP1MUYFULGeuGsRmJxGEKSHhNA8xZeBq/6TKV829IR5Bar0zp3Et2t5LB6SCD/i
         am5Q77mYpQCGV8bDPg7AC4NwwBBXKdvrrW+bDE6sq12/D9s4eGYbGt9ziEXrHd0M4NLy
         ZKW7hriq+Bq4AB7oh6kVgfvZGLviAAlJJV22JgXgAPJB025LISDY68Eb6G7YeYHGZNHR
         EO8w==
X-Gm-Message-State: APjAAAU/3ZMUCrJ+2j/LK0XX/Xbh5dELEva7cWLqE2NMUtacBp7QbApU
        RVMQ5DnqueRwRAKVVp6dsfNaDIvFRiXw6/xaCEmC9Q==
X-Google-Smtp-Source: APXvYqyeA6KsFzksjJDf94nSJu6w5HUZtja1X47I54TE0Mi2LMeu4QKnJWjErHE63f/G3DB5waXNTNvR/FCbmfqHIz8=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr44529608ljj.224.1564029854423;
 Wed, 24 Jul 2019 21:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191655.268628197@linuxfoundation.org>
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Jul 2019 10:14:01 +0530
Message-ID: <CA+G9fYtOry75ux=E3g1G_SQxnqw8rFMDc4tvuUH6=hMb_hijKQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/271] 4.19.61-stable review
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

On Thu, 25 Jul 2019 at 01:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.61 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.61-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 872cde3ebfc93ca6ac127f51bbb54eafe1d8eda5
git describe: v4.19.60-272-g872cde3ebfc9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.60-272-g872cde3ebfc9

No regressions (compared to build v4.19.60)

No fixes (compared to build v4.19.60)

Ran 23544 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
