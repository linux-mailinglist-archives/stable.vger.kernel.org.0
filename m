Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6302C7813
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 06:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgK2FxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 00:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgK2FxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Nov 2020 00:53:19 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2705F207FF;
        Sun, 29 Nov 2020 05:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606629159;
        bh=o4E+DZ68rRK9k80NFd/6zT5QlF4HSViLX0v+r3JvyCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FPPsTDTxsMEwkhYidjwfo/biGuOKCgQ05yaMbggm3k4NCbGkWy0FkHR6qqlh2KfxZ
         +RYCbIcQbaVSn3jkdas+NAfXqJojzzl1HA4MReA05dCt0zT4JXRyVJ9F9sdmE6SqKQ
         OD2COwgn7R8nWK2LsD8yL9eIrDkU5QzSpuOjwip4=
Date:   Sun, 29 Nov 2020 06:52:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        u.kleine-koenig@pengutronix.de, wsa@kernel.org,
        Stable <stable@vger.kernel.org>
Subject: Re: Patch "i2c: imx: Fix reset of I2SR_IAL flag" has been added to
 the 5.4-stable tree
Message-ID: <X8M3I9GWzv9Owtso@kroah.com>
References: <1606575438136209@kroah.com>
 <2394419.nDFh2rNouh@n95hx1g2>
 <CADVatmO2irK-zhsmxceyr0Ami-C16y+7e8BZxpnQibMWk3Y_yg@mail.gmail.com>
 <2749996.lFCkXiQ3ky@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2749996.lFCkXiQ3ky@n95hx1g2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 28, 2020 at 09:15:52PM +0100, Christian Eggers wrote:
> Hi Sudip,
> 
> On Saturday, 28 November 2020, 17:57:50 CET, Sudip Mukherjee wrote:
> > Hi Christian,
> > 
> > On Sat, Nov 28, 2020 at 3:11 PM Christian Eggers <ceggers@arri.de> wrote:
> > <snip>
> > > Although I am happy seeing my patch in the stable series, I think it should be
> > > applied to mainline first.
> > 
> > Stable trees can only take fixes which have been applied to the
> > mainline. This is in mainline since v5.9.
> 
> I cannot see it in 5.9-stable:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/drivers/i2c/busses/i2c-imx.c?h=v5.9.11

$ git describe --contains fa4d30556883f2eaab425b88ba9904865a4d00f3
v5.9~5^2~5

But, you are right, the change really isn't in there as it got reverted:

~/linux/stable/linux-5.9.y (linux-5.9.y)$ git log --oneline | grep I2SR_
5a02e7c429cb Revert "i2c: imx: Fix reset of I2SR_IAL flag"
fa4d30556883 i2c: imx: Fix reset of I2SR_IAL flag

So I should drop it from all of these trees as well.

thanks,

greg k-h
