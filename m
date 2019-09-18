Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE6CB6BD7
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 21:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfIRTPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 15:15:18 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36157 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfIRTPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 15:15:18 -0400
Received: by mail-lf1-f67.google.com with SMTP id x80so500904lff.3
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Dt7yXHdH1Id3RqwiIV0C/01O960lQm3BJXXwJf9SWQk=;
        b=vSydBGwCyB1jXs+b1UTgFSZi/gDms6dPurRmOosRtLcffbq3zdjlkimGIIga+ynHAz
         L88NMXM7iO0/1BfFK79uhjFtao7kzBwWH0AfExgcL4Tvz6rc/Ic56ptbPcoLckd2dCXw
         2rZ8fdY+GmDjm/KBSX+DS1EDNN5V+4EFoxAunF0hr+u6JvBJBWmc+WHgfHpVuRcLK9q0
         gUlzpqbBVWnyqoCV3bFd8eRfLVvmE49avaaXnp0Epnmlgoduqo2a+vOA+qGsgt73TM+0
         LuY+qS32cBW2sGayfTyZ/+HbSShX+m1ySAH0lAg8DpX9UbuBhvhwQ+B0M0Xwi58jix2l
         gRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dt7yXHdH1Id3RqwiIV0C/01O960lQm3BJXXwJf9SWQk=;
        b=d1X1PCNbOvkbdryhZiny2horjHvK+HD6RXpq14vL0lMX81SG28/71LXWSCSdWVRLcN
         JG71jihetwJ5v1V0u6vOAuGXyJtbUUwz3ValC+TQik2GDOvF/KDGFYAFTutkodnNU6cD
         iZ/LG2u2iBfGukou0BzBsTDQl8Aw/mplPKQYjoWOgmAx6Gy7yj4J+JMtn2HbAkb4dxFm
         V3rqvEhNpZmVEmb7si0HuJRn6O5pcP26tekGxjI8iyQAhOll0rnR+X/g2borXSRXzO+P
         bdsa6VqMVytpaKjDV4U1g+2a/X/PDcKesyoTaOoMhlNJmkZbzkj+UFD21NA+o71RPirQ
         EeSw==
X-Gm-Message-State: APjAAAVKMaHtkdwDOwYrqQxNOAZKUasiSJr1j8sqdeMwRZleHCF3q9Pf
        q8E3D957thaQB4F3Bl+fZpXaS+IgZssjjs1Y8e0Lfw==
X-Google-Smtp-Source: APXvYqwd8mNgmAfxRsxbHpmGTXqPPI/NsSo0c+yLNIpD0CA/y4mcecLNN+C0S9Om3F9p4OroS8A2dc7qxuv+hwjeWaQ=
X-Received: by 2002:a19:f247:: with SMTP id d7mr2832989lfk.191.1568834116432;
 Wed, 18 Sep 2019 12:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190918061223.116178343@linuxfoundation.org>
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 19 Sep 2019 00:45:04 +0530
Message-ID: <CA+G9fYvgYva87MObJ=Qm=1y+q5GMh74XFA9vhQ6BEK8rzZZVXA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/50] 4.19.74-stable review
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

On Wed, 18 Sep 2019 at 11:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.74 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.74-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

-rc2 looks good.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.74-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7290521ed4bdf6c7ec60cab4c19507fd1f53214a
git describe: v4.19.73-51-g7290521ed4bd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.73-51-g7290521ed4bd


No regressions (compared to build v4.19.73)

No fixes (compared to build v4.19.73)


Ran 22247 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none


--
Linaro LKFT
https://lkft.linaro.org
