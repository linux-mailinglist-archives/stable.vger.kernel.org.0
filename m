Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738D332AEF9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhCCAMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349590AbhCBKmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 05:42:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721C864F04;
        Tue,  2 Mar 2021 10:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614681681;
        bh=ppLyOzfn75hvjWPuiyp3XKquj3xU0eG3AVxg3I9CdH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KYCQvqP+gfX+J8q1ekAnFFL0J6zpc2cpp4OJXM8IL7grGLEvAJY94U/n2KSUwArza
         hib5OLK100mpjbQPrH4gnHq/4Ja4+h54bkjBOXp0WkCUU+jh6kLidKCMAxTBkPSn3M
         TzUxNgDqwcYS6TuYW32pukx7czo4XDLUNU0ObVhk=
Date:   Tue, 2 Mar 2021 11:41:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     stable@vger.kernel.org, Linux Phy <linux-phy@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Commits for 5.11 stable
Message-ID: <YD4WTn1mdE+RBoR1@kroah.com>
References: <YD4LfQEXWawk2b4C@vkoul-mobl>
 <YD4NINW6u28SxedJ@kroah.com>
 <YD4SlyXIVFZQYip5@vkoul-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4SlyXIVFZQYip5@vkoul-mobl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 03:55:27PM +0530, Vinod Koul wrote:
> 
> HI Greg,
> 
> On 02-03-21, 11:02, Greg KH wrote:
> > On Tue, Mar 02, 2021 at 03:25:09PM +0530, Vinod Koul wrote:
> > > Hi Greg,
> > > 
> > > Please include these commits for 5.11 stable series
> > > 
> > > 9a8b9434c60f phy: mediatek: Add missing MODULE_DEVICE_TABLE()
> > > 25e3ee590f62 phy: phy-brcm-sata: remove unneeded semicolon
> > > 6b46e60a6943 phy: USB_LGM_PHY should depend on X86
> > > 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
> > > c188365402f6 phy: rockchip: emmc, add vendor prefix to dts properties
> > > 88d9f40c4b71 devicetree: phy: rockchip-emmc optional add vendor prefix
> > > aaf316de3bba phy: cpcap-usb: remove unneeded conversion to bool
> > > 39961bd6b70e phy: rockchip-emmc: emmc_phy_init() always return 0
> > 
> > Why take these?
> > 
> > What problems do they solve?
> 
> Sorry I should have provided the context. I had sent these as fixes for
> 5.11 but that was bit late so we merged it for 5.12 [1]

I still do not have any context :(

> > How does 25e3ee590f62 meet the stable tree rules?

And all of these really are needed for stable?  Again, how does this
above commit qualify?

thanks,

greg k-h
