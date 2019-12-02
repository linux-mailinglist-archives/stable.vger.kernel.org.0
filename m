Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2B910EE3F
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLBReR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 12:34:17 -0500
Received: from verein.lst.de ([213.95.11.211]:39500 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbfLBReR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 12:34:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EF4B868BE1; Mon,  2 Dec 2019 18:34:14 +0100 (CET)
Date:   Mon, 2 Dec 2019 18:34:14 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is
 optional
Message-ID: <20191202173414.GA8950@lst.de>
References: <20191202155611.21549-1-kbusch@kernel.org> <20191202161545.GA7434@lst.de> <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com> <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com> <20191202162905.GA7683@lst.de> <20191202164903.GA21650@redsun51.ssa.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202164903.GA21650@redsun51.ssa.fujisawa.hgst.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 01:49:03AM +0900, Keith Busch wrote:
> Customer or OEM requirments are poorly written, like "Must report NVMe
> version 1.3". Nobody bothers to mention that it must also be compliant
> to that version, or even realize they never cared for those features in
> the first place.
> 
> Compliance testing like from UNH should have caught this before shipping
> with such a device, but it's a cheap device, so maybe they skip that step.
> 
> >  I wonder if we actually do users a favour by allowing that..
> 
> I think it's too late now. We did successfully use such namespaces
> before 5.4, even if they're fundamentally broken.
> 
> Johannes also commented *not* to consider these errors when this
> identification was originally implemented, so either he knew vendors
> screwed this up, or had the forethought to know they would.

Yes. I guess your patch is the best thing for now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I think we might need a new kernel tain flag or something like
it for devices that are so obviously broken in their identifiers.
