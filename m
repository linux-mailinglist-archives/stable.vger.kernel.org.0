Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC6B43CC6A
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbhJ0Okz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 10:40:55 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:33727 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233962AbhJ0Oky (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 10:40:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D86C1580593;
        Wed, 27 Oct 2021 10:38:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 10:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=EQW6ogjIJGDseBKZUZlDLFw/kgn
        I54KQm+3+JLexLeQ=; b=uvkRd6h6Z3Um1spyfD5prX7NogFRDqd00IzR6h9MCbi
        KpPsIyfw1eDNUtGsNF4NMP3hyYfOjG01KsHU2kGY1elvdUvYUxHqrJPI6f7oDbeE
        NiQQMyXvFdGr5axZW/jiOqVKH2gnUj+WAoBbBEgib2skoaFACaZ1bKVJr/oGOcMV
        qislhj+yviX7gjHE7ngXx0dKFzBxZpzFhgJpcYI/qjERefgmMvHAf4ixR++bnjWs
        OsoDkW8z0ZrjiPFN6z+SrQuFtMGFKTJdAgOvQxLNp22JkLK/UOX/aqOirTrB4W3V
        8WBCmr7MbTjfCncmJ2lVJ3PK+kFifFY7R2gjKz7P5yQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=EQW6og
        jIJGDseBKZUZlDLFw/kgnI54KQm+3+JLexLeQ=; b=TtnoLK8NH2i9K7POTI4lJg
        RAiELU7JDt/WJqrX/wSSMUOrf41saz3QfqnpITWqOuqGqLHGtKUdEM7b4oupVxFa
        HTqRaX6+U5Jvou/dsu58F1VipvyNpo0FI98zPeB3IDY66Z/DFTMZQSAknqjFlNvG
        ZfS1vpnskGBpXgE+E1XjM9uSlUWCgl//72XUjuZZPx3kIxztVA1Wt6LYXVsHVmBT
        ZuW2GH9KDtkyF9r+f8sfF+qv6nuW2DtYoMoRDf9oen1UuAXWH7yy/Z0ihQjYqymJ
        wcYD3qWhSedZj7Y/EHZzOfZBGgyTAbpWb5d6+yZHBbfjG+5vXPO69LB297zmfiQg
        ==
X-ME-Sender: <xms:ZGR5Yc64IzHl17nYyIuXFtALShF3rB_CfiTSzpC1XtpazIVGQzBQrQ>
    <xme:ZGR5Yd7fHE6cV7J5m6-Z-QG1O6k53y0Txta45dqKAArko9d26cqdEDrjy7-PId5vE
    Wm48OfQ1fBuIg>
X-ME-Received: <xmr:ZGR5YbcddQ_82u0wClpsHvXNn9YCLbyYK8c2zGsE5rQRZHFlMarVLA2160zb6-lDMxBNrsZ-6MQThA2l_mqjcn9sJZf1ZOCi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZGR5YRJ9JykGewDtlddn7dSQuTBqe9rojq16uGlY8aGR7ChUisTZrQ>
    <xmx:ZGR5YQIxCiUyyNg1NLFB91XYfjkOh7iIj2cRSm0zSYJn4byUvn_pkg>
    <xmx:ZGR5YSxGHVjT911ASZFHR5gTFQb3rbIsJoZGi08bSbOdEXd8ipGLuw>
    <xmx:ZGR5YdAHRwFXNcc53UiQU_f1aQWf21GXrPtKBzBLd_WjrnV-WqnnXQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 10:38:28 -0400 (EDT)
Date:   Wed, 27 Oct 2021 16:38:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXlkYWPlz3TwNH7Z@kroah.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
 <YXkP533F8Dj+HAxY@google.com>
 <YXkThoB6XUsmV8Yf@kroah.com>
 <YXkVxVFg8e5Z33zV@google.com>
 <YXlKKxRETze45IPv@kroah.com>
 <YXlbdJRa6kTu2GEz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXlbdJRa6kTu2GEz@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 03:00:20PM +0100, Lee Jones wrote:
> On Wed, 27 Oct 2021, Greg KH wrote:
> 
> > On Wed, Oct 27, 2021 at 10:03:01AM +0100, Lee Jones wrote:
> > > On Wed, 27 Oct 2021, Greg KH wrote:
> > > 
> > > > On Wed, Oct 27, 2021 at 09:37:59AM +0100, Lee Jones wrote:
> > > > > On Wed, 27 Oct 2021, Greg KH wrote:
> > > > > 
> > > > > > On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > > > > > > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > > > > > > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > > > > > > hunk of commit which does so.
> > > > > > 
> > > > > > Why can't we take all of that commit?  Why only part of it?
> > > > > 
> > > > > I don't know.
> > > > > 
> > > > > Why didn't the Stable team take it further than v5.11.y?
> > > > 
> > > > Look in the archives?  Did it not apply cleanly?
> > > > 
> > > > /me goes off and looks...
> > > > 
> > > > Looks like I asked for a backport, but no one did it, I only received a
> > > > 5.11 version:
> > > > 	https://lore.kernel.org/r/1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com
> > > > 
> > > > so a 5.10 version would be nice, as I said it failed as-is:
> > > > 	https://lore.kernel.org/all/161460075611654@kroah.com/
> > > 
> > > Precisely.  This is the answer to your question:
> > > 
> > >   > > > Why can't we take all of that commit?  Why only part of it?
> > > 
> > > Same reason the Stable team didn't back-port it - it doesn't apply.
> > > 
> > > The second hunk is only relevant to v5.11+.
> > 
> > Great, then use the "normal" stable style, but down in the s-o-b area
> > say "dropped second chunk as it is not relevant to 5.10.y".
> 
> Just to clarify, by "normal", you mean:
> 
>  - Take the original patch
>  - Apply an "[ Upstream commit <id> ]" tag (or similar)
>  - Remove the hunk that doesn't apply
>  - Make a note of the aforementioned action
>  - Submit to Stable

Yes.

> Rather than submitting a bespoke patch.  Right?

Correct.

thanks,

greg k-h
