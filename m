Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C962E2E71
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 16:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgLZPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 10:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLZPHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Dec 2020 10:07:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED773207CD;
        Sat, 26 Dec 2020 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608995220;
        bh=hOENAK1Mr1BO5tFgcoU/M1T7xwdMU+acAjuBcstSy7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wYaX0yKsUizs5nB14y26AfP91NoAGGtUswXERRiWSFO2BCoS5K+9IMmU4C5jgu0yM
         sC0e0CEuop+xazs50Z5Pcl+nylT705J5kiMF44PMbpqEQqOzS4HKlLzZcO/mYlgNhP
         ejOxWDCl6PQIlGw0uUeJwEV5uL+mJrelhB627+5Q=
Date:   Sat, 26 Dec 2020 16:06:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <X+dRkTq+T+A6nWPz@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 24, 2020 at 03:13:38PM +0530, Jeffrin Jose T wrote:
> On Wed, 2020-12-23 at 16:33 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.3 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello ,
> Compiled and booted 5.10.3-rc1+.
> 
> dmesg -l err gives...
> --------------x-------------x------------------->
>    43.190922] Bluetooth: hci0: don't support firmware rome 0x31010100
> --------------x---------------x----------------->
> 
> My Bluetooth is Off.

Is this a new warning?  Does it show up on 5.10.2?

> Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

thanks for testing?

greg k-h
