Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66ACB29A9
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 06:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfINES7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 00:18:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45615 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730047AbfINES7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 00:18:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so18417576ljb.12
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 21:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZlApnDH6uzGioq4MEPWFg3abrgliAQW/xOnjhVpM4Yw=;
        b=vloFQkKkYGt9gx3lZns42E668T7Uln2xC/1nmv0NSdGWwsqVKWhIaf5k/sVK7s0GcY
         9J2a/gfxxvJdDsigz62y4CD0eProtuZi0cpiYUi6zVVvM+HXP+jwcka0M/XFDHN7gv1M
         4F9puca7fRnFVXO9edKRl61+eBYtXtcyN1rqT44p+6jBIuCSiWZr5ApfurDEO6b0U5ou
         jd2TzzXW0NFFUL9fnbvQPAQufG8XfTNmRg9p0OpZ+VFJ0SWABLMmfAqIYh+9qS/6dSVd
         /b0zh4/wO0bjWzEPd3uE2kd1lx2RZAYFL87snowtePwwqctSFU/cXQPcDqZUguSfXAxC
         zdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZlApnDH6uzGioq4MEPWFg3abrgliAQW/xOnjhVpM4Yw=;
        b=fqXTC8d12ava7ysjUFs7cx1iX+qF2VWXHH8+z9xY3hnfn98rF+laYaad2YtZF2M+Nt
         me8b8VlwxR0NHHAiTC5r/tQ2MfrP240+lFLsMHpjwgQwwSgTyHYb5LUGvr2qq/6oof9O
         D3pPmRO7DyULUsp7vdSasjDj3YmYSHf0lEbHzrpy6Y9jj/FS297DlJ1renY/IkxvKOks
         2PuRrcRra7dyb5hgN2YeclV9gY8z6RsvaE6Duw7vHGjq27T5yZnmawFeJCve9oPa+lNb
         Ix4eN/i77hvYtkClZjCzN8E3xIeHNeWaExqvH+NCh2MnkxUM1GerFy0BPBlmRc8tCwWG
         FR8g==
X-Gm-Message-State: APjAAAUTplzoXg2OMxQb+xlLkJHYLUGCi3vmXvZbE43/keL9CxxdkzhR
        +nqVvZZmqQRpcyVwGT6BvA5GsE3/st+ND8d7fIlObA==
X-Google-Smtp-Source: APXvYqwZwg6zJg0uKG8mcZf/ncSZcgrs3hNMIksbSWoXJEwVUL2LXeZ2dGnRBQ52DVqd0b5GwvZOIsQ7gKgFN8agMNo=
X-Received: by 2002:a2e:a17a:: with SMTP id u26mr31842116ljl.137.1568434737324;
 Fri, 13 Sep 2019 21:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130559.669563815@linuxfoundation.org>
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Sep 2019 00:18:46 -0400
Message-ID: <CA+G9fYu9NYFPrD2WqKTPFkRmKfNiYFb+LL2H6Q7=OVW_A6Q3Tg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/190] 4.19.73-stable review
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

On Fri, 13 Sep 2019 at 09:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.73 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.73-rc1.gz
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

kernel: 4.19.73-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 490747a3f68a8ef2bba5b0cb5f29b896c02885c6
git describe: v4.19.72-191-g490747a3f68a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.72-191-g490747a3f68a

No regressions (compared to build v4.19.70)

No fixes (compared to build v4.19.70)

Ran 25136 total tests in the following environments and test suites.

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
