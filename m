Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600C84A5E55
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiBAOc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 09:32:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44680 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbiBAOc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 09:32:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FE7BB82E40;
        Tue,  1 Feb 2022 14:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384B6C340EB;
        Tue,  1 Feb 2022 14:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643725945;
        bh=SzL6/uvmByac7kgNmmnjoJZkWV6BXp/MpjW3ybQpzdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AoE0UsWdeRY0arwk4DA4FD2UKfkeG5PwlGyJLj3RqWSw/3CiZnIq9Ni9yyHJTu0H+
         N50Y3O4B/nUgVWpH3BgP4kiptq6J2lFUJkZHdo91Z1jHbRdepnQolYMoi41aVlkOoo
         i+L9puv9/Xc9hpx/CFRIXDd2WQZYHpt24hAzoOaQ=
Date:   Tue, 1 Feb 2022 15:32:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.16 138/200] mptcp: keep track of local endpoint still
 available for each msk
Message-ID: <YflEd6+5rdsfKojI@kroah.com>
References: <20220131105233.561926043@linuxfoundation.org>
 <20220131105238.198209212@linuxfoundation.org>
 <26d216d1-355-e132-a868-529f15c9b660@linux.intel.com>
 <YflD6pbqi/EGPG3f@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YflD6pbqi/EGPG3f@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 03:30:02PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 31, 2022 at 11:36:32AM -0800, Mat Martineau wrote:
> > On Mon, 31 Jan 2022, Greg Kroah-Hartman wrote:
> > 
> > > From: Paolo Abeni <pabeni@redhat.com>
> > > 
> > > [ Upstream commit 86e39e04482b0aadf3ee3ed5fcf2d63816559d36 ]
> > 
> > Hi Greg -
> > 
> > Please drop this from the stable queue for both 5.16 and 5.15. It wasn't
> > intended for backporting and we haven't checked for dependencies with other
> > changes in this part of MPTCP subsystem.
> > 
> > In the mptcp tree we make sure to add Fixes: tags on every patch we think is
> > eligible for the -stable tree. I know you're sifting through a lot of
> > patches from subsystems that end up with important fixes arriving from the
> > "-next" branches, and it seems like the scripts scooped up several MPTCP
> > patches this time around that don't meet the -stable rules.
> 
> I think these were needed due to 8e9eacad7ec7 ("mptcp: fix msk traversal
> in mptcp_nl_cmd_set_flags()") which you did tag with a "Fixes:" tag,
> right?  Without these other commits, that one does not apply and it
> looks like it should go into 5.15.y and 5.16.y.
> 
> Note, just putting a "Fixes:" tag does not guarantee if a commit will go
> into a stable tree.  Please use the correct "Cc: stable@vger.kernel.org"
> tag as the documentation asks for.
> 
> I'll go drop all of these mptcp patches, including 8e9eacad7ec7 ("mptcp:
> fix msk traversal in mptcp_nl_cmd_set_flags()") for now.  If you want
> them added back in, please let us know.

To be specific, I have dropped the following commits from the queues
now, which was more than just these three that you asked:

602837e8479d ("mptcp: allow changing the "backup" bit by endpoint id")
59060a47ca50 ("mptcp: clean up harmless false expressions")
86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
8e9eacad7ec7 ("mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()")
a4c0214fbee9 ("mptcp: fix removing ids bitmap setting")
9846921dba49 ("selftests: mptcp: fix ipv6 routing setup")

If you want them back, please let us know.

thanks,

greg k-h
