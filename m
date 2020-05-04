Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8941C3687
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgEDKNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgEDKNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 06:13:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E24C061A0E;
        Mon,  4 May 2020 03:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HYr4jMG5Fx8z45ehq19JE5BB1pRtcqVpSSdsC2AjlhY=; b=CmgNscbfFaxys2H8sNgXEM5V5
        OrhtGd/K3U7qiBY+teHpl2a1hL2ClrCNSK0sQ04G4yVN41oGPagC7WvFygQF0xfJGOBTvS/+MI0p0
        Q9II8asQ3BfG/CVqj852mZXqJiIsyDfRVdauhJa3EYXQXpfubYmDrAsGoSxell4VJsZG6SMjFOHrE
        1kW50x39XaHBdZBlGFqP0HMSqw8aDCiuEqcDlyZLgZnUbRXpuX1JnpuI9bYkv96s685LjcSnUkrPl
        QDTcaDO8UONoJKSPLQnyE061fP56muBZ1+oYCkIOlTtTAQdq7vUzag30rgIOVM0v3WDHa0DD9BOvJ
        6uTFYxwwA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:35838)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jVY6L-0003zf-FE; Mon, 04 May 2020 11:13:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jVY6K-00063o-Fg; Mon, 04 May 2020 11:13:28 +0100
Date:   Mon, 4 May 2020 11:13:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Greg KH <greg@kroah.com>
Cc:     Miguel Borges de Freitas <miguelborgesdefreitas@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch include request] ARM: dts: imx6qdl-sr-som-ti: indicate
 powering off wifi is safe
Message-ID: <20200504101328.GC1551@shell.armlinux.org.uk>
References: <CAC4G8N75VkqDug9AmhvMQnXr8bOvC9cu_jUwZVUKwpvWr6pO5A@mail.gmail.com>
 <20200504095832.GA1277837@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504095832.GA1277837@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 11:58:32AM +0200, Greg KH wrote:
> On Fri, May 01, 2020 at 09:23:49PM +0100, Miguel Borges de Freitas wrote:
> > Dear all,
> > 
> > This is a request to backport b7dc7205b2ae6b6c9d9cfc3e47d6f08da8647b10
> > (Arm: dts:  imx6qdl-sr-som-ti: indicate powering off wifi is safe),
> > already in Linus tree
> > (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm/boot/dts/imx6qdl-sr-som-ti.dtsi?h=v5.7-rc3&id=b7dc7205b2ae6b6c9d9cfc3e47d6f08da8647b10)
> > to LTS kernel 5.4 and to stable 5.6.8.
> > 
> > Reasoning:
> > 
> > Changes to the wlcore driver during Kernel 5.x development, made the
> > Cubox-i with the IMX SOM v1.5 (which includes.a TI Wilink 8 wifi
> > chipset) not power the wireless interface on boot leaving it
> > completely unusable. This happens since at least kernel 5.3 (older one
> > I tested) and affects the current stable and LTS latest kernels. The
> > linked commit, already in linux mainline, restores the wifi
> > functionality.
> > 
> > Thanks in advance,
> 
> Now queued up, thanks.

Just be aware that there's a good reason the patch was never marked
with a Fixes: tag - that is because no one seems to know exactly which
commit broke it, and hence it hasn't been clear which stable kernels
it should be backported to.

So, it's good that someone has put up this backport request.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
