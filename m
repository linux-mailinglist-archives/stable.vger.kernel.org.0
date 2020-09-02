Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042C525A631
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBHNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIBHNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 03:13:35 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD165C061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 00:13:34 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id q124so983467vkb.8
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 00:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9FyRqglKmbgC+YLd7eUpkAxWZYcCmplsY/5grczgp4M=;
        b=uZdIhUejpj0MS9lSXbyyF5E/+kgUutyQsFhsYKZAeayBijIkNIER6kBOjXFhmOiOMj
         /+oDnvt54tyNAa0Hq9UIIv9h1nbU6VvZT99Bp/cYH3i5pX22v5Uu8teHXRBXnwinupYV
         63wHJhG8A/Ksh3Wr4uVjwHJ0GTkvMtTv963Ra6CHlJepWzMfHNV+y2fmnKsbdBxeiFvN
         ySGWY3qKVSOw6NvWSftXayU1QgU4D5QVqiQ8bZ1RG6HJgjRP1Wth99dpD+AFOd2k4e31
         2FSE4bd9m00lnzzQ8LZHA7nNr275ea6z261YDoY3ktW6n7sU4gRhJDM6ndaoaMTiEnIH
         tLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9FyRqglKmbgC+YLd7eUpkAxWZYcCmplsY/5grczgp4M=;
        b=H2SzWIoHpwXibNXUIpbpzds6M2ctg64I3yw2azC4uLxulrTAjwPPGoLApviAdd6nr3
         0WXMa4ANg3NIyzzfR6lgt7xWv0ZucJAJ2mgApdsMi+9/EAvSxwjO7A7VTI/cOEdIGAMl
         oxHzsjfhboTAwQtJhHPvlUg8Qiw1w2kCxuPFQfsL4qNUVJ320aS2rxHYf6C4kXaq3qtJ
         dBIPSWBmvK+NcruDfl4XThbENm8TGkKnsrZUJ35wgnSb4OdE0zph09RmvoLfyucXuJ3h
         4mhKkZbbwMQrYF7tydCin1qArugTmWTPy23joz8hoh/00WxKqsRgUZ2Lo3cSmov5S+H8
         uNZw==
X-Gm-Message-State: AOAM530++bbdfha3TPK3DKq4ATOrwtLsg6pnIy9Kin9OAf79izwwoZsL
        U+w4q7msMo5kQVkM54T6YjV0ciZEtANw0GvwDJhhAQ==
X-Google-Smtp-Source: ABdhPJyrVAyQl3k4J4t4zLtuk6x7K8Pt+C7h2n0tGx6cjE6twG/jjc0/lGg6PvOYD0tQGrmUBPBp8lb5/xcH6L8oA8s=
X-Received: by 2002:ac5:c8b9:: with SMTP id o25mr4294526vkl.51.1599030813900;
 Wed, 02 Sep 2020 00:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200901150928.096174795@linuxfoundation.org>
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Sep 2020 12:43:22 +0530
Message-ID: <CA+G9fYtOetDR6EVygFx6S5wU6SL6fPYjwp25rbxYM_XmAqiLMA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/91] 4.14.196-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Sep 2020 at 20:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.196 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.196-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Kernel BUG on arm64 juno kasan config kernel running
LTP tracing test suite found this BUG. This BUG is not specific
to this stable rc release.
BUG: KASAN: use-after-free in prepare_ftrace_return

Summary
------------------------------------------------------------------------

kernel: 4.14.196-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 54fa008d06cd73d42acafb918a6ae005eaef4875
git describe: v4.14.195-92-g54fa008d06cd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.195-92-g54fa008d06cd

No regressions (compared to build v4.14.195)

No fixes (compared to build v4.14.195)

Ran 33060 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-containers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite


--
Linaro LKFT
https://lkft.linaro.org
