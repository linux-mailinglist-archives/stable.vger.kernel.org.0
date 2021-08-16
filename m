Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6C13EDDCE
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhHPTWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 15:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhHPTWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 15:22:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1955360EFE;
        Mon, 16 Aug 2021 19:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629141738;
        bh=WbzqszoevFCXeG3wGBVLFxld3hWoRSrA585QZfNEMoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9Bzxp0BsPlRl9Whu97NxfVi+iG9MCdVBqSCnFHYibDRX25LxxXPfZLmUzXIO9OhH
         hF2zVvF0JeHO4nqwwM0cs7kQiMce5iBMRI6gcy893AQizxh8nzD1jUhJS29jQzdjfx
         bgbwb0JRLU9gzNeyYKrUJrlWVas5C4V+BBXdp9Ck=
Date:   Mon, 16 Aug 2021 21:22:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@essensium.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 52/96] net: dsa: microchip: ksz8795: Fix VLAN
 filtering
Message-ID: <YRq66I9IuYSZUoBo@kroah.com>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.688497376@linuxfoundation.org>
 <20210816132858.GC18930@cephalopod>
 <YRqR7NFWJmhFR9/d@kroah.com>
 <20210816174905.GD18930@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816174905.GD18930@cephalopod>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:49:05PM +0200, Ben Hutchings wrote:
> On Mon, Aug 16, 2021 at 06:27:24PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Aug 16, 2021 at 03:28:58PM +0200, Ben Hutchings wrote:
> > > On Mon, Aug 16, 2021 at 03:02:02PM +0200, Greg Kroah-Hartman wrote:
> > > > From: Ben Hutchings <ben.hutchings@mind.be>
> > > > 
> > > > [ Upstream commit 164844135a3f215d3018ee9d6875336beb942413 ]
> > > 
> > > This will probably work on its own, but it was tested as part of a
> > > series of changes to VLAN handling in the driver.  Since I initially
> > > developed and tested that on top of 5.10-stable, I would prefer to
> > > send you the complete series to apply together.
> > 
> > What is the "complete series"?  We have 7 patches for this driver in
> > this round of kernel rc reviews.
> 
> You have the full series queued up for 5.13, but only 2 of them for
> 5.10.
> 
> > What specific git ids are you referring to?
> 
> The fixes missing from the 5.10 queue are:
> 
> ef3b02a1d79b691f9a354c4903cf1e6917e315f9
> 8f4f58f88fe0d9bd591f21f53de7dbd42baeb3fa
> af01754f9e3c553a2ee63b4693c79a3956e230ab
> 9130c2d30c17846287b803a9803106318cbe5266
> 
> (I also have another fix just for 5.10 because the issue was fixed by
> a refactoring in 5.11 that wouldn't be suitable for stable.)

Thanks, sorry, I was looking at 5.13.  All now queued up.

greg k-h
