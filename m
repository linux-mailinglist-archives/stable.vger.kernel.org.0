Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52ADFF5E78
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 11:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfKIKc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 05:32:28 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36652 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfKIKc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 05:32:28 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so8816890lja.3
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 02:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x90YfWLsoz/i9rgd4aZmTpssHGEfM8PqRGQW6oK14VU=;
        b=xJQL45WxbQyvkeWDLo0XQ3Wek6whiF8weRmZKEI4SfrPIsm69lRWxUZRmlMyjQUrUf
         aXHqPo3euRTmrPZZttzD7H31AYbOptoOBhcwX74M/87oEStJ9zxe2sMy93dJXd6rn952
         R+G+KT3ftLHiw0wPjGKvzCJJYyv6vJs9Xhr+ZAwbnFHQg/wNELDLGzBv+ce5fNZ/gx7y
         W2xVJoqWCEGPr4GvgWE/6XpqrOkttDU+GzKMXY0DTm/l5LRrZ11+9f+EdT+nCEUZkhD/
         Xid6/NnH0BF6qgoDHP5F9Xa6S52aLOwWFDWxJGeF7NPwLrxUhdiAidxp/OLolYCjwDWL
         JnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x90YfWLsoz/i9rgd4aZmTpssHGEfM8PqRGQW6oK14VU=;
        b=Y/Q5uPImwjIjHkWGmrznLDMqfmDe4iGdtvCvUsFTTLHouyXP0G1CSMf/1nRZufiMgC
         ricwpIq2Pj68Qs93sV7wEFe1tAkpK9pJhy4v5HlaIcd0LfWwkUD+1fSYj2AE8A/fRjL2
         l5KaHAT+kAgs2PCs572SA8JbdUBFGsEG3KN0Zd2ovgt96ktrX0bJnkEJvRdrlmww16rC
         PGTIxUPRG1w/D2pOqPrLcWz28SEooieDzunaQ6+7rPA2ZfnT/4rJcsvPrcGvAzhTfOLS
         +HXZ2H17Qn2qo55wwytu8Ri6LAjA3sJOfGqOmOtoZh+xkaAMIYVJZEiRlIQaAuYvwJec
         3RZQ==
X-Gm-Message-State: APjAAAWQ5vubC1qOh96ft+fpP4taZowDVeemXoiet9xDeoTmmrp9OlyK
        avzlzfL765X6r8pGkcwUKUO/D4Ydpo+yLcV0BEISqQ==
X-Google-Smtp-Source: APXvYqy44Cl7iUEB+kI/Z7uZnPSKeMJdbg8nNjnafCmVZv8bSJ9eNA2sqJew1ncCvJjhiHNU8vIcv6puulr95WGMwq8=
X-Received: by 2002:a2e:888a:: with SMTP id k10mr9893540lji.195.1573295546106;
 Sat, 09 Nov 2019 02:32:26 -0800 (PST)
MIME-Version: 1.0
References: <20191108174708.135680837@linuxfoundation.org>
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Nov 2019 16:02:14 +0530
Message-ID: <CA+G9fYuga3ZCTfzuXwx4Rk7kR5==zgbv57+jLpbYrXRfowd4Ow@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/75] 4.4.200-stable review
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

On Sat, 9 Nov 2019 at 00:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.200 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.200-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.200-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 6afbf4832d8a30149fdb36136e222f795f2e9ec9
git describe: v4.4.199-76-g6afbf4832d8a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.199-76-g6afbf4832d8a


No regressions (compared to build v4.4.199)

No fixes (compared to build v4.4.199)

Ran 16997 total tests in the following environments and test suites.

Environments
--------------
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
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
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
* network-basic-tests
* perf
* prep-tmp-disk
* kvm-unit-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
