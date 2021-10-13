Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C042C26F
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 16:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhJMOM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 10:12:26 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:35829 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233699AbhJMOMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 10:12:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 106D6580FBC;
        Wed, 13 Oct 2021 10:10:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 13 Oct 2021 10:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=a4NgNiwnDaVilTvex/1aQJzPrXC
        mauGoVnUaMUROL+E=; b=LSpGXXokWERNN3AUSWrfjX/yyip3Vc9F6mHA391eTnf
        aHZ13uiNzO9GAeG5cu7pkDz6ylP4C4sPOKi1l2seroJLLiJPhAgiieUmKx/W3NME
        FXctYY4xkgTykTe3wVcabT8C8ALpMu/E2w85BLYH7Bu2nXwbyuaPXJyqp4dijjOX
        ygZ4vWhfcWYTGxnctfy7S5Yn+RSvqVKoBwpFMI8NBhvvTqznMNs0JRloN+VAB7Nd
        g4Y9XoW83hUXNQA6p8z5OMPgbEut71bjC6eyM4dd1NSI7se44dh6ZOutHzYPzGJN
        VplkN3bOqwIkRJKGr9gdfm0wl2U7PKsHZpYegQE8RUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=a4NgNi
        wnDaVilTvex/1aQJzPrXCmauGoVnUaMUROL+E=; b=XWbSVBcKQ63WA2sVPeuAef
        zATGwzvci0+YDQn53/0MXr+zKIf977o0xW6ABASDoE2nIc+hJQRg72FDfMOvJkVl
        NalHRsWJVBfSvwAjZAvX1wcgh6Oc92Nax/VN/e8s111qTicIljygI98F2GSEWJjJ
        f9eff951pZiLUzw2CPafqnBhxab4vdV0fy6E7f+oPZ+jmktboO0NlMr3Da6vsbJ8
        8XhA+mA3nFQmLGQqsvFY/N6mM3iQ+skctqfXwQfeRYpjHUy+Brt3udtGWXpXnclg
        RF+JNYS/7iG+/0rb4rBpdwltkc+KK/Cqi0+4ZGPs4JBHzSTYUoX5tv5MPhEPBfwg
        ==
X-ME-Sender: <xms:zehmYXOWT5fPvETuSMHIZ-gvT183qxLwQjZr6__2yBkw1kuGnduasQ>
    <xme:zehmYR99CKIDQsg1hyiRAll-eE_XN66vwJmYRZNJphf5HJv0FJ67kAF9Pd01i0hXw
    ZgbxX7nJuJO_g>
X-ME-Received: <xmr:zehmYWR4-89ODCHmrJmNak4IEabMKhRFFjCQFHyqfbvFjtxkUUZRUqiPdg7D6uFXBPqzg73Un5eQhcW58TCX7MEnP-w0jwWa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zehmYbuGT3UYai2hgkuLlqJdKyebN3kcr2NopSRvkk5ydm7Du_12Bg>
    <xmx:zehmYfcjkABbvHW7LUpotaEfyi5hy6KfgWww1ARZ8e-iRr6x26ejvg>
    <xmx:zehmYX3WSZgfU_A692ZJ4Lx0uIF5IixyDWIEBuQREOgqnfFcMUmvMg>
    <xmx:zuhmYQWiM8FkFAiHRn4iIXHaxNNQdRtJzlTAo7LLPxbDfGRXcnrO9Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 10:10:21 -0400 (EDT)
Date:   Wed, 13 Oct 2021 16:10:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        stable-commits@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Patch "ext4: enforce buffer head state assertion in
 ext4_da_map_blocks" has been added to the 5.14-stable tree
Message-ID: <YWboy2pbJl6vXD+6@kroah.com>
References: <20211013113653.726356-1-sashal@kernel.org>
 <20211013135343.GA8994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013135343.GA8994@localhost.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 09:53:43AM -0400, Eric Whitney wrote:
> * Sasha Levin <sashal@kernel.org>:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     ext4: enforce buffer head state assertion in ext4_da_map_blocks
> > 
> > to the 5.14-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      ext4-enforce-buffer-head-state-assertion-in-ext4_da_.patch
> > and it can be found in the queue-5.14 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > 
> > commit b2838e02c515366e8452370fcda5baa2dcc8be68
> > Author: Eric Whitney <enwlinux@gmail.com>
> > Date:   Thu Aug 19 10:49:27 2021 -0400
> > 
> >     ext4: enforce buffer head state assertion in ext4_da_map_blocks
> >     
> >     [ Upstream commit 948ca5f30e1df0c11eb5b0f410b9ceb97fa77ad9 ]
> >     
> >     Remove the code that re-initializes a buffer head with an invalid block
> >     number and BH_New and BH_Delay bits when a matching delayed and
> >     unwritten block has been found in the extent status cache. Replace it
> >     with assertions that verify the buffer head already has this state
> >     correctly set.  The current code masked an inline data truncation bug
> >     that left stale entries in the extent status cache.  With this change,
> >     generic/130 can be used to reproduce and detect that bug.
> >     
> >     Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> >     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> >     Link: https://lore.kernel.org/r/20210819144927.25163-3-enwlinux@gmail.com
> >     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index fc6ea56de77c..d204688b32a3 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1726,13 +1726,16 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
> >  		}
> >  
> >  		/*
> > -		 * Delayed extent could be allocated by fallocate.
> > -		 * So we need to check it.
> > +		 * the buffer head associated with a delayed and not unwritten
> > +		 * block found in the extent status cache must contain an
> > +		 * invalid block number and have its BH_New and BH_Delay bits
> > +		 * set, reflecting the state assigned when the block was
> > +		 * initially delayed allocated
> >  		 */
> > -		if (ext4_es_is_delayed(&es) && !ext4_es_is_unwritten(&es)) {
> > -			map_bh(bh, inode->i_sb, invalid_block);
> > -			set_buffer_new(bh);
> > -			set_buffer_delay(bh);
> > +		if (ext4_es_is_delonly(&es)) {
> > +			BUG_ON(bh->b_blocknr != invalid_block);
> > +			BUG_ON(!buffer_new(bh));
> > +			BUG_ON(!buffer_delay(bh));
> >  			return 0;
> >  		}
> >  
> 
> 
> This patch should not be added to the stable tree, as it will be reverted in
> 5.15.
> 
> There have been two reports of unexpected kernel panics triggered by this code
> in kernels derived from 5.15-rc4, and the code will be removed for the time
> being until the root cause can be determined and corrected in a future release.

Now dropped from all stable queues, thanks.

greg k-h
