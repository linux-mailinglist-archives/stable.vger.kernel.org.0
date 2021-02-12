Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6041C319AB9
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 08:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBLHnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 02:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhBLHmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 02:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC8FC64DE2;
        Fri, 12 Feb 2021 07:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613115722;
        bh=hyrGObWesCGH0zWreiF+hEnrketEdVfxj5+Ju1D1YgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ak8q+OS0fQs46vQe8C5uI0VZZWNPAmJ7l1ehMDUnEfedwSVWI4Ae8M24xxH65iA47
         ffDGY3TuhMfU6ELAcwjHw/IMgu81YXKw/1jjIFctTiNuBs/hDZeobvv6lbhqtVmw0D
         uK2+oCKEv8sg6Ot+nOYIduIZI8YvKxnM8ZtwrVn4=
Date:   Fri, 12 Feb 2021 08:42:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 00/24] 4.19.176-rc1 review
Message-ID: <YCYxSEwzNGfMoLbb@kroah.com>
References: <20210211150147.743660073@linuxfoundation.org>
 <CA+G9fYugE5n1qsudwP7XntBvvNcEquxQkMEskWvxJAZdZX5Fng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYugE5n1qsudwP7XntBvvNcEquxQkMEskWvxJAZdZX5Fng@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 10:16:11AM +0530, Naresh Kamboju wrote:
> On Thu, 11 Feb 2021 at 20:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.176 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following lockdep noticed on the arm beaglebone x15 device.
> I have not bisected this problem yet.
> Suspecting this patch,
> 
> > David Collins <collinsd@codeaurora.org>
> >     regulator: core: avoid regulator_resolve_supply() race condition

Sasha queued up a fix for this, let me push out a -rc2 with that in
there to see if this resolves the issue.

thanks

greg k-h
