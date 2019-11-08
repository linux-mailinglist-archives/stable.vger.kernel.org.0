Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC3BF4D88
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKHNst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:48:49 -0500
Received: from foss.arm.com ([217.140.110.172]:43826 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfKHNst (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 08:48:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CDA046A;
        Fri,  8 Nov 2019 05:48:49 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D2783F719;
        Fri,  8 Nov 2019 05:48:48 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:48:46 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Greg KH <greg@kroah.com>, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH for-stable-4.4 08/50] arm/arm64: KVM: Advertise SMCCC v1.1
Message-ID: <20191108134845.GB11465@lakrids.cambridge.arm.com>
References: <20191108123554.29004-1-ardb@kernel.org>
 <20191108123554.29004-9-ardb@kernel.org>
 <20191108131105.GA759061@kroah.com>
 <20191108133952.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108133952.GX25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 01:39:52PM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Nov 08, 2019 at 02:11:05PM +0100, Greg KH wrote:
> > On Fri, Nov 08, 2019 at 01:35:12PM +0100, Ard Biesheuvel wrote:
> > > From: Mark Rutland <mark.rutland@arm.com>
> > > 
> > > From: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > Lots of Mar[c/k]'s :)
> > 
> > I'll fix this up...
> 
> Mark and Marc are both valid variants, there is nothing to be fixed up
> (and if you do, you risk insulting one or other.)

Lost context here -- the issue was both were at the top of the patch,
but there should only be one for the author (Zyngier).

I don't think anyone was suggesting deed poll would be necessary! ;)

I probably messsed that up when doing the v4.9 backport, sorry if that
was the case!

Mark.
