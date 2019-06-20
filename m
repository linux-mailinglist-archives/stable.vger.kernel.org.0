Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A9D4D41E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfFTQsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfFTQsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 12:48:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 408E72083B;
        Thu, 20 Jun 2019 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561049329;
        bh=YqeiERUb+PHX9CwSsRK/djXvE0RYtufS4ilLoL+eBvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSvIZb3N9RIuhVO4XBUHCYi8O+VlWrbU85u8j5UW1rBMBRfgQ2OTvBRUKCBPRoGDf
         YSpqpbjOrqWiMo1RduUBj2LvIk4MhsgN0bFeSREUmh2yEG2D4b2ueWgRCil3GyCY/l
         J3Gjfy112PJLyfnglaHEAcKFw70FIfH5HZsnv8Lg=
Date:   Thu, 20 Jun 2019 18:48:47 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Subject: Re: Patch "net: phylink: set the autoneg state in
 phylink_phy_change" has been added to the 5.1-stable tree
Message-ID: <20190620164847.GA19523@kroah.com>
References: <156094908410230@kroah.com>
 <VI1PR0402MB28004F08C06FAEC6FADD7DEAE0E40@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB28004F08C06FAEC6FADD7DEAE0E40@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 02:48:18PM +0000, Ioana Ciornei wrote:
> 
> > Subject: Patch "net: phylink: set the autoneg state in phylink_phy_change" has
> > been added to the 5.1-stable tree
> > 
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     net: phylink: set the autoneg state in phylink_phy_change
> > 
> > to the 5.1-stable tree which can be found at:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git 
> > 
> > The filename of the patch is:
> >      net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
> > and it can be found in the queue-5.1 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree, please let
> > <stable@vger.kernel.org> know about it.
> 
> Hi all,
> 
> Sorry for the late response but this patch should not be added to stables trees since it was already reverted in net-next.
> More information can be found at: https://marc.info/?l=linux-netdev&m=156104162206869&w=2

No problem, I've now dropped it from everywhere, thanks!

greg k-h
