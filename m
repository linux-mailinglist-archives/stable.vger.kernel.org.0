Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A28C32AED2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhCCAGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376305AbhCBHQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 02:16:50 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F61C061797
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 23:16:09 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hs11so33245715ejc.1
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 23:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dhQ/p75iCVhXBur2ISu19bCShY4YhNyufyyRn+NVer8=;
        b=np7mVVDgFoC//buHBjMD6mjKSLoEMzDr9XlMeQLyxONxiMzk0qpLpB4ugocDonMTO6
         JzpD9jU0RO40wY5209HANQdSSyP2MdNCqDiwvJp4kqdLQxIk8IjUW4jpMGG88KcliNR9
         3tfzLfXQ14Efwl6Wnq1yawlBKFIJI0HlECw0ctBgv9rGiCWI1Eyqrh8WTLZWP7gIg9QG
         HnceW1Iex3XYzx5UVBciU4u5ou7iaQx3Zt0Akc+RDe2MEvYZ4xCvkE0wkMN9yJ4jX0Pk
         X9qW9Y9ysEUq+p03g5CS5OmDSHrU7w6G1Q6fEnzWsKkw4T6YpwzzJbHpfpxrd8Yu2TjU
         CbwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dhQ/p75iCVhXBur2ISu19bCShY4YhNyufyyRn+NVer8=;
        b=sZrfvxOq1+1PH1pJpM7qyfe4zxr22y9UFkx6+rAJYRxVtra7STLWBCGCn9RIYiSJzR
         +SBDji7Sth87Tm9K+pNl7pLwPXrGMIlmPLVjgQ3izWaZEpze/k4DYT1scr5ZhepVrWIP
         eE86tS76mr08H4uMlgICkR6ojwD9D5Tf9ocTWAR/ps3EPw1LmjHiBITS9SQpYWxT2k5Q
         +Fa6g7DdN7opd5WegvH+/AHiUgXdrogzAL9ILDrRVwQmugpXuq49YddDzdhMWbV7shcM
         D0QhlioVzYUq3WkOoX2pkz5vl8ebLnOgbMqqMiXQTD4Rsf7O7jOk+oxNPOa0kTq5TDmQ
         Fnqg==
X-Gm-Message-State: AOAM530udjoM1Vq4GMtlE9o5LzVdme1tsVrCiz7io2hnKpvQVpW0VCFD
        ENFrhVDdo9X/pUBov7gdywlSHKM8/9rhdB5BG2nyRA==
X-Google-Smtp-Source: ABdhPJyVxmsihpy1kqY+kqI95RR2JeFZi+7jFFVwsJ1WASqnYtD7E6XB1O6s0LzMWjFVen/J3v9lOeEqeY4wZGVfrBw=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr19675329ejo.247.1614669367668;
 Mon, 01 Mar 2021 23:16:07 -0800 (PST)
MIME-Version: 1.0
References: <20210301193642.707301430@linuxfoundation.org>
In-Reply-To: <20210301193642.707301430@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 12:45:55 +0530
Message-ID: <CA+G9fYuK0k0FsnSk4egKOO=B0pV80bjp+f5E-0xPOfbPugQPxg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
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

On Tue, 2 Mar 2021 at 01:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 661 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.20-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions detected on all devices (arm64, arm, x86_64 and i386).

hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3

This failure is specific to stable-rc 5.10 and 5.11.
Test PASS on mainline and Linux next kernel.

Summary
------------------------------------------------------------------------

kernel: 5.10.20-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 92929e15cdc088938051b73538d9d4d60844f9d4
git describe: v5.10.19-662-g92929e15cdc0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.19-662-g92929e15cdc0

Regressions (compared to build v5.10.19)
------------------------------------------------------------------------

  ltp-pty-tests:
    * hangup01

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--=20
Linaro LKFT
https://lkft.linaro.org
