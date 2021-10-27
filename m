Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143F443CA00
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241980AbhJ0MtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 08:49:05 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57741 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241986AbhJ0MtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 08:49:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 78ACB5804E6;
        Wed, 27 Oct 2021 08:46:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 27 Oct 2021 08:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=29V71h8BhQBo3sqoWQpAuVgqsrL
        ReneVZFweoMQBIu4=; b=ZK5brb0K3eqJ8GVIQBs5mwJ8sq/VB5nEfzN80TuvOui
        A3ysAVaBSHx9KjX6OjPwWH9hKABUc8u1MvB6T26BN29qBMpQu0grmmIlKkTx+ozM
        LWrcXgMALqxp4Sx10gbrNt86AP1BYPR3OxreC7Mi1zuXFKti4hptnEI5xAwubc4N
        K1UoYdzIUS+QaraymjMrnSNa5kN6b+K2BvyeMoN49LoqdPBjMUFjbd4iW3mU/lV4
        +pJNYAAYZzbCumu3yYbaG+4fU9+kKJIswxWPdPRExWJkdbj/75UTGQ7f803yr78r
        UJvrylLccdRSQyb5mi9HGbfw+BulBZi1RjBdbLYxbUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=29V71h
        8BhQBo3sqoWQpAuVgqsrLReneVZFweoMQBIu4=; b=ZsB/voN52dwQ+95upqa7Dm
        uToXwOhKEA88mcgbmeVnje0utbEhSiOuazd0fJkEY7++RWFxrxqyyyjhJ75PB1yj
        NGJ5TEbbEu2xsUDK9jApUnk3lzK3tLKYgCTCkuN9ISoDw+uC7vlXO3ksGYeEWwsb
        W2r7qiSOc7zLVS+VvhGHAMf3oHrj9nu2iNL/zzlIJ2ieUBXUXN8ZtTDQshH6RnlE
        EC0YigYUrtzAzfPwBtsV4s6Kl1U73aBANBQjRhJmxP07RnnXdtrxg6NUhWgpmS9N
        qdf6U8LA/vf/2Um0Wq7kqDP2OSB8t2rAruU3FTKay3cyUouxEIfBkC5M9ugR67uw
        ==
X-ME-Sender: <xms:Lkp5YRfPt6cNJ-cbk3yno2jzaZZ0K42F7muv-qUd1t4t5ft5YR7aow>
    <xme:Lkp5YfPye7AFhCy2y8yWZqJWCCK6ve6d1eZ10oTm1BMms7sAMJaDOqxrzFPlkJJJT
    SYTXcrOgepw_A>
X-ME-Received: <xmr:Lkp5YagbcSrL6fsGcRUeD4ZuCwF2UDAq04g6dnOTWvIt_-SQdM2iL4Aid-0d4ZaH9FLXAMJ0wzils40JfudFxYe3zqBl9VCz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Lkp5Ya8ixSS8edVzmcyJmsBDCw48J9xF3dXTVbztIEm_Z0KKpT9xzw>
    <xmx:Lkp5YdvCsLyNBO5vQWwIpvNB8BOPC_GC_650XOdG-ixe3fJpCgz31g>
    <xmx:Lkp5YZFVHjMOZYYgeEG000zLIgfr6ABUsmyfyqaT8Ej01YzqE_wCVg>
    <xmx:Lkp5YenBCUZUUxWKEkl_Ol0rvf9C4QzDF7HBOjaiFhPntescQggYDQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 08:46:37 -0400 (EDT)
Date:   Wed, 27 Oct 2021 14:46:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXlKKxRETze45IPv@kroah.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
 <YXkP533F8Dj+HAxY@google.com>
 <YXkThoB6XUsmV8Yf@kroah.com>
 <YXkVxVFg8e5Z33zV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXkVxVFg8e5Z33zV@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 10:03:01AM +0100, Lee Jones wrote:
> On Wed, 27 Oct 2021, Greg KH wrote:
> 
> > On Wed, Oct 27, 2021 at 09:37:59AM +0100, Lee Jones wrote:
> > > On Wed, 27 Oct 2021, Greg KH wrote:
> > > 
> > > > On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > > > > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > > > > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > > > > hunk of commit which does so.
> > > > 
> > > > Why can't we take all of that commit?  Why only part of it?
> > > 
> > > I don't know.
> > > 
> > > Why didn't the Stable team take it further than v5.11.y?
> > 
> > Look in the archives?  Did it not apply cleanly?
> > 
> > /me goes off and looks...
> > 
> > Looks like I asked for a backport, but no one did it, I only received a
> > 5.11 version:
> > 	https://lore.kernel.org/r/1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com
> > 
> > so a 5.10 version would be nice, as I said it failed as-is:
> > 	https://lore.kernel.org/all/161460075611654@kroah.com/
> 
> Precisely.  This is the answer to your question:
> 
>   > > > Why can't we take all of that commit?  Why only part of it?
> 
> Same reason the Stable team didn't back-port it - it doesn't apply.
> 
> The second hunk is only relevant to v5.11+.

Great, then use the "normal" stable style, but down in the s-o-b area
say "dropped second chunk as it is not relevant to 5.10.y".

thanks,

greg k-h
