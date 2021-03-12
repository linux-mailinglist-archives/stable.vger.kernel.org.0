Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D43339047
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhCLOsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:48:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhCLOsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 09:48:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKj5K-00AXdN-5y; Fri, 12 Mar 2021 15:48:14 +0100
Date:   Fri, 12 Mar 2021 15:48:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <YEt/Ll08M1cwgGR/@lunn.ch>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210312101027.1997ec75@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 10:10:27AM +0100, Marek Behún wrote:
> On Fri, 12 Mar 2021 09:58:34 +0100
> Gregory CLEMENT <gregory.clement@bootlin.com> wrote:
> 
> > Hello Marek,
> > 
> > > From: Pali Rohár <pali@kernel.org>
> > >
> > > Move the turris-mox-rwtm firmware node from Turris MOX' device tree into
> > > the generic armada-37xx.dtsi file.  
> > 
> > I disagree with this patch. This firmware is specific to Turris MOX so
> > it is not something that should be exposed to all the Armada 3700 based
> > boards.
> > 
> > If you want you still can create an dtsi for this and include it when
> > needed.
> > 
> > Gregory
> 
> Gregory, we are planning to send pull-request for TF-A documentation,
> adding information that people can compile the firmware with CZ.NIC's
> firmware.
> 
> Since this firmware exposes HW random number generator, it is
> possible that people will start using it for espressobin.
> 
> In that case this won't be specific for Turris MOX anymore.

Part of the problem is that it looks specific to the Turris MOX.

But please help me understand the big picture first.  How is the
firmware distributed? Is the binary part of linux-firmware? How does
it get loaded? Does the firmware contain anything which is specific to
the Turris MOX? Could the hardware number generator part be split out
into a more generic sounding name blob?

     Andrew
