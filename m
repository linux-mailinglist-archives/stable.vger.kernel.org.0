Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA722A1C80
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 08:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgKAHE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 02:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgKAHE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 02:04:56 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B472BC0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 00:04:55 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t11so10836554edj.13
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 00:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FhEY5xf3E+aW2yCGV8SL4Wn8WcDv8DyQUUrSCoTvQic=;
        b=tBk5o58fI/RgVowcC/WnLBizxhTkfQK71COkcedg81q5jTYfWCkM/9NOtJtgRjMx4u
         rJMpCRXTaMc6CzD5SsvObnOqLrWbZmOyILoS3zAWHHmdBF5n5Wh8u6zueBsg5Uzkg0UL
         9LfqUg5UNyDw9EoD1uxVvpOhCbXeTI0/S3wUW0G2IV+jGL51AJAlN5hbCW+PRQYHaHuw
         QyuC4KQEjBIwHMnec+j9Qxx6EWlLHcftY4gV3TvQvXn64zCxPL3oagFQZ4RZIyaxoMe8
         KZomw3kdcuRKJzuSmldAA7F/7Ja+Zu877HuW68+5u1VTonaaCr/j2XnDy/ibSpmQ2wS1
         gn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FhEY5xf3E+aW2yCGV8SL4Wn8WcDv8DyQUUrSCoTvQic=;
        b=RF2rGFV8hiDM/ZP+cpG6/S1ZNydcKACvSfXyy9oOW1D8Fj2/a1BvWb2otUazjIZ2Rm
         xyPKI5BzfivjFgvXA+wK3HN8G5tcQAAHrFbk/pduNqoXrTuxksgqQRkLt5CCCkRIgHMK
         xZcV3zRQ4R/mvbJxlmsp3TN5Y+pDHSRpkOhCnbsz173XtM2Shz7YtwF03Iw5FV1pT6UH
         j/Ef2bHN8PJ2jcwxTYxUuFpxbyKtGB/rV5kntwDWiSsLoWrh9zw0JZc/rfhd4QDOGlXX
         IJ4QPEzYITXBVHl96n9iQRzh8XUBJt9VaKYsR6grqZPkIov/J6c17Fm2bsllN7jEpzhu
         lpSg==
X-Gm-Message-State: AOAM531beI9blJ8Zg5xKRVW7pqI3ff9XkjRw9rPM7qU17zNKlGwy+aG3
        zJJnOauSUhntVAw4o1H/4PjuOAReUje1bZeQK1CBmA==
X-Google-Smtp-Source: ABdhPJynmej9nQmQpBCToQImgdYv/KcAPb5cD+mw+03564+9kS+eWrzYzkMmvOcg1KajXMH9+WTjTfDWM+L/LvccZZU=
X-Received: by 2002:aa7:c2d7:: with SMTP id m23mr10910678edp.230.1604214294256;
 Sun, 01 Nov 2020 00:04:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201031113500.031279088@linuxfoundation.org>
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 1 Nov 2020 12:34:42 +0530
Message-ID: <CA+G9fYshNJgQFZ_oxb4VgSbe2xWym9am6ajpr-SVH_bw4psa1Q@mail.gmail.com>
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 31 Oct 2020 at 17:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.3 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
LTP version upgrade to 20200930. Due to this change we have noticed few tes=
t
failures and fixes which are not related to kernel changes.

Summary
------------------------------------------------------------------------

kernel: 5.9.3-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: dae2c902d0480f9e51891768862f034ee97f4db1
git describe: v5.9.2-75-gdae2c902d048
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.2-75-gdae2c902d048

No regressions (compared to build v5.9.2)

No fixes (compared to build v5.9.2)

Fixes (compared to LTP 20200515)
These fixes are coming from LTP upgrade 20200930.
  ltp-commands-tests:
    * logrotate_sh

  ltp-containers-tests:
    * netns_netlink

  ltp-controllers-tests:
    * cpuset_hotplug

  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805
    * cve-2018-1000199

  ltp-syscalls-tests:
    * clock_gettime03
    * clone302
    * copy_file_range02
    * mknod07
    * ptrace08
    * syslog01
    * syslog02
    * syslog03
    * syslog04
    * syslog05
    * syslog07
    * syslog08
    * syslog09
    * syslog10

  ltp-open-posix-tests:
    * clocks_invaliddates

--=20
Linaro LKFT
https://lkft.linaro.org
