Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12E53AF0C
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 08:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbfFJGir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 02:38:47 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35564 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387464AbfFJGiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 02:38:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id a25so5805238lfg.2
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 23:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iGn/q4Q13MqrWMeqZokMUPss3YZHlZJtlTRMPfjLiIY=;
        b=fbB32089b8xODi1bWnjv3D9hBBDfgRHCl1D0DOTyOSsc5RLsAFg4sUNXLqxyjnOXmG
         4rozgAKJQ/h3fr8uKBBl/5dz5Nz0nQWxje7RWmqcyHHZI5NGiFacYB7AE7ED8yORg1kr
         g7MQG1SIj2NYXX9Sth+ySfdDqFnhtjeCE+cnxmM8tpvwbyKb2ciDq1uzseGbwLGq1mQG
         uzJ1K+NdBrs11whKNDY9hwbmIX6ltVD9gTGlX75H4Etkud0WYJVr0xY4Vz9Lf/8zA7VV
         1XZSQMtLmHxzqBCmLP9/U4ITK5v+O/qxhqXZO9W+MsVBrOopCvlW9CLMgecWuzHMjTwl
         FH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iGn/q4Q13MqrWMeqZokMUPss3YZHlZJtlTRMPfjLiIY=;
        b=GmiamweYGfbDbdQOtiGumaey+DG/fqz+faEFHU1mjTlhPy4HCM6acrPdYTMk5o5t82
         4HAnfaO1S20jwsoqgaJSLUc5Goow0BZB3OyYkrVvRKiEPgamzSyQYrhICR8WS8hAwgSU
         tfeFBmnpH55jlB0xFa+iWPXKv+xDhZ3Sekpv5pmqWvUmhwDS+kVB/WtTXLvPKjECF3Z0
         MRpDEHRQ4Z1eKfuh/HpTb7hsHC+FY8HSAzpWlgDRUfakZSsXIAwppBC1kzegZn3LhXPE
         SzJ/GjdNiTtIGKzYq78OgJChunUEn5na+Xwl5znJ7l0ub2K8Xn0/7gc8otEnBQ77NH0+
         37Ig==
X-Gm-Message-State: APjAAAWSU01LNge1RRuPVX1ueALXXkmXq1vZpfskah1B45oPD1OnTHAi
        Mh80lGKoZ8x9byookxx7NnqvViym7xuMz7x42HxPKw==
X-Google-Smtp-Source: APXvYqxS3niahYH9+6KRwhteHPEaD44LmaEn8dwnw8ls++OMsyuE6ADCaaqnR33cTk8e9h5OBV/3CqBnFMCoPeZq/Bc=
X-Received: by 2002:a19:ed0c:: with SMTP id y12mr31981224lfy.191.1560148724912;
 Sun, 09 Jun 2019 23:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190609164127.843327870@linuxfoundation.org>
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Jun 2019 12:08:33 +0530
Message-ID: <CA+G9fYtf1oB_31eJ44S63X8skoNoNmjngKTG7yKtJXKGMtXk6Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/83] 4.9.181-stable review
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

On Sun, 9 Jun 2019 at 22:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.181 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 11 Jun 2019 04:39:58 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.181-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
selftest sources version updated to 5.1
LTP version upgrade to 20190517

Summary
------------------------------------------------------------------------

kernel: 4.9.181-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 4fcf72df7bc71264d86e616874a0a0cd382f1b12
git describe: v4.9.180-84-g4fcf72df7bc7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.180-84-g4fcf72df7bc7

No regressions (compared to build v4.9.180)

No fixes (compared to build v4.9.180)

Ran 23615 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
