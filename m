Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83294059B5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 16:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhIIOxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 10:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234825AbhIIOxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 10:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8180611C4;
        Thu,  9 Sep 2021 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631199131;
        bh=RyhDqSo7eVr3/i568r1sAmNdegNoHFaEVoEM74z862w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nunu8xLSr1u7Y+G9wACVI6lfRkdoyVtp1QFlMvjpdCK/kJUjLTS6KxiqYsMhx/FhO
         MwLT5iwm5ATUwY7+irIQ5uvJdXrADbgx3vxeOG5MiPpqQvU8ZlLj4sQji3BDmLE0o0
         cE/OXOeNZozOayi0OumA0HzW5T92V4Fm0s/hfDvQ=
Date:   Thu, 9 Sep 2021 16:52:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5.10.y 0/3] netfilter: nf_tables fixes for 5.10.y
Message-ID: <YTofmaFaPAtGLFs8@kroah.com>
References: <20210909140337.29707-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909140337.29707-1-fw@strlen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 04:03:34PM +0200, Florian Westphal wrote:
> Hello,
> 
> please consider applying these nf_tables fixes to the 5.10.y tree.
> These patches had to mangled to make them apply to 5.10.y.
> 
> I've done the follwoing tests in a kasan/kmemleak enabled vm:
> 1. run upstream nft python/shell tests.
>    Without patch 2 and 3 doing so results in kernel crash.
>    Some tests fail but afaics those are expected to
>    fail on 5.10 due to lack of feature being tested.
> 2. Tested the 'conncount' feature (its affected by last patch).
>    Worked as designed.
> 3. ran nftables related kernel self tests.
> 
> No kmemleak or kasan splats were seen.
> 
> Eric Dumazet (1):
>   netfilter: nftables: avoid potential overflows on 32bit arches
> 
> Pablo Neira Ayuso (2):
>   netfilter: nf_tables: initialize set before expression setup
>   netfilter: nftables: clone set element expression template
> 
>  net/netfilter/nf_tables_api.c | 89 ++++++++++++++++++++++-------------
>  net/netfilter/nft_set_hash.c  | 10 ++--
>  2 files changed, 62 insertions(+), 37 deletions(-)
> 
> -- 
> 2.32.0
> 

All now queued up, thanks!

greg k-h
