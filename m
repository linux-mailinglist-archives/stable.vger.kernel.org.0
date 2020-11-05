Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C5B2A7C41
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 11:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKEKw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 05:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKEKw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 05:52:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 090552151B;
        Thu,  5 Nov 2020 10:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604573547;
        bh=dHIPFHJS8mksvgjLXcR/EsyhX2pv1p/eGxNVCgM8hrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SahJzWsZQ2bLQXz1f8iY+r1b4yVRcWcoXiB8i6+F7bLid+d1tYxE59d4wtS3l6Mn7
         ObzQPGDxTuxKJfJu0KlO3Wa5uK+NYvW7uwd5uVBtppieLp8pOmWHDqtO5y3TdYZeC5
         khmsdst29miRjXIvJ1SmUJ71LWLvyFL55QdqMncw=
Date:   Thu, 5 Nov 2020 11:53:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
Message-ID: <20201105105316.GA4038994@kroah.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <CA+G9fYsrppNwC0S4vkrS8jGW4k2fgmbAzy=oMLV6X9=DHkznpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsrppNwC0S4vkrS8jGW4k2fgmbAzy=oMLV6X9=DHkznpw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 12:42:46PM +0530, Naresh Kamboju wrote:
> On Wed, 4 Nov 2020 at 02:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.4 release.
> > There are 391 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.4-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

Thanks for testing all of these and letting me know.

greg k-h
