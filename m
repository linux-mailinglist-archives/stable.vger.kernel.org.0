Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD37387167
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 07:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhERFrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 01:47:24 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:53211 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234640AbhERFrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 01:47:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 80CC758123F;
        Tue, 18 May 2021 01:46:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 18 May 2021 01:46:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Jbmf4WRhsfHsu1LE7NMnVkzakBi
        NS33xX0ldvnGydxc=; b=m5XlY1eLYX5EHnTiBxtOk4EshiYNVV3/JPAOwinAIwa
        Pc+bAQCoQtepYB796CC/fqOlyQOoh6RVY4sfO8iMzDSxZ+B4Hbclnh2GLi3s0+gO
        WRk1R+YxsNdmGADB1QsaRxUk+H9M7HXcVkFav54WBhPsT1PShI5TEgVLgh3x6bFJ
        XPsy5a5VUWHVah2NyrIdB6Jh3iMxhdY8H6pj6SyPNCYLAH7lr+5J2uE8YicjRWfb
        CpFGn2sx9lqNyJF2J9ocQxH1MgUzJb1Odm4bsPR+414gBKqr3UN7YxwJpBcX5RpU
        4Y5B02nDdGgp3XrJRBZpxf2ZDkLEt4UQAUifDmoyB7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Jbmf4W
        RhsfHsu1LE7NMnVkzakBiNS33xX0ldvnGydxc=; b=U3ykAomG81+5MrN9HJXlfm
        Muv1aJdWzVZ1O9GppD6WDRH9LNKMcLpSDSup24DRIxsmAJ+4qPWy81Kut8VErFtP
        DPLteZbxv/Vn9DcAs5zJyR/NSU6HaOWMTLMBTr/HIRbWdHBEK7IvhMPjWNx5LM3W
        OyKb1kSiYsH37IWAGCdt3MjAh270GR+SusI/U6LdJf5adKXYmfyeuRVE0bb3LXzz
        NplM5kt7wJVAC3BY8gCrwClfNks8r26aTPUpfbz6CBDcGYyKZKPAdxNol+/1lLdP
        o+MNWONlm4JqyzyR5iXOIJ6MVE5Tf6e0WdpZhrqa00POdryO4lYPNOHvaanF2M2g
        ==
X-ME-Sender: <xms:nVSjYGYH_rNflfC5QpS_SWitCwRtBl2Lv02cxI40ujktJfgJ6otVHg>
    <xme:nVSjYJbmzGtQIu-3MyWuNuwuHCZ4m5z4EFqAYJqOF0CNZ0MyApgxyUCrP7WBatb1J
    LO9EHKugizdXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiiedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nVSjYA9KEZtikOS7goNVrTzwaGgoOP7eCXVRS34eJqQCCOEfP93Pog>
    <xmx:nVSjYIpunRuXAGI1vhnfuaUDogPsrtr0o8Wg-fCxEOTBwJbRSWih0g>
    <xmx:nVSjYBrR0wIKVHBPWxFSqDMdT_iQtEvubgXAOonvKzePxi7qGcwI3A>
    <xmx:nlSjYC5roDjwitsOwJ4iCXjBv_cfJkbbL20F62TFs5OMo2_3B1sYqg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 01:46:05 -0400 (EDT)
Date:   Tue, 18 May 2021 07:45:59 +0200
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
Message-ID: <YKNUl/f/c8HfF6dS@kroah.com>
References: <20210518010940.1485417-1-sashal@kernel.org>
 <20210518010940.1485417-5-sashal@kernel.org>
 <CAHk-=whw9_rp0NYTsCqcGnUkcV5Qgv7FTxADtPrdq4KFmsj+Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whw9_rp0NYTsCqcGnUkcV5Qgv7FTxADtPrdq4KFmsj+Lg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 06:35:24PM -0700, Linus Torvalds wrote:
> On Mon, May 17, 2021 at 6:09 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >
> > [ Upstream commit ffb324e6f874121f7dce5bdae5e05d02baae7269 ]
> 
> So I think the commit is fine, and yes, it should be applied to
> stable, but it's one of those "there were three different patches in
> as many days to fix the problem, and this is the right one, but maybe
> stable should hold off for a while to see that there aren't any
> problem reports".
> 
> I don't think there will be any problems from this, but while the
> patch is tiny, it's conceptually quite a big change to something that
> people haven't really touched for a long time.
> 
> So use your own judgement, but it might be a good idea to wait a week
> before backporting this to see if anything screams.

I was going to wait a few weeks for this, and the other vt patches that
were marked with cc: stable@ before queueing them up.

thanks,

greg k-h
