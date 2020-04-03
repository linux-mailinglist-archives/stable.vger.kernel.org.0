Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DDC19D90A
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 16:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgDCOZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 10:25:01 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38957 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727431AbgDCOZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 10:25:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A2145C02DC;
        Fri,  3 Apr 2020 10:25:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 03 Apr 2020 10:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=h//KBBbTbCyqY5QR6Vnfov/BvLf
        Hp/XAplTvJ5sSpZo=; b=F5LpxV8w8wwUOwdIRDGwVKRSgprh7zt8IlNEgwg0efK
        WUGoZIatvwOODSwF0LMLn9wGXfsp6tP5gey4vzI7Xjh3V9XLQxp6mSuFA1pWXEHV
        Pm4+b4nO7kntmCQfPOLNn2u7iLhap37yCbM6E5TgJDvXuRImpmqQiesG9B5ScOlP
        wXaBpba6l/CFTzqZ4e/RNKpItKL5m9nqELnRPkkUyf/sONhB0L8s8B/lfJI5PAtW
        dUdbqj6WIEtlUdzjbpvZyK+FG9Vt7M/m8w7DjXdxnR9wR2RiX1u1aTrjdLIFcgiO
        4vy9X9Fr3oRmYnqfJCGH4tdUcVkFC+RhedLQ7InhnXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=h//KBB
        bTbCyqY5QR6Vnfov/BvLfHp/XAplTvJ5sSpZo=; b=bBa3X3hB/je0rfyY8TSfKw
        FFoJC/zDMMkWwtcXjGEf//Mvc5s4t7U6HpgaYKOIvNiIaH9PMwy+xVgRj/rtSEOX
        Tse8AL/mdGcWH+FBgvY0ToCpRrU/5vFNwwe6z/3YJjNHMi17yrPzFAOEf6OkwE+2
        IUjJO2tj3jhmJXGGWV2vBwTzVS3B4sZarbPR1VKRwMViDO3MY6VGjwUMparDIZGY
        TYysce5aRdS6UShhtOy1nOHNbuszY1fQ5NJY6iU2CVxIWgvUR4rbFatn8hG8IVVz
        S/R/emWzkCLLq2f/ulNJRN6lkvm+5PmzjjFnWOPmmMaX63668fcXmAptkkjRCodA
        ==
X-ME-Sender: <xms:PEeHXuvYBz_XBqK4eze1qdzIpnXh9FyLv6HzaCRaDtxdYGQI-AK3AA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PEeHXplhaaNy224I1M32QlfeLk7TU2aEiZ2_0W99OVXmD-dg-y5Qgg>
    <xmx:PEeHXgS2y7LOPWa2ajxc2qdfAnSbNr4oGXZ-P5_oViI_kKKF22V-Wg>
    <xmx:PEeHXjOtjDp2ChBfQK65mmln8KANVOXWvhHQ8WPtOzchT9uMazuHWA>
    <xmx:PEeHXpqCvpnSv02U_BzUPu-_l8qAg8YatTI4XkP0fySUN4ec8ItetA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C39A306CFDB;
        Fri,  3 Apr 2020 10:25:00 -0400 (EDT)
Date:   Fri, 3 Apr 2020 16:24:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Backport dependencies helper
Message-ID: <20200403142456.GC4088318@kroah.com>
References: <20200331123217.GM4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331123217.GM4189@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 08:32:17AM -0400, Sasha Levin wrote:
> Hi all,
> 
> I wanted to share a resource I've been using to help me with doing
> backports to various stable kernels.
> 
> In the Stable Kernel world, when we need to backport a patch, we'd
> rather take any relevant dependencies to make the patch work cleanly on
> an older kernel, rather than modifying the patch and diverging from
> upstream.
> 
> This raises an interesting problem: how do we figure out which other
> patches might be "interesting" to look at? git-blame is a great tool,
> but it takes a while to go through the history of a patch, and given the
> volume of patches we need to look at, it just isn't enough.
> 
> So here's a tool in the form of a git repo that can help point out these
> interesting patches:
> 
>        https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/
> 
> How does it work, you might ask? It's actually quite simple: Each
> directory represents a kernel version which we'll call K, and each file
> inside that directory is named after an upstream commit we'll call C,
> and it's content are the list of commits one would need to apply on top
> of kernel K to "reach" commit C.
> 
> For example, let's say we want to apply:
> 
>        f8788d86ab28 ("Linux 5.6-rc3")
> 
> On top of the v5.5 kernel tree. All we need to do is:
> 
>        $ cat v5.5/f8788d86ab28f61f7b46eb6be375f8a726783636
>        f8788d86ab28 ("Linux 5.6-rc3")
>        11a48a5a18c6 ("Linux 5.6-rc2")
>        bb6d3fb354c5 ("Linux 5.6-rc1")
> 
> If you don't feel like cloning the repo (which contains quite a few
> files), you can also use kernel.org's web interface in a script that
> might look something like this:
> 
>        #!/bin/bash
>        curl https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/$1/$2
> 
> And then simply:
> 
>        $ ./deps.sh v5.5 f8788d86ab28f61f7b46eb6be375f8a726783636
>        f8788d86ab28 ("Linux 5.6-rc3")
>        11a48a5a18c6 ("Linux 5.6-rc2")
>        bb6d3fb354c5 ("Linux 5.6-rc1")
> 
> Caveats:
> 
> - Each file is limited to 50 entries. I feel that at that point it
>   stops being useful.
> - Each file stops if a merge commit is hit.
> - I might have bugs in my scripts and some entries are broken, please
>   report those if you see them.

This is really cool, thanks for posting this, and for doing this work.

greg k-h
