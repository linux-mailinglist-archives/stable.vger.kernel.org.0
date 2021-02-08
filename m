Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8FA3135CC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhBHO43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhBHOyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 09:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCFEA64E45;
        Mon,  8 Feb 2021 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796052;
        bh=rygwTEZ0cNZvD4SNSIkNc2FbFMYuVcvnd4GHYV5EChc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NX8iM5B/f91DHXSyRDG1Qu673EEf0dntodq4iRQbx0RtJpXj3d7ofwFDPp2Z5RAim
         9A2ZWamNU4UcN6XCQwKO8vfrvBHRzBaMmYUh+eJ0F7vUBRjamWLXCh5MrFKB33hQLh
         qeWZVSiBtkmt6d8KKvxkphqADm0bjtFykR4Vymso=
Date:   Mon, 8 Feb 2021 15:54:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <YCFQkt2XRYa+zE0f@kroah.com>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
 <YCEPdBfsxpWSdSar@kroah.com>
 <20210208110709.2ce5h3fdm3ftipcf@pali>
 <20210208143705.xi4jjy6unz5ueph4@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210208143705.xi4jjy6unz5ueph4@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 03:37:05PM +0100, Pali Rohár wrote:
> On Monday 08 February 2021 12:07:09 Pali Rohár wrote:
> > On Monday 08 February 2021 11:16:20 Greg KH wrote:
> > > On Mon, Feb 08, 2021 at 11:09:52AM +0100, Greg KH wrote:
> > > > On Sun, Feb 07, 2021 at 04:56:21PM +0100, Pali Rohár wrote:
> > > > > On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> > > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > ...
> > > > > > Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> > > > > > Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> > > > > > Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
> > > > > 
> > > > > Hello Greg! Seems that you have forgot to apply some dependency patches.
> > > > 
> > > > You are right, I had one, not the other, now fixed up...
> > > 
> > > Nope, of_phy_put(phy) is not present in 5.4, so it needs a "real"
> > > backport.
> > > 
> > > Can you do that?
> > 
> > Ok, I will look at it.
> 
> Now I have backported this patch to 5.4 version and tested it with old
> arm trusted firmware (for which this patch is fixing support) and also
> with the new arm trusted firmware. It is working fine in both cases.
> 
> Still this patch depends on two mentioned commits which are required.

This worked, thanks!

greg k-h
