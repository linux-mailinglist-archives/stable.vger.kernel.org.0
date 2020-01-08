Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08E8134810
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgAHQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:37:13 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43759 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgAHQhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 11:37:12 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so3958438ljm.10
        for <stable@vger.kernel.org>; Wed, 08 Jan 2020 08:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mSprmQdK8yTUyJ82NWGsdQl7KNFt6mfONZwoBzX7Scc=;
        b=Mx5Blo97fj+AnzG7KBhWIOrSA1aAzR//CiHXE3u3nCOCb/Dv7q7TRvXIugC3hQbr+6
         5sB6CFF9Fa7oSbQYUS7Ja84TQnoCD5hhr9fgzMQEkcC53H/P5NriyB6xVX5ToLZmOXls
         rdDYpufA7GGFQUBiAUMC9yKwUVZrWY5WDQOQJvRiSJvMIlH3g/huTZoRp5s65yF8Q9zV
         VwpEnoeii8VtiHNosrv4YIeca0IqGQI5ksHg0d8ZkkBIEnQClKeCStFoIGejBbyNDvx8
         xbUidIsN7AYJVPJVO+QHP/xcplbrQeYX4/HLKseEoWSJjMQcpc5vCoqxyoVz4p5Q7FRl
         d4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mSprmQdK8yTUyJ82NWGsdQl7KNFt6mfONZwoBzX7Scc=;
        b=OOs7bTnCSMdGb8VlbQyQbCDmAD2/7UESAmJ6xxUhou9DM9joz5PZhuUx2r7m1IHlVS
         +fd+zLHYeZbNLcEyHWxWIYA6J8MYHM3gwlZQzaMGXPWnTo3jyoyTMu7c++YGTB+olpiA
         TUQlnVaFQ09YgqDE1rdmoto4mxsbH2DDUgtKOV9mCzok64bal6QCdsbqCUUH2pCLTS7n
         29PKy1ZgvZru5y7ZvCKN320cnCGSQdU2Hq+durzPrkvE1+DMe3BmspRdEdBv1qPz8W1+
         w97FhvriuKwWA1mHXClVAfTrOEtQdEFbVyAJXSug9BM1CiO4b7zlUpEiUHSie32O+cRP
         KVsQ==
X-Gm-Message-State: APjAAAX4qzQ2zHbEYaIw6f2g2Z13NwaVceATk/wMJVF7EOyvMPGFouvl
        kYKqAWFi8W4dFe2IZMbtRk7+7wt7+6bNULefvCLpFANbnwk=
X-Google-Smtp-Source: APXvYqxL+8Xqj+9eGKjoAtet7LHfIw8H9eIdzazSJAswsH91mD9301/A1IC9vC6MqgFYnflHn+OtiHoI5v5gF2nNkY4=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr3450021ljd.227.1578501430805;
 Wed, 08 Jan 2020 08:37:10 -0800 (PST)
MIME-Version: 1.0
References: <20200107205135.369001641@linuxfoundation.org>
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jan 2020 22:06:59 +0530
Message-ID: <CA+G9fYvCL_wwOOY76n2_JGeTYFkMyPRti0xsaOJsQ3D76YwLDg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/74] 4.14.163-stable review
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

On Wed, 8 Jan 2020 at 02:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.163 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.163-rc1.gz
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

kernel: 4.14.163-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 404399b2e7dbcae8377bff92324178718f9574d0
git describe: v4.14.161-163-g404399b2e7db
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.161-163-g404399b2e7db

No regressions (compared to build v4.14.161)

No fixes (compared to build v4.14.161)

Ran 21424 total tests in the following environments and test suites.

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
* linux-log-parser
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
