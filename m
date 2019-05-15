Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E01F9B4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfEOSGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:06:35 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38270 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEOSGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:06:35 -0400
Received: by mail-lf1-f67.google.com with SMTP id y19so541604lfy.5
        for <stable@vger.kernel.org>; Wed, 15 May 2019 11:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sjmiq1cCH63qmG8pGXuSooVJ5F0u+qb0wj0/CssAcp4=;
        b=SlvgNIgQqK5M9gCVm3yAs+0hobGk05eWLldR5Fsl6Q1n3/k8h0E8dRirHMgte8T0Gs
         ABGmEhUfERBQkJvO1HYDZvx/HNhkOT4zeUIfFguFpIt5Omak0dFeo09dyPB8qhO4XBYF
         +ecMN/vuucJEXLT3613aUoz4kgZglpKXDqPY1pgFqZiGdnJw/QvyZuzmLhSYVmF8gZid
         WkQAmpAY+IidAoVceJWcPN9/7URBwtGVCIbFHqGebO5qPB3nqd9PymhgXhrVFY1EAgcK
         v8/S98bQOkrrxT6ySChm6BU0bVopFSW4lICbF1HXh/C61OjKO42uoSwjBrOKEokUiObR
         pEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sjmiq1cCH63qmG8pGXuSooVJ5F0u+qb0wj0/CssAcp4=;
        b=Cno7LBlvKDlHcPgk6uAyBTtMVdLE2JdAAt7V4a94bglqIqoWaRHdXeHwTBLoiDBY06
         /yUi/D51kM/GtILC4Bk+Or76KQ0Rv3pyakaI+Kq5M+BkknAd0I+9xXTc63F2kY3dnk+r
         SjwYHR88WB9zbIQwASa1pOcKtGTMHNqGuK2OkW0LBqXDV4a7vO1kgeD3byH7/nrffcdT
         Pb7Wm6cZC+5kk+vqkvodZWTxCD64/p9xBIEoTxzUb4rW4A3BtNoCCxvNxnbit0HZEocj
         6ePOCaHsGNdLK38cvGZAQIS84fEaWMBpWNp0r3jskvQa1/b8J5pst4lxRRwGiMyvkmze
         cSJA==
X-Gm-Message-State: APjAAAXx6CrNSouq/mIguIP0I/CyRZlGoLPK71axXTLvEaIJm4GysnQs
        uK+WmXoXDKsfGoCB7ctZbnVhryzKXTZMv9WjSDeIgA==
X-Google-Smtp-Source: APXvYqw7+yY7rcMpUyzxSf/n8K0DZ3ig6cmT0emvJBhlDW/eZOy+5izYGPwJ2+mf+jNzPk5qIMy1dmCbW8r77gZbbjk=
X-Received: by 2002:a05:6512:507:: with SMTP id o7mr202686lfb.137.1557943593111;
 Wed, 15 May 2019 11:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190515090651.633556783@linuxfoundation.org>
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 May 2019 23:36:21 +0530
Message-ID: <CA+G9fYuXv8KPEsXieSVZLY6uk=2Pfwh3B+xFa1FDRRrT=MYT9Q@mail.gmail.com>
Subject: Re: [PATCH 5.0 000/137] 5.0.17-stable review
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

On Wed, 15 May 2019 at 16:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.0.17 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 17 May 2019 09:04:31 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.0.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.0.y
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

kernel: 5.0.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.0.y
git commit: 174f1e44d0165ce68f4e520718847304556717e3
git describe: v5.0.16-138-g174f1e44d016
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/bui=
ld/v5.0.16-138-g174f1e44d016


No regressions (compared to build v5.0.16)

No fixes (compared to build v5.0.16)

Ran 24960 total tests in the following environments and test suites.

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
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
