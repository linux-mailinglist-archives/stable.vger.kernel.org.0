Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981D910C55E
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 09:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfK1IoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 03:44:14 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34457 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfK1IoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 03:44:13 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so1373914lfc.1
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 00:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1QZ3A4o6jUAyB3PxC5zRpui47YcoCkxIVIayUdZmVu0=;
        b=zZCG9UtvOwZAK1grCKaRzCYHS4KLRdtvuBphwaRPOLSx9Dn8TV16FEngYEvljnTFfm
         mm38rlBvMPSM3w6jVxSbi+aF8Y6hS+NXSKhXUhc1IHvExzVz1XKTTUtKbSaBjxXYAytB
         vxDohzZDHYT4HGbEV996fWwesJY4fAlTEd8wL8JeTRYQRFicH/G6GEod9BWiDeuxe6j5
         HA5UlY5T/PA49/5c1xwqUXoZw9KJr/XAhZ+THXrupALH6Cw88QDN27Fy8btqfpwGPGfK
         QtaSsgtsHK3T+ZxEBOCsVCZzVnycyCjM4Xxb0RrBT3bDHHlxBb3ktbVoXgLv5wvYe2Dv
         TT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1QZ3A4o6jUAyB3PxC5zRpui47YcoCkxIVIayUdZmVu0=;
        b=BWcMV4mQxKkbx9ouzo/HtzlvFzL94tTs5wuCQicvgI/ISP6m2/gATGqK6tF1+glPnW
         HdL0SDPXMUi2fFef5rtf0Z24sxEI9TAEMza4PF/FIPtB3E2Xu8ZKNNQkS510ETKqp6LC
         rPvD4a92YLeQ52vCdh4U9QWTlfmnaFgp+AjUvgEIQ+REWxDSE8rwgXdmLg9Wwh6gv17I
         gjRBIhhHw7Fx3SyAr8B+JEPaH3uIWM9G73Zp4H9ffrb6mrLISmnylzq0S53I7bl2J8wJ
         JOrjJLt4ojtAb1X3x8DwQ5mO9f4WHUDdgxqBkvC+sDtol011UQ/ONmGdsWbOmm2vKOiG
         OCpg==
X-Gm-Message-State: APjAAAVzbgGDcmTL0GVGyV8b4+W2SYDhOgElXSkFwK4Fd8JANMrDSyjp
        hL/r4Dt2I/E7hygQFwJmTXEM8Pg96VVyMrojcoox1m0z41k=
X-Google-Smtp-Source: APXvYqzXiIowksFeLWLRy3juK5p/6F+2j1PS5lSup6jUcBPDKGziJUD1f+cQUdIxMsaDb/PXZMAfEpj9Si2teDsNiXo=
X-Received: by 2002:ac2:48b6:: with SMTP id u22mr8308593lfg.164.1574930651615;
 Thu, 28 Nov 2019 00:44:11 -0800 (PST)
MIME-Version: 1.0
References: <20191127203000.773542911@linuxfoundation.org>
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 14:14:00 +0530
Message-ID: <CA+G9fYv6LQXD4ZCKgtt_X1R6vXzSOwhrsH7nHoJNhvGY9_YnBA@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/151] 4.9.204-stable review
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

On Thu, 28 Nov 2019 at 02:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.204 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.204-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.204-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 3bbfc6b1c25b08b1e400515f8a2c333a6bdc7f26
git describe: v4.9.203-152-g3bbfc6b1c25b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.203-152-g3bbfc6b1c25b


No regressions (compared to build v4.9.203)

No fixes (compared to build v4.9.203)


Ran 23796 total tests in the following environments and test suites.

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
* linux-log-parser
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
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
