Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF38D3B5E9C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 15:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhF1NFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 09:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233165AbhF1NEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC5DE61C72;
        Mon, 28 Jun 2021 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624885344;
        bh=IpTdm+bx99nkflUFvQonizPJX+mDv/7+zlOpX45Xbms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bT4Yth/QDHfCmzNa1jKVSNnxloIJlpT0dHeNGufeTGotRHlIrP+/P42X4gZ22llJH
         KLKZmdA3N1Lw58t4PHnBq/AXaYNE5mPuXQO7q+xtq7XIMVVGEknkOs6teeTxt1bOfE
         yro5guB5mH3GirTooVbO0/bZqdWaRgpwCfJelAOI=
Date:   Mon, 28 Jun 2021 15:02:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-stable <stable@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM
Message-ID: <YNnIXjGyvaQgf2wP@kroah.com>
References: <20210408230001.310215-1-marex@denx.de>
 <47597d13-e6ec-ccd2-c34b-eb65896cdd70@denx.de>
 <YNnAxiDMCQ8Y05ll@kroah.com>
 <7fc37c79-4e04-2cb0-efc4-4f642316c612@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fc37c79-4e04-2cb0-efc4-4f642316c612@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 02:32:50PM +0200, Marek Vasut wrote:
> On 6/28/21 2:29 PM, Greg KH wrote:
> > On Mon, Jun 28, 2021 at 12:44:37PM +0200, Marek Vasut wrote:
> > > On 4/9/21 1:00 AM, Marek Vasut wrote:
> > > > The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
> > > > enabled when the nRST is toggled according to datasheet Microchip
> > > > LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:
> > > 
> > > [...]
> > > 
> > > > Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
> > > 
> > > Adding stable to CC.
> > > 
> > > Patch is now part of Linux 5.13 as commit
> > > 
> > > 1cebcf9932ab ("ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM")
> > 
> > $ git show 1cebcf9932ab
> > fatal: ambiguous argument '1cebcf9932ab': unknown revision or path not in the working tree.
> > Use '--' to separate paths from revisions, like this:
> > 'git <command> [<revision>...] -- [<file>...]'
> > 
> > Are you sure?
> 
> This would seem to indicate so:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1cebcf9932ab76102e8cfc555879574693ba8956
> 
> linux-2.6$ git describe 1cebcf9932ab76102e8cfc555879574693ba8956
> v5.13-rc1-1-g1cebcf9932ab
> 
> Did the commit get abbreviated too much ?

Something is really odd, as that commit _is_ in linux-next, but it is
not in my local copy of Linus's tree.

So how it is showing up in that link above is beyond me.  Can you see it
locally on your machine?

thanks,

greg k-h
