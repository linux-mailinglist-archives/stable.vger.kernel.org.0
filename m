Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F3A74498
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 06:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390258AbfGYE6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 00:58:31 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42830 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390257AbfGYE6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 00:58:31 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so46672903lje.9
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 21:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9+NOmu0ZAGYhLycHrK5M664LA1VOSDREzqpm8uExcCI=;
        b=Dy6x7El4IxH6xxqwSIXwk8PVp3iArZQnLOPaatzWbQol5FXPSiRD+mSzToWtfeBy43
         0qOrR6FwUd1VSYlZT8ljRjbi/p0S+oxpx6zOyQEIYkn4QIiANBECJejUmcWhCmFmCE8g
         Pkk6Ib6ZsllRiLQviQOuRpoWy7LLAQQ4Sp01AD4kMXRltwrtr/9p2e21Kt+iYMXMjCSR
         CQTaAVL4RfprKmQyeSzOkJMLu7egFIspCG30UuvrQDngDclsfkbPkQyUvb4cYW55Alrg
         9OyR9QVIjFWxIEqOQ/CQoLr7MA0O5TjPfhQSX8TxrDIWAVGGroubmE0oaAU7/c23esID
         xT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9+NOmu0ZAGYhLycHrK5M664LA1VOSDREzqpm8uExcCI=;
        b=a4DIvZvDjQRWq2gFtI85NIFHBGcKm3xzdnuTac17+KjUDTXQjv1EhCwoeffvT2YmAj
         1/5Fa6XuxN890n6phPifNmSpN9s2UWXyIORPFc6WB48vRNilw2X9V9WKhcdaxrhqQXgL
         BVMTM6FtOWGycQH6B8oqBm0+kUJXXYeNKpfTQ3ldqOoTqOd7HWwJQZ0zY2vVHhkVYcqG
         xMB/6DRAqCkpSa1bzTS0giYEpGWiY8rWx5G5S+qi3ZyArLFXvkYre222EW0ssfia3mV2
         kfaAGn0oE7V238FTkTOaFSAC723Xb1qZqlWmpcPh1iwJ268AQMQjCcP79Q0vTgbWMzPt
         LV4Q==
X-Gm-Message-State: APjAAAXcmIsT26RP0mM09ufdN6fcLEU9ZHsq5A7/1fZjLjaEtLUqcu5S
        IxKAVxCe+V4E7kqPTGA+JLi363FUogb8msVgkh8Dvw==
X-Google-Smtp-Source: APXvYqxCxXvzfSrCzd2T3BmPanalQe0AYZIjpjc3wJQbiJzoSwhJm8/FAOCzsW6b++2SD0th2VtkctElnJkmZZvQwlY=
X-Received: by 2002:a2e:9b4a:: with SMTP id o10mr8836705ljj.137.1564030709205;
 Wed, 24 Jul 2019 21:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191724.382593077@linuxfoundation.org>
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Jul 2019 10:28:16 +0530
Message-ID: <CA+G9fYvwq2n_uzR8H6Vh+2zQEvn7t9LRFxahb-1bzm5uE1B5Pw@mail.gmail.com>
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
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

On Thu, 25 Jul 2019 at 01:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.20 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.20-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.20-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: 21e90543f836d29dae6ec06215a6e52419913d7b
git describe: v5.1.19-372-g21e90543f836
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.19-372-g21e90543f836


No regressions (compared to build v5.1.19)

No fixes (compared to build v5.1.19)

Ran 22773 total tests in the following environments and test suites.

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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
