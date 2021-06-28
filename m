Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADFB3B5F32
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhF1NlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 09:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhF1NlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 09:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E63F46145F;
        Mon, 28 Jun 2021 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624887526;
        bh=/+pHo7VIQTgnU9iKXD15OH9Vp9yhTFqH2725M6P3IIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S5Z6Bbtpb6UuQfgnZe4vOricaB7B+slBlTkAu1xwTd2XOt0JzOFfl0UESNhMB0e33
         HP7+/hqk3c3B7GFg+EomCX7QHcc337NtiNulsz7bc+pGE+eVv2Riw3/7Dyua8U6ujQ
         1Ml8CqdQhvfZs28mg/Y7FKiR/EmL+Q0gJ8hrnILw=
Date:   Mon, 28 Jun 2021 15:38:44 +0200
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
Message-ID: <YNnQ5F43u0hurra3@kroah.com>
References: <20210408230001.310215-1-marex@denx.de>
 <47597d13-e6ec-ccd2-c34b-eb65896cdd70@denx.de>
 <YNnAxiDMCQ8Y05ll@kroah.com>
 <7fc37c79-4e04-2cb0-efc4-4f642316c612@denx.de>
 <YNnIXjGyvaQgf2wP@kroah.com>
 <7137f147-f127-2884-39e7-7cfabe9e2bfc@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7137f147-f127-2884-39e7-7cfabe9e2bfc@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 03:10:36PM +0200, Marek Vasut wrote:
> On 6/28/21 3:02 PM, Greg KH wrote:
> > On Mon, Jun 28, 2021 at 02:32:50PM +0200, Marek Vasut wrote:
> > > On 6/28/21 2:29 PM, Greg KH wrote:
> > > > On Mon, Jun 28, 2021 at 12:44:37PM +0200, Marek Vasut wrote:
> > > > > On 4/9/21 1:00 AM, Marek Vasut wrote:
> > > > > > The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
> > > > > > enabled when the nRST is toggled according to datasheet Microchip
> > > > > > LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
> > > > > 
> > > > > Adding stable to CC.
> > > > > 
> > > > > Patch is now part of Linux 5.13 as commit
> > > > > 
> > > > > 1cebcf9932ab ("ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM")
> > > > 
> > > > $ git show 1cebcf9932ab
> > > > fatal: ambiguous argument '1cebcf9932ab': unknown revision or path not in the working tree.
> > > > Use '--' to separate paths from revisions, like this:
> > > > 'git <command> [<revision>...] -- [<file>...]'
> > > > 
> > > > Are you sure?
> > > 
> > > This would seem to indicate so:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1cebcf9932ab76102e8cfc555879574693ba8956
> > > 
> > > linux-2.6$ git describe 1cebcf9932ab76102e8cfc555879574693ba8956
> > > v5.13-rc1-1-g1cebcf9932ab
> > > 
> > > Did the commit get abbreviated too much ?
> > 
> > Something is really odd, as that commit _is_ in linux-next, but it is
> > not in my local copy of Linus's tree.
> > 
> > So how it is showing up in that link above is beyond me.  Can you see it
> > locally on your machine?
> 
> Yes, that's where the git describe came from. And I used a different repo
> than the one from which I submitted the patch originally, so the commit
> must've come from fetching origin (i.e. linus tree).
> 
> Could it be this "ambiguous argument '1cebcf9932ab'" , which would indicate
> the commit hash got abbreviated too much ?

The web site "lies" it has a shared backend.  Trust your local copy of
the tree, that shows that this commit is NOT in Linus's tree just yet.
Please let stable@vger know when it does hit Linus's tree and we will be
glad to take it.

thanks,

greg k-h
