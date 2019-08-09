Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E07B87026
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 05:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfHIDVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 23:21:03 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46479 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHIDVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 23:21:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so90953992ljg.13
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 20:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=msEHT0iv566xvf+vfMcGL2ig2A7ZI1+K3ZvkoXORsXQ=;
        b=yeu28Y/HVFnVOJpo0PmViLj53in91wGhXbdhDpm0Lxf20TkJHrP0rDvKE0ENrT7i9g
         +NsxCSeiu2cb9cgFoN632kaSccSm5pC4PCE4IQfHvqHQxHeDcsSKZ2812hSNE4r6BA76
         pwBFIpVWHDG6+kN5joAifP8UaK4/srYMYruCxT1MbghmeKOecY1sHWiYvd32npHYN/l9
         661mkEogmCmyEqP1uy7I4DO14+Plv4z30DWBwZTLx+mnT0paxrU9T59rf6wbDVZVSbGP
         q6i9ix7cvTOgxLOt5SNLHJlL/bL6aGMwNFajW4+mirf1Q0M5LwEFpNgkhKbQKsey7pcO
         a9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=msEHT0iv566xvf+vfMcGL2ig2A7ZI1+K3ZvkoXORsXQ=;
        b=LKX8M1sBVuRN2isQwTgL7wUBoIsqLpzF2oBdUIqJFzrHmuyvuh1fKnA4b3st21a9jF
         ihtFGTfVHs2MxxEu/Hs4cYQUUQCkg7Va7j5gEF8OV7x0fDxbmX/UKtWNw0JKvT6QEvhP
         ee1+PigU/RvKVGG/+vbN4+di6ynH2tJP9RrYIgX9OwPP1lAKz9pJ64W/no1p6nfiR55/
         y330m6HT0CYrXampDaWGoQBEP/JUVHCuRCd66HebYuK1XAIYt3PqNLUwgvCPtKZER0mc
         Eim1ckA/XlpXD13eo9tMXmlUFKlib+CAdp7c5XaP+2GZip8kb43Z4SBgk+9WpiWxJ41B
         a+qQ==
X-Gm-Message-State: APjAAAUluGINyhzQ11q+rTJfC0VtSRF0j9csgJNu1vBpc0UiGIQ3et7A
        DUmzYky2MbSE1GvNLqN08wZXqg6he1ivbB8K2ePMUA==
X-Google-Smtp-Source: APXvYqxTtAKv4kkyenJgwEgxe75lkiGyiF4zxBFZFw9N98GBv1cf9aftyNYCWMS3dEp3l+tAM8ZrVTrcGF84oUP4Md4=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr709400ljj.224.1565320861762;
 Thu, 08 Aug 2019 20:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190808190453.827571908@linuxfoundation.org>
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 9 Aug 2019 08:50:49 +0530
Message-ID: <CA+G9fYvkMFfbBPd_VV89Cme1VtQk6hcZ22a6Qi4p+dKV0CbW3w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/45] 4.19.66-stable review
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

On Fri, 9 Aug 2019 at 00:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.66 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.66-rc1.gz
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

kernel: 4.19.66-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d43238541496ae2b216aaac84e0933bb06eeb0a6
git describe: v4.19.64-128-gd43238541496
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.64-128-gd43238541496


No regressions (compared to build v4.19.64)

No fixes (compared to build v4.19.64)

Ran 23168 total tests in the following environments and test suites.

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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-commands-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
