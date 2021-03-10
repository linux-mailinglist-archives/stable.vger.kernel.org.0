Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6777334611
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhCJR6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 12:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbhCJR6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 12:58:38 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41169C061760;
        Wed, 10 Mar 2021 09:58:38 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id y131so17175814oia.8;
        Wed, 10 Mar 2021 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qkwa8H4HYdOM0e9yyfRDovBxJoNbMnvqE7j9wsTAbgU=;
        b=VpSyEHAVHGH52gKKUFr0MYvtt6ou0/uJHn97MZVoHKP1+OT8WHgsYnV68zSFvWOjnH
         0c9pN0igajg3Ryw7OAQqWtXBBJCwzKsUnxtnr9mLa3RW5EhY1ld9J8s37drZv9ojzFLV
         wtnchP6Ea5lYJH3iFaq0tD9kEnwRm7PRoYwqyJnuxhat7kvEcUKa0e52CiprUjH6f+DI
         u5TecbZ0vTi7dmDbhX0dg8OJvXLT9ucy8fkoJrBLQ2ltPk5nAsZRkTgE3sGkzzSr3Y6B
         ARyYGafGrsrkF2yvupDjdgoZolcGfSun2QJKCCmCZkIiuiUCu+ejA/TJj9Kksd60JeB/
         3QaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qkwa8H4HYdOM0e9yyfRDovBxJoNbMnvqE7j9wsTAbgU=;
        b=AZ6yUlGjOhBmFgNusV2eIRV+aMOEXhfcN7yM4JsZe48OemSiWUYsrfMHp2ejC4f+Wx
         qgtr4GlYRy/muwQAJxPog+VdIa2S7WxELwmoR5Psi/Q9YAMNEwJi+82fqtaIkXUw3yoj
         B6K/YCzArA7EJBzVSd/rpc9tTXVRyTHsi+6jHawrBZkqf2Hmmi3PLaGp7ByOUh0hAtw7
         qEVd4vUxfb4utJkURq9BGlmFfMHS1TUgpIF4rCYuQPcvKTuVHp4AvWMJwByKQ1SmTS/x
         Jlu2sC66zVCKczqswEMKtHU7V5oslbGXoJkep58gm9RBRbH3lh1Ka55EsQ8cIVViLUn6
         4TUw==
X-Gm-Message-State: AOAM531aJ7hPcCvMixOc1zNm/2z2uT/HXq6q3oLPvz8RymsUi3auBGUJ
        E+VmBqIJ+8sooPbnybzxlQs=
X-Google-Smtp-Source: ABdhPJxLuOU86ieJeoLsiEyhpG6yGHdOzv10X15L8V0aaHE45sA2VQ5nyfeKNwhLEiIEguPY+kJLYw==
X-Received: by 2002:aca:4e8e:: with SMTP id c136mr3263201oib.97.1615399117350;
        Wed, 10 Mar 2021 09:58:37 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 1sm72487otr.53.2021.03.10.09.58.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 09:58:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 09:58:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 00/49] 5.10.23-rc1 review
Message-ID: <20210310175834.GA257774@roeck-us.net>
References: <20210310132321.948258062@linuxfoundation.org>
 <CA+G9fYuydf-g2FPOtP9LAX-4zY3EF64Bx0OQjbjn=a4V+0=eLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuydf-g2FPOtP9LAX-4zY3EF64Bx0OQjbjn=a4V+0=eLA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:08:10PM +0530, Naresh Kamboju wrote:
> On Wed, 10 Mar 2021 at 18:54, <gregkh@linuxfoundation.org> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This is the start of the stable review cycle for the 5.10.23 release.
> > There are 49 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> While building stable rc 5.10 for arm64 the build failed due to
> the following errors / warnings.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> drivers/net/ipa/gsi.c:1074:7: error: use of undeclared identifier
> 'GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL'
>         case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
>              ^
> 1 error generated.
> make[4]: *** [scripts/Makefile.build:279: drivers/net/ipa/gsi.o] Error 1
> 
Also:

Building arm64:allmodconfig ... failed
--------------
Error log:
sound/soc/intel/boards/sof_rt5682.c:117:6: error: 'SOF_RT1015_SPEAKER_AMP_100FS' undeclared here

Guenter
