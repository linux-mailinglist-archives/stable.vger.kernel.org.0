Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F84612495C
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfLROWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:22:30 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42056 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfLROWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 09:22:30 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so2330848ljo.9
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 06:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jo+R1TTGcJsYMxa30YVdwmew5sMvUZiUlEnGrV31yCE=;
        b=JQ6dvlDdRFkUHfxe7bDgR/HwyZHKQawwKU5h/usfGR+z0tmdf0N+WEuwareRcJBKG+
         zWuN/AU7jxTxpqCxgIdqiWobxX2nTseZQQuZjiNyzhiSXoNJXhJrZklqINXBBcr7gM12
         ovaR6dKx4AU3Qv+q9JY5avY0p8lqri1/UC0We4ybcTAozHk6vkbUWw3YmfdxOrFNM5qG
         57gZF+/cajeH9YF4Mi9Svxztjgd9j9Du6sMJ+lMnS6CtdRyennjQXVS2UV/2v8anlzQE
         rgJjexXnIewRHQs0s4akShqXawNn18f8j88EyJjYFbEkMvemOKthl9OkrkZPdJSZBron
         5UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jo+R1TTGcJsYMxa30YVdwmew5sMvUZiUlEnGrV31yCE=;
        b=cki/svqV/ATCRSeJBJO6RT1WEJaQEzDSUIf59ZDFFY2o0flewGU6QYmvB6HwWSeXLw
         glBA/8+9AKpirWKFOeMumHdxNRB3UYCEnvHR2jdVx2lm9DAfPxcetFgQy2ATHjLw/9y+
         uyoKU9qehsHdukQHqpsthalZ6tU7d8O9Dg87xeLua3UzWBTXFu1atA0g1eidZP5vUuxY
         +k1lWk+E0aj/PsertbSSguAUXnqO6D0ndzAKtMRKtUABSGC8IzU5ZLCSzGebySuXxZC6
         K+Q5mV3dSuDlJkj0Z0K4Z2OHEtzxT50D/NXpIQYTxHAo8xoBJbi+NA0hxoNqRMcyw3+Q
         Pnxw==
X-Gm-Message-State: APjAAAWmysE3RFZtj4TC49feN1FOk7tInzn9tGF5Nafmny5vcUTyqoCc
        LS7l6AoZUjdR8niQdP6AGNZvyj7ioxn7sukivzHR3g==
X-Google-Smtp-Source: APXvYqxZUykIjq2r+Uz2bfp+KNP93UjcNLW94m1QYYV29xTP7mlTFZYzPUAyNYsD8Ar+PLZ+ox+HvrDJUyLLy0IthQg=
X-Received: by 2002:a2e:854c:: with SMTP id u12mr1893548ljj.135.1576678948187;
 Wed, 18 Dec 2019 06:22:28 -0800 (PST)
MIME-Version: 1.0
References: <20191217200721.741054904@linuxfoundation.org>
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Dec 2019 19:52:16 +0530
Message-ID: <CA+G9fYur78nMLo8=PkcTJ5LP+UY54RH9cTDmk9m2RR0h+4Mqug@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
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

On Wed, 18 Dec 2019 at 01:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.5 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2019 20:06:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.5-rc1.gz
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

kernel: 5.4.5-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 280ed91cba5bf8a58ecacd658d388388bf630512
git describe: v5.4.3-219-g280ed91cba5b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.3-219-g280ed91cba5b


No regressions (compared to build v5.4.3)

No fixes (compared to build v5.4.3)

Ran 21153 total tests in the following environments and test suites.

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
* linux-log-parser
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* libhugetlbfs
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
