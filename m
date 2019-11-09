Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC5F5E67
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 11:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKIKTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 05:19:48 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36755 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfKIKTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 05:19:48 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15so8798760lja.3
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 02:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d/0JlyrEpPvo/xoV0YwoV0VmVUtNnEukhtJsbTY0DpA=;
        b=xrELLCHc/M1mdN1miGBp2oSiEtdZHN9UcZTnMMyGnd1unL2120/UCqPo8LwU2LPGNO
         ORLbz6poh/gcSnjSPiFdJ639WIMLb8gEYTfATggWa7nNQKnW7PTWZISwOEwqPDvGOoPh
         MhztC8PmOCdj3NAs75W2wZGxhIxrx0GStd7uj6N3U2mvb/VuDJBhsasR9s27j4pPUIFZ
         cKxaKd+ujOpS5CRaFNDEQOXcIdliZt0MmVXVoQLnpFraGBHnQdFE4hZvBUAA5BDhRhyN
         MsC5c186nh/V/Y8iKXTUOgEVQWzliPM6ce1VimVSoMPS9pTC3EKuxrh3jlhfRHe3QVBs
         GB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d/0JlyrEpPvo/xoV0YwoV0VmVUtNnEukhtJsbTY0DpA=;
        b=LnjcsP6q/fz8pgZOM/RuE/NO6te1OhuQX+JajG1Us4MiVuD5EVQXIaquxvql3asbr7
         u5Ny99gpHpQ6rcUQGIpatBMYAWMnHUBrec4EfvVku/dCyP/1k7NOQNtYANu3k5C05HHe
         zaz5zis9sSez+WAIaQVJa/OunFu6SKiZowTsjqyIFx7Sx3hWGV6gbTFOTqWVXPBTSfnH
         N1+1NtEDdgiNvBe1ced09m/kjMaaAmvo/KA1gZEr3YjfsHhzFh5HVqCBqUFucUAxG2b5
         LS1+ALJPqyL1CkqNP1KcZ1yf4xy7qaXa9B0p1XBI2Zfw3gs8zvobZRctRb4Ow00cCcg5
         2wSQ==
X-Gm-Message-State: APjAAAXtztxeQI64xho3WkHCdG5MDN9UWc9p3GPT/E+LLkflrgYPlsCA
        dsKPLZL+oEL7Id136xhfeWeGagKrNrBaP5g0TIGr6w==
X-Google-Smtp-Source: APXvYqxIwSNlXc1CjOxGiiF8OU9289cYxeDYclnVUyEks7SA/GIvsOU423VvMXa0CNTHeXMuePnVXW8UYQQZ4BC0exE=
X-Received: by 2002:a2e:888a:: with SMTP id k10mr9865086lji.195.1573294785910;
 Sat, 09 Nov 2019 02:19:45 -0800 (PST)
MIME-Version: 1.0
References: <20191108174719.228826381@linuxfoundation.org>
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Nov 2019 15:49:34 +0530
Message-ID: <CA+G9fYt6=xJ9q5x_VHjfEOPDjM3xof-MDnMX58HcBMj5=tuLBQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/62] 4.14.153-stable review
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

On Sat, 9 Nov 2019 at 00:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.153 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.153-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.153-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 2cfe0b7bdeef09a0ffe2895928288ebca332b8be
git describe: v4.14.152-63-g2cfe0b7bdeef
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.152-63-g2cfe0b7bdeef


No regressions (compared to build v4.14.152)

No fixes (compared to build v4.14.152)

Ran 24212 total tests in the following environments and test suites.

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
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
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
* ltp-dio-tests
* ltp-io-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
