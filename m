Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745B7319D05
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 12:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhBLLDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 06:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhBLLBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 06:01:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9891064E2D;
        Fri, 12 Feb 2021 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613127631;
        bh=3nPRC+ND9/9I8Az5Z7YnekOr5QE2Gffe2cr+3+V+hyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=srKt5aZcErucLcNYEOI2Z1/CzOOeBJ9gX3BGupBhK/lkeqWv9v8b1vNPW8B+NEbwR
         j4e2Czl8O9BVgEOijcGDCU/yeYr5WU9N7UBtE9qyNu1dPA0zLd3jpZPgAQvYZBp+bf
         PZdI6Zsnq7pHagFdTitlCTHElgZTU0o5XdmVwIfw=
Date:   Fri, 12 Feb 2021 12:00:28 +0100
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
Message-ID: <YCZfzGnRw1wGLxXA@kroah.com>
References: <20210211150147.743660073@linuxfoundation.org>
 <CA+G9fYugE5n1qsudwP7XntBvvNcEquxQkMEskWvxJAZdZX5Fng@mail.gmail.com>
 <YCYxSEwzNGfMoLbb@kroah.com>
 <CA+G9fYugMr_Qat6KJ2-HeF_qMBYtcYXx2EEMZqQ6a8AavEFPTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYugMr_Qat6KJ2-HeF_qMBYtcYXx2EEMZqQ6a8AavEFPTQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 03:59:41PM +0530, Naresh Kamboju wrote:
> On Fri, 12 Feb 2021 at 13:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 12, 2021 at 10:16:11AM +0530, Naresh Kamboju wrote:
> > > On Thu, 11 Feb 2021 at 20:36, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 4.19.176 release.
> > > > There are 24 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > The following lockdep noticed on the arm beaglebone x15 device.
> > > I have not bisected this problem yet.
> > > Suspecting this patch,
> > >
> > > > David Collins <collinsd@codeaurora.org>
> > > >     regulator: core: avoid regulator_resolve_supply() race condition
> >
> > Sasha queued up a fix for this, let me push out a -rc2 with that in
> > there to see if this resolves the issue.
> 
> The reported issue is fixed on 4.19.176-rc2.

Wonderful, thanks for letting me know.

greg k-h
