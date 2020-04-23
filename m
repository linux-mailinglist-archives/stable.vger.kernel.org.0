Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656201B60B3
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgDWQW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 12:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729527AbgDWQW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 12:22:57 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B73C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 09:22:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a21so6834960ljb.9
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w34dDWOvXQm5HMAoUFj55JSLOl65xl3iabYd8dS63XM=;
        b=DAd3NejFDEiIu0cJl/NJ8/ym1tbwrrbkTgHRXeQO2k4fZQCSYafE4f6D2iHTtUb+2F
         /mmGB2A92Djo8rpbcyFh6nE6FRTpKVuwCANh/G03qYT6HT4hwF1fkkY11tglys65bvgY
         1ycVlHmKCAvsTbPF7QB3Gl0ssK0JDVTgIJvaiw1wnmetBEZPliL1tAqwfTECJ2DjZ6Pn
         /UBOEUC1z1h6n5D5+mqoPEW5K83E+nWKxoKByZEJoLo3h+/CNIEZlvsgml79/7/KlSH3
         DwP3VlWKjq9FQL8145qGCXEKqgiZ5LOFcYSBaHpTp2saPhKe5RmyN33CCFqE+J6gGzFh
         cfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w34dDWOvXQm5HMAoUFj55JSLOl65xl3iabYd8dS63XM=;
        b=irjgmjDvMByYrghiyLObIdUMQ6xVvo7gcyBMbTGIY4Ox9/m/iSmkjbIJ/5h7Y5HlzO
         GqOwXcGSFqDHil/yN4aTsxMeBMv2b0r6Cj6J6dH3d7qyFUAbYxjkGS+6RBbDeKx7osYl
         5KerBy/SEQxUzwexq2E/M4+zn92qhfBc7XZ9TpGrxkK6kPkzAF5VGagUfgqq7QJ3g4Wo
         QKEJJBUTOjzaPzD+pdiIKZYy3dNqiG54zBuykCJsuRj3Oek9QxS/9NBwIwaFW4JgIg+1
         VcFXa8Zvr00+LjnzTNjkDYtfD5BAzy82q6tz2Kclgrat19CoNbcEzqHSparIWbaJAMYF
         90kw==
X-Gm-Message-State: AGi0PubyD3kN8WeY66Doy2I4AhdXjXmPp11CHZrII68OSE2gvFoi1UOY
        j3x21zSaeam8qbdP5EbzYRDmy3MQGxopQhN3KXhxdw==
X-Google-Smtp-Source: APiQypJE+zCpr7eDkKlUDwHR751ytOTh3cjA4+7Lr1ufzP6qhxRyb/S1gJpux81PY/M4rlOEPk3K6UrN+z1CTHUMtZY=
X-Received: by 2002:a2e:9018:: with SMTP id h24mr2778258ljg.217.1587658975058;
 Thu, 23 Apr 2020 09:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200423103335.768056640@linuxfoundation.org>
In-Reply-To: <20200423103335.768056640@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 21:52:43 +0530
Message-ID: <CA+G9fYvR8eLJt_PYePC0xY7yWeubCqt2Y-wimX9JWE9VtujnAQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/198] 4.14.177-rc2 review
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

On Thu, 23 Apr 2020 at 16:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.177 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.177-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.177-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: a7097ef0ff8203c8e25ad7d3b996e030c083a81a
git describe: v4.14.176-199-ga7097ef0ff82
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.176-199-ga7097ef0ff82

No regressions (compared to build v4.14.176)

No fixes (compared to build v4.14.176)

Ran 38632 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
