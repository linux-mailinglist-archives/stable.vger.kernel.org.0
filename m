Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760C41CFA35
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgELQML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 12:12:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35175 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbgELQMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 12:12:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7E1A75C0131;
        Tue, 12 May 2020 12:12:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 May 2020 12:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=WdxskVqADaciZoTeZ8HP8SyJhqq
        P2uyamPg5faf2kCQ=; b=cfYYlMQAktFvvlPOfy7eRgmQoU4SEx4RZN1zWe8uBXj
        MnlLOO9BdAcD7uWDU3RW4kY5yI+VOQceX3mrmCH6cTwui56IsWyf04PutZinpvj5
        buXZV9T99dZCKbRBVfhHYNrJfacOcxST4lMNSAextgSlFLkM0RoHFed+9smgB9e7
        Y9pm2b9otqlGyIt6xDdTQm6PAazpudWY5xvMhDQd/mZPkAdg4WvX2owTglTv0mVa
        kmjG4aCc1mcYe6HM3a9crAc0CwvhpjfIqnX+khGR3aFHOE+v/yCzGCuYSFkLG0Sg
        tBXUATaIOaLQWtWqfmm9cT1V0p2KwAd59WKKh2ZCX2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WdxskV
        qADaciZoTeZ8HP8SyJhqqP2uyamPg5faf2kCQ=; b=NuQTbPUUGPUNupkppJeQii
        eZ60S8wrvDopiEYMr1VRZ00x0yh4xreBJiC07GIl/y7G/JnYPDQXNrNECHea7jyT
        hP3ESDcd2tM6RPLcmYAxg+pY5iKKOxCWiI/7Syezwx3mulHtvZ4EqlBvCCEb0pD0
        OK3XrKoQZliQov2q+DajfKTO5TG6KbtczIYRWYd1dDJPxAliPn6ZBElltL/cf3Bu
        uTdujob2L2xQOdWFnMYm+f4AgW2bGs5CVuo4OSSHziR3zU96EBMVl8n2qly51XZJ
        qiFlIXLqkxQJwHawITc3KjyxYnPpYg4/AH1YHczqJ117R/0h6cjMVe162Ai4e1Zg
        ==
X-ME-Sender: <xms:2Mq6XvGo-l8eY975BrSbteps2SpAAISvFfb79f5KUXlq1kjIHT_Hgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:2Mq6XsWQpBU2Bnc8mFxq8IM4-n1x_m-6WzrwUIsHqecjGfktLH6PSw>
    <xmx:2Mq6XhL6HlQnOPyxb9P_mvQ5dKYqTULanxxODkXB9mfbJwlQQVbhXA>
    <xmx:2Mq6XtERWA-3OOPupt0DOIRNyA-TWBDFiLVTeBd2fM_ZGMxJNZ6FeQ>
    <xmx:2cq6XoRRnJOst4r2M6gS_igfgVrvCkht3CtOj5qf7nGe9VH9rOdudg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 927C730662C2;
        Tue, 12 May 2020 12:12:08 -0400 (EDT)
Date:   Tue, 12 May 2020 18:12:05 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ritesh Harjani <ritesh.list@gmail.com>, stable@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize
 < pagesize
Message-ID: <20200512161205.GA690441@kroah.com>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
 <20200329021728.GI53396@mit.edu>
 <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
 <20200512114533.GA54730@kroah.com>
 <61fb772b-75e2-f391-1a5f-044e573b38f7@gmail.com>
 <20200512125931.GA435853@kroah.com>
 <20200512141312.GP13035@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512141312.GP13035@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 10:13:12AM -0400, Sasha Levin wrote:
> On Tue, May 12, 2020 at 02:59:31PM +0200, Greg KH wrote:
> > On Tue, May 12, 2020 at 06:20:05PM +0530, Ritesh Harjani wrote:
> > > Hello Greg,
> > > 
> > > On 5/12/20 5:15 PM, Greg KH wrote:
> > > > On Mon, May 11, 2020 at 01:37:59PM +0530, Ritesh Harjani wrote:
> > > > > Hello stable-list,
> > > > >
> > > > > I think this subjected patch [1] missed the below fixes tag.
> > > > > I guess the subjected patch is only picked for 5.7. And
> > > > > AFAIU, this patch will be needed for 5.6 as well.
> > > > >
> > > > > Could you please do the needful.
> > > > >
> > > > > Fixes: 244adf6426ee31a (ext4: make dioread_nolock the default)
> > > > >
> > > > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=626b035b816b61a7a7b4d2205a6807e2f11a18c1
> > > >
> > > > This patch does not apply to the 5.6 kernel tree at all.  Please provide
> > > > a working backport if you wish to see it present there.
> > > 
> > > Sorry if that's the case.
> > > I tried both "git cherry-pick" and "git am" with patch mentioned @ [1]
> > > to apply on branch "remotes/linux-stable/linux-5.6.y" of tree
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > > and it applied cleanly.
> > > 
> > > Also, just noticed this patch in the queue. Is it that maybe you are
> > > trying to apply it twice?
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.6/ext4-don-t-set-dioread_nolock-by-default-for-blocksi.patch
> > 
> > Odd, it didn't have the "upstream" commit id, which is why I didn't see
> > that it was applied already.
> > 
> > Sasha, something went wrong with your scripts, you didn't sign-off on it
> > either :(
> 
> Crap, sorry. I'll fix it up.

I already did :)

