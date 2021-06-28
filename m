Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C3C3B5DFC
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhF1Mc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhF1Mc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 08:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F91A6197F;
        Mon, 28 Jun 2021 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624883400;
        bh=jAiuAP0g+RiIDTJ5WA+otVaDS8UCWm6F8DQd5VL3hs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8nfSNbj4EB0/oai0JY5hrMdmxuqFjEFXcY8BKKfGjnrQZdT6eETpH3L0tZqm3aOu
         Z0eDw2v6l4ujf5JEq8D7+G0P3c4T372m0R6O2/r+nVg0+2QgWaWHETTIw9b+eQxTJp
         fsoK4Mzt0xx8WMuq8fcOEKMG9nJD9YwD5iBDKmuc=
Date:   Mon, 28 Jun 2021 14:29:58 +0200
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
Message-ID: <YNnAxiDMCQ8Y05ll@kroah.com>
References: <20210408230001.310215-1-marex@denx.de>
 <47597d13-e6ec-ccd2-c34b-eb65896cdd70@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47597d13-e6ec-ccd2-c34b-eb65896cdd70@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 12:44:37PM +0200, Marek Vasut wrote:
> On 4/9/21 1:00 AM, Marek Vasut wrote:
> > The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
> > enabled when the nRST is toggled according to datasheet Microchip
> > LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:
> 
> [...]
> 
> > Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
> 
> Adding stable to CC.
> 
> Patch is now part of Linux 5.13 as commit
> 
> 1cebcf9932ab ("ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM")

$ git show 1cebcf9932ab
fatal: ambiguous argument '1cebcf9932ab': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'

Are you sure?
