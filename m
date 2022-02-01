Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E111F4A5E4B
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 15:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbiBAOaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 09:30:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43626 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239290AbiBAOaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 09:30:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2524AB82E40;
        Tue,  1 Feb 2022 14:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEB5C340EB;
        Tue,  1 Feb 2022 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643725804;
        bh=LK3M1UPKH8Xi4QHEPqO7ltAiInjXSyuFuQP9KidhKTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ax3db2hxGyVvT2/SLAU3eI68dX+UrVrsz+9A24FYskvQFxPNDwHjFyG4lSvNRLzmD
         U7tvRsyd4hjglxez8Otsv21N3BEg+K2+8hNAgZgE4J30zpwQ1WIDpTKNirgd38JlFE
         7d/EfsG26egWgho0+mePu/eJJIgqNz0l1n0SgBa0=
Date:   Tue, 1 Feb 2022 15:30:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.16 138/200] mptcp: keep track of local endpoint still
 available for each msk
Message-ID: <YflD6pbqi/EGPG3f@kroah.com>
References: <20220131105233.561926043@linuxfoundation.org>
 <20220131105238.198209212@linuxfoundation.org>
 <26d216d1-355-e132-a868-529f15c9b660@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26d216d1-355-e132-a868-529f15c9b660@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:36:32AM -0800, Mat Martineau wrote:
> On Mon, 31 Jan 2022, Greg Kroah-Hartman wrote:
> 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit 86e39e04482b0aadf3ee3ed5fcf2d63816559d36 ]
> 
> Hi Greg -
> 
> Please drop this from the stable queue for both 5.16 and 5.15. It wasn't
> intended for backporting and we haven't checked for dependencies with other
> changes in this part of MPTCP subsystem.
> 
> In the mptcp tree we make sure to add Fixes: tags on every patch we think is
> eligible for the -stable tree. I know you're sifting through a lot of
> patches from subsystems that end up with important fixes arriving from the
> "-next" branches, and it seems like the scripts scooped up several MPTCP
> patches this time around that don't meet the -stable rules.

I think these were needed due to 8e9eacad7ec7 ("mptcp: fix msk traversal
in mptcp_nl_cmd_set_flags()") which you did tag with a "Fixes:" tag,
right?  Without these other commits, that one does not apply and it
looks like it should go into 5.15.y and 5.16.y.

Note, just putting a "Fixes:" tag does not guarantee if a commit will go
into a stable tree.  Please use the correct "Cc: stable@vger.kernel.org"
tag as the documentation asks for.

I'll go drop all of these mptcp patches, including 8e9eacad7ec7 ("mptcp:
fix msk traversal in mptcp_nl_cmd_set_flags()") for now.  If you want
them added back in, please let us know.

thanks,

greg k-h
