Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7C2E9065
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 07:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbhADGWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 01:22:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbhADGWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 01:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF5F20DD4;
        Mon,  4 Jan 2021 06:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609741283;
        bh=e9kMeAcB1DLpn1AJtsX2ec/gUS+qCYIzwz+9ib941Dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wI3qGXfny4BhUatOXhr9gqD94l3Z27gMnUSkTIfRgVD720VNJmyUNafuWkLzQgP63
         R4TkWs9ceXKWmWUF0IWDByNS07LjyeYEg2i4CnFGx+z2u+h0LVWkhdhxvV9phzkWk/
         rCh8bZtdLpz15q8qOdlNcDnpBIIXVclsx9Fpy3XY=
Date:   Mon, 4 Jan 2021 07:21:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <X/Kz4KHxoU/YYEvu@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
 <X+dRkTq+T+A6nWPz@kroah.com>
 <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
 <X+iwvG2d0QfPl+mc@kroah.com>
 <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
 <20201228095040.GA11960@amd>
 <356ddc03-038e-71b6-8134-5b41f090d448@roeck-us.net>
 <aa62485a757305b46df190e6f90dfbd6bc31a144.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa62485a757305b46df190e6f90dfbd6bc31a144.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 03, 2021 at 06:37:51PM +0530, Jeffrin Jose T wrote:
> On Mon, 2020-12-28 at 12:41 -0800, Guenter Roeck wrote:
> > On 12/28/20 1:50 AM, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > > > > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > > > > > > > > or in the git tree and branch at:
> > > > > > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/s
> > > > > > > > > table/
> > > > > > > > > linu
> > > > > > > > > x-
> > > > > > > > > stable-rc.git linux-5.10.y
> > > > > > > > > and the diffstat can be found below.
> > > > > > > > > 
> > > > > > > > > thanks,
> > > > > > > > > 
> > > > > > > > > greg k-h
> > > > > > > > 
> > > > > > > > hello ,
> > > > > > > > Compiled and booted 5.10.3-rc1+.
> > > > > > > > 
> > > > > > > > dmesg -l err gives...
> > > > > > > > --------------x-------------x------------------->
> > > > > > > >    43.190922] Bluetooth: hci0: don't support firmware
> > > > > > > > rome
> > > > > > > > 0x31010100
> > > > > > > > --------------x---------------x----------------->
> > > > > > > > 
> > > > > > > > My Bluetooth is Off.
> > > > > > > 
> > > > > > > Is this a new warning?  Does it show up on 5.10.2?
> > > > > > > 
> > > > > > > > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > > > > > > 
> > > > > > > thanks for testing?
> > > > > > > 
> > > > > > > greg k-h
> > > > > > 
> > > > > > this does not show up in 5.10.2-rc1+
> > > > > 
> > > > > Odd.  Can you run 'git bisect' to find the offending commit?
> > > > > 
> > > > > Does this same error message show up in Linus's git tree?
> > > 
> > > > i will try to do "git bisect" .  i saw this error in linus's 
> > > > tree.
> > > 
> > > The bug is in -stable, too, so it is probably easiest to do bisect
> > > on
> > > -stable tree. IIRC there's less then few hundred commits, so it
> > > should
> > > be feasible to do bisection by hand if you are not familiar with
> > > git
> > > bisect.
> > > 
> > 
> > My wild guess would be commit b260e4a68853 ("Bluetooth: Fix slab-out-
> > of-bounds
> > read in hci_le_direct_adv_report_evt()"), but I don't see what might
> > be wrong
> > with it unless some BT device sends a bad report which used to be
> > accepted
> > but is now silently ignored.
> > 
> > Guenter
> > 
> hello,
> 
> Did  "git bisect" in  a typically ok fashion and found that 5.9.0 is
> working for bluetooth related. But 5.10.0-rc1  related is not working.
> 
> some related information in bisect.txt  attached.
> 
> -- 
> software engineer
> rajagiri school of engineering and technology - autonomous
> 

> $sudo git bisect bad
> Bisecting: 0 revisions left to test after this (roughly 1 step)
> [194810f78402128fe07676646cf9027fd3ed431c] dt-bindings: leds: Update devicetree documents for ID_RGB
> 
> $sudo git bisect bad
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [3650b228f83adda7e5ee532e2b90429c03f7b9ec] Linux 5.10-rc1

That's really odd, as that commit only has a Makefile change.

Also, why run this as root?

greg k-h
