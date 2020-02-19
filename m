Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5322C163B5B
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 04:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgBSDeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 22:34:15 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36206 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgBSDeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 22:34:15 -0500
Received: by mail-lf1-f68.google.com with SMTP id f24so16168479lfh.3
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 19:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TYt7HJjvktLwYF5fWsjcRqKlBg9s9ySi5xDNucBdwwM=;
        b=V2kGHxSpVquxNbLsrIA4Tc8X0T0dQK8oblbDB63inYvlFgNXSQrjgAGT5vP3BQoMWu
         wUgyAd+JyD3fsz2NRRMnbOxsND22Z4FVr/Tb886Olr5cKqxgc59jsYDtdhBrxoeYyE7B
         syLOnxQkIOj/VbJBqYyShP1jm3e0aIsyXshXWfmDmtz05T3lEaVu1lkIqfzfzOfpFqqM
         ZRJVgtUsSU+ZLXrBDI5kwkuZCgAHMg59c/lzlRAmlt+ELnc67H1WApvcLKQQu3gC1QtQ
         B5HJTw7Wt52jYDhDvkFAd3rKhHwljQ5kN426zY0iBoRogMSnOxDd/8mRrS7RbTNwkxOx
         OCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TYt7HJjvktLwYF5fWsjcRqKlBg9s9ySi5xDNucBdwwM=;
        b=YCWsfDuWxg5x33u4dnxn/DUv0CrBhT2GV0t2RHRHB7z2gf77CP+GkQPOEFUHAoTKIP
         HDfsbgLAYJUMzj/57NZXgp83qGB6zSDguRWG2XS8ivCoCoj3fi+Ov2kqQ0btaWrAR8KT
         IlnABz9Kavc6wAxtKSaj8wem8aytrmimP+UQOMHnaViTnNwcUjMTIuEIJYX1vLmLlurR
         YBVpL14H0G5ALh7OVBGDHvrpOx1w+pJwSIds1goyCkJnEavXQkqUnMiF4Ahzx9JnRM9x
         GHSU0qbU2GKpT1qh09Dxd1tOhEpZEDN86JlVcSIk9XGXSNz++rRt2qxKmuUoDHPmaSZo
         CPrw==
X-Gm-Message-State: APjAAAWltuYHyoCRtSata8SmOOw1p/Y+GE+dBITadASxrUrfkad8v8wK
        xIDoxloYr53wbDIsuwDaz/ucIQCs/9CQtXvdVq2gkQ==
X-Google-Smtp-Source: APXvYqwvVYTdTd/xkQkW7M6vEezu20MskC8zCQh/UXfXhkGWKW9ijfCSFt8ZFACOfhqPHeFSpss0pRG6zZbylyWTw7U=
X-Received: by 2002:ac2:59dd:: with SMTP id x29mr11952854lfn.95.1582083252806;
 Tue, 18 Feb 2020 19:34:12 -0800 (PST)
MIME-Version: 1.0
References: <20200218190428.035153861@linuxfoundation.org>
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Feb 2020 09:04:01 +0530
Message-ID: <CA+G9fYtZeFz4mX2EW4yhT4vwTM+SBdDSJH=ZRvV4Lg1pQ0W0_w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/66] 5.4.21-stable review
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

On Wed, 19 Feb 2020 at 01:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.21 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.21-rc1.gz
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

kernel: 5.4.21-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 70464966e42b69820bd71947631574b2d9f13ea6
git describe: v5.4.20-67-g70464966e42b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.20-67-g70464966e42b

No regressions (compared to build v5.4.20)

No fixes (compared to build v5.4.20)

Ran 20055 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
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
* ltp-sched-tests
* spectre-meltdown-checker-test
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
