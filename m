Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2166812865
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 09:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfECHET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 03:04:19 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43723 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfECHET (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 03:04:19 -0400
Received: by mail-lj1-f195.google.com with SMTP id t1so4347230lje.10
        for <stable@vger.kernel.org>; Fri, 03 May 2019 00:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EG+yERdoJo9BLN7VabMPjS/nhRf3hDC8H2zgWdVktco=;
        b=LGpe7H9N9gdqKsRij55UyDvK5Rz+ixPQVDW1H/qYkdHeHuY3jhh09f0gQQ195p9wkb
         pX8613oVMrUuuZMY4JMkArMfBaKJpqxlM0I8tccr81pWlgQDCi8DQ2H39cToPGeKXst1
         IpP+QfbmXoxFUetvnqHMHvKv5HcPqul6pZ9aD801QMD957aJ6+OsSJTslsN3GQkoRX7S
         MdNbIkcoU3Ahy6RBN7wUxx8506d2FpsuGwNu7ds2szkresDza3tCfSdGTplM+sxKXFpL
         0acmupA4eBxXOVA4Hnd/ExVduePWSJgprEHM6PRvouaqUuGJ1hbCmNwovDo4PMJXWO5J
         klyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EG+yERdoJo9BLN7VabMPjS/nhRf3hDC8H2zgWdVktco=;
        b=p1jbLILSharZvDIyuuSsZ7ny9ca2A6qPwhXy6E2uKGdQgF7RvwMUuOphSL8KO6gF+j
         d8SeOp7/MQMaR9T4pZRANjYxvxcDTeaksybaECEatQm/XkExkh0T/pwcUC+t01xnQjr6
         7+kGTOVzTcp//K9xVo82zxuO/3yJaeNJ1ldIWuW1iAgPg1tAZcWcPbX2sAqyEJKLo/4N
         S24g3zr/u29NqgnA2NO6iSi5DK/UCOQCkDJmQ9fuLyeGcxf8FsymO/SMlUJWHt6byXhB
         XnytDR9Gr/JBhDnZXsBhXVkr3EAR+tsj9wcSQlNQQMqKZa6VHqzjMWaQcs8v7dtLBnOm
         OXVQ==
X-Gm-Message-State: APjAAAXuO3Zd3DGN0QZFrC70DajqaA04PEeDEdt+CDJ6N32kueh6mKxM
        5OaYo71QG7IPpX7sgBwkMcVrDYc4xMgYRfMBzHSxGg==
X-Google-Smtp-Source: APXvYqw2h0hfR6f/SutSl8UZyA/nX5xNrB5MvVv2JMKYKFlUPlT8FlMO7B40W8tltBw/xkLvewH1ZBVuO0ndV4skS7Y=
X-Received: by 2002:a2e:8186:: with SMTP id e6mr4405169ljg.136.1556867057291;
 Fri, 03 May 2019 00:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190502143314.649935114@linuxfoundation.org>
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 May 2019 12:34:06 +0530
Message-ID: <CA+G9fYsQdQRoC9d-eV90=09eY_ZHc06cByoDbgmi_WoxHUL05Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/32] 4.9.173-stable review
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

On Thu, 2 May 2019 at 20:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.173 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 04 May 2019 02:32:02 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.173-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
v4l2-compliance test kernel crash fixed by,

Hans Verkuil <hverkuil@xs4all.nl>
    media: vivid: check if the cec_adapter is valid

Summary
------------------------------------------------------------------------

kernel: 4.9.173-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: d35bcd0923041bd98c18947041f8929b2fb12674
git describe: v4.9.172-33-gd35bcd092304
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.172-33-gd35bcd092304


No regressions (compared to build v4.9.172)

No fixes (compared to build v4.9.172)

Ran 18302 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
