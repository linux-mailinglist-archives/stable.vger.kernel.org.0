Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A44710DA85
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfK2UPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:15:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37429 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfK2UPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:15:48 -0500
Received: by mail-lj1-f195.google.com with SMTP id u17so5787592lja.4
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jhZvoDjmgkpHHMF+KaBCVGZLWSODhI6Cp1SDmKy5n6g=;
        b=kc8Otn3w+mPUSmbMZnemXFI+l3gqZvEB+zv8oRiNy3deNDc9KH9oib48NMu1hsuodj
         LBZ8xv0i9z4N9N0EU8eQaDDO9nIGoNQu3aYt1HPm5UHmU5yG228iNqA1MRgLR+V1di25
         e6/Y1y7y1zXfiSP82sr71TzaLy+9Mq2TvGqtcDArdocMAshi+/lIw/BAAgzkaiF2Im4s
         z0y9RF6JaTLL14brV6epmtWqfD3YlHr6mpmm0UVd1vo2Ywv6aeLSrlT0o2kkjZZbY7RX
         S6Y/0L0/jgGijFuk6UqzzXwoVj2r4OFxfRnUOsXpShjame4g37d1InZzIwWGQqQlI+Zb
         jK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jhZvoDjmgkpHHMF+KaBCVGZLWSODhI6Cp1SDmKy5n6g=;
        b=QGwXB2jEy7JOryApTcC5b1XGdV/2hKa8ihQwx1zasrCR8i237XFJQ7XGEgQK43JMl4
         pQxLFxecVtUvU6sVqnfD0yFuIu2KyIVvgYBDGLBnamerRjZs/BoN+6AifC65SmaumGkH
         Y6LKF3YUvfTu3bEhBOzrj+giAuSsf/jezj1XAH0bEuNX/y+gEOnrErxsaQNw8Fgz6xUQ
         FwKnn1/QEt+HZc1Peq60bjM6zyS5SYWaiFoHfTNss1DDXs+7oFxm0cSD062OR70XWMtN
         GnESL3Grq76gaddUoWhWl6ydkGQ9sRON0wXwMaLWPULtDmh19DHXNhca7CJTMoMN8Ky4
         +Pfg==
X-Gm-Message-State: APjAAAVGjwphy+J3fDkf28T7hX/NhD/tJgThrijT1JSQnSWFeSWqLOgF
        SwjoUgh5+R1dXbpDIUSwwK7e4c37NQH+pYPLlNObGdgZfYA=
X-Google-Smtp-Source: APXvYqx2C+o8YntToEJno8TL8bhR1vVdixkzkQFJY6cb2gx2TvLSubrRSHpKRq496oPNCjbEmhDFs8wS+8KtjBrckns=
X-Received: by 2002:a05:651c:299:: with SMTP id b25mr39527265ljo.195.1575058545402;
 Fri, 29 Nov 2019 12:15:45 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191129103724.GB3692623@kroah.com>
In-Reply-To: <20191129103724.GB3692623@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Nov 2019 01:45:34 +0530
Message-ID: <CA+G9fYuVJi8McvpWq4177hzAjF_n-CNwQeWJB9S1YN4p9E=EZQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
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

On Fri, 29 Nov 2019 at 16:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 27, 2019 at 09:27:30PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.87 release.
> > There are 306 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.87-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
>
> I have released -rc3 now:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.87-rc3.gz
>
> that should have the i386 and all other reported issues fixed.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.87-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: cc82722f8f1b05c10e62b80951b3950e453fcb88
git describe: v4.19.86-299-gcc82722f8f1b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.86-299-gcc82722f8f1b

No regressions (compared to build v4.19.86)

No fixes (compared to build v4.19.86)


Ran 23167 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* kselftest
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
