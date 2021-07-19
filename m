Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83F53CD4EF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbhGSL7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 07:59:43 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:56513 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236571AbhGSL7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 07:59:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 514473200949;
        Mon, 19 Jul 2021 08:40:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 19 Jul 2021 08:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=5kfSZnZyxCfOqkxjBhPjwhVzpil
        rAJAJf8pdfSBPjjs=; b=ZcGTp3w9ldiAlFTNXD5ABqqIQ4MOpFcaNMrvL8oNUZz
        jFzh8ftxItpqNAuhQjcwhJwi1oHlwxHYZ1jPLhY4iVpQn7HWxODZn33HmzYeMgFd
        fc+Zq7AUCDBeM9GUEN7pEYPA6U9O6KdEORITXWxQ1MxdjzIH/lteht8l8id/AmJH
        ioMMtlbv+WlNwnMTBWp4oUoYbosYAPxK/Yk7hz98kqthFqUo7Yd0B/+6LMmN2ysj
        agarMnivyeT7xAHYPnrdHT+/woQBUJDIFdWMh925GJ2D3/qTdskwH0nCbSEOwliG
        THrMuLAeeKJrY997+u+34YAx+antwjsttd6A5qF7khA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5kfSZn
        ZyxCfOqkxjBhPjwhVzpilrAJAJf8pdfSBPjjs=; b=l+L7wtwKaDRLzXIv/V4dca
        9dDreQus2B7zcizkt5CftfAOQznQ4XGDw5ejuWz+BViYsfpNcyMhapLXPv6PHm9i
        wAkzgN+w6BcWRTPi9vTEDqJufTyFtPYPdaxADO1Xgp6t9gfvGOO5hZN33k0LfHU9
        AHW8yWSq8LuQi5oTb994IauMkushy/YIga9R65U+RR3fgSy1ST5J85ZGoGLJOLhv
        r+MdSdY2LsMr4iify1nDIkdBBxc65UPrj28NBLLYcAB/GIjxABi2xgSKDOPqHwxo
        5Kbz9gVLU5VtIlgn9bPzDy+4xWSa6sTvAo3JRJBpm3J0V4aKDcQ+s4DipCAavn0A
        ==
X-ME-Sender: <xms:tXL1YCRUTvIGxOj4uefHygZYhQayWqNu4wEADS_EktClNPE3aom2yQ>
    <xme:tXL1YHxHGJwC1LEy_7FMw0a15fvufUrPAt51QZ0wkMRr2VRvi3aId8kXHgIdQpYu2
    vYSqRlu912ogw>
X-ME-Received: <xmr:tXL1YP0vQKzebnQIxJaLVztXieiKMVhm918KbRjXUjABUFTOWI2qGrQo58MG3DBKQrHj2yBjjcwOdG0d_b_GWzsyVNTB1iA2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepuddtiedvje
    egudffgfdvhfdtjeeugffhhedvjeehgffgleduuefgfeekgedvlefhnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tXL1YOAokeop6T_usNe4jvKGRpU_Np4SGj5twfOQqzk20JAhnDSnsg>
    <xmx:tXL1YLhrS3UzBULRXIt6ctnntKqjgy9UVArp5WW40JGl8VlCrAEImg>
    <xmx:tXL1YKrJahLiGNcbrHesosRyD8xQ8-utKsL2IFai-dletS_P0IML0Q>
    <xmx:tXL1YGUKSW6e6_YxOO5buWUdWHF4qgzE62C-w7kM7U9x3ouAR3H5Eg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 08:40:20 -0400 (EDT)
Date:   Mon, 19 Jul 2021 14:40:15 +0200
From:   Greg KH <greg@kroah.com>
To:     Davis <davis@mosenkovs.lv>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4] mac80211: fix memory corruption in EAPOL handling
Message-ID: <YPVyrwvNnTGkZTdm@kroah.com>
References: <20210710183710.5687-1-davis@mosenkovs.lv>
 <YPAiFsEncZ95Oomx@kroah.com>
 <CAHQn7p+dA3-FS+DGPqCvXJGtTZfWqg9hy1GUbtWFwtQFvKcnfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQn7p+dA3-FS+DGPqCvXJGtTZfWqg9hy1GUbtWFwtQFvKcnfg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 01:02:06AM +0300, Davis wrote:
> On 2021-07-15 at 15:36 Greg KH (<greg@kroah.com>) wrote:
> >
> > On Sat, Jul 10, 2021 at 09:37:10PM +0300, Davis Mosenkovs wrote:
> > > Commit e3d4030498c3 ("mac80211: do not accept/forward invalid EAPOL
> > > frames") uses skb_mac_header() before eth_type_trans() is called
> > > leading to incorrect pointer, the pointer gets written to. This issue
> > > has appeared during backporting to 4.4, 4.9 and 4.14.
> >
> > So this is also needed in 4.9 and 4.14, right?  If so, now queued up
> > everywhere.  If not, please let me know so I can drop it from the other
> > trees.
> >
> > thanks,
> >
> > greg k-h
> 
> Thank you! Yes - this is needed in 4.4, 4.9 and 4.14.
> Only line offsets and commit messages (they contain references to
> backport commits introducing the issue) differ between kernel versions
> and I see the patches are queued with correct line offsets.
> Patches for 4.9
> (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-4.9/mac80211-fix-memory-corruption-in-eapol-handling.patch)
> and 4.14 (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-4.14/mac80211-fix-memory-corruption-in-eapol-handling.patch)
> still contain 4.4 in the cc line in sign-off section. Also these
> patches contain reference to commit e3d4030498c3 that is from 4.4
> branch. Is this OK?

It's fine :)
