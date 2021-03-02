Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9366F32AEEE
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhCCAJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241971AbhCBKDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 05:03:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79FE564F0E;
        Tue,  2 Mar 2021 10:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614679331;
        bh=RKLx782e+Xbs66tKtfF0TwGnkvj1uSMgxxXztn0zNhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MydUhbCxW8C4PzG75K7fHOUMq/uxhmeU27MwfyrQqw8ZOH57fkPScbeI1rFEGCbED
         aB5DnNe7/YY0tKrPo3qHt8oHxfhcbHv2ttX51b2mNzwi38kNdyUZoxyLrftnSP1VdS
         u4qv/3tlC2LMwggFpc22ir3Qsuc1rgWosyGif8cg=
Date:   Tue, 2 Mar 2021 11:02:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     stable@vger.kernel.org, Linux Phy <linux-phy@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Commits for 5.11 stable
Message-ID: <YD4NINW6u28SxedJ@kroah.com>
References: <YD4LfQEXWawk2b4C@vkoul-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4LfQEXWawk2b4C@vkoul-mobl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 03:25:09PM +0530, Vinod Koul wrote:
> Hi Greg,
> 
> Please include these commits for 5.11 stable series
> 
> 9a8b9434c60f phy: mediatek: Add missing MODULE_DEVICE_TABLE()
> 25e3ee590f62 phy: phy-brcm-sata: remove unneeded semicolon
> 6b46e60a6943 phy: USB_LGM_PHY should depend on X86
> 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
> c188365402f6 phy: rockchip: emmc, add vendor prefix to dts properties
> 88d9f40c4b71 devicetree: phy: rockchip-emmc optional add vendor prefix
> aaf316de3bba phy: cpcap-usb: remove unneeded conversion to bool
> 39961bd6b70e phy: rockchip-emmc: emmc_phy_init() always return 0

Why take these?

What problems do they solve?

How does 25e3ee590f62 meet the stable tree rules?

> Please note that below commit is applicable for 5.7+
> 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable

So for 5.10 also?

thanks,

greg k-h
