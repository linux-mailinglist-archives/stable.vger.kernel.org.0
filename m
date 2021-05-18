Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C600387A0E
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 15:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349670AbhERNfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 09:35:34 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:48565 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349539AbhERNfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 09:35:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 6481813A3;
        Tue, 18 May 2021 09:34:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 18 May 2021 09:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=wgrrsLoj4Unfv9rO+Z97PvhymNn
        Aksc3e14zYpEaaIo=; b=gLMk2gy3pEdHNYtopPSu/wie58FMREv3VXf4GnJfkeV
        ibg7K0kVYY1AfgT8cyQ8q+1Jae/Mu/KlDFWiqnt/MNntRdr24qPrhBGoHiFWfLIi
        vNTJnFpT+Jk6siP9eGD8b0IC3PA5DLhp0n2SBFZX6b7DwkjTnyTCwlIeh5aaEmJu
        IBkT5QTP7OEz5pECePv/ka44k9JVDrYRuZ0vN/KUljSJX2o2tGBjlgiVbxsX9IKy
        4FqYM6YpaCrCAgqxx+J2ZDNg7TmQtPbAmI1wLQx4VGMgvRIOZIKatrIFJIDQqb1/
        cPFTKb1abMyCI7acLR9msPT5vE4Ic3mPIUC709JYdSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wgrrsL
        oj4Unfv9rO+Z97PvhymNnAksc3e14zYpEaaIo=; b=LsgcTb8A20y58XE3hYh6AD
        z2ce8sD59CEW0KbvKF64wc92oM+g2BE92ema/xck6Paf8N24ybB31rH6gpVIjuU6
        HDmetafe0KHM7JiFKfKwBzhdfPQKRj2ATcgCw9lxpBAuwjUUbqrnEQYAwnZfNkIn
        dTeid5bI9+51sBMgWyQamn0jvVnUhOzWFrdIBwAov9WSEHoX1ftdZR+xmdrNSpme
        +Jm0RUTwPKhEXBtGLfCOYga/LsLEieA92rZWi7Kk9rXPvUGwGzWWxDb++KkRjELA
        SY3x3iUKz+SRMed34L6SXDamAINB2SJTlpHCNR75Ck0H+xOQJYmi/7SvEuHUQ19g
        ==
X-ME-Sender: <xms:VcKjYLQoDyWuqk1NVkAeryNyMTfGkOmuOTHtfG_yBAMqr0FrQG5cvQ>
    <xme:VcKjYMwo7EsGm6hXwKOPYV9gh6IvT8PQvhYKm8Q5Z4GA5MH2xs28t20Sa2SE80bS3
    vJ3AkvQz1BZIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeijedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VcKjYA3_pPuHYxX6Q4-1_5OpcAVQrkMgFiSPK-OMcVgV7SZXeBYCyA>
    <xmx:VcKjYLCyRQ0U6EW60F4-5pRSTWEPrKH1KWnHkDNo6s6lat_3Ly3nPQ>
    <xmx:VcKjYEj5utsT_IFFi77c_MRpAZIBDVYDeC9zZ1Tx3VFCbovZr1puaA>
    <xmx:V8KjYDQ5QJCgwLIDvtM5dRjj4qwLH55bd2Q-l5uDq_q2bpnuka668WfKtaU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 09:34:13 -0400 (EDT)
Date:   Tue, 18 May 2021 15:34:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+1f29e126cf461c4de3b3@syzkaller.appspotmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.12 5/5] tty: vt: always invoke
 vc->vc_sw->con_resize callback
Message-ID: <YKPCU8NkdoterrXA@kroah.com>
References: <20210518010940.1485417-1-sashal@kernel.org>
 <20210518010940.1485417-5-sashal@kernel.org>
 <CAHk-=whw9_rp0NYTsCqcGnUkcV5Qgv7FTxADtPrdq4KFmsj+Lg@mail.gmail.com>
 <YKNUl/f/c8HfF6dS@kroah.com>
 <YKO/qKRwPYJF7ols@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKO/qKRwPYJF7ols@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 09:22:48AM -0400, Sasha Levin wrote:
> On Tue, May 18, 2021 at 07:45:59AM +0200, Greg KH wrote:
> > On Mon, May 17, 2021 at 06:35:24PM -0700, Linus Torvalds wrote:
> > > On Mon, May 17, 2021 at 6:09 PM Sasha Levin <sashal@kernel.org> wrote:
> > > >
> > > > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > >
> > > > [ Upstream commit ffb324e6f874121f7dce5bdae5e05d02baae7269 ]
> > > 
> > > So I think the commit is fine, and yes, it should be applied to
> > > stable, but it's one of those "there were three different patches in
> > > as many days to fix the problem, and this is the right one, but maybe
> > > stable should hold off for a while to see that there aren't any
> > > problem reports".
> > > 
> > > I don't think there will be any problems from this, but while the
> > > patch is tiny, it's conceptually quite a big change to something that
> > > people haven't really touched for a long time.
> > > 
> > > So use your own judgement, but it might be a good idea to wait a week
> > > before backporting this to see if anything screams.
> > 
> > I was going to wait a few weeks for this, and the other vt patches that
> > were marked with cc: stable@ before queueing them up.
> 
> I'll drop it from my queue then.

Thanks!
