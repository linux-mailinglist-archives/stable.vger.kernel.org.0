Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBA762DF0
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 04:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfGICLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 22:11:02 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40126 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfGICLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 22:11:02 -0400
Received: by mail-lf1-f66.google.com with SMTP id b17so8653119lff.7
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 19:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b2d61h/e8K7gOexBQzZ4oZE/XD/sRT3CTsvG5+H3A4Q=;
        b=Az8wDUbxlJdsuRoTLXS8WpGGYc5jVO+MA1eR/qCcI5Mq8AhJqHP35faax/F5lL1Odb
         bc/gcnb2WCIDMS0dF1vKT7pAXmPdkZ8wGfuyXw4ipLbUsprXxY4J3+k2AWCsAbkpfYkf
         slwrauPARr48uLoKMmsABzbBSJCcvgFN6Ga7ytTObRW8nTBuYvCdQnS/wpO8oqzk5sxM
         ZafCsFj1mg822AhxmBfU9Ji0DAMMgTPz4eEMlr4A94bnMO5oiq1hmVLTdjl33DzwUFAO
         CJMKhYYxhBfWvhQIs2lyIPVVR8SrSPfqLPoZRGeK2rW0y5nGojy+NJK8yraVkfKw6iU2
         b8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b2d61h/e8K7gOexBQzZ4oZE/XD/sRT3CTsvG5+H3A4Q=;
        b=FjJQLj62FH5CnU+EeDjJ0D69VlZIYjTSXwRUvhYkQWtb75l3glKsJPnNHlfNSNN0sZ
         BkS51snri6xPx2mX+t5D/2OcGQo/BzmH3qWWSfh0i41w7MDWn3ER90X4zDsTZOiMINiX
         QrIcW77Jzi4fQDVTISSHS2eURi4VCacP8KDcMOLJWO4VJ9E/7l2lmhdytSVFKsCUAmwM
         /SAJYfqlHI/PDrcPCWyMt/W+lol3SaLt2LWSoOZcsYzbW5p+bGJPOqfw19OMLDVwNUHN
         73Albasj3wmzzZY338yPMSgT9mvf5lZmHTBYmSJfy/jNkbAIzeOXqVdxBVp6WZ06/bYv
         kTEQ==
X-Gm-Message-State: APjAAAVqw31wswxwoTuCEO157FOW6QgtruS4is4yogYMtZq5wplemADM
        WQlwdOGwZlppmJuDD/e6Gv1WUljA12HiTJ6eQwAyuQ==
X-Google-Smtp-Source: APXvYqyEXn5Zj5tRUTNMBjRTanMF9aoy0uQ9svpDftElzBhGVu2a8UNMWA9QdZkDQjIELvV07tM+mUdIrOEmWBXmb08=
X-Received: by 2002:a19:ed0c:: with SMTP id y12mr9946172lfy.191.1562638260033;
 Mon, 08 Jul 2019 19:11:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190708150525.973820964@linuxfoundation.org>
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Jul 2019 07:40:48 +0530
Message-ID: <CA+G9fYuRfaWnZ4x5PO6fPj9-8wQZkco-imJD8HGT35ePvAXqMA@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/102] 4.9.185-stable review
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

On Mon, 8 Jul 2019 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.185 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.185-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.185-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: bb7044a09b6bd0f3b0a78afd25a4eb42ca85f50d
git describe: v4.9.184-103-gbb7044a09b6b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.184-103-gbb7044a09b6b


No regressions (compared to build v4.9.184)

No fixes (compared to build v4.9.184)


Ran 23371 total tests in the following environments and test suites.

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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
