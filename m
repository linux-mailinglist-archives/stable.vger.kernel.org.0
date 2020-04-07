Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F041A0EA6
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 15:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgDGNvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 09:51:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35198 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgDGNvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 09:51:32 -0400
Received: by mail-lf1-f68.google.com with SMTP id r17so2448944lff.2
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0ZDRUt3eOgGiaKX8/LhaubmvfH76uWvW+ZDm0Jnzfuw=;
        b=OzzFlv8dJTtxOJq1DDp9Cu2oRQ/u+vPgLaEttIDiFFYQazpja60LVy7GcKOJtN9KVe
         SmrXMtt829rBJtRwFrp3Yo/+7RFQEeIsDt98Pmf/rpjoto8Yv7lsBFoxnYGCa98+NA8q
         vcTQB0ObNwY4RiV5U4m7tH0TtQHdzuWrcRBBbqWhX6KrJXbHlAl9cgLshL54vG20Zd8b
         xV/iK/LsadsjL6dqgJO0i1xsWjf6hDsX9JxtfL1vROqP1Fj2QqnyOox+badK8fshoKKK
         jVzjW2XeWQmn7RuiROOwFLeCkOdpW89f63oXCNGJf5D5PkaR1508DuCtwpSz1unPHN6+
         K5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0ZDRUt3eOgGiaKX8/LhaubmvfH76uWvW+ZDm0Jnzfuw=;
        b=rnXdO1Xr907kozygN3rfuEUj/oiBunTVd9uT+tmqGBxho7tTFI8gCE9A+egcwar44R
         LXJLGR7Fj7qqTFtXNlEqYa3XAOxwZxySk0LRtHEYC8KfqFGSt4x8BreUP7sh+bpI3z8x
         2MJK/NnoOz0FQScAl8gYCnpsmRR52m+11VWWa7QXnWER7n5N7vD5R9GjuTCcLg3TgP2E
         2aai49EPuG2QyX6BjOY9pfWRURD1odbCyNdbIxW/a0G1OpdslR+IJnU0FLvvIhLV3BI5
         FoDXIA/Ot/yzZsAR0bv3gVkDJ2XMG/gPbQtKW+IFqHsOHFjhRMoaU1qpQBrE2PeAc/3L
         WQPg==
X-Gm-Message-State: AGi0PuY+9IZY+zKjMIJN2CfLQMoDG03dqHd9sRFp9U4lq9Sr1B0PxMwS
        1SSQeYRrC8aBcOTv9qembPb95xB1yBIcHdu144RxHw==
X-Google-Smtp-Source: APiQypJwDVqCmyA8mC9IcT6X63VEZpPEFfsRPRlDBmqddx+8Lh4NnRodBiV0OnC173NkLm76vKQtFva8Cl1/9fUSaFM=
X-Received: by 2002:a05:6512:1109:: with SMTP id l9mr1632108lfg.50.1586267488223;
 Tue, 07 Apr 2020 06:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200407101452.046058399@linuxfoundation.org>
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Tue, 7 Apr 2020 08:51:15 -0500
Message-ID: <CAEUSe7_Je2e_ExLnnwj-SLtSqLyoAPTXqS_WO8yiHneMh46qfw@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/29] 5.6.3-rc1 review
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

Hello!

On Tue, 7 Apr 2020 at 05:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.3 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Apr 2020 10:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Perf still fails to build. Can be fixed by picking up 9ff76cea4e9e
("perf python: Fix clang detection to strip out options passed in
$CC").

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
