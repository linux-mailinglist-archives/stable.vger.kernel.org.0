Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC14A2EBD
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243759AbiA2MEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243421AbiA2MEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:04:47 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE95C061714;
        Sat, 29 Jan 2022 04:04:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nDmTE-0002d5-1M; Sat, 29 Jan 2022 13:04:44 +0100
Date:   Sat, 29 Jan 2022 13:04:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Weinreich <steve@weinreich.org>
Subject: Re: [PATCH 4.19.y] netfilter: nft_payload: do not update layer 4
 checksum when mangling fragments
Message-ID: <20220129120444.GJ25922@breakpoint.cc>
References: <20220128113821.7009-1-fw@strlen.de>
 <YfUp/K7ZQoKcvfn+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfUp/K7ZQoKcvfn+@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jan 28, 2022 at 12:38:21PM +0100, Florian Westphal wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > commit 4e1860a3863707e8177329c006d10f9e37e097a8 upstream.
> > 
> > IP fragments do not come with the transport header, hence skip bogus
> > layer 4 checksum updates.
> > 
> > Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
> > Reported-and-tested-by: Steffen Weinreich <steve@weinreich.org>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  This is already in the 5.y branches but 4.19 needs a minor
> >  tweak as ->fragoff member resides in xt sub-struct.
> 
> I don't see this commit in the 5.10 or 5.4 branches, am I missing
> something?

Oh, indeed.  Can you place this patch in 5.4 and 5.10 too?

Releases >= v5.14 should be covered given upstream commit works
as-is on those.

Thanks,
Florian
