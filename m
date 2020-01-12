Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652551384BC
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 05:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgALEzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 23:55:21 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46952 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732178AbgALEzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 23:55:21 -0500
Received: by mail-lj1-f195.google.com with SMTP id m26so6352365ljc.13
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 20:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e3re4IXkyyw/6+2ZpdvvKRwtPpdPNGOyATLsdF0oXqM=;
        b=hAmHcKkru7Ws+bYPtWoibuV5UJ72IuF6dgWGL5tJuMeheEKvkn+UBiWpIq8J4qR0mW
         uCJjZnwGvlY+QCH/RxCwWGPK5SFHCcFUq5GvYcMjwrQcxaHDsh7bDcwhvgeHrGZseHlN
         gACfjpW7OPENtY9heTGfHC5M/UCpS8SqRHwlfEGTMCqCRb5YLrhTr3NnJauFntM4LhRG
         LJRjxaN/8Op3CUFo/93QTWC8tSBTjx7Dx/fvUe1VEQCJxDUK5LuSFEh6lROpm3cpRbM6
         WXYkoM4Q02P/7ZWw+dNGXv1lG0t1QwYJVufPr4j4sdekbmMV6xYT7hr0C2wekAh2miNh
         Jlug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e3re4IXkyyw/6+2ZpdvvKRwtPpdPNGOyATLsdF0oXqM=;
        b=sHVUmPOIBsUPpbRqQBOFkMNuuTp047Xj6R3D7DLxEc6yQowWaoKcmVT2dlvZNe5c7+
         qQjyZGs9kFNID2V4yVxb7wz0jZLoyzFPPEzYG/qtIRRLnovASrmNNhGHz2ce2JiEo73F
         EA1NPUjAGgNY3r6iuION/UpvQs3wJRKOxHKRd6w2AOp3p/TsP74VaBuwwF8k6GNghPgj
         sMsh6Q77VOXzJ31E+TVJmMFwn6HuEar5OetB6jlug1E/ju9kjJqp1GsE4+vkx4qWPbhM
         yxsGF06milTekniPYjUHwN3K5xwuk1PszJZrK7YihIlHQPMMJCfZCFO9wdmnArAID2sI
         oiIA==
X-Gm-Message-State: APjAAAVIwns6q1a57KF1oIDc3q1kfGC+snuEdTwohl5/rQLZuYg99j9R
        cG8UoFy55qy8am+9XNiSLEzgAJ4aqen2yr+YU74qfg==
X-Google-Smtp-Source: APXvYqyWXRnqElnMRXdT/2ppNEwfNstxcJF5mmLRZ6EnkTVr4weuScXNYSC42S6L4+iVxmFc4PHQVgRO4GteHdVJHmk=
X-Received: by 2002:a2e:b017:: with SMTP id y23mr7516131ljk.229.1578804918969;
 Sat, 11 Jan 2020 20:55:18 -0800 (PST)
MIME-Version: 1.0
References: <20200111094844.748507863@linuxfoundation.org> <0668a7b6-502b-719b-a2eb-59519de7bf3e@roeck-us.net>
 <20200111175114.GA403776@kroah.com>
In-Reply-To: <20200111175114.GA403776@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Jan 2020 10:25:07 +0530
Message-ID: <CA+G9fYuwQW1qqTSdYTCc6es5R6AJ6zHScmw1952raHHJ7x+uNw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/91] 4.9.209-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Sat, 11 Jan 2020 at 23:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Ugh, I thought I dropped those earlier, but they came back through
> Sasha's autosel.  There's another build error with another coresight
> patch in there too, looks rare enough that your scripts didn't catch it
> :)
>
> I'll go push out a -rc2 now with the offending patches dropped.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.209-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 0dd28c11952d3a45280706afe87a14db95f8cf21
git describe: v4.9.208-90-g0dd28c11952d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.208-90-g0dd28c11952d

No regressions (compared to build v4.9.208)

No fixes (compared to build v4.9.208)

Ran 21877 total tests in the following environments and test suites.

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
* linux-log-parser
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
