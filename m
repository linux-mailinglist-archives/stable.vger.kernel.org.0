Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B46636B90D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhDZSg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234796AbhDZSg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 14:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1056F613C2;
        Mon, 26 Apr 2021 18:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619462175;
        bh=ctJ7HKX1SYe2OWvb9fvNlLwdREd5PVNeOBxdpTc/JXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DN4NB8ZE+ICuwgkX4PSDG9YOp7uuBK9tnT3gd/8xt0rd2cy/hsBXW6y/Y1VjCkfVF
         h1P77Cgz7qOXtTUT58G4qQ+wy2zdQoUP7jCfwxBE8leKLKw9xaZLyNmimZucIDv6Tk
         2qWid/9BTzP5HHsXj5H73YEezEDLXPC2Wzdg9bSBNcHktqzmxWlPGlYXf79taXHtZ9
         9Ep3mkUMW+KxfZdsX5XeTgrEgwv2SuBw/94Y9+drx1Z/WFWae9LwLkKqpe9iR6WIbP
         pFpt264jE9GRyh6Ag/QVEueDC9xrgHHw7Ble5ys4lWcluq4Z1uuoazk6VNJdP0rzHL
         PccjepIDk+c/g==
Received: by pali.im (Postfix)
        id 543C1EBC; Mon, 26 Apr 2021 20:36:12 +0200 (CEST)
Date:   Mon, 26 Apr 2021 20:36:12 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <20210426183612.kj5g3wklgue3gx55@pali>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
 <YEt/Ll08M1cwgGR/@lunn.ch>
 <20210312161704.5e575906@kernel.org>
 <YEuOfI5FKLYgdQV+@lunn.ch>
 <20210315101454.dpyfdwk43poirxlw@pali>
 <YE9OMFHwLi8q0qnb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YE9OMFHwLi8q0qnb@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 15 March 2021 13:08:16 Andrew Lunn wrote:
> On Mon, Mar 15, 2021 at 11:14:54AM +0100, Pali Rohár wrote:
> > On Friday 12 March 2021 16:53:32 Andrew Lunn wrote:
> > > > So theoretically the turris-mox-rwtm driver can be renamed into
> > > > something else and we can add a different compatible in order not to
> > > > sound so turris-mox specific.
> > > 
> > > That would be a good idea. And if possible, try to push the hardware
> > > random number code upstream in the firmware repos, so everybody gets
> > > it by default, not just those using your build. Who is responsible for
> > > upstream? Marvell?
> > > 
> > > 	  Andrew
> > 
> > Hello Andrew!
> > 
> > I do not think that renaming driver is the best option. For future it
> > would complicate backporting patches to stable kernel and also it would
> > make usage of 'gitk' harder as this tool cannot automatically track file
> > renames.
> 
> Hi Pali
> 
> I'm not suggesting renaming the .c file.
> 
> What would be good is to add additional compatible strings. Add a more
> generic compatible. What goes into the .dtsi should use the generic
> name. Also, the node names should also be generic, since the node name
> is probably not used anywhere, just the compatible string. Keep the
> current compatible in the driver, for backwards compatibility with
> older DT blobs.

Ok! What about compatible string "marvell,armada-3700-rwtm-firmware"?

Mailbox layer which is used by this driver has compatible string
"marvell,armada-3700-rwtm-mailbox", so name is similar.
