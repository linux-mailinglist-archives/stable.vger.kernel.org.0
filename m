Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D7F4A2FE4
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiA2NwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:52:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48584 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiA2NwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:52:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74963B82772;
        Sat, 29 Jan 2022 13:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A839FC340E5;
        Sat, 29 Jan 2022 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643464329;
        bh=jbC1G8zj9PfHRZhpdgdt8Yi/IsE/Dllp8L0x1k4vAaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vFwWYh+nEzdAi5cpMmdgOdc16/XQKPG8WOo6yVJU33hyfFPRIM+2K5it08yMzurkb
         3HoytuL12NLD2HB8Zw17D2k/7+gmTqk60h6lgVqcnw21Xe9f8Yu8yx+57lWDFfmCO7
         kvM9Fvpw+Qs6KfB95Sj9cSAqXGyGnryZj34IdutI=
Date:   Sat, 29 Jan 2022 14:52:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Weinreich <steve@weinreich.org>
Subject: Re: [PATCH 4.19.y] netfilter: nft_payload: do not update layer 4
 checksum when mangling fragments
Message-ID: <YfVGhmlZMs6fH/cJ@kroah.com>
References: <20220128113821.7009-1-fw@strlen.de>
 <YfUp/K7ZQoKcvfn+@kroah.com>
 <20220129120444.GJ25922@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220129120444.GJ25922@breakpoint.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 01:04:44PM +0100, Florian Westphal wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jan 28, 2022 at 12:38:21PM +0100, Florian Westphal wrote:
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > commit 4e1860a3863707e8177329c006d10f9e37e097a8 upstream.
> > > 
> > > IP fragments do not come with the transport header, hence skip bogus
> > > layer 4 checksum updates.
> > > 
> > > Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
> > > Reported-and-tested-by: Steffen Weinreich <steve@weinreich.org>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > >  This is already in the 5.y branches but 4.19 needs a minor
> > >  tweak as ->fragoff member resides in xt sub-struct.
> > 
> > I don't see this commit in the 5.10 or 5.4 branches, am I missing
> > something?
> 
> Oh, indeed.  Can you place this patch in 5.4 and 5.10 too?

Now done, and it was needed for 4.14.y, so I added it there too, thanks!

greg k-h
