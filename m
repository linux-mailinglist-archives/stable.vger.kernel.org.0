Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DEE1616B4
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 16:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgBQPyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 10:54:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55133 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729597AbgBQPyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 10:54:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 35B3621F8E;
        Mon, 17 Feb 2020 10:54:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 10:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=pH6LbW1d+9z/pKqgAnE2oTt95TL
        YHMKEHXXSWG12OpY=; b=fz1MSp15NoqXtMldTuI4f70SdLJM9gtuZ8T1jj+Tm8u
        HHsz3f+ASnYZn7f0yiXpLV+sMqIy0Z9LFVzJBMIQ4s438dkMNxyjy6/vvFoHbwqT
        vkR+eYDZzGb+NHbQIyJQ4uhlXeC2Oq3jKw4k2lOfL4QQyeuMgcejvxLh4oqD5B7y
        CFhQkPJflvixnz1B/CpRcCXIG63CvqgYBIHW5j5eFd9iZgqpw0oHUowYsIGzDEBJ
        LEC8ODnX/9FJUDlRib4ZnJhl7QfdL4zqlR67HAPy3lSplqqEQK2GwTaIl4U73Bsz
        YRSUqXnGrkFTY8WqVeR1sFNuiUCIYK0n4tC3XpPimfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pH6LbW
        1d+9z/pKqgAnE2oTt95TLYHMKEHXXSWG12OpY=; b=M7qmy6o4Ccor9R38lhCAHE
        i3H2JacdWAuU8ZMCDgS1XryK3NJBP8fwMm2ZPpt8/FmqqJO3UkzL2LRb4J0w9Vno
        DXY3MUGbUld12vlmjeOuPYR21kuwxLCAJTu+DXFkBY5Kbmrh5EtRYipkme4NZ9DR
        A+73jv+7EHYWNbFP413/2nyWuqrWoCaDHOlOuXBQST+eYnbDusHZ+MLd3H9X2lWz
        afqVuaJMMJ3J/U6yEHrSUdB91TLYcnN3X73rjMI6N9y0q3ZKAWrIh0EqtHCeUYqt
        4ldkWJPWEHouyC+DAeNl0H16ZyK9fS72nKWjVgm9A6NMULu5yTqfQjI7w1dkRGTQ
        ==
X-ME-Sender: <xms:H7dKXnI-rpYXHv3qNSVhm49viDbs5_15D-kfaqfkExollngjIzcsaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ILdKXo3ivsqrfwmDKdzl877jyUIJKpVdO0Vs0tuA6W7hRuuDDWX_fg>
    <xmx:ILdKXnwLXGHZS8nyLlls4WKxgyVz7p1f0G-FjUPk_1p2BnhhBF5h0A>
    <xmx:ILdKXowuQ4AyLvQBIhsBd779X05v5BgrKL9pHpo_uX6ON-Q8ZSsR0A>
    <xmx:ILdKXh0eQWyHWuFNCwQLLjBCjf9drCaDroqthnWNfonIyEk7xNrmRw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF2A73060BE4;
        Mon, 17 Feb 2020 10:54:07 -0500 (EST)
Date:   Mon, 17 Feb 2020 16:54:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] efi: READ_ONCE rng seed size before munmap
Message-ID: <20200217155402.GB1461852@kroah.com>
References: <20200217123354.21140-1-Jason@zx2c4.com>
 <CAKv+Gu83dOKGbYU1t3_KZevB_rn-ktoropFrjASjsv3DozrV1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu83dOKGbYU1t3_KZevB_rn-ktoropFrjASjsv3DozrV1A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 04:23:03PM +0100, Ard Biesheuvel wrote:
> On Mon, 17 Feb 2020 at 13:34, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > This function is consistent with using size instead of seed->size
> > (except for one place that this patch fixes), but it reads seed->size
> > without using READ_ONCE, which means the compiler might still do
> > something unwanted. So, this commit simply adds the READ_ONCE
> > wrapper.
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: stable@vger.kernel.org
> 
> Thanks Jason
> 
> I've queued this in efi/urgent with a fixes: tag rather than a cc:
> stable, since it only applies clean to v5.4 and later.

Why do that?  That just makes it harder for me to know to pick it up for
5.4 and newer.

> We'll need a
> backport to 4.14 and 4.19 as well, which has a trivial conflict
> (s/add_bootloader_randomness/add_device_randomness/) but we'll need to
> wait for this patch to hit Linus's tree first.

Ok, if you are going to send it on to me for stable, that's fine, but
usually you can just wait for the rejection notices for older kernels
before having to worry about this.  In other words, you are doing more
work than you have to here :)

thanks,

greg k-h
