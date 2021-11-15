Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D877E450A71
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhKORGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:06:43 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53871 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231336AbhKORGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 12:06:41 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id A0CF73201C6E;
        Mon, 15 Nov 2021 12:03:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 15 Nov 2021 12:03:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=2FmVt9Ku6/tnTvyQMVVjbvP8jFg
        7pXKV68FsjSNZg50=; b=RF8Ar/6evi3hrseMOIFRt9TU7Hr0CTVQDLnqxVkURzL
        +0QopBWHzPoFXRlduysGtyv7uXr6PiSf/jVPIV/283TgfLduPWaM5KytpK72wkwF
        ix2+DLc8RYtKKMNxWkLpVtTyYelEIOXh2prEeXsF1GX+gd2j4DKmowR6J6enXEgA
        eG1PbIN5hHvmpn4+kWIoFVlJk7yMdENseG3rg3+/Hd/huUdV9hwzbnTVUJ4A7omv
        3FhEY5ojiueVTdJH51qux5PU4aIuh/B35VOeIEzxxKlbmvKLCNH6Hx4J6xfTG898
        kFdgryFm0OEK0v9r1ULJLpY0Wdjtd4ZN8UXThjI50iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2FmVt9
        Ku6/tnTvyQMVVjbvP8jFg7pXKV68FsjSNZg50=; b=Ps6ZUCm9LALRISZB05C1SD
        EFD0FzKII5PVHHBaxiHRDzar3u25U9KnL4OIwygOlKIy82/whT/a7vv9YgOKniLU
        kdLvOQrsEigNLgA1kEB388Z7OK6HTElSIeaayGYgDZkKxWa4Ej5sMMRc7B0KxoJa
        JcnaR3DICAu/9fnjaodv7lGmydK+hceo2li2XjIQ7ojpibGjDLMYOP1wRbQYo2vC
        CfQXV4SWdQ6hHCgVIyVl814Z4hAIHhKxtRMAQqDZU3rFIE0R7aQDqJr++gaYQTMV
        Ymnh7D2CeGvXCARE/14rX4n4qffEFduvPpz86KYz+gZML8ip4TKBxdPiVcersIGw
        ==
X-ME-Sender: <xms:7pKSYcmAA-Ewfoe2xiAryIzFEbe9nJ_pOsiY_6fdEku6yHggxgEWsQ>
    <xme:7pKSYb2HdEPEW6r6P5N8mdhDP7FfOjqYD8YSJ8P1xx2SqgkXHA4KLoNhLp5Jqgmcb
    rQpHJnOSzZUCg>
X-ME-Received: <xmr:7pKSYarxLWqUR__LHbskE4mGQdJ5qBiDZ1XmXy7Byt42HJVLailLtN3dOvUQYOSIWqzpXW4qGoDkfRSLmyYHGhKj-ypxB1B1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfedtgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7pKSYYkNSvbbIWjxBQqyiMYx1VsWVrKnAVpokqVUQb0T2Lk3mol7FQ>
    <xmx:7pKSYa2dQOocY1D7_ox7XAG0X1ulQbawQFmJwK00-wh9DDq5bshmqw>
    <xmx:7pKSYfssj61d0eTmPrSH0stmAXaEfG6412rI14UCPiYNt-qiHyM09w>
    <xmx:7pKSYUqqZo90RHorSLPR9z7yV53CzTrb47xPi6aQvbGQie5tcCoTZw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Nov 2021 12:03:41 -0500 (EST)
Date:   Mon, 15 Nov 2021 18:03:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Jane Malalane <jane.malalane@citrix.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH for 4.19] x86/cpu: Fix migration safety with
 X86_BUG_NULL_SEL
Message-ID: <YZKS63HXBGrcMj10@kroah.com>
References: <20211115163020.16672-1-jane.malalane@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115163020.16672-1-jane.malalane@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 04:30:20PM +0000, Jane Malalane wrote:
> commit 415de44076640483648d6c0f6d645a9ee61328ad upstream.
> 
> Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
> makes it unsafe to migrate in a virtualised environment as the
> properties across the migration pool might differ.
> 
> To be specific, the case which goes wrong is:
> 
> 1. Zen1 (or earlier) and Zen2 (or later) in a migration pool
> 2. Linux boots on Zen2, probes and finds the absence of X86_BUG_NULL_SEL
> 3. Linux is then migrated to Zen1
> 
> Linux is now running on a X86_BUG_NULL_SEL-impacted CPU while believing
> that the bug is fixed.
> 
> The only way to address the problem is to fully trust the "no longer
> affected" CPUID bit when virtualised, because in the above case it would
> be clear deliberately to indicate the fact "you might migrate to
> somewhere which has this behaviour".
> 
> Zen3 adds the NullSelectorClearsBase CPUID bit to indicate that loading
> a NULL segment selector zeroes the base and limit fields, as well as
> just attributes. Zen2 also has this behaviour but doesn't have the NSCB
> bit.
> 
>  [ bp: Minor touchups. ]
> 
> Signed-off-by: Jane Malalane <jane.malalane@citrix.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> CC: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/20211021104744.24126-1-jane.malalane@citrix.com
> ---
> Backport to 4.19.  Drop Hygon modifications.

Now queued up, thanks.

greg k-h
