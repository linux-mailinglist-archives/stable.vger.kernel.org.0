Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14D311357F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 20:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfLDTL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 14:11:58 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43395 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfLDTL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 14:11:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id 9so417591lfq.10
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 11:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JYuqMASZpiTe5nuiGY93MH6O0/HdXIaFU15wVqM7e9k=;
        b=D1JWQWqNFljOCLqlZW2gu9wWPuOlND9c9MnAhvPP3jVIFgam6A39PXzihi8Qt4VTqm
         hTeuKHG81pakLfV7aqlfciEBXe+6dAcFC8VoTOmzBMXQs/LtT/J3CJwxuSifLa3oaw+x
         pB3w9G5bQQWuxY8rARr8pNP8mqx+REMLTQ+8QSU5OtyJPolDrG7f2VHVoMmZpJ5aG9I6
         OnufAoPZpyhc860plE3xH0M5g/Ew/zpoaAadgonQOFHgE3vP2J6CGrJdCdMk7d4V68x+
         K+SeACmxrIwenNfvHI0oz0jqBnp0UEuj/J2BvDtntY6E0WSAzJVwxeadvdC19gmlzq71
         pj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JYuqMASZpiTe5nuiGY93MH6O0/HdXIaFU15wVqM7e9k=;
        b=bDmG0iY8mqmJ+icIQOHBZS73+QLCOF9Fh68LuYgKuE9Yi/v/1aUz7YREPmOeQTeJ8g
         p+e7khqKUG1ic3xHBq8ffxk0JUNYsMNsj2MXulD3AOxcticdu3RohFyqXinVSt4+Jrkk
         k7xda9Gzz7rUwB4chGEgwF8SjvePT76tXmBLh9fJ68bS1x82tQs5vlR04/ovC7DN6QRM
         ZDlIp/M22vsyDAYiytd7dMzNyhkV5RTk/zcNMfcEUkrzliNU4IUzXLcKlnTdWJC7GEgv
         Flnej52UzY4jC/Tp0S+TvnIVgVwBnKsp6gy7/nmCKqxR1UGjqTjGnJLSDFsGhRcZR6Et
         NyNg==
X-Gm-Message-State: APjAAAVYP2tupwAHWkKSFQIj6VOOmW8512FWt+vFyLGIyqhubvTAUE0w
        XsHpLU8wvNA/QlVtfAVHQBySnQ+EFtJVIqKt4lSqqhF5k5Q=
X-Google-Smtp-Source: APXvYqw9yp5+BS+JOuXjIZQucnuG7GqzCi20RPTauPFIxq2vEXvlXKZihUVuZuEM4l35uFfuGxig6bYiTWk4oeHdWjg=
X-Received: by 2002:a19:5057:: with SMTP id z23mr3018046lfj.132.1575486713192;
 Wed, 04 Dec 2019 11:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20191203223427.103571230@linuxfoundation.org> <79c636e7-145b-3062-04a3-f03c78d51318@nvidia.com>
 <20191204112936.GA3565947@kroah.com>
In-Reply-To: <20191204112936.GA3565947@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Dec 2019 00:41:41 +0530
Message-ID: <CA+G9fYtba3Hhd7QikcWSEjYK0mwGBNuaXctnO5f1COsRP7qkSw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/321] 4.19.88-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Thanks for letting me know, I'll go drop this one and push out a -rc2
> with that removed.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.88-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: ba731ec12c667db0f1f85e4bfe11387587feb243
git describe: v4.19.87-322-gba731ec12c66
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.87-322-gba731ec12c66


No regressions (compared to build v4.19.87)

No fixes (compared to build v4.19.87)

Ran 21276 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-commands-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
