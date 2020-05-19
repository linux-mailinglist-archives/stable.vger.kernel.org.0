Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62B81D96AB
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgESMvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgESMvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 08:51:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C1152081A;
        Tue, 19 May 2020 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589892675;
        bh=tJ+lbCmEDAHdv4K7nzW2AGiccqfTHL/sgR11LJYMowM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KOn7WhNxFSpIXviYjpvQO4XlUs4zxHNOQNHtOF9l0dIC8oKRIjVRT4b2n6AdiJnOj
         KGPAlZ8Hn3Ktb33xTtAIo+O/4Av9SEoj9YTA3pQYQmFLh3kk4H44odDxnjJDq+s5Du
         bOh84qWov/p4rjtPDewSQJbdAoHDa4Jl1iataVvg=
Date:   Tue, 19 May 2020 14:51:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 41/80] netfilter: nft_set_rbtree: Introduce and use
 nft_rbtree_interval_start()
Message-ID: <20200519125113.GA376546@kroah.com>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173458.612903024@linuxfoundation.org>
 <20200519120625.GA8342@amd>
 <20200519121356.GA354164@kroah.com>
 <20200519121907.GA9158@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200519121907.GA9158@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 02:19:07PM +0200, Pavel Machek wrote:
> On Tue 2020-05-19 14:13:56, Greg Kroah-Hartman wrote:
> > On Tue, May 19, 2020 at 02:06:25PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > [ Upstream commit 6f7c9caf017be8ab0fe3b99509580d0793bf0833 ]
> > > > 
> > > > Replace negations of nft_rbtree_interval_end() with a new helper,
> > > > nft_rbtree_interval_start(), wherever this helps to visualise the
> > > > problem at hand, that is, for all the occurrences except for the
> > > > comparison against given flags in __nft_rbtree_get().
> > > > 
> > > > This gets especially useful in the next patch.
> > > 
> > > This looks like cleanup in preparation for the next patch. Next patch
> > > is there for some series, but not for 4.19.124. Should this be in
> > > 4.19, then?
> > 
> > What is the "next patch" in this situation?
> 
> In 5.4 you have:
> 
> 9956 O   Greg Kroah ├─>[PATCH 5.4 082/147] netfilter: nft_set_rbtree: Introduce and use nft
> 9957     Greg Kroah ├─>[PATCH 5.4 083/147] netfilter: nft_set_rbtree: Add missing expired c
> 
> In 4.19 you have:
> 
> 10373 r   Greg Kroah ├─>[PATCH 4.19 41/80] netfilter: nft_set_rbtree: Introduce and use nft
> 10376 O   Greg Kroah ├─>[PATCH 4.19 42/80] IB/mlx4: Test return value of calls to ib_get_ca
> 
> I believe 41/80 can be dropped from 4.19 series, as it is just a
> preparation for 083/147... which is not queued for 4.19.

I've queued it up for 4.19 now, thanks.

greg k-h
