Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C12E31C1
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 17:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgL0QEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 11:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL0QEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Dec 2020 11:04:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ADC5207D1;
        Sun, 27 Dec 2020 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609085032;
        bh=LNu5ZmZFj5+0D7JqzpxyvG7LdugWh/PonPUP1ky6Me8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vKf2OLYVFukETO6O4yru97z3a2iGpa1UpB+uIZSZnYgPmqM0r+hAAxqdafhkCLS/B
         DafiM0sACQn3OpbNxB5KNEj3haa7GFVgM5hkeqW3YmtwF4+MNUXb4u7IhcQRI+/SqX
         N8+8xj1W2XpoTUR3wOwrzDNKDeSFQNmR4HyRc88I=
Date:   Sun, 27 Dec 2020 17:05:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <X+iwvG2d0QfPl+mc@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
 <X+dRkTq+T+A6nWPz@kroah.com>
 <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 09:20:07PM +0530, Jeffrin Jose T wrote:
> On Sat, 2020-12-26 at 16:06 +0100, Greg Kroah-Hartman wrote:
> > On Thu, Dec 24, 2020 at 03:13:38PM +0530, Jeffrin Jose T wrote:
> > > On Wed, 2020-12-23 at 16:33 +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.10.3
> > > > release.
> > > > There are 40 patches in this series, all will be posted as a
> > > > response
> > > > to this one.  If anyone has any issues with these being applied,
> > > > please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >         
> > > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu
> > > > x-
> > > > stable-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > hello ,
> > > Compiled and booted 5.10.3-rc1+.
> > > 
> > > dmesg -l err gives...
> > > --------------x-------------x------------------->
> > >    43.190922] Bluetooth: hci0: don't support firmware rome
> > > 0x31010100
> > > --------------x---------------x----------------->
> > > 
> > > My Bluetooth is Off.
> > 
> > Is this a new warning?  Does it show up on 5.10.2?
> > 
> > > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > 
> > thanks for testing?
> > 
> > greg k-h
> 
> this does not show up in 5.10.2-rc1+

Odd.  Can you run 'git bisect' to find the offending commit?

Does this same error message show up in Linus's git tree?

thanks,

greg k-h
