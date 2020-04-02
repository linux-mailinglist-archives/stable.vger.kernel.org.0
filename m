Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA819BE6B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 11:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgDBJLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 05:11:24 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40344 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgDBJLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 05:11:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id 19so2404517ljj.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 02:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3PwxcnGrVHgA3azoN8MVPbIA1AIZGKEAl5hTNkNmtdE=;
        b=EU0dvGg2lZnWelRL82j4D5McrzfKBqPjmUYDwOXZ96rdvCqKKCR7QXuEyyoIiv958I
         W8cVTsUo1PxAo7FF0P5tmUu9uDpeDAOChvJC8YkVx+yUHFav7p3d9WKnxWZKnGJYi2oF
         c7hWos3Z0fTq4gb7xRRe4d8QoqfjuCCl5FmI0u8e/UGqgelA/wojtJJ6MnzqNlcjyXtu
         3dupm9X+6KM9Z6WXAlwQ3rIkJKX7I5YuMcO6Mrv3UeSviVBrxxl/OjqXly5pyZi1jxJ1
         FBY4dn8QwJirvGhikesXJvZvCq/njG3QYuBRm6zOfNenl+YSlvIAT9ekkQWyeIA/IdXM
         fgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3PwxcnGrVHgA3azoN8MVPbIA1AIZGKEAl5hTNkNmtdE=;
        b=PdztfMAymgIu9W9KqOh6lUqNBPeKr9clHZbEXc9oi0sEUOSOAy7Qjy/E1kvZzvxKuo
         BC/2hBA9l/ND84z4hvFZYFUc+XODLnDdSu5JplX/jne25JHTHehJB71zVti9kwanOd83
         7fHJvJxGesWgH8cOP6Kv1PEXM03+tKxqE1BupSOz0cPSRdt2A8DBaZtzAOB04AQlXVP5
         HUiVvHMQuP9LtjX4t8aDZVC++OGc91pPYHrnPh4thjwNM1m/hWB4EEsmwJQqt2S0WfHa
         1D2x3nw2jwUyEtvVcq5GatLMabeW0tSH7lXez9mz5YlyOkneZktRCkQFbuqu1u/QA88u
         +AKA==
X-Gm-Message-State: AGi0PuYiyS1bwFTnShMjPnDU8aUbLpvAfM/GDJzzVPk3LO6XRFA47jSr
        9IbgHAiaaG76XXUXCfVtmiWh38tnFDe3VbXUgphTog==
X-Google-Smtp-Source: APiQypInMYGkZt44+vO+N1eZeaUglZNmnhURDbRWCG71RL0MP7+Qat4xQnKy82bgpuDDLZQyrqWIFhwPahUBIhDtZ2k=
X-Received: by 2002:a2e:b52f:: with SMTP id z15mr1442065ljm.38.1585818681469;
 Thu, 02 Apr 2020 02:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200401161414.352722470@linuxfoundation.org>
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Apr 2020 14:41:10 +0530
Message-ID: <CA+G9fYvW=nJ1+=SLeTjL9+YEyfjsQ3xeK4vteKKAxpDAzN6JYA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/27] 5.4.30-rc1 review
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

On Wed, 1 Apr 2020 at 21:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.30 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.30-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.30-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: c1d6c1dff8f20567448ba39841abfe8be3037995
git describe: v5.4.29-28-gc1d6c1dff8f2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.29-28-gc1d6c1dff8f2

No regressions (compared to build v5.4.29)

No fixes (compared to build v5.4.29)

Ran 31379 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* ltp-commands-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
