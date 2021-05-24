Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD438E614
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhEXMCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:02:50 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44305 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232819AbhEXMCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:02:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5796F58270C;
        Mon, 24 May 2021 08:00:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 24 May 2021 08:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=9b68iKsk8DPJHoYxXOYWybMr7+T
        fDaS+j0bppFnZpLo=; b=aYxbuGTfofOqjr3l46ffYuGleIRL9XBMhQT9Zgknwgw
        26NkeNlothDsGmm8UFEZmbC+pKj3pmmsMdvMsNNcbq2zPbYxcjxAb7tpLZu82mVE
        O/EHyv/z8hMS3yhLHIufw1U1MYjzY5hPEH2uflSCkBXwCThXDRgsrx9R5dt4PBms
        5JJlgeFs4/jd+O1Rn2PSON4UBWvpiOTeVDLWdlmZTDBuY+py9ADefYRG6W41HKVF
        fG7wd9888EWenY7VaqPCI7XN8C5qUHZxSKs/aPHP8WI+o+L9z33VGny19xj4GfsL
        vURJYFnKkHrkEYdf+wAtdXaoZMhVtLxar6e0BLVrJ3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9b68iK
        sk8DPJHoYxXOYWybMr7+TfDaS+j0bppFnZpLo=; b=EpqzaZa8hQY2XMl+bD4Ibs
        5J6Vx3hDVHqcdvcNMW8piRtpH0jcqRY3Os4gGw/ygc9Ue3EDY+ZGeaMttHDw9ciJ
        09La2Xqx/wwAwsCJcAol9yS9QLLCN9I0IF7b6O9k17OO78KXEtu069hJROzdpt/g
        3/V+2952OmNHIF/VqPdc/rRa9+cqwPjje6Beqw7F9oVxOc0Z+vPuDmZijV2Mi1Ac
        iSMzezWYvVFQe/UBgvC3dAsnyjYW2SdO3TZ1Ti6SyXiUFcSld9G5Ibp8bujTtOij
        gyd6TB0DeFCOKA4aK/aIj+kuiU0jUua8KrPV/ulBca0yepvFhHsGahk44NTtHA8g
        ==
X-ME-Sender: <xms:d5WrYLCt6JBEFXq5dMXTK_K1Q3FLgT31oN4r4jvVxsWpYdRzh2sMhw>
    <xme:d5WrYBgwVMUKI1qPW2FOMwhRCGrI4CWiJcTRDO2pR4nI12yvgQDgdvITGSUaKwxL_
    olHgkLdI1pLXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:d5WrYGlijsWGTkjJsz5c8gLwDWUyzsmaUSUivmTlzpiqr6F_oM71dg>
    <xmx:d5WrYNyouRWKitd-ArnyUUpxd_X5AfNFLeJGgqx16xtp0wSxBgmYYw>
    <xmx:d5WrYARS1ryrICK-Xz-tJKA-ewqwE7h5Ph_p_hAkTQKHVSNbjYDu9Q>
    <xmx:eJWrYCD5kumaSPNhpAhDiLvUVssdoO1Xu-KGyHyCq4R9iZDe2TpjIQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 08:00:54 -0400 (EDT)
Date:   Mon, 24 May 2021 14:00:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.12 5/5] tty: vt: always invoke
 vc->vc_sw->con_resize callback
Message-ID: <YKuVaUJFp0K929k+@kroah.com>
References: <20210518010940.1485417-1-sashal@kernel.org>
 <20210518010940.1485417-5-sashal@kernel.org>
 <CAHk-=whw9_rp0NYTsCqcGnUkcV5Qgv7FTxADtPrdq4KFmsj+Lg@mail.gmail.com>
 <YKNUl/f/c8HfF6dS@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKNUl/f/c8HfF6dS@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 07:45:59AM +0200, Greg KH wrote:
> On Mon, May 17, 2021 at 06:35:24PM -0700, Linus Torvalds wrote:
> > On Mon, May 17, 2021 at 6:09 PM Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > >
> > > [ Upstream commit ffb324e6f874121f7dce5bdae5e05d02baae7269 ]
> > 
> > So I think the commit is fine, and yes, it should be applied to
> > stable, but it's one of those "there were three different patches in
> > as many days to fix the problem, and this is the right one, but maybe
> > stable should hold off for a while to see that there aren't any
> > problem reports".
> > 
> > I don't think there will be any problems from this, but while the
> > patch is tiny, it's conceptually quite a big change to something that
> > people haven't really touched for a long time.
> > 
> > So use your own judgement, but it might be a good idea to wait a week
> > before backporting this to see if anything screams.
> 
> I was going to wait a few weeks for this, and the other vt patches that
> were marked with cc: stable@ before queueing them up.

I have now queued all of these up.

greg k-h
