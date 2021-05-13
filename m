Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5710737F40C
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 10:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhEMIbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 04:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhEMIbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 04:31:42 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F567C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 01:30:28 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a25so5953421edr.12
        for <stable@vger.kernel.org>; Thu, 13 May 2021 01:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zRdMo99sBcPVkYh7kqt4rJWFtQ+AE7arsx+IsmBxYQ=;
        b=zzy81YRwLvqZzgj+GAVRg7gO7gSxcD6vZz0p9y37lkWqy9qXdwmV2pXxf7Ci2oOSyT
         iaeFMFenS29V5u125YVd/ikqaYxnj1qrm33lc52I/iNXygB1dEjBHYt+GpkG6Q6nlkZg
         RLfJbcZxdcSumd/o/QfTbr8K9Z3ymxC2J8vquVgceZPODfj7x5bT8p9FNYn1gc6jsD5d
         pGxcbIwNCJVLAbAbQCjamkI9AfOAW33pCLGyYQTFbtl3k4Ei/sWyz+X8wB6fJ/JpGu7Y
         X4onwMc884oaT2zssEUMFi3zNS6v/oDCIVlRnAqqj8ABXL2KCA753oou9NUMsN8J3Ahw
         vOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zRdMo99sBcPVkYh7kqt4rJWFtQ+AE7arsx+IsmBxYQ=;
        b=MO8NQPKUsCK3jBG5Q0fzGznwUsn2ZpNIza7ZN0Kdzw5Qhx+6bLtvDzIZNVqr/ro9E1
         zzW3AEPH3/Wh722R6Cn03u1WH4OH+rJBMAUbevfOYSfjD6zHS5+N9nlnw0izCs2x0b0U
         VVeu0vFV3asSiTRjarEuZ7uIzT2pXn2dZZYIMFaB4G5jQgy8sFBoahQiIRqtUuvJa4xZ
         ogPi73/K1rcaND0Rkzqg5DYZF2orPh3BmWNwVbXCGIbjjP4AyVpmu2jPXVUFwl6V4WoV
         Sl9SXiLOwVeuo2TRBgod4GY6pE7N9ukKIi0/l9KQKiJm8FtWGeWRGi8t83pfFdPv14sM
         fX7w==
X-Gm-Message-State: AOAM532ZyQWjYCAT+5e+kD/XVzgsBnrYbq0ya2Dbw9/cVa7wVwUXtpQn
        hAuqYGRQJhpd0Zk4NMhez5h7OZCNGq0gc3c6LoZZqycJ1LGQGA==
X-Google-Smtp-Source: ABdhPJwGeFX8pHSgnM7O78q4lR707KbYHSCGE+AlKfh5wKAsFR1Tk5ifzZsnGo+0qfgu0fGg5RRVaLsYQZ4/zIeI5Yk=
X-Received: by 2002:aa7:c6ca:: with SMTP id b10mr33639738eds.221.1620894626895;
 Thu, 13 May 2021 01:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144837.204217980@linuxfoundation.org> <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
 <YJwW2bNXGZw5kmpo@kroah.com> <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com>
 <YJwjuJrYiyS/eeR8@kroah.com> <8615959b-9054-5c9f-0afa-f15672274d12@kernel.org>
In-Reply-To: <8615959b-9054-5c9f-0afa-f15672274d12@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 May 2021 14:00:15 +0530
Message-ID: <CA+G9fYuR0OwYG1fmbro2N4FOk-nw61BJHQmd-B7Jbg+mDhsSAg@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
To:     Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I think you just need to grab commits c1d337d45ec0 ("MIPS: Avoid DIVU in
> `__div64_32' is result would be zero") and 25ab14cbe9d1 ("MIPS: Avoid
> handcoded DIVU in `__div64_32' altogether") to fix this up.

I have cherry-picked these two patches on stable-rc 5.4, 5.10, 5.11 and 5.12
and the MIPS clang builds PASS.

- Naresh
