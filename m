Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1992E1A1DC2
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 11:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgDHJC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 05:02:59 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37745 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgDHJC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 05:02:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id t11so4564989lfe.4
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 02:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d6iX3xifVyFAZZxzZ+ZUkySaGBi3Nfi1aejj2DoGEWg=;
        b=WejJV9De5yYmpbQSHuE9A8+FEboLDetyBsC280HOBYFm0tXAwFiV6NO8Bbsaml1Mja
         OJHvW6bkAVOtPXZaljfwk9BmXRaj+hIY1dFnq9R2ODlz3UkdkaPXxm3jKZNZxx/wF6Iz
         mxwXAZmIftqS7urAPwoiVZ3nPcT6gVpojnq3d9xGX3fdcCOmzC50Kgsg89CCQmnQWm69
         pKebctLISCKWVMfQickOO2o4llpAcIKsIniwxa3zrNpaWw3RrXHo+jw6OXKCKSj7+IcI
         HnZEBFf6bCLh5+r0DF6yOBr396gndna1dQBSctYp15nf8EewSHGvR2vjGL2+r5c+qFqq
         lliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d6iX3xifVyFAZZxzZ+ZUkySaGBi3Nfi1aejj2DoGEWg=;
        b=fe0WnMUVpfFHmOFW171SRCjRKYxtez8gHYnkOMmSl3WCmUcWpmNpCqpq/ksUJSO6N/
         mqU1PCAO3uYrLW7TtFuO5iZxvz7Yw0DqpDc7VyluX4HgC2R0KV+L9OBHd9SdD4SUtXqF
         bhYKJ38KqHmRKxLqFN4SsKOijr5pI0T7GTX5D5kjkEsXJyluXhuodd88GaE5ZkAwsARy
         p44emkZpvdfYA0lrD+mWsScgj53px9yVh8IFxnc0N+D0th1B2+S34hAevC7h43R47XCX
         23IqVupKVtU/3QySdrsYAaTeyV+TFOnR7R+yYUTzmG9tLZGFpXsSU1WOld7RC29hIvQI
         ZV+Q==
X-Gm-Message-State: AGi0PuZi6kpfQWL8fYQopEijr+07gTOq0LU4Ne7R+/5cPIdYJlmWw+xB
        hq6MUgtTziyw3JKsD/Ejq7IzQbaj320sMly7b+Gs6g==
X-Google-Smtp-Source: APiQypKtuXbC/0SaIYR34BcjSWaVVCQ4GdK68V++lxooJonwaDdpORlnb2LYnLa3elwbSjB5oasLBsbhUqy+C2Lae8Y=
X-Received: by 2002:a19:5e46:: with SMTP id z6mr3709533lfi.74.1586336575176;
 Wed, 08 Apr 2020 02:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200407154800.629167305@linuxfoundation.org>
In-Reply-To: <20200407154800.629167305@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Apr 2020 14:32:43 +0530
Message-ID: <CA+G9fYtuotK1_BvxXED+em-dnZqkCvACpR86q59DqpBBx9rPfQ@mail.gmail.com>
Subject: Re: [PATCH 5.5 00/48] 5.5.16-rc2 review
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

On Tue, 7 Apr 2020 at 22:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.16 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.16-rc2.gz
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

kernel: 5.5.16-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: f921e13beada3f84cf4323f3ba7f6bdf70bedc8a
git describe: v5.5.15-49-gf921e13beada
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.15-49-gf921e13beada

No regressions (compared to build v5.5.15)

No fixes (compared to build v5.5.15)

Ran 22716 total tests in the following environments and test suites.

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
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
