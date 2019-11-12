Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D150F8827
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725298AbfKLFmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:42:32 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40460 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfKLFmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 00:42:32 -0500
Received: by mail-lf1-f68.google.com with SMTP id j26so4667289lfh.7
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 21:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y4MKvz0vf5znuyxPzI0zc4sZxNrfZWFQiG0Ct6YROUY=;
        b=PlmniiAPxWzRDOcjMLwd+hE9M7dEKYMop5DrVREzExqblbQNlA89n/7rgzGO+bBJVy
         Nf9qT1q4zUJu1Xjpgqdf+10LT1TVCABhaFO/SQOZomKaUiyNgu7ALsTE4T4VHIBvQ42e
         3HC6HW5hhmVJJ8N+yetodbVuXNGG0wz0HFs4Yw4AIUYj2cYTcAFmqTDKKMMG2jWcXK0J
         YZ23IsopzX71cnl35XFe15oQ0aUAIArBbGsaNPRjlenV2nEcEAfyBR8RnnMXBL/2Z8Jp
         Ufl0VIudf6SZdNQzSULuofJGNgeQptzWQEgF3ThL7Cs1eNKnU5U3gLgw7G3KrTOFovDg
         /J+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y4MKvz0vf5znuyxPzI0zc4sZxNrfZWFQiG0Ct6YROUY=;
        b=rCKvYkZOgI+MUzr2IxACQ51/vcXp2gRwAMdEfu8L2DRsvadhKbNwAMKKLSDG7vF5Vo
         5JdIuALpcIOttfQUslEDcz3SGdwSocghx8Re0iR1SARYj5rQsCCszocDmHTLKUWbwLPy
         PnldSihnx/Iw7/Ab6DipOvUSreZXNuS9iCV7flJha/1h2k1sKirXWm4fwgk6+6C7MPgc
         R7e+0VC+C9AGfSMsUjYLX+yozsF+/IoXcRTHi/kMfIFBlKPn5FqBphlRCe5K+7VQ5FvJ
         WobCotLOyiSrb9pRvySG+OdVFrvN2F0AmU8ZSexwmwEyLkuJh6EjeeFRFhMiBBgmtEHl
         I20Q==
X-Gm-Message-State: APjAAAVP/MHWhiGKUFBGn+EPu9dsHQGAlIb4+QpVIhiNiGM7WNFgpAc7
        6Yqk3D7+KvA/0Af2ejMgfPzlGNRSl4SahbbZsk9qtg==
X-Google-Smtp-Source: APXvYqwi8ThHgK351M+9ZybYIwICmmPCW3Gm4Eza2MRMgA7cNRmMgNxtvt3OgG8MGk7Q8kYEspuHnWL2kE7i7proIrg=
X-Received: by 2002:a19:e018:: with SMTP id x24mr17700593lfg.191.1573537347798;
 Mon, 11 Nov 2019 21:42:27 -0800 (PST)
MIME-Version: 1.0
References: <20191111181459.850623879@linuxfoundation.org>
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Nov 2019 11:12:15 +0530
Message-ID: <CA+G9fYvBckngrAhc4NEU9G-_UrE9evmJNkCz3ZP7eEZjwyHGKA@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/193] 5.3.11-stable review
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

On Tue, 12 Nov 2019 at 00:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.3.11 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.11-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: feeefcbdbfc1362972ef26970aed0aafe90cc1ae
git describe: v5.3.10-194-gfeeefcbdbfc1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.10-194-gfeeefcbdbfc1


No regressions (compared to build v5.3.10)

No fixes (compared to build v5.3.10)

Ran 26052 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
