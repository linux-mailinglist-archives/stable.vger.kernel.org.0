Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF185349191
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCYMII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230448AbhCYMHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:07:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D04F61A1B;
        Thu, 25 Mar 2021 12:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674064;
        bh=UH4puTxbvB+4BT+zh4XWHTT/BThBOlyUMtU73ZiL4gk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ot5OJlwcvTkO2Cdpuojq36XJXnVf+X7CpBvWV45XbRKKQnisedSfyws/qod0/4Lf8
         AYt9VSm47ogddl9UL4jNdQpSpvoucVFpsQOBYAw1xnrre/iaVT1n7BM7yco6ApnZSd
         plyVqiZvHi0pLXWeDMAUiHz8MzLEuIl5laM4MDyA=
Date:   Thu, 25 Mar 2021 13:07:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <YFx9Dp0H0sVoRr+i@kroah.com>
References: <20210324093435.962321672@linuxfoundation.org>
 <CA+G9fYvYrY=FgN5gZYkTvwGfG++_GBJ7u+BWNjmp90kxtmKO-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvYrY=FgN5gZYkTvwGfG++_GBJ7u+BWNjmp90kxtmKO-w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 11:24:09PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Mar 2021 at 15:10, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for the quick turn-around and for finding the regression.

greg k-h
