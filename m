Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116E5D2F31
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 19:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfJJREz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 13:04:55 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34929 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfJJREz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 13:04:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id m7so7003520lji.2
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 10:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+crOUQhON9pq1abW0XzG6pam/66+6kNGOuIM8ailCOQ=;
        b=DrlcWV6XF/nqUZSlIwUGrTTxIb2vEtlqBcofdgDRdtOWPz6fEmUmPsUMUzKkZoSmoO
         0Cgv8xQtTAUSAO/jq90lRegoJ+yK/9Gf2+DMzuJPLp/EJnnmzgv8ZxVztrICVtwcoI2u
         l1S2hcEPLKY9sDQbXUycSJq2QnJtWZTy5H1mpazm9S+0QDlvozm+Kr3yk5iVS6U81tW/
         pG/stmkrMmgcTYjIbJYfdNeRNvvBTA0oQ8+fhx2ALqNcZVdwscdEpWzxPgROhBIWGHQe
         YjAfH1dTUehBh3GIl6fPPcSg8jKG6P2nAQg1U5Mz5Rrqc7CRE8VeT/FKfYu6CEOCY5O9
         iKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+crOUQhON9pq1abW0XzG6pam/66+6kNGOuIM8ailCOQ=;
        b=Y60r9FG/RIc60d/AqEcDa3wDgZJ60YqtqN7RbbyQxZGStwSnLAQkQzjT9RFnA1vGi1
         AoLNM5C+9UWx13txzpQU2QSk4ssGUr8Je3a8ARhVo/0bJeJFP0TpAV0MLstmG2mnZpCW
         d/joNP/rN9ddmLOtYalcst7nkTpAOKXOq3xkmPJpChQFCT0gAXr4fIXZU2ymekAQwyLG
         ZDstlKegwHw1367nbsnx0+oKRMRuQ0/2M6cmgNOCbTu/0LWhwD7bivDteAYzbkd1MIbJ
         91JQoJ4/2ovcj9spdka+Kxq38BrInyhkz23gm3yfFk8FT4Idxfy5qg6iZsVknt9ZjCTB
         M+CA==
X-Gm-Message-State: APjAAAUBvOsfDh8fMNuNjpc3qod6CI6fAezAfZuSQf7S1xjf7B7VhKUH
        d0vvQ22OSuEY9p3F/v0pZmfOiAW3NaIubjpNutsORg==
X-Google-Smtp-Source: APXvYqytmHu6QkNyGaviwCa5Sdhht695pZZMHlFdWWT/g04Rr2YwgtaSzIk0KPOvgZY7oH6cythk4cQn+Kee8bMX1Hw=
X-Received: by 2002:a2e:5354:: with SMTP id t20mr6948459ljd.227.1570727093055;
 Thu, 10 Oct 2019 10:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191010083544.711104709@linuxfoundation.org>
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Oct 2019 22:34:39 +0530
Message-ID: <CA+G9fYsSVQM127F9vofKrmfF9Q_SHb04T=tedsVp_5SiXd1QVA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/114] 4.19.79-stable review
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

On Thu, 10 Oct 2019 at 14:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.79 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.79-rc1.gz
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

kernel: 4.19.79-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 4d84b0bb68d49edd179af2b16d4b912c1568a182
git describe: v4.19.78-115-g4d84b0bb68d4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.78-115-g4d84b0bb68d4


No regressions (compared to build v4.19.78)

No fixes (compared to build v4.19.78)

Ran 23612 total tests in the following environments and test suites.

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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
