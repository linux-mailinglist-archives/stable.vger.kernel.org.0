Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134359F27A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfH0Sjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:39:46 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50555 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729779AbfH0Sjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 14:39:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 101C528AD;
        Tue, 27 Aug 2019 14:39:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 27 Aug 2019 14:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=2Pi2UrTYWIZeSLhHDsmgNc73uGU
        Eowqv9oRu+ZwsHGA=; b=ERL0kigPYO3OOz4tGQ+vEqkqh0JtqzICMMQfqdWbcU/
        rytJcRaMGrU/T8owYvdVPhUKoDWhD0/ZOr1Z5wHQJE4Ug5/TmRzTt9/72pfzgiuL
        Du1v8YcF7vi673FsOfHS3CwrD8BfytsPXZ9rD/wJe94ok9QIYzCYWXR7DkiwCU+T
        cV7GGZDxvYZilkzclYwbHDf0a2VdjdCZJAOfJmPhaSHd7Yy1qGF3j1/edzsYmCHx
        2DK47P8o90y3AcG9b8cWDMNx+XtBlahTB7SptqEo+PDdnYp+1uBj4YlurE/1aSjD
        PmGDvqUtiNwcDXRucyXs/4vxz96WbU2QwLrkUr3ue8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2Pi2Ur
        TYWIZeSLhHDsmgNc73uGUEowqv9oRu+ZwsHGA=; b=wMTir3CHsmW0knAj4jGavl
        VA3aikjJIy/f6GBK9UNZuaKk7Whb35zv9Tk7sPLWnTsxGrI/w9jAcAVbOeOqD750
        He9Pkdwp7mNCVN8qZkuPyI0wdsF6fDD5JzpVr4UpietVo1Y8/i8mJp18D3vHWjp0
        ixBpcqJ6z8LZs5sO64y3Tq0eRdmn5Pnx2SdtHcU10vOqzSqDsmmDnkua58OkiGfG
        ZOPrWiV2J2joUvQdfOpEItP3AXgoZ0Y2O6/rdVMJwsr3K180qg3c4xztZP35Yr+k
        Vqw3ZcjK5GLwNwr1XwKnIfqUg1+UXhYgQDMur9W1zUXeq4WHy1Ju17TUrV8UY+Sw
        ==
X-ME-Sender: <xms:73hlXfX7Vchuz9zmlBM56kYVBLGIQJHubf8MIvFsRBXXNJGdbaMu8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehkedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:73hlXdH7YI8jCFkiLHviNcu0jCeAgL0xjiUisNijqqGoGNn19CErzw>
    <xmx:73hlXafPM7yZFn7IJWAJdeE7G0lRiGGdAvdsBfdJhywjJDDgktYWtA>
    <xmx:73hlXeqBLLjyr1V-zR_NyQdKihMQgf4PAihzAUEF3FGUVfCLeoENlQ>
    <xmx:8XhlXTfghgODvyWc3J-F8F6rCiKefmXMXzgzjeMopFsEt6l7CsM9uw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABAA580063;
        Tue, 27 Aug 2019 14:39:42 -0400 (EDT)
Date:   Tue, 27 Aug 2019 20:39:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc:     Thomas Backlund <tmb@mageia.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM
 counters in sync with the hierarchical ones"
Message-ID: <20190827183940.GA2924@kroah.com>
References: <20190817004726.2530670-1-guro@fb.com>
 <20190817063616.GA11747@kroah.com>
 <20190817191518.GB11125@castle>
 <20190824125750.da9f0aac47cc0a362208f9ff@linux-foundation.org>
 <a082485b-8241-e73d-df09-5c878d181ddc@mageia.org>
 <20190827141016.GH7538@dhcp22.suse.cz>
 <20190827170618.GC21369@kroah.com>
 <20190827173950.GJ7538@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827173950.GJ7538@dhcp22.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 07:39:50PM +0200, Michal Hocko wrote:
> On Tue 27-08-19 19:06:18, Greg KH wrote:
> > On Tue, Aug 27, 2019 at 04:10:16PM +0200, Michal Hocko wrote:
> > > On Sat 24-08-19 23:23:07, Thomas Backlund wrote:
> > > > Den 24-08-2019 kl. 22:57, skrev Andrew Morton:
> > > > > On Sat, 17 Aug 2019 19:15:23 +0000 Roman Gushchin <guro@fb.com> wrote:
> > > > > 
> > > > > > > > Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
> > > > > > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > > > > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > > > > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > > > > > ---
> > > > > > > >   mm/memcontrol.c | 8 +++-----
> > > > > > > >   1 file changed, 3 insertions(+), 5 deletions(-)
> > > > > > > 
> > > > > > > <formletter>
> > > > > > > 
> > > > > > > This is not the correct way to submit patches for inclusion in the
> > > > > > > stable kernel tree.  Please read:
> > > > > > >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > > > > > > for how to do this properly.
> > > > > > 
> > > > > > Oh, I'm sorry, will read and follow next time. Thanks!
> > > > > 
> > > > > 766a4c19d880 is not present in 5.2 so no -stable backport is needed, yes?
> > > > > 
> > > > 
> > > > Unfortunately it got added in 5.2.7, so backport is needed.
> > > 
> > > yet another example of patch not marked for stable backported to the
> > > stable tree. yay...
> > 
> > If you do not want autobot to pick up patches for specific
> > subsystems/files, just let us know and we will add them to the
> > blacklist.
> 
> Done that on several occasions over last year and so. I always get "yep
> we are going to black list" and whoops and we are back there with
> patches going to stable like nothing happened. We've been through this
> discussion so many times I am tired of it and to be honest I simply do
> not care anymore.
> 
> I will keep encouraging people to mark patches for stable but I do not
> give a wee bit about any reports for the stable tree. Nor do I care
> whether something made it in and we should be careful to mark another
> patch for stable as a fixup like this one.

Sasha, can you add these to the blacklist for autosel?

thanks,

greg k-h
