Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6E432B007
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhCCAai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447309AbhCBMwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:52:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70AF064EE8;
        Tue,  2 Mar 2021 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614687424;
        bh=j+EW1OpeEGqnjxAWRy/nEAc13Opcu64hp99OwkFNGeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUJawHx7j2x5RwlZCd44KkjByldc+6v5K2G+GMcKx/6FwRi6lRB3nmVZww1aNqeoc
         jVk1NxQubw8bg2CRtwMsCpxVMcmvLc9K24PzvugAJ0P84KAwNlC5rDAVM9lwc/wr8T
         +odC8ZSNf5rwUnGLTHhRDbI6FMu20p+EiSvjHmJq24QcL/k1wcJHmEwcZHu99Hr6LP
         4/r++QdesS0ZNSeviK5g6eANZhL26CV4RY+FGyV4XtX2TUsfvMK/xs0pRRsUbIkqRp
         Q8gCROAA+PlGz6GL9HfI9Vo2jLZU1cKBMaulpgvgQtV4LdhQyF0btQuXhk6moK7yd2
         HFJ5EVOTMS3+Q==
Date:   Tue, 2 Mar 2021 17:46:59 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Linux Phy <linux-phy@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Commits for 5.11 stable
Message-ID: <YD4su5gWILbbrd0z@vkoul-mobl>
References: <YD4LfQEXWawk2b4C@vkoul-mobl>
 <YD4NINW6u28SxedJ@kroah.com>
 <YD4SlyXIVFZQYip5@vkoul-mobl>
 <YD4WTn1mdE+RBoR1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4WTn1mdE+RBoR1@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02-03-21, 11:41, Greg KH wrote:
> On Tue, Mar 02, 2021 at 03:55:27PM +0530, Vinod Koul wrote:
> > 
> > HI Greg,
> > 
> > On 02-03-21, 11:02, Greg KH wrote:
> > > On Tue, Mar 02, 2021 at 03:25:09PM +0530, Vinod Koul wrote:
> > > > Hi Greg,
> > > > 
> > > > Please include these commits for 5.11 stable series
> > > > 
> > > > 9a8b9434c60f phy: mediatek: Add missing MODULE_DEVICE_TABLE()
> > > > 25e3ee590f62 phy: phy-brcm-sata: remove unneeded semicolon
> > > > 6b46e60a6943 phy: USB_LGM_PHY should depend on X86
> > > > 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
> > > > c188365402f6 phy: rockchip: emmc, add vendor prefix to dts properties
> > > > 88d9f40c4b71 devicetree: phy: rockchip-emmc optional add vendor prefix
> > > > aaf316de3bba phy: cpcap-usb: remove unneeded conversion to bool
> > > > 39961bd6b70e phy: rockchip-emmc: emmc_phy_init() always return 0
> > > 
> > > Why take these?
> > > 
> > > What problems do they solve?
> > 
> > Sorry I should have provided the context. I had sent these as fixes for
> > 5.11 but that was bit late so we merged it for 5.12 [1]
> 
> I still do not have any context :(

Please see the discussion we had in https://lore.kernel.org/lkml/20210210091249.GC2774@vkoul-mobl.Dlink/

> > > How does 25e3ee590f62 meet the stable tree rules?

Sorry it doesn't. My mistake on picking this for fixes. Lets drop this
one

> And all of these really are needed for stable?  Again, how does this
> above commit qualify?

I relooked, expect this one, rest should be added for 5.11 stable.

Thanks
-- 
~Vinod
