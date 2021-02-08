Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55D312EC4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhBHKTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhBHKRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 05:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F36B64E05;
        Mon,  8 Feb 2021 10:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612779383;
        bh=pMRRGzW3+cd1iEn+XcVRAQ7xrxEla2MqXll2tIuYX7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AZbjKRzsrRdpEJjMZuLd3Zl+sJjTDQUg3GxEyW1bDzhPuJ+AZ8maYH4JAQsGcp6e+
         a9D/GuotmzTLn4sNe2T2ORdz+ga2eJga6lAi+Wbc+/pDowFuwGa/wLu8n9aJwQspH5
         pfnx3uTV7hnpgslMbXVHhLFhVL9EZ4APQQmLluW4=
Date:   Mon, 8 Feb 2021 11:16:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <YCEPdBfsxpWSdSar@kroah.com>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YCEN8PptcWpl5PvW@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 11:09:52AM +0100, Greg KH wrote:
> On Sun, Feb 07, 2021 at 04:56:21PM +0100, Pali Rohár wrote:
> > On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > ...
> > > Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> > > Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> > > Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
> > 
> > Hello Greg! Seems that you have forgot to apply some dependency patches.
> 
> You are right, I had one, not the other, now fixed up...

Nope, of_phy_put(phy) is not present in 5.4, so it needs a "real"
backport.

Can you do that?

thanks,

greg k-h

