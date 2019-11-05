Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8588EF56E
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfKEGPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:15:09 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46848 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEGPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 01:15:09 -0500
Received: by mail-lf1-f68.google.com with SMTP id 19so8979947lft.13
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 22:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vK9Mnsx1TZA88Bv+5izX5qtx1e8u4DTMxpuNyXSTjqs=;
        b=iaiWCAtHhujzJu3GtKnjx7I82b8w4i1wpTBKy5wPpuEAEB0y7na694Er7L3Hg3MNP5
         ErBDsFjk9oQR/uhHnJrFoRvWO5+b2c9FkEH+io/RfKMK9vCAGB33fdnP9mSqc29dRuo+
         uEflV0aCgrmTkDhwxC+C1k9eNa0DrmToRtNiKp3etunBp78mtgOxAfTjciBo26lMoM5q
         Dpg6PkTVXvOTqAJ2wWpY0pMdq+zI9Ouh4Kvq/CVnoMN1jFEFUn/yFbappekPQSTedENa
         IwqoMXzSobmOPETJy8tEPLaFsufY1Cg7Iq8q4MVRzGeThDwk++/6F336zIK5abVTg1wc
         E8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vK9Mnsx1TZA88Bv+5izX5qtx1e8u4DTMxpuNyXSTjqs=;
        b=kK+xTuWPcQb/QS9EWqPoOBO+h2cx/TbM7OQJP1ucS0pJA7S1spJmFVMEZOxFe/Z5St
         WZd4x7WeD2FFQC/VJoE2ag++9cxyQ7nVimf0gfm9W2UDOxep74iBlnU5Ric7IZP+tB97
         7MVyuvOWBDq/oC9mNSSKWmlzC0qhIAml776SttA0mHO5ViltgHWUYp4IQzh5kAp1teHF
         bTIQ5C+f4G12IUxT6Z3wYUkjRGV1h1dDJexy4YdDybNfe59FUhMOHxeglotaZQVn58Lz
         V2qxCjYiHjxQPjWfe3720uSKr2ttb6vKIKfEtYPd/3Hhcg2TjGmL6yLEp9Y2B+x5xIwt
         2WVA==
X-Gm-Message-State: APjAAAX52pnC24n85FeAZSU49Hk3NbemIHcbpqV6/LVGLVVyRbn4fJM5
        OvQgAx8OoJUjNRbGXf+TBPLYZGHXnEmoS0M1KHjsmQ==
X-Google-Smtp-Source: APXvYqx7Oe9389T7yRtAw6T9ktSncl6KjipVfbXkwYr+gjjUrjhT8X0b9s3w8cW2ioomjGxq3rZgq5Vw4LGIfllNvx0=
X-Received: by 2002:ac2:5930:: with SMTP id v16mr618224lfi.67.1572934506802;
 Mon, 04 Nov 2019 22:15:06 -0800 (PST)
MIME-Version: 1.0
References: <20191104212126.090054740@linuxfoundation.org>
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 11:44:55 +0530
Message-ID: <CA+G9fYsOivRzYVgp1UkieSHftL=LF7YogKA7EaJEVY27E-4AZw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/149] 4.19.82-stable review
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

On Tue, 5 Nov 2019 at 03:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.82 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.82-rc1.gz
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

kernel: 4.19.82-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 3d3728a67bfcb7460a6f7c5417a2d9a4ff180c58
git describe: v4.19.81-150-g3d3728a67bfc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.81-150-g3d3728a67bfc

No regressions (compared to build v4.19.81)

No fixes (compared to build v4.19.81)

Ran 23947 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
