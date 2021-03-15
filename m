Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB02833B229
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhCOMIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:08:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhCOMIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 08:08:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lLm1A-00B6Bw-Sf; Mon, 15 Mar 2021 13:08:16 +0100
Date:   Mon, 15 Mar 2021 13:08:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <YE9OMFHwLi8q0qnb@lunn.ch>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
 <YEt/Ll08M1cwgGR/@lunn.ch>
 <20210312161704.5e575906@kernel.org>
 <YEuOfI5FKLYgdQV+@lunn.ch>
 <20210315101454.dpyfdwk43poirxlw@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210315101454.dpyfdwk43poirxlw@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 11:14:54AM +0100, Pali Rohár wrote:
> On Friday 12 March 2021 16:53:32 Andrew Lunn wrote:
> > > So theoretically the turris-mox-rwtm driver can be renamed into
> > > something else and we can add a different compatible in order not to
> > > sound so turris-mox specific.
> > 
> > That would be a good idea. And if possible, try to push the hardware
> > random number code upstream in the firmware repos, so everybody gets
> > it by default, not just those using your build. Who is responsible for
> > upstream? Marvell?
> > 
> > 	  Andrew
> 
> Hello Andrew!
> 
> I do not think that renaming driver is the best option. For future it
> would complicate backporting patches to stable kernel and also it would
> make usage of 'gitk' harder as this tool cannot automatically track file
> renames.

Hi Pali

I'm not suggesting renaming the .c file.

What would be good is to add additional compatible strings. Add a more
generic compatible. What goes into the .dtsi should use the generic
name. Also, the node names should also be generic, since the node name
is probably not used anywhere, just the compatible string. Keep the
current compatible in the driver, for backwards compatibility with
older DT blobs.

      Andrew
