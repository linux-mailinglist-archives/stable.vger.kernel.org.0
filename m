Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8209A3346AE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhCJS1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233135AbhCJS1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 13:27:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6C764F9A;
        Wed, 10 Mar 2021 18:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615400833;
        bh=+2nbPlTJJf3vPrbkAUDpHL3B4YKAYPtUuxmWJYVRjBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JEHrVNAHhgP+GS3saXgERsLVJYmmO+TPFE+cdAkpsnAVgB6XSs3O+oBVjNcWeFUrR
         TQTBev6+9Z1abfqIM3VdtJ001mn4CxXwNkK2XFTg76S8RACEv119hNSokPXMlLz8iZ
         Y3FBcD6YxAnyj/HJwc3mZvUU5fiDjfeJ7eYtqHwg=
Date:   Wed, 10 Mar 2021 19:27:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 00/49] 5.10.23-rc1 review
Message-ID: <YEkPf9e8uSLz7wtB@kroah.com>
References: <20210310132321.948258062@linuxfoundation.org>
 <CA+G9fYuydf-g2FPOtP9LAX-4zY3EF64Bx0OQjbjn=a4V+0=eLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuydf-g2FPOtP9LAX-4zY3EF64Bx0OQjbjn=a4V+0=eLA@mail.gmail.com>
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

Offending patch dropped, thanks.

greg k-h
