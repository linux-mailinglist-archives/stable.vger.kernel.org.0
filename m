Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA7818DEC3
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 09:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgCUIgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 04:36:51 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34457 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgCUIgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 04:36:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id s13so9052518ljm.1
        for <stable@vger.kernel.org>; Sat, 21 Mar 2020 01:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UX67wRN7rFBppvROxiGvXWoGuTK1VZF5KIrD6zZERok=;
        b=Haqv4YAUO52DsDYxsdaaY27+FxVjBJwJuvG7Pwgp+13yI8bN8XZBOpw+FiWAkAN3Fr
         kyKhCHnckzNtjICn5kPsMF1IpVg0W84aPwWGt0I8aFXFJ5BnJCqJWiZC1GaJ0XclGhWY
         ye5RIV6bKRwhLrdmFhJWc37wLkIpI2j4Onoy2XWr8D+rH2AGEMXmnurdvwV4N36rlAxe
         VV4Yhn3mPxRb80eJOyD1B+Hcv2ZeENVLY5vwbO4GFAPVhxEkJLTXbM5wI48ZGUgpXy4i
         a5pijDQlsTtU/IbZy/OI4TDo2xPLUNYEOpIyqxrevvsKkiUHi6Xy7U1hHR2nMkw7YQeE
         8e2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UX67wRN7rFBppvROxiGvXWoGuTK1VZF5KIrD6zZERok=;
        b=N4ZT696PcCopL8QUnOAfzRUm9A0YkdHZUMKsZ0RzJYPUEyCQud814Pc4bohYtiNjlq
         2LoVvE+nHZlZXzgpA/s9FmvLCQbqPcZ41FeZLB8BslGE/gkyu7pYmNcOsrkyywPmb5KU
         XxzyC3+qxmdxnCvYiSTjrf1XS8/plnVUSOtQRjdVjKWPRMUnmWEeGamJlbCGhJJJTtKP
         cQNWsipF01lLp1wZ5Iz8AjJimwFz7FaQP5dT1sTUiRwlsjfRLn97zgraRc/GSr3Uk8bZ
         aO/JuR/x0LPBxbNclmfrNQFrRdK8SaUWuSnVg7r2GgjMIh/00GWG2wqMh0hO4ZoLmM2P
         kiCA==
X-Gm-Message-State: ANhLgQ0t07Z4ZoGj3BZLdx6C+mg0HYh1Vus2JZ1OscByuN9fMXPn0YiB
        1Tq23k2xIwm0W1PFgy2t4qng6p8P0cULX94knfIOxw==
X-Google-Smtp-Source: ADFU+vvPfcczI+GuuSBq7Xx4zKNRkVEOFJkItTF/T/z4q87PkQpWBiqqG3LBGTwZCQ9LlKSaP4r46vLjEkh70ZMrDQE=
X-Received: by 2002:a2e:9256:: with SMTP id v22mr7728795ljg.38.1584779807443;
 Sat, 21 Mar 2020 01:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200320113335.277810029@linuxfoundation.org>
In-Reply-To: <20200320113335.277810029@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 21 Mar 2020 14:06:36 +0530
Message-ID: <CA+G9fYtQk-x7qTZVcFo3CjiuPYNTr6RTLcDaSxh+AR_MyxjkVg@mail.gmail.com>
Subject: Re: [PATCH 5.5 00/54] 5.5.11-rc3 review
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

On Fri, 20 Mar 2020 at 17:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.11 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Mar 2020 11:32:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.11-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.11-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: bea94317c526b97d68c6f0aa31c56de3267c43a1
git describe: v5.5.10-55-gbea94317c526
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.10-55-gbea94317c526

No regressions (compared to build v5.5.9-207-gbea94317c526)

No fixes (compared to build v5.5.9-207-gbea94317c526)

Ran 22328 total tests in the following environments and test suites.

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
* perf
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* libhugetlbfs
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-syscalls-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
