Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A5B29F499
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJ2TNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:13:25 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37899 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgJ2TNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 15:13:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E2E9F5C0182;
        Thu, 29 Oct 2020 15:13:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 15:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Mry6OUyswZ+YVTyhrEViEN0VSoQ
        +5Vm866Sllqo/pUQ=; b=dpqcGm76oLdYhQ/Cv/FpbumVJSAA1Goz6wuU3IP6sbh
        Lj51BOVl4pFnKRto0+HOCFVNlUfxcOwgJBpe7jj/iUOh34v4c70oAVhVPn/cQWGn
        IgJfRWQnTPPWoiSpT4DTgu2zCVbUBckdIR/iTtZMFM+00NWgZRn47Dc9U5TDSfD6
        qqtVKsXogGP/xr88nKrSzmuVclb7z8fGy95D3SAaTCTG7ibBHsxY6k2iLpuAg7nI
        QZ22IiNOur0KhUFqWeUfx96LyUlCM1E6E2QH/DbZ5zPzqoKgCjbTajJD26EianSq
        5HDiSLeEbfn7gzqW/C1M9n0v0LZ7n7RCjeZXCbUiXFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Mry6OU
        yswZ+YVTyhrEViEN0VSoQ+5Vm866Sllqo/pUQ=; b=OVJG+q6dVWmZlZPx2/TeJp
        5KExkU+Fqm6yI89BszZoVaZTaNC15LKuxJFs9yyZ/F7FCGBu2whd2uwFlqdmJIVt
        QxWe7v8lZ2Ez/lu+tAUnlXnHalBhmNuGEwMaVZGFzBlCJaqunJO7anQmDjkZeDy2
        phc6SnCERMotvsF3+wEsQmImU5Xp+xL0jXZuRvRm0k3wPmz8DDDpBiixug2dAjm9
        WV/cQIMz1pSkw6XkhYtWeij6ED7MEWrl0mebD8rZoCwN8cCp102lrgRTvEW7Uxgw
        6lCXmzLocp6scBAdcp56jsIpQaLPxhyT6/bxd1gZB1mrLdgK2WAeCrGtgixceE/g
        ==
X-ME-Sender: <xms:UxSbX69Joncri7kFQ5bpYeUqliwzpXQcWN1UkvFGfLyw0yC2YupOZg>
    <xme:UxSbX6u1lrU-NjAN0gLgv4iQEFrNWvgwNtVKikuuhZ3CRkPkzA_r_IOogjcmLuWOg
    AK_UR7VgP3lnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeliefhhe
    ffhfdvgeejffelveejiefgueevheejuddtgfejfeevheetgeeljeeugeenucffohhmrghi
    nhepuggrrhhinhhgfhhirhgvsggrlhhlrdhnvghtpdhkvghrnhgvlhdrohhrghenucfkph
    epkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UxSbXwBUZ3Nce3mp83Br9hhQwh2zl13E3VULl0n8EYdUs1MCqJZfug>
    <xmx:UxSbXycwWq3gPlwBV7ZLYXDCScs4qiyW_eSdMtkssRDrwu5b10WEfQ>
    <xmx:UxSbX_NO4UjsFrFgqGIV0R9eyAV_415i5VvOT4FAXWNjxaW6Fc9nfg>
    <xmx:UxSbX61Ygn_Eg0HQbILwIqOcVHavLn82SwlLwiGpKt2jVVZ_qWP7Ow>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 541583280063;
        Thu, 29 Oct 2020 15:13:23 -0400 (EDT)
Date:   Thu, 29 Oct 2020 20:14:13 +0100
From:   Greg KH <greg@kroah.com>
To:     Chris Ye <lzye@google.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linzhao.ye@gmail.com, stable@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
Message-ID: <20201029191413.GB986195@kroah.com>
References: <20201028235113.660272-1-lzye@google.com>
 <20201029054147.GB3039992@kroah.com>
 <CAFFudd+7DrJ+vYZ5wQ58mei6VMkMPGCpS1d7DwZMrzM-FVKzqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFFudd+7DrJ+vYZ5wQ58mei6VMkMPGCpS1d7DwZMrzM-FVKzqQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Oct 29, 2020 at 08:23:57AM -0700, Chris Ye wrote:
> Haha, thanks!
> I have fixed my git config and sent a new mail, can you check it?

Do you have a pointer to it on lore.kernel.org?

And you did properly version the patch, right?

thanks,

greg k-h
