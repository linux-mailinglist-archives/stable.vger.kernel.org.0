Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2F53F61F5
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 17:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbhHXPrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 11:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238457AbhHXPrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 11:47:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A5BC061757;
        Tue, 24 Aug 2021 08:46:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mIYdB-0003aV-9w; Tue, 24 Aug 2021 17:46:29 +0200
Date:   Tue, 24 Aug 2021 17:46:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Gianluca Anzolin <gianluca@sottospazio.it>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Request for a backport to Linux v5.4
Message-ID: <20210824154629.GA6610@breakpoint.cc>
References: <c1088b68-1804-d009-9627-d649162cdfff@sottospazio.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1088b68-1804-d009-9627-d649162cdfff@sottospazio.it>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gianluca Anzolin <gianluca@sottospazio.it> wrote:

[ CC stable ]

> I'm writing to request a backport of the following commit:
> 
>    2e34328b396a netfilter: nft_exthdr: fix endianness of tcp option cast
> to the stable version of Linux v5.4.

Hello stable maintainers, can you please pick this change
for 5.4, 4.19 and 4.14?

It applies cleanly to all of those branches.
I'll leave rest as full-quote for context.

> This bugfix never landed to Linux v5.4: a later similar endianness bugfix
> (b428336676db) instead did (see commit 666d1d1a0584).
> 
> The aforementioned commit fixes an endianness bug in the mangling of the MSS
> tcp option for nftables.
> 
> This bug bites hard big-endian routers (MIPS for example) running the PPPoE
> stack and nftables.
> 
> The following rule:
> 
>     nft add rule ip filter forward tcp flags syn tcp option maxseg size set
> rt mtu
> 
> instead of changing the MSS value the one in the routing cache, ZEROES it,
> disrupting the tcp connections.
> 
> A backport would be nice because Linux v5.4 is the release used in the
> upcoming stable release of OpenWRT (21.02).
> 
> I already submitted a bug-report to OpenWRT a few weeks ago but I've got no
> answer yet maybe because they still use iptables as the default netfilter
> tool, even if they offer nftables as an alternative.
> 
> Still I think this bug should be fixed in the stable versions of the kernel.
> 
> This way it will also come to OpenWRT when they update the kernel to the
> latest minor version, even if the maintainers don't see the my bug report is
> ignored.
> 
> I'd like to thank you for the attention you paid to this message even if I
> probably didn't follow the right process for reporting the problem.
> 
> Regards,
> 
> Gianluca Anzolin
