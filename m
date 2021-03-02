Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8489832AFC7
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbhCCA2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383918AbhCBMcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE8B64F14;
        Tue,  2 Mar 2021 12:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614687906;
        bh=Aldm8YMvXG8WVX+mOd7bcdqNQnSYW9wkuny25CHQMo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BqY+FnncddCy86MsJfCwxtqZlVd+QhCG/KBo2bHMBnoKIn+sGYVxmZKOw7FoI1H5n
         PbQf6AemFCsRZ8F1Dt8iwo6t58tu/kKXdaFf/EvwaIkxJdN1DPSYGMXt9MLgK6LCuf
         h11SgPfPU/QkmOWIjuxcyzJs09Ypzrw/u1iJx0Ik=
Date:   Tue, 2 Mar 2021 13:25:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     stable@vger.kernel.org, Linux Phy <linux-phy@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Commits for 5.11 stable
Message-ID: <YD4un+98ZK7yLJNV@kroah.com>
References: <YD4LfQEXWawk2b4C@vkoul-mobl>
 <YD4NINW6u28SxedJ@kroah.com>
 <YD4SlyXIVFZQYip5@vkoul-mobl>
 <YD4WTn1mdE+RBoR1@kroah.com>
 <YD4su5gWILbbrd0z@vkoul-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4su5gWILbbrd0z@vkoul-mobl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 05:46:59PM +0530, Vinod Koul wrote:
> On 02-03-21, 11:41, Greg KH wrote:
> > On Tue, Mar 02, 2021 at 03:55:27PM +0530, Vinod Koul wrote:
> > > 
> > > HI Greg,
> > > 
> > > On 02-03-21, 11:02, Greg KH wrote:
> > > > On Tue, Mar 02, 2021 at 03:25:09PM +0530, Vinod Koul wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > Please include these commits for 5.11 stable series
> > > > > 
> > > > > 9a8b9434c60f phy: mediatek: Add missing MODULE_DEVICE_TABLE()
> > > > > 25e3ee590f62 phy: phy-brcm-sata: remove unneeded semicolon
> > > > > 6b46e60a6943 phy: USB_LGM_PHY should depend on X86
> > > > > 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
> > > > > c188365402f6 phy: rockchip: emmc, add vendor prefix to dts properties
> > > > > 88d9f40c4b71 devicetree: phy: rockchip-emmc optional add vendor prefix
> > > > > aaf316de3bba phy: cpcap-usb: remove unneeded conversion to bool
> > > > > 39961bd6b70e phy: rockchip-emmc: emmc_phy_init() always return 0
> > > > 
> > > > Why take these?
> > > > 
> > > > What problems do they solve?
> > > 
> > > Sorry I should have provided the context. I had sent these as fixes for
> > > 5.11 but that was bit late so we merged it for 5.12 [1]
> > 
> > I still do not have any context :(
> 
> Please see the discussion we had in https://lore.kernel.org/lkml/20210210091249.GC2774@vkoul-mobl.Dlink/

All that means is that you felt some of these needed to go into 5.11 but
did not make it.  That does not mean that all of the above qualifies for
stable backporting, correct?

So can I have a list of ids, in the order in which they should be
applied, that you feel should go into 5.11, and any other older stable
releases?

thanks,

greg k-h
