Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B81617FE
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 17:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgBQQdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 11:33:21 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60705 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728540AbgBQQdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 11:33:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AC4E21E56;
        Mon, 17 Feb 2020 11:33:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 11:33:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=z7SIQMe8gxZXCrF92WQcQrgLZ/B
        hMiFjzfj9KMJK7K8=; b=ScagvJcTAO5ftJfd77H/HvKvdchvc5G/uNs0OFLeXX3
        Hl6I/72aZ3hRXj3+Mjt6QLLAZYMYm4H410ta3bzm8g84FurpbgBFYPkgmMkPsQx6
        +kO9bT49mqFQNA+ZhjQQ0+kmhaGO1Uv/0h1Njh4/8cijpS7wbpl/PV0WcyP8zQnO
        FbOqPsrveENvSj3OkGTvDSsCSND102g/gtgMtIoBI6QFNiJlFGjvD+qFN8qvLo0w
        9MMY8hBGqrA/quApuirtuNYLKfriTzfAvgUqu8mqdskJxdI1Y7mXuHm+Fxkr+KWF
        DqD/xt7SpYQIsXqXpKwT+Q0++QzVnAn9FwBrwRSWGAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z7SIQM
        e8gxZXCrF92WQcQrgLZ/BhMiFjzfj9KMJK7K8=; b=tsNqGrim9eK5GK6DHc31Rp
        80sI+Lm1vmy5lQCJP7lP2QDxl9aW7bNuToRAL+vibgCUJw4IMSOIjccd+BJ5N7eR
        Nov8TWbHO6fP/tfnXOKyTvGyDPCDFoxxVHDJaEYI6UpFX7qqw+/+BbfyrDWwERHa
        V+WU9GgNWcvDv0G+MeXlhfx3KF0GSK0ZBgHbbAlzlUEbK2R9tOzhnzKasawRU/Pb
        kAfN6vVY1gbXdHbxFt7juuaCBUlgn4JP4HYXn6qHcgN2yvffdOcm4Vh9ePh0lw2H
        T6Lz+lwqz0ODM+PkmZnj2kOEkxQAtSCThXUAoRsn1QE1Hc2qKyZq0tPeBrB00sRg
        ==
X-ME-Sender: <xms:T8BKXlJeFXJW3U8KrGxcR1dZd8RyGuDKlblmsLUdVqKtI8XMUQmkkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeltdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T8BKXmgygXB-ttKX6K324l7-Bl35Ly36BrmB_XoPm-HIOCdYM4Fmhg>
    <xmx:T8BKXqLoT3WIL0JYjbdxZilmAVYTCBXqraykwTwNUNj5vBKjtNSGZw>
    <xmx:T8BKXrgqoNM7Ubv8GgFD_9tawuu_7_DOt1tiRXeXx8k5my4XhW3Z4w>
    <xmx:UMBKXtMIbkh9VRXeVebbccsamgv6ARJd1lupumxNkvh70qQ1KiY1Dw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76E253060C21;
        Mon, 17 Feb 2020 11:33:19 -0500 (EST)
Date:   Mon, 17 Feb 2020 17:33:18 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] efi: READ_ONCE rng seed size before munmap
Message-ID: <20200217163318.GF1502885@kroah.com>
References: <20200217123354.21140-1-Jason@zx2c4.com>
 <CAKv+Gu83dOKGbYU1t3_KZevB_rn-ktoropFrjASjsv3DozrV1A@mail.gmail.com>
 <20200217155402.GB1461852@kroah.com>
 <CAKv+Gu_uQvONH=vAcckPEn+HWOOsiQdt_Dsscw2Y3KEUObafxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_uQvONH=vAcckPEn+HWOOsiQdt_Dsscw2Y3KEUObafxA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 05:09:00PM +0100, Ard Biesheuvel wrote:
> On Mon, 17 Feb 2020 at 16:54, Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Feb 17, 2020 at 04:23:03PM +0100, Ard Biesheuvel wrote:
> > > On Mon, 17 Feb 2020 at 13:34, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > This function is consistent with using size instead of seed->size
> > > > (except for one place that this patch fixes), but it reads seed->size
> > > > without using READ_ONCE, which means the compiler might still do
> > > > something unwanted. So, this commit simply adds the READ_ONCE
> > > > wrapper.
> > > >
> > > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > Cc: stable@vger.kernel.org
> > >
> > > Thanks Jason
> > >
> > > I've queued this in efi/urgent with a fixes: tag rather than a cc:
> > > stable, since it only applies clean to v5.4 and later.
> >
> > Why do that?  That just makes it harder for me to know to pick it up for
> > 5.4 and newer.
> >
> > > We'll need a
> > > backport to 4.14 and 4.19 as well, which has a trivial conflict
> > > (s/add_bootloader_randomness/add_device_randomness/) but we'll need to
> > > wait for this patch to hit Linus's tree first.
> >
> > Ok, if you are going to send it on to me for stable, that's fine, but
> > usually you can just wait for the rejection notices for older kernels
> > before having to worry about this.  In other words, you are doing more
> > work than you have to here :)
> >
> 
> So just
> 
> Cc: <stable@vger.kernel.org>
> 
> without any context is your preferred method?

If you can provide a "Fixes:" tag showing what commit it does fix,
that's even better as that way I _know_ to try to apply it to older
kernels and if it fails, you will get an email saying it failed.  With
just a cc: stable, I do a "best guess" and don't work very hard if older
kernels do not apply as I don't know if it is relevant or not.

thanks,

greg k-h
