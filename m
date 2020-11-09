Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F323C2AB520
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKIKix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:38:53 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53763 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:38:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 221E710D3;
        Mon,  9 Nov 2020 05:38:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:38:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=F2v/aqdgl6NzNY+sSz60/ToELQX
        BK9rtT6mYftxyLsU=; b=BaO6MJRpvt68dW8wrOHvEpX2LP2Xh630IA38FWQ+beR
        es1mVJGAwwaH187E0PvAyEGgBp3Vn2d7OrnecWdmi0+Q6K6KGFMsz4aySsAhgNa5
        U2Er84M8LDY9SVP6CRp43S5NNZ6EAXwe4HZFeAVC3txp67q65PKqn80Soh7UijOj
        nmgO5+ytlBQi7ObWvvCChQO5WYktgRu/gNv/fAMzK58ewxJW0vYwWE1pIDELlZfU
        DB4JLwT8x6BkeUIvxeTTXd51s6XIMCEiq2jpixq5pKWdASGtPzd+Yv4BPk0HJWnG
        MIAKpdpkL1+jWjgzYxJrBD4UxoQj4uqj25H9zGN454g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=F2v/aq
        dgl6NzNY+sSz60/ToELQXBK9rtT6mYftxyLsU=; b=pP8HOg1KnO+rDnxPyiPrZK
        qT2ESGyOZim6IxuT5m339vqDQb82brxSxU4yfNe1QJ9fsPRzgZ46TjdhH+ALBkrb
        hAlMADiReirtb6yrx9QwPo/Efk/4u0GHUUAYPc3m8Ba9OqWpgPqCjJCxwevql1JF
        c/lupYMGlDJJa64Oh0DK7vr0NyXZHO1caGzPrr7eTorhFpnbavDJs1gvXDgf6wKC
        1Z+1b+qlp9hphl8cvWFaQ6cn8j0LfjM7YF1yG8WNKPSP+BqB/HbR8a76AA2zXdZf
        mJFugmAubusA0/1umVGpA0TFTb5MeP/FtT6PIy8qICV/uqeOQNuWOXXtjXp8DLbA
        ==
X-ME-Sender: <xms:OhypX4DiUIhphEF1ZUUyt00E0EEyNRElBtWlaUxGmJZ38HNYiF1X9w>
    <xme:OhypX6iM5cs6iuAsDZaZk4b9CbJl6gmKNwxYHsXEFVaEi3bDxKCpiCdjmjysyGa4X
    eiOZWzMyAXr4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OhypX7krXF8WFcMp7PboDpDjJAsmHlD6bilQIJymS_zJGRI3QjdLHw>
    <xmx:OhypX-w_9mrAOclgXoPfT2j85sDGL56p-XwGOVLhN0TpZE2jOyHyWw>
    <xmx:OhypX9QDG5o5NQmTVWoWoMCTAkMSbjZZwa9iLeZTG-8SGs7hK8l8fA>
    <xmx:OxypX2JtSSL_of5pNFFPvEHSFisNNb_akahHT_8p0Dog3WNxqZcsew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0D953280065;
        Mon,  9 Nov 2020 05:38:50 -0500 (EST)
Date:   Mon, 9 Nov 2020 11:39:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Security Officers <security@kernel.org>,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] vt: Disable KD_FONT_OP_COPY
Message-ID: <20201109103951.GA1311133@kroah.com>
References: <20201107092857.3110264-1-daniel.vetter@ffwll.ch>
 <CAHk-=wjoTrpJcC+VKNwsOF+NFd+LANm_pydcFoaV9PscO0Ogaw@mail.gmail.com>
 <CAKMK7uFzGDe9vV8zef5kU6mS5W-0tTDw2KdUmMgbFJ=WT-F-RA@mail.gmail.com>
 <20201108161335.GB11931@kroah.com>
 <20201108183640.GA65130@kroah.com>
 <CAKMK7uHCSxAjcRR8oQRS5uL4i2-iLv38jiN8=7pntoNgQBu+bg@mail.gmail.com>
 <20201109095715.GA836082@kroah.com>
 <CAKMK7uEbioBvRggrprEvLB9MkQVoSburdneoEAHo7JmM4va9Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEbioBvRggrprEvLB9MkQVoSburdneoEAHo7JmM4va9Hw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 11:30:18AM +0100, Daniel Vetter wrote:
> On Mon, Nov 9, 2020 at 10:56 AM Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Nov 09, 2020 at 08:57:38AM +0100, Daniel Vetter wrote:
> > > On Sun, Nov 8, 2020 at 7:35 PM Greg KH <greg@kroah.com> wrote:
> > > > On Sun, Nov 08, 2020 at 05:13:35PM +0100, Greg KH wrote:
> > > > > On Sun, Nov 08, 2020 at 04:41:35PM +0100, Daniel Vetter wrote:
> > > > > > On Sat, Nov 7, 2020 at 7:41 PM Linus Torvalds
> > > > > > <torvalds@linux-foundation.org> wrote:
> > > > > > >
> > > > > > > On Sat, Nov 7, 2020 at 1:29 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > > > > >
> > > > > > > > It's buggy:
> > > > > > >
> > > > > > > Ack. Who is taking this? Should I do it directly, or expect this
> > > > > > > through Greg's tty/char tree, or what?
> > > > > >
> > > > > > I've sent out v2 with more archive links, typo in commit message fixed
> > > > > > and ack from Peilin added. I'll leave merging up to you guys. Note
> > > > > > that cc: stable still needs to be added, I left that out to avoid an
> > > > > > accidental leak.
> > > > >
> > > > > Great, I'll grab this now and add it to my tty tree and send it to Linus
> > > > > later today.
> > > > >
> > > > > Unless I should be holding off somehow on this?  I didn't see anyone
> > > > > wanting to embargo this, or did I miss it?
> > > >
> > > > Given that Minh didn't ask for any embargo, and it's good to get this
> > > > fixed as soon as possible, I've queued this up and will send it to Linus
> > > > in a few minutes.
> > > >
> > > > Thanks all for the quick response,
> > >
> > > cc: stable didn't get added I think.
> > >
> > > Stable teams, please backport commit 3c4e0dff2095 ("vt: Disable
> > > KD_FONT_OP_COPY") to all supported kernels.
> >
> > I was going to do that given that I am the same person :)
> 
> I thought there's some lts that aren't maintained by you?

Not anymore, no :(

> And distro teams who randomly still misalign with lts somehow ...

Those "teams" are so far out on their own, they insist they have their
own ways of devining which patches to apply and which to ignore that I
am pretty sure have nothing to do with the stable@ mailing list last I
was told.  But I could be wrong, anyway, no harm, I'd much rather be
reminded of things I'm already planning on doing than to miss anything,
thanks!

greg k-h
