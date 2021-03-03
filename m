Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68C732C824
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355622AbhCDAea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhCCQNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 11:13:52 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E596C061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 08:12:35 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id c10so16770698ejx.9
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 08:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hdbGvE7OxH1ozlVSe6sun/EFAVtFiv+mLa//hBpREOQ=;
        b=kEDT0UAfgVm1B7FGc2AiSdBCh4aRsxqSIkFqm/q8SkddfZ9jE1SFBumnYCN2bKQjG6
         znPUqE7thSf+gXicrhsEFJv4eecwi/Hi1k7OWInF/gQsYl6T58a/GEDgBuIRCjAVDyhG
         dkD1HdAQWO8gDCrOu7vpjJmVp2cMJsSlCVvktbpFndQBLdq/2rOElNj6p5k1rBruFduq
         6qKe+tLcP3iIxtn0dXVutxXz2KnmVHjQDl5kBWLNXyUvBu4aOWMdq9jQT58t1RVEGQDs
         BbW7bdTy8GPQz/Af3i916SDzttOkxOKE8RPYYghmhX5D9RvaKu0aeMs+2ttQgtet6enk
         nFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hdbGvE7OxH1ozlVSe6sun/EFAVtFiv+mLa//hBpREOQ=;
        b=OAFmBlnjWR9+7B5BunE8ngv2Ozgre05Dt/0TSM9ITXVeGhp1GAp2IIaM1G3j3KYuf4
         DOa8O8djbKEMFyi2iJ3jt6scW4lmVpU/LC6N0dGaaVw3StgYbqUjOdLNaGW5DEJ57lOG
         ruOh/Thf46ChW5GdLHmFpHUb6CTsfyFNv///0igAazs8qf8BT7f4TBcA0t/wp/j9l1yB
         o/NBi89c9eKGfFO7MprTKK84V96f7i0sr3HoKbNCNGeHQy083alho7a1wx7AW1HzLclV
         BGa5Ae/8o4LDNqVJPxP2r0xOdKRnc0cJucq0BfoGPzUDt8EHjy44shhr1zokvbO8wjof
         p+lw==
X-Gm-Message-State: AOAM532WTzBZ2ZlQjKvA59HoQBkpE1IzXIiOpPGktqSJ0lRtE0U9Fhue
        EqsLkonhrbse4D9IMJvPhlzswTRBKGzvPJwukggPpg==
X-Google-Smtp-Source: ABdhPJy6rAOgoMw/i73rHFickgZDyRhv0OZu+fM32yUkz8wO4itbfzFAefn69stUaxRvhGLVYDibW5qDfLnieYVeDow=
X-Received: by 2002:a17:906:b2c3:: with SMTP id cf3mr25576820ejb.133.1614787953836;
 Wed, 03 Mar 2021 08:12:33 -0800 (PST)
MIME-Version: 1.0
References: <20210302192700.399054668@linuxfoundation.org>
In-Reply-To: <20210302192700.399054668@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Mar 2021 21:42:20 +0530
Message-ID: <CA+G9fYsA7U7rzd=yGYQ=uWViY3_dXc4iY_pC-DM1K3R+gac19g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 657 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.20-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
All our builds are getting PASS now.
But,
Regressions detected on all devices (arm64, arm, x86_64 and i386).
LTP pty test case hangup01 failed on all devices

hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

This failure is specific to stable-rc v5.10.20-rc4 and v5.11.3-rc3
Test PASS on the v5.12-rc1 mainline and Linux next kernel.

Following two commits caused this test failure,

   Linus Torvalds <torvalds@linux-foundation.org>
       tty: implement read_iter

   Linus Torvalds <torvalds@linux-foundation.org>
       tty: convert tty_ldisc_ops 'read()' function to take a kernel pointe=
r

Test case failed link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.19-658-g083cbba104d9/testrun/4068229/suite/ltp-pty-tests/test/hangup01/log


--
Linaro LKFT
https://lkft.linaro.org
