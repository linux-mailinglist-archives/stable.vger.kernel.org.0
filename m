Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FED46B448
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 04:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfGQCFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 22:05:03 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:45061 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfGQCFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 22:05:03 -0400
X-Originating-IP: 82.64.72.66
Received: from debamax.com (82-64-72-66.subs.proxad.net [82.64.72.66])
        (Authenticated sender: cyril@debamax.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 82F69FF802;
        Wed, 17 Jul 2019 02:05:00 +0000 (UTC)
Date:   Wed, 17 Jul 2019 04:04:59 +0200
From:   Cyril Brulebois <cyril@debamax.com>
To:     Greg KH <greg@kroah.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        charles.fendt@me.com
Subject: Re: [PATCH 1/3] ARM: dts: add Raspberry Pi Compute Module 3 and IO
 board
Message-ID: <20190717020459.g3qgvwpqxlym27aw@debamax.com>
References: <20190715140112.6180-1-cyril@debamax.com>
 <20190715140112.6180-2-cyril@debamax.com>
 <860468a1-df13-cb6a-6951-455cf72ad4a0@i2se.com>
 <20190716091122.GB11964@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190716091122.GB11964@kroah.com>
Organization: DEBAMAX
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Stefan,

Greg KH <greg@kroah.com> (2019-07-16):
> On Mon, Jul 15, 2019 at 05:26:16PM +0200, Stefan Wahren wrote:
> > Hi Cyril,
> > 
> > On 15.07.19 16:01, Cyril Brulebois wrote:
> > > From: Stefan Wahren <stefan.wahren@i2se.com>
> > >
> > > commit a54fe8a6cf66828499b121c3c39c194b43b8ed94 upstream.
> > >
> > > The Raspberry Pi Compute Module 3 (CM3) and the Raspberry Pi
> > > Compute Module 3 Lite (CM3L) are SoMs which contains a BCM2837 processor,
> > > 1 GB RAM and a GPIO expander. The CM3 has a 4 GB eMMC, but on the CM3L
> > > the eMMC is unpopulated and it's up to the user to connect their
> > > own SD/MMC device. The dtsi file is designed to work for both modules.
> > > There is also a matching carrier board which is called
> > > Compute Module IO Board V3.
> > 
> > this patch series doesn't apply to the stable kernel rules.
> 
> I'm with Stefan.  Cyril, how do you think this matches up with what:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> says?

First off, I'm sorry to have wasted everyone's time with this attempt at
getting the DTB addition upstream'd so that other distributions/users
could benefit from it as well; it's now been included downstream
instead.


stable-kernel-rules has this entry that made me think this would be
acceptable:

    - New device IDs and quirks are also accepted.

To my non-expert eyes, a DTB looked similar to a bunch of device IDs,
mapping specific hardware to the right modules and parameters. I thought
that allowing device IDs to be added, mapping new HW to existing and
known-to-be-working modules, was similar to what's happening with a DTB.


In hindsight, looking at say 4.9 or 4.19 (baselines for Debian kernels),
I see that DTBs were fixed but never added. Maybe having an extra “(DTBs
don't qualify)” in the documentation might prevent others from making
the same mistake?


Cheers,
-- 
Cyril Brulebois -- Debian Consultant @ DEBAMAX -- https://debamax.com/
