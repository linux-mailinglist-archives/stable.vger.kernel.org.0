Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0638FAD220
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 05:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbfIIDNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 23:13:06 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35174 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387407AbfIIDNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 23:13:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id w6so9284112lfl.2
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 20:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3LfCbYav0GuA0YL9gmVzYCUuIMsC4Vv6UiM5Mn7c/LM=;
        b=O5lXIvrUXnr+WXbBbwSSiq5gXFIIxXcbW9uQLIbQKyA4HtPBk/3jqsAppET63fAgm2
         J5zOWrn6s8UnYjEgQrmrJJTcgVkm0KII5G3V1NNRzawSKm8+QdUOxR6i3B7YtgTMgfEo
         /R+z7F95ftZMRK/Y9uR61G+BFg5193eFOH5VuARuJjOpHkpG2cERFZBFlC5/vmCTT7X5
         p5eK2weHnDIkj0URyKTuUZQziSTLlqXT3AeRJls+hce8RKeRoYFxwQnVf2EDLhLZPScM
         klAXg3oH8jPdm910u1kEP1bLQbCgfnnsvtVOAYXlFZnLCIuN1uVxiTk6HBWpDg6I5wIK
         rQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3LfCbYav0GuA0YL9gmVzYCUuIMsC4Vv6UiM5Mn7c/LM=;
        b=lck8aQB64AAQ3A0SPI1AOS8clPNB3JuvKOH0OyMoOLyyE1SWEarQr+KrfsDu6U2jiN
         tK5qXLX34iMCWNcUlyayoMuRbqSk1UIIQY+/EbYU9f0Gre4W4cYOXsG5Qq8kJZOshwyA
         /huXh/P0+7dD1yLM67wKYyKzcctbO2k8ehMmquIvIJHfIcJr5C/74Z5EjIvjAUDgL6zN
         H6plEgx4oZP9F7Sd7wYRXS/bVzVcusdrT9Qi8UkPtkLEtwpo2YgFGDZkKqcuWQGtqI4y
         mDd4tbAqiYZxnZRBNsDVSKDE8LwJsxCOU7vSqyjgCDwZaF4InkQqr1XbNA9jfNH8lOOV
         10KA==
X-Gm-Message-State: APjAAAXaTvFpTn3CJnEp6dsmMtbBVoHq5bqlRZOZhk9VgNIrQKmfhr5A
        NPF/qbrY/9Mw+tgBtonYJQl/+FRqYvNNYHlSv1ABxQ==
X-Google-Smtp-Source: APXvYqzTargLBkYl79X0rGmUOLaXZUdvMWAMG7oW/+CUGnU/EiQ1JEwEMQuXHB1GLY4nZD/63U4bbu8hdAXHZjWMZ84=
X-Received: by 2002:ac2:4352:: with SMTP id o18mr15000583lfl.164.1567998783481;
 Sun, 08 Sep 2019 20:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190908121125.608195329@linuxfoundation.org>
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 9 Sep 2019 08:42:51 +0530
Message-ID: <CA+G9fYttXw5buEQkt+PVH2By+S0OazBJZp6FJbDQXPZru_obew@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.72-stable review
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

On Sun, 8 Sep 2019 at 18:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.72 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.72-rc1.gz
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

kernel: 4.19.72-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 20f1e9f544166cca04c111f8719286155a5b9b09
git describe: v4.19.70-60-g20f1e9f54416
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.70-60-g20f1e9f54416


No regressions (compared to build v4.19.70)


No fixes (compared to build v4.19.70)

Ran 22190 total tests in the following environments and test suites.

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
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
