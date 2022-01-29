Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78644A2E5D
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiA2LuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiA2LuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:50:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DAFC061714;
        Sat, 29 Jan 2022 03:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5EF660B90;
        Sat, 29 Jan 2022 11:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A80C340E5;
        Sat, 29 Jan 2022 11:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457023;
        bh=b3PezHkx1+Q3PCxr4Dpg/pQ/Te3NyogToMksuBzv2Ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxecUUxUCLo4bLF0G1bep128YUmBIjKdNNv2RsBaLB/nM/xzsVqtKx2PnlMQJTOea
         jwD2xPSNKT/kpp4R09dz9EIvJX1HX4TLXkJs4WF5SrdPPhrvnbYSVQKGHfyhZ+3/fu
         nHI0vZ82/YphnnpJtFesudQIAt9l/YbrvpUVA3aI=
Date:   Sat, 29 Jan 2022 12:50:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Weinreich <steve@weinreich.org>
Subject: Re: [PATCH 4.19.y] netfilter: nft_payload: do not update layer 4
 checksum when mangling fragments
Message-ID: <YfUp/K7ZQoKcvfn+@kroah.com>
References: <20220128113821.7009-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128113821.7009-1-fw@strlen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 12:38:21PM +0100, Florian Westphal wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> commit 4e1860a3863707e8177329c006d10f9e37e097a8 upstream.
> 
> IP fragments do not come with the transport header, hence skip bogus
> layer 4 checksum updates.
> 
> Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
> Reported-and-tested-by: Steffen Weinreich <steve@weinreich.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This is already in the 5.y branches but 4.19 needs a minor
>  tweak as ->fragoff member resides in xt sub-struct.

I don't see this commit in the 5.10 or 5.4 branches, am I missing
something?

confused,

greg k-h
