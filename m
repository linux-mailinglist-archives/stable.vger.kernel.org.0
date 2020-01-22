Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549871457EE
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAVOhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:37:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41865 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVOhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:37:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so7063373ljc.8
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 06:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c13zs8955RjOwO1R68Yo+jLBYdPImb6ylKEnAaJXyfI=;
        b=Er1BCnrp9pDvNyImzTqxasJ+FYW8/qO7X6bhQUhS6CQLwAfmG9cXbpfioOahR9qOrF
         /yIDow0U2JjXN0EnFsfK74W2eiQYgVwfeUa3ettvfdOTXIsy7jT0su4soPNOuPcczkto
         3pQMzKhoFOh1OhCl/1PtV/HZXUVyrYHLw5lrpa6eUpvftZNoPuyFkFp3fdfpT1wATepV
         SOS6Y9ilqaC/goEQ6aRfc5sYHNfe12bmF4/w+ZB8fQ8HbeTyIADc3I3W4RM0lp8dHXDL
         dKHEcpCM0QECJ61cfTQyYCtOvS19tlSglws3Q9ANtu1fei+xCYALxdzY6A8FaM9ax9jb
         7h8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c13zs8955RjOwO1R68Yo+jLBYdPImb6ylKEnAaJXyfI=;
        b=FWm5BaQ+iR2duP2tw5v0Txrm24YhqrpBt3xRED+4gEmXiE6zcXvUm6X8CDxfZ+EDk/
         esbibE8OhPaPTMTv2B0zdIhqco7uKuFKfdGfQcR51wPWhgGdi4NK1AEYnyfegm54I9iu
         f4mFObJB5EIigIsNl35PnMwCZqDdC5k7unhITOJWmwUCP4pqZY3HSqRBzwFZOm1yNO12
         RLTtjY0Kh7IW0hTwC1OMtWs6cPP0D8XG/+Ybm7Youa+kUoa6JCSL+qJqwa7TZ/lNDEXy
         tUOa752LrusaqozMmbLD512JKmhVCMsgDSbReMXIWcZ7Ox4FqCz7C6INxsujFXOLjWZZ
         SGFA==
X-Gm-Message-State: APjAAAVyLjj9O8qtTat+TJRF/k0Y9RGJiFXjW6JuB72xUDNKiioRcYFx
        s0rPEW5vbPHe7HHCiWQjw4lIatIKuCtSo+VXLefvNQ==
X-Google-Smtp-Source: APXvYqywzF2CDlmaQcEQ/h0GK7mqNcY3nemKFbD/fkL3KGrztNcgnnWKbJ0mlhX1LotfCWETqxh9T1ckkUhB/Tx1rn0=
X-Received: by 2002:a2e:9c0b:: with SMTP id s11mr19310123lji.11.1579703825148;
 Wed, 22 Jan 2020 06:37:05 -0800 (PST)
MIME-Version: 1.0
References: <20200122092755.678349497@linuxfoundation.org>
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Jan 2020 20:06:53 +0530
Message-ID: <CA+G9fYv=neoAU80UdcQ_dRv78x02AXvkUX5y0kY2ZZ-meWQKQg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/97] 4.9.211-stable review
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

On Wed, 22 Jan 2020 at 15:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.211 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.211-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.211-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: c10529b210d19bdf8fca0385b4e1e6374401dd5a
git describe: v4.9.210-98-gc10529b210d1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.210-98-gc10529b210d1

No regressions (compared to build v4.9.210)

No fixes (compared to build v4.9.210)

Ran 21111 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* ltp-open-posix-tests
* ltp-syscalls-tests
* v4l2-compliance
* kvm-unit-tests
* kselftest-vsyscall-mode-native

--=20
Linaro LKFT
https://lkft.linaro.org
